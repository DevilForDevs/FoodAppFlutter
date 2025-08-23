import 'dart:ui';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdController extends GetxController {
  RewardedAd? rewardedAd;


  // Load rewarded ad
  void loadRewardedAd() {
    if(rewardedAd==null){
      print("loading mad");
      RewardedAd.load(
        adUnitId: 'ca-app-pub-1261818971959382/3869467323', // Your real rewarded ID
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) => rewardedAd = ad,
          onAdFailedToLoad: (error) => rewardedAd = null,
        ),
      );
    }
  }

  // Show rewarded ad
  void showRewardedAd({required VoidCallback onRewarded, VoidCallback? onAdClosed}) {
    if (rewardedAd != null) {
      rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          //loadRewardedAd(); // Reload
          onAdClosed?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          // loadRewardedAd();
        },
      );

      rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          onRewarded(); // Give reward to user
        },
      );
      rewardedAd = null;
    } else {
      onAdClosed?.call();
    }
  }

  @override
  void onInit() {
    loadRewardedAd();
    super.onInit();
  }
}

