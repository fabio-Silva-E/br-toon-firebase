import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
//import 'dart:html' as html;
import 'package:dio/dio.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

class FirebaseStorageService {
  Future<String?> chooseDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      // O usuário cancelou a operação de seleção de diretório
      print('Seleção de diretório cancelada');
      return null;
    } else {
      print('Diretório selecionado: $selectedDirectory');
      return selectedDirectory;
    }
  }

  Future<String?> getDownloadDirectory() async {
    if (await requestPermissions()) {
      if (Platform.isAndroid) {
        // Pega o diretório externo para Android
        Directory? externalDir = await getExternalStorageDirectory();

        // Verifica se obteve o diretório externo
        if (externalDir != null) {
          // Caminho para a pasta de download

          // Retorna o caminho completo da pasta de download
          return '${externalDir.path}/Download';
        }
      } else if (Platform.isIOS) {
        // Para iOS, geralmente usamos o diretório de documentos do aplicativo
        return (await getApplicationDocumentsDirectory()).path;
      }
    }

    return null; // Se a permissão não foi concedida ou o diretório não pôde ser obtido
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      if (await _isAndroid11OrHigher()) {
        var status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          status = await Permission.manageExternalStorage.request();
        }
        return status.isGranted;
      } else {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        return status.isGranted;
      }
    }
    return true; // Se não for Android, retorna verdadeiro por padrão.
  }

// Função para verificar e criar o diretório
  Future<String> _createDirectory(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory.path;
  }

// Função para salvar arquivos
  Future<void> saveFile(String path, List<int> bytes) async {
    final file = File(path);
    await file.writeAsBytes(bytes);
  }

// Função para testar a escrita no diretório selecionado
  Future<bool> testDirectoryAccess(String path) async {
    try {
      final testFile = File('$path/test.txt');
      await testFile.writeAsString('Test access');
      await testFile.delete();
      return true;
    } catch (e) {
      print('Erro ao acessar diretório: $e');
      return false;
    }
  }

// Verifica se o Android é 11 ou superior
  Future<bool> _isAndroid11OrHigher() async {
    var deviceInfo = DeviceInfoPlugin();
    var androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt >= 30;
  }
}
