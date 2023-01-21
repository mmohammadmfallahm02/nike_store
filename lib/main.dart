import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nike/constants/Product_sort.dart';
import 'package:nike/constants/theme.dart';
import 'package:nike/data/repo/product_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    productRepository.getAll(ProductSort.latest).then((value) {
      debugPrint(value.toString());
    }).catchError((e) {
      debugPrint(e.toString());
    });
    const defaultFontFamily = TextStyle(
        fontFamily: "IranYekan", color: LightThemeColors.primaryTextColor);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'), // Persian
      ],
      theme: ThemeData(
          fontFamily: "IranYekan",
          // text theme
          textTheme: TextTheme(
            bodyText2: defaultFontFamily,
            headline6: defaultFontFamily.copyWith(fontWeight: FontWeight.w700),
            caption: defaultFontFamily.apply(
                color: LightThemeColors.secondaryTextColor),
          ),
          // color scheme
          colorScheme: const ColorScheme.light(
              primary: LightThemeColors.primaryColor,
              secondary: LightThemeColors.secondaryColor,
              onSecondary: Colors.white)),
      home: Scaffold(
          appBar: AppBar(title: const Text("فروشگاه نایک")),
          body: const Center(
            child: Text(
              'دکمه را فشار دهید',
            ),
          )),
    );
  }
}
