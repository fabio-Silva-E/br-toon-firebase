import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:brtoon/common_widgets/button/button_widget.dart';
import 'package:brtoon/common_widgets/input/text_form_fiel_widget.dart';
import 'package:brtoon/common_widgets/sized_box/sized_box_widget.dart';
import 'package:brtoon/config/custom_colors.dart';
import 'package:brtoon/login/controller/login_controller.dart';
import 'package:brtoon/login/mixins/login_focus_nodes_mixin.dart';
import 'package:brtoon/login/mixins/login_text_edinting_controller.dart';
import 'package:brtoon/login/view/components/forgot_password_dialog.dart';
import 'package:brtoon/mixins/loading_error_mixin.dart';
import 'package:brtoon/mixins/snack_bar_mixin.dart';
import 'package:brtoon/pages_routes/app_pages.dart';
import 'package:brtoon/util_services.dart';
import 'package:brtoon/validators/email_validator.dart';
import 'package:brtoon/validators/password_validator.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = '/login';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with
        LoginFocusNodesMixin,
        LoginTextEditingControllerMixin,
        // NavigationMixin,
        LoadingErrorMixin,
        SnackBarMixin {
  final utilsServices = UtilsServices();
  final emailController = TextEditingController();
  late LoginController loginCtrl;
  @override
  void initState() {
    loginCtrl = LoginController();
    setIsLoading(false);
    super.initState();
  }

  void onLogin() async {
    setIsLoading(true);
    final error = await loginCtrl.onLogin(emailTEC.text, passwordTEC.text);
    print('Passou por aqui');
    if (error != null && context.mounted) {
      setIsLoading(false);
      showSnackBar(context, error, MessageType.error);
    } else {
      Get.offAllNamed(PagesRoutes.baseRoute);
    }
  }

  @override
  void dispose() {
    disposeFN();
    disposeLoginTECs();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /* const AppNameWidget(
                        brasilTileColor: Color.fromARGB(255, 255, 195, 195),
                        textSize: 40,
                      ),*/
                      SizedBox(
                        height: 200,
                        child: Image.asset('assets/logo/novaLogo.png'),
                      ),
                      //categorias
                      SizedBox(
                        height: 30,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                          child: AnimatedTextKit(
                            pause: Duration.zero,
                            repeatForever: true,
                            animatedTexts: [
                              FadeAnimatedText('mangas'),
                              FadeAnimatedText('aventuras'),
                              FadeAnimatedText('autores'),
                              FadeAnimatedText('leitores'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //formulario

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 40,
                ),
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(45),
                    )),
                child: Form(
                  key: loginCtrl
                      .loginFormKey, // Certifique-se de usar a chave aqui
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //Email
                        TextFormFieldWidget(
                          inputLabel: 'email',
                          controller: emailTEC,
                          focusNode: emailFN,
                          validator: EmailValidator.validate,
                          textInputType: TextInputType.emailAddress,
                          onFieldSubmitted: (_) => passwordFN.requestFocus(),
                          textInputAction: TextInputAction.next,
                        ),

                        //Senha
                        const SizedBoxWidget.md(),
                        TextFormFieldWidget(
                          inputLabel: 'senha',
                          controller: passwordTEC,
                          focusNode: passwordFN,
                          isPassword: true,
                          validator: PasswordValidator.validate,
                          onFieldSubmitted: (_) => onLogin(),
                          textInputAction: TextInputAction.go,
                        ),
                        //botão entrar
                        const SizedBoxWidget.xxl(),
                        ButtonWidget(
                          label: 'entrar',
                          onPressed: onLogin,
                          isBlock: true,
                          isLoading: isLoading,
                        ),
                        //esqueceu a senha

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () async {
                              final bool? result = await showDialog(
                                  context: context,
                                  builder: (_) {
                                    return ForgotPasswordDialog(
                                      email: emailController.text,
                                    );
                                  });
                              if (result ?? false) {
                                utilsServices.showToast(
                                  message:
                                      'um link de recuperação foi enviado ao seu email',
                                );
                              }
                            },
                            child: Text(
                              'esqueceu a senha?',
                              style: TextStyle(
                                color: CustomColors.redContrastColor,
                              ),
                            ),
                          ),
                        ),
                        //divisor
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.withAlpha(90),
                                  thickness: 2,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text('Ou'),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.withAlpha(90),
                                  thickness: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //criar conta
                        const SizedBoxWidget.lg(),
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(fontSize: 16),
                              children: [
                                const TextSpan(
                                    text: 'ainda não possui uma conta ?',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                                TextSpan(
                                  text: 'registre aqui!',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        Get.toNamed(PagesRoutes.signUpRoute),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
