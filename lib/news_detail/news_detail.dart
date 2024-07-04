import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail({
    super.key,
    required this.newsUrl,
  });
  final String newsUrl;

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  late final WebViewController controller;
  bool _isLoading = true;
  void openWhatsapp({
    required BuildContext context,
    required String text,
    required String number,
  }) async {
    var whatsapp = number.replaceAll(" ", "+"); //+92xx enter like this
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=$text";
    var whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.tryParse(text)}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(
          whatsappURLIos,
        ));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Error",
            ),
          ),
        );
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Error",
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // #docregion webview_controller
    controller = WebViewController()
      ..enableZoom(true)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('https://api.whatsapp.com/send?phone')) {
              // Get phone number from whatsapp url
              String phone = getPhoneNumberFromUrl(request.url);
              // Get message from whatsapp url
              String message = getTextFromUrl(request.url);
              // Open Whatsapp
              openWhatsapp(
                context: context,
                text: message,
                number: phone,
              );
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.newsUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              sharePressed(widget.newsUrl);
            },
            icon: const Icon(
              Icons.share,
              size: 25,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 20),
                  Text(
                    "Loading...",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            )
          : WebViewWidget(controller: controller),
    );
  }
}

String getPhoneNumberFromUrl(String url) {
  Uri uri = Uri.parse(url);
  String? phoneNumber = uri.queryParameters['phone'];
  return "$phoneNumber";
}

String getTextFromUrl(String url) {
  Uri uri = Uri.parse(url);
  String? text = uri.queryParameters['text'];
  return "$text";
}

void sharePressed(String message) {
  Share.share(message);
}
