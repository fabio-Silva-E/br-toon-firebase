import 'dart:io';
// import 'dart:html' as html; // Certifique-se de que a importação esteja correta

import 'package:brtoon/common_widgets/anuncios_widget.dart';
import 'package:brtoon/common_widgets/button/button_widget.dart';
import 'package:brtoon/common_widgets/input/text_form_fiel_widget.dart';
import 'package:brtoon/common_widgets/sized_box/sized_box_widget.dart';
import 'package:brtoon/common_widgets/text/widget_text.dart';
import 'package:brtoon/enums/sizes_enum.dart';
import 'package:brtoon/extensions/ui/sizes_extension.dart';
import 'package:brtoon/mixins/loading_error_mixin.dart';
import 'package:brtoon/mixins/navigation_mixin.dart';
import 'package:brtoon/mixins/snack_bar_mixin.dart';
import 'package:brtoon/pages_routes/app_pages.dart';
import 'package:brtoon/signup/controller/signup_controller.dart';
import 'package:brtoon/signup/screens/mixins/signup_focus_nodes_mixin.dart';
import 'package:brtoon/signup/screens/mixins/signup_text_editing_controller_mixin.dart';
import 'package:brtoon/validators/email_validator.dart';
import 'package:brtoon/validators/password_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with
        NavigationMixin,
        LoadingErrorMixin,
        SnackBarMixin,
        SignupFocusNodesMixin,
        SignupTextEditingControllerMixin {
  late SignupController signupCtrl;
  XFile? imageFile;

  @override
  void initState() {
    signupCtrl = SignupController();
    setIsLoading(false);
    super.initState();
  }

  final phoneFormatter = MaskTextInputFormatter(
    mask: '## # ####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    disposeFN();
    disposeTECs();
    super.dispose();
  }

  void onSignup(BuildContext context) async {
    setIsLoading(true);
    setError(null);

    final (errorMessage, success) = await signupCtrl.onSignup(
      emailTEC.text,
      passwordTEC.text,
      nameTEC.text,
      imageFile,
    );
    if (success && context.mounted) {
      Get.offAllNamed(PagesRoutes.baseRoute);
    } else {
      setIsLoading(false);
      if (errorMessage != null) {
        showSnackBar(context, errorMessage, MessageType.error);
      }
    }
  }

  Widget getProfileImageWidget() {
    if (imageFile != null) {
      if (kIsWeb) {
        return Image.network(imageFile!.path); // Se for web, usa Image.network
      } else {
        return Image.file(
            File(imageFile!.path)); // Para outras plataformas, usa Image.file
      }
    } else {
      return Image.asset('assets/perfil/perfil-de-usuario.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: signupCtrl.signupFormKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizesEnum.lg.getSize),
          child: SingleChildScrollView(
            child: Stack(
              // Mudei de Column para Stack
              children: [
                Column(
                  children: [
                    const SizedBoxWidget.lg(),
                    TextWidget.title('Cadastro'),
                    const SizedBoxWidget.md(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 40,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(45),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 75,
                                    backgroundColor:
                                        const Color.fromARGB(99, 71, 67, 67),
                                    child: CircleAvatar(
                                      radius: 65,
                                      backgroundColor: Colors.black26,
                                      child: ClipOval(
                                        child: getProfileImageWidget(),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black45,
                                      child: IconButton(
                                        onPressed: _showOpcoesBottomSheet,
                                        icon: Icon(
                                          PhosphorIcons.camera,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TextFormFieldWidget(
                            inputLabel: 'Nome',
                            controller: nameTEC,
                            focusNode: nameFN,
                            validator: (value) =>
                                value!.isEmpty ? 'Nome é obrigatório' : null,
                          ),
                          const SizedBoxWidget.md(),
                          TextFormFieldWidget(
                            inputLabel: 'Email',
                            controller: emailTEC,
                            focusNode: emailFN,
                            validator: EmailValidator.validate,
                            textInputType: TextInputType.emailAddress,
                            onFieldSubmitted: (_) => passwordFN.requestFocus(),
                          ),
                          const SizedBoxWidget.md(),
                          TextFormFieldWidget(
                            inputLabel: 'Senha',
                            controller: passwordTEC,
                            focusNode: passwordFN,
                            validator: PasswordValidator.validate,
                            isPassword: true,
                            onFieldSubmitted: (_) => onSignup(context),
                            textInputAction: TextInputAction.send,
                          ),
                          const SizedBoxWidget.xxl(),
                          ButtonWidget(
                            label: "Cadastrar",
                            onPressed: () => onSignup(context),
                            isBlock: true,
                            isLoading: isLoading,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: SafeArea(
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const AnunciosWidget(
                  adUnitId: 'ca-app-pub-4426001722546287/9726196914',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pick(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      XFile? file = await picker.pickImage(source: source);
      if (file != null) {
        setState(() => imageFile = file);
      }
    } catch (e) {
      showSnackBar(context, "Erro ao selecionar imagem: $e", MessageType.error);
    }
  }

  void _showOpcoesBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.image_square,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.camera,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.trash,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Remover',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    imageFile = null;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
