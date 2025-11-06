import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:votopia/core/providers/auth_provider.dart';
import 'package:votopia/core/ui/styles/app_colors.dart';
import 'package:votopia/core/ui/styles/app_text_styles.dart';
import 'package:votopia/core/ui/widgets/primary_button.dart';
import 'package:votopia/core/ui/widgets/custom_text_field.dart';
import 'package:votopia/core/ui/styles/app_paddings.dart';
import 'package:votopia/core/views/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showCredentials = false;
  final TextEditingController _codeOrganization = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _orgFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _orgFocusNode.addListener(() {
      if (_orgFocusNode.hasFocus) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _orgFocusNode.dispose();
    _scrollController.dispose();
    _codeOrganization.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double maxWidth = ResponsiveValue<double>(
      context,
      defaultValue: 420,
      conditionalValues: [
        Condition.largerThan(name: TABLET, value: 600),
        Condition.largerThan(name: DESKTOP, value: 800),
      ],
    ).value!;

    final EdgeInsets padding = ResponsiveValue<EdgeInsets>(
      context,
      defaultValue: const EdgeInsets.all(24),
      conditionalValues: [
        Condition.smallerThan(name: TABLET, value: const EdgeInsets.all(16)),
        Condition.largerThan(name: DESKTOP, value: const EdgeInsets.all(40)),
      ],
    ).value!;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: ResponsiveRowColumn(
            layout: ResponsiveRowColumnType.COLUMN,
            rowMainAxisAlignment: MainAxisAlignment.center,
            columnMainAxisAlignment: MainAxisAlignment.center,
            children: [
              ResponsiveRowColumnItem(
                child: Container(
                  padding: padding,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: !_showCredentials
                            ? Column(
                          key: const ValueKey('org'),
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/icon.png', height: 80),
                                  const SizedBox(width: 14),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset('assets/images/icon_text.png', height: 48),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Seleziona organizzazione",
                                        style: AppTextStyles.body.copyWith(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            AppPaddings.sectionSpacing,
                            CustomTextField(
                              controller: _codeOrganization,
                              focusNode: _orgFocusNode,
                              hintText: 'Codice organizzazione',
                              prefixIcon: Icons.business_outlined,
                            ),
                            AppPaddings.sectionSpacing,
                            PrimaryButton(
                              text: 'Avanti',
                              onPressed: authProvider.isLoading
                                  ? null
                                  : () async {
                                final result = await authProvider.getOrganizationToAuthenticate(
                                    _codeOrganization.text);

                                if (result['status'] == true) {
                                  _emailController.clear();
                                  _passwordController.clear();
                                  setState(() => _showCredentials = true);
                                } else {
                                  QuickAlert.show(
                                    width: 350,
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: "Errore",
                                    text: result['message'] ?? "Organizzazione non trovata",
                                    confirmBtnText: "Ok",
                                    confirmBtnColor: AppColors.primary,
                                  );
                                }
                              },
                            ),
                          ],
                        )
                            : Column(
                          key: const ValueKey('credentials'),
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => setState(() => _showCredentials = false),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: Column(
                                children: [
                                  Image.asset('assets/images/icon.png', height: 120),
                                  Image.asset('assets/images/icon_text.png', height: 48),
                                  const SizedBox(height: 15),
                                  Text(
                                    authProvider.organizationLogged?.name.toUpperCase() ?? "NOME ORG",
                                    style: AppTextStyles.heading.copyWith(fontSize: 26),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            AppPaddings.sectionSpacing,
                            CustomTextField(
                              controller: _emailController,
                              hintText: 'Email',
                              prefixIcon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 24),
                            CustomTextField(
                              controller: _passwordController,
                              hintText: 'Password',
                              prefixIcon: Icons.lock_outline,
                              obscureText: true,
                            ),
                            AppPaddings.sectionSpacing,
                            PrimaryButton(
                              text: 'Accedi',
                              icon: Icons.login,
                              onPressed: authProvider.isLoading
                                  ? null
                                  : () async {
                                final result = await authProvider.login(
                                  _emailController.text,
                                  _passwordController.text,
                                );

                                if (result['status']) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DashboardScreen(
                                        organizationName: "Closer Acireale",
                                      ),
                                    ),
                                  );
                                } else {
                                  QuickAlert.show(
                                    width: 350,
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: "Errore",
                                    text: result['message'] ?? "Credenziali non valide",
                                    confirmBtnText: "Ok",
                                    confirmBtnColor: AppColors.primary,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}