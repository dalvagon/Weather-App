import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => const HomeScreen(),
};
