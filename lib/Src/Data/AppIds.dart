import 'dart:io';

class AdIds {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5238824914705486~7105277286";
    } else {
      return "ca-app-pub-5238824914705486~4523844304";
    }
  }

  static String get bannerId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5238824914705486/4291411683";
    } else {
      return "ca-app-pub-5238824914705486/1897680963";
    }
  }

  static String get openAd {
    if (Platform.isAndroid) {
      return "ca-app-pub-5238824914705486/9031981243";
    } else {
      return "ca-app-pub-5238824914705486/5645354280";
    }
  }

  static String get startInt {
    if (Platform.isAndroid) {
      return "ca-app-pub-5238824914705486/6099317377";
    } else {
      return "ca-app-pub-5238824914705486/9201455912";
    }
  }

  static String get performanceInt {
    if (Platform.isAndroid) {
      return "ca-app-pub-5238824914705486/3870392248";
    } else {
      return "ca-app-pub-5238824914705486/2889244726";
    }
  }

  static String get facebookAppid {
    if (Platform.isAndroid) {
      return "277341654109719";
    } else {
      return "277341654109719";
    }
  }

  static String get applovinSdkId {
    if (Platform.isAndroid) {
      return "LTVla0Ir4MFk1XkJtPoDUfB2qvtJTTFXrNTTf9ROZIQZUtWXBwAZPd4IgfzhqJA2QdhWnzUFo-Z-e6_Wb_z4zy";
    } else {
      return "LTVla0Ir4MFk1XkJtPoDUfB2qvtJTTFXrNTTf9ROZIQZUtWXBwAZPd4IgfzhqJA2QdhWnzUFo-Z-e6_Wb_z4zy";
    }
  }

  static String get applovinInt {
    if (Platform.isAndroid) {
      return "4d0464bb4c2477ba";
    } else {
      return "4d0464bb4c2477ba";
    }
  }
}
