import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdWidget extends StatefulWidget {
  final Widget child; // The widget to display after the ad
  final String adUnitId;

  const InterstitialAdWidget({
    Key? key,
    required this.child,
    required this.adUnitId,
  }) : super(key: key);

  @override
  _InterstitialAdWidgetState createState() => _InterstitialAdWidgetState();
}

class _InterstitialAdWidgetState extends State<InterstitialAdWidget> {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: widget.adUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _navigateToChildWidget();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              print('Ad failed to show: $error');
              _navigateToChildWidget();
            },
          );
          _showInterstitialAd();
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
          _isAdLoaded = false;
          _navigateToChildWidget();
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      _navigateToChildWidget();
    }
  }

  void _navigateToChildWidget() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => widget.child),
      );
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Optional loading indicator
      ),
    );
  }
}
