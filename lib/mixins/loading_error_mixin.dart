import 'package:flutter/material.dart';

mixin LoadingErrorMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = true;
  String? errorMessage;
  void setIsLoading(bool newIsLoading) {
    setState(() {
      isLoading = newIsLoading;
    });
  }

  void setError(String? newErrorMessage) {
    setState(() {
      errorMessage = newErrorMessage;
    });
  }
}
