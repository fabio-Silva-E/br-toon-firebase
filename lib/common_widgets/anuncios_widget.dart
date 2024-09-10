import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AnunciosWidget extends StatefulWidget {
  final String adUnitId;
  const AnunciosWidget({
    super.key,
    required this.adUnitId,
  });

  @override
  State<AnunciosWidget> createState() => _AnunciosWidgetState();
}

class _AnunciosWidgetState extends State<AnunciosWidget> {
  late BannerAd? _myBanner;
  @override
  void initState() {
    super.initState();

    _myBanner = BannerAd(
      size: AdSize.banner,
      adUnitId: widget.adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            // Anúncio carregado com sucesso
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Falha ao carregar anúncio: $error');
        },
      ),
      request: AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _myBanner!.size.width.toDouble(),
      height: _myBanner!.size.height.toDouble(),
      child: AdWidget(ad: _myBanner!),
    );
  }
}
