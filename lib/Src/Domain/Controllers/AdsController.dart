import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pacer/Src/Utils/Functions.dart';
import 'package:applovin_max/applovin_max.dart';
import '../../Data/AppIds.dart';

enum AdLoadState { notLoaded, loading, loaded }

class AdsController extends GetxController {
  bool consentstatus = false;
  // banner at landing page
  late BannerAd landingpagebanner;
  RxBool islandingpagebannerloaded = false.obs;
  // banner at home page
  late BannerAd homepagebanner;
  RxBool ishomepagebannerloaded = false.obs;

  //banneradsize
  AnchoredAdaptiveBannerAdSize? size;
//interstitial ad
  InterstitialAd? startint;
  InterstitialAd? performanceint;

  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  Future fullbanner() async {
    return await AdSize.getAnchoredAdaptiveBannerAdSize(
        Orientation.portrait, Get.width.toInt());
  }

  createbannersize() async {
    size = await fullbanner();
  }

  //landingpage banner

  createlandingpagebanner() async {
    landingpagebanner = BannerAd(
      size: size ?? AdSize.banner,
      adUnitId: AdIds.bannerId,
      request: request,
      listener: BannerAdListener(onAdLoaded: (_) {
        dlog("", "Successfully Load A Banner Ad");
        islandingpagebannerloaded.value = true;
      }, onAdFailedToLoad: (ad, LoadAdError error) {
        dlog("", "Failed to Load A Banner Ad = $error");
        islandingpagebannerloaded.value = false;

        ad.dispose();
      }),
    );
    landingpagebanner.load();
  }

  //homepage banner

  createhomepagebanner() async {
    homepagebanner = BannerAd(
      size: size ?? AdSize.banner,
      adUnitId: AdIds.bannerId,
      request: request,
      listener: BannerAdListener(onAdLoaded: (_) {
        dlog("", "Successfully Load A Banner Ad");
        ishomepagebannerloaded.value = true;
      }, onAdFailedToLoad: (ad, LoadAdError error) {
        dlog("", "Failed to Load A Banner Ad = $error");
        ishomepagebannerloaded.value = false;

        ad.dispose();
      }),
    );
    homepagebanner.load();
  }

  static AdRequest request = const AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  //create and show start int

  createstartint() {
    InterstitialAd.load(
        adUnitId: AdIds.startInt,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            startint = ad;
            _numInterstitialLoadAttempts = 0;
            startint!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            startint = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createstartint();
            }
          },
        ));
  }

  showstartintad() {
    if (startint == null) {
      dlog('', '\nWarning: attempt to show interstitial before loaded.');
      if (Platform.isAndroid) {
        load_applovin_inter();
      }

      return;
    }
    startint!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        dlog('', '\nad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();

        createstartint();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createstartint();
      },
    );
    startint!.show();
    startint = null;
  }
//end of start int

  //create and show start int

  createperformanceint() {
    InterstitialAd.load(
        adUnitId: AdIds.performanceInt,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            performanceint = ad;
            _numInterstitialLoadAttempts = 0;
            performanceint!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            performanceint = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createperformanceint();
            }
          },
        ));
  }

  showperformanceintad() {
    if (performanceint == null) {
      dlog('', '\nWarning: attempt to show interstitial before loaded.');
      if (Platform.isAndroid) {
        load_applovin_inter();
      }

      return;
    }
    performanceint!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        dlog('', '\nad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();

        createperformanceint();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createperformanceint();
      },
    );
    performanceint!.show();
    performanceint = null;
  }
//end of start int

//APPLOVIN

  final String sdkkey = Platform.isAndroid
      ? "LTVla0Ir4MFk1XkJtPoDUfB2qvtJTTFXrNTTf9ROZIQZUtWXBwAZPd4IgfzhqJA2QdhWnzUFo-Z-e6_Wb_z4zy"
      : "LTVla0Ir4MFk1XkJtPoDUfB2qvtJTTFXrNTTf9ROZIQZUtWXBwAZPd4IgfzhqJA2QdhWnzUFo-Z-e6_Wb_z4zy";

  final String _interstitial_ad_unit_id = AdIds.applovinInt;

  var isInitialized = false;
  var interstitialLoadState = AdLoadState.notLoaded;
  var _interstitialRetryAttempt = 0;

  Future<void> initialize_applovin() async {
    debugPrint("initialize_applovin called");
    Map? configuration = await AppLovinMAX.initialize(sdkkey);
    if (configuration != null) {
      isInitialized = true;
      attachAdListeners();
    }
  }

  void attachAdListeners() {
    debugPrint("inside attachAdListeners");
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        interstitialLoadState = AdLoadState.loaded;
        _interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        debugPrint("app lovin failed ti load");
        interstitialLoadState = AdLoadState.notLoaded;
        _interstitialRetryAttempt = _interstitialRetryAttempt + 1;
        int retryDelay = pow(2, min(6, _interstitialRetryAttempt)).toInt();
        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          debugPrint("\nDelayed called for apploving");
          AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        });
      },
      onAdDisplayedCallback: (ad) {},
      onAdDisplayFailedCallback: (ad, error) {
        interstitialLoadState = AdLoadState.notLoaded;
      },
      onAdClickedCallback: (ad) {},
      onAdHiddenCallback: (ad) {
        interstitialLoadState = AdLoadState.notLoaded;
      },
    ));
  }

  bool isReady = false;
  void load_applovin_inter() async {
    debugPrint("load_applovin_inter called");
    AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);

    isReady =
        (await AppLovinMAX.isInterstitialReady(_interstitial_ad_unit_id))!;
    debugPrint("enter");
    if (isReady) {
      debugPrint("AppLovinMAX.showInterst called");
      AppLovinMAX.showInterstitial(_interstitial_ad_unit_id);
    } else {
      debugPrint("bash");
    }
  }
}
