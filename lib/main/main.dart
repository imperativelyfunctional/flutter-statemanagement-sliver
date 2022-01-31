import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:sliver/gallery/binding.dart';
import 'package:sliver/gallery/gallery.dart';
import 'package:sliver/main/binding.dart';
import 'package:sliver/main/login_client.dart';
import 'package:styled_widget/styled_widget.dart';

import 'controller.dart';

void main() {
  runApp(GetMaterialApp(
      initialBinding: MainBinding(),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => MyHomePage(), binding: MainBinding()),
        GetPage(
            name: '/gallery',
            page: () => GalleryWidget(),
            binding: GalleryBinding()),
      ],
      home: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key) {
    Timer.periodic(const Duration(seconds: 2), (time) {
      MainController controller = Get.find();
      controller.switchIcon();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lime)
            .copyWith(secondary: Colors.amber),
      ),
      dark: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber)
            .copyWith(secondary: Colors.amber),
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  MyHomePage({Key? key}) : super(key: key);

  void _onChanged(val) {
    MainController controller = Get.find();

    if (_fbKey.currentState?.validate() == true) {
      controller.markFormValid(true);
    } else {
      controller.markFormValid(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final icons = [
      Triple(Icons.ac_unit, Colors.blue, Colors.lightBlue),
      Triple(Icons.wb_sunny, Colors.orange, Colors.orangeAccent),
      Triple(Icons.nature, Colors.green, Colors.greenAccent),
      Triple(Icons.water, Colors.grey, Colors.blueGrey),
    ];

    return Scaffold(
      body: GetBuilder<MainController>(
        builder: (controller) => Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/bg.png"), fit: BoxFit.cover)),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Obx(() {
                  var icon = icons[controller.icon.value];
                  return Icon(
                    icon.data,
                    color: Colors.white,
                  )
                      .padding(all: 10)
                      .decorated(
                          color: icon.inner.withAlpha(200),
                          shape: BoxShape.circle)
                      .padding(all: 20)
                      .decorated(
                          color: icon.outer.withAlpha(200),
                          shape: BoxShape.circle);
                }),
              ),
              Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: FormBuilder(
                      key: _fbKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FormBuilderTextField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: "Email is required."),
                              FormBuilderValidators.email(context,
                                  errorText: "Not a valid email address."),
                            ]),
                            onChanged: _onChanged,
                            style: const TextStyle(color: Colors.white),
                            name: "email",
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.white54),
                                hintText: "email",
                                filled: true,
                                fillColor: Colors.white38,
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.amber,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lime, width: 0.5),
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(10, 10)))),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FormBuilderTextField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: "Password is required."),
                              FormBuilderValidators.minLength(context, 6,
                                  errorText:
                                      "Password needs to be at least 6 characters long."),
                            ]),
                            onChanged: _onChanged,
                            name: "password",
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.white54),
                                hintText: "password",
                                filled: true,
                                fillColor: Colors.white38,
                                prefixIcon: Icon(
                                  Icons.password_outlined,
                                  color: Colors.amber,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(10, 10)))),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.login),
                                  const Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, top: 5, bottom: 5),
                                      child: Text('Login')),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Opacity(
                                          opacity:
                                              controller.showSpinner ? 1 : 0,
                                          child: const GFLoader())),
                                ]),
                            onPressed: controller.validForm
                                ? () async {
                                    final result = await controller.login(
                                        LoginRequestBody(
                                            _fbKey.currentState!
                                                .fields['email']!.value,
                                            _fbKey.currentState!
                                                .fields['password']!.value));
                                    if (result) {
                                      Get.toNamed("/gallery");
                                    }
                                  }
                                : null,
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    const BorderSide(
                                        color: Colors.lime, width: 0.5)),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.lime),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black12),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(10)),
                                textStyle: MaterialStateProperty.all(
                                    const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
