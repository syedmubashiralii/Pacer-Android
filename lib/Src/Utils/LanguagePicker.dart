import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pacer/Src/Utils/Widgets.dart';
import '../Domain/DataHandlers/PreferencesData.dart';
import 'Constants.dart';

void languagepickerdialog(BuildContext context) async {
  showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.white38,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 600),
      transitionBuilder: (BuildContext context, Animation<double> a1,
              Animation<double> a2, Widget child) =>
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(a1),
            child: Dialog(
              backgroundColor: AppColors.primaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppColors.primaryLight,
                        Colors.black,
                      ],
                    )),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "Select Language",
                              style: TextStyle(
                                fontSize: 22,
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                for (int i = 0; i <= 3; i++) ...[
                                  InkWell(
                                    onTap: () {
                                      selectedlanguage = languagelist[i].locale;
                                      AppSharedPreferences.addlanguage(
                                          languagelist[i].locale);
                                      Get.updateLocale(
                                          Locale(languagelist[i].locale));
                                      Get.back();
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: Image.asset(
                                                languagelist[i].flag)),
                                        text(languagelist[i].name,
                                            languagelist[i].locale)
                                      ],
                                    ),
                                  ),
                                ]
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                for (int i = 4; i <= 7; i++) ...[
                                  InkWell(
                                    onTap: () {
                                      selectedlanguage = languagelist[i].locale;
                                      AppSharedPreferences.addlanguage(
                                          languagelist[i].locale);
                                      Get.updateLocale(
                                          Locale(languagelist[i].locale));
                                      Get.back();
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: Image.asset(
                                                languagelist[i].flag)),
                                        text(languagelist[i].name,
                                            languagelist[i].locale)
                                      ],
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
      pageBuilder: (context, anim1, anim2) {
        return Transform.rotate(
          angle: anim1.value,
        );
      });
}

List<LanguageModel> languagelist = [
  LanguageModel(name: "English", flag: AppImages.english, locale: 'en'),
  LanguageModel(name: "Português", flag: AppImages.portugal, locale: 'pt'),
  LanguageModel(name: "हिंदी", flag: AppImages.india, locale: 'hi'),
  LanguageModel(name: "française", flag: AppImages.france, locale: 'fr'),
  LanguageModel(name: "عربي", flag: AppImages.saudia, locale: 'ar'),
  LanguageModel(name: "Deutsch", flag: AppImages.germany, locale: 'de'),
  LanguageModel(name: "Española", flag: AppImages.spain, locale: 'es'),
  LanguageModel(name: "中国人", flag: AppImages.china, locale: 'zh'),
];

class LanguageModel {
  String name;
  String flag;
  String locale;
  LanguageModel({required this.name, required this.flag, required this.locale});
}
