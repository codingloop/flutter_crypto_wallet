import 'package:firebase_core/firebase_core.dart';
import 'package:crypto_wallet/ui/authentication.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Crypto Wallet',
      home: Authentication(),
    );
  }
}
