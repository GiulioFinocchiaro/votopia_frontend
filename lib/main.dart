import 'package:flutter/material.dart';
import 'package:votopia/core/ui/themes/app_theme.dart';
import 'package:votopia/core/views/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:votopia/core/providers/auth_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(const Votopia());
}

class Votopia extends StatelessWidget {
  const Votopia({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, widget) => ResponsiveBreakpoints.builder(
          child: ClampingScrollWrapper.builder(context, widget!),
          breakpoints: const [
            Breakpoint(start: 0, end: 450, name: MOBILE),
            Breakpoint(start: 451, end: 800, name: TABLET),
            Breakpoint(start: 801, end: 1200, name: DESKTOP),
            Breakpoint(start: 1201, end: double.infinity, name: '4K'),
          ],
        ),
        title: 'Votopia',
        theme: AppTheme.lightTheme,
        home: const LoginScreen(),
      ),
    );
  }
}