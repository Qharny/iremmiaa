//main.dart

import 'package:bookmie/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Custom_classes/theme_provider.dart';
void main() => runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'Bookmie';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: Provider.of<ThemeProvider>(context).themeData,
      // ThemeData(
      //   fontFamily: GoogleFonts.merriweatherSans().fontFamily,
      color: const MaterialColor(
        0xFFF59B15,
        <int, Color>{
          50: Color(0xFFFFF7F7),
          100: Color(0xFFFFE8E8),
          200: Color(0xFFFFD9D9),
          300: Color(0xFFFFCACA),
          400: Color(0xFFFFB8B8),
          500: Color(0xFFF59B15),
          600: Color(0xFFF49212),
          700: Color(0xFFF38B0F),
          800: Color(0xFFF2840C),
          900: Color(0xFFF17D09),
        },
      ),

      home: const SplashScreen(),
    );
  }
}

// class SplashAndAuthenticate extends StatefulWidget {
//   const SplashAndAuthenticate({Key? key}) : super(key: key);

//   @override
//   _SplashAndAuthenticateState createState() => _SplashAndAuthenticateState();
// }

// class _SplashAndAuthenticateState extends State<SplashAndAuthenticate> {
//   @override
//   void initState() {
//     super.initState();
//     // Simulate a delay before navigating to AuthenticateSolo1Widget
//     Future.delayed(const Duration(seconds: 4), () {
//       Navigator.pushReplacement(
//         context as BuildContext,
//         MaterialPageRoute(
//             builder: (context) => const AuthenticateSolo1Widget()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height,
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           fit: BoxFit.cover,
//           image: AssetImage('assets/splash_screen.jpeg'),
//         ),
//       ),
//       // child: Scaffold(
//       //   body: Center(
//       //     child: Image.asset(
//       //         'assets/splash_screen.jpeg'), // Replace with your splash image
//       //   ),
//       // ),
//     );
//   }
// }
