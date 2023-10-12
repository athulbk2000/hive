import 'package:flutter/material.dart';
import 'package:hiv/hivdatabase.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('school_box');
  runApp(hiv());
}
class hiv extends StatelessWidget {
  const hiv({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:hivdata(),
    );
  }
}