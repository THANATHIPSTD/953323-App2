import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WebView3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'WebView3'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebViewController _controller;
  late WebViewController _controller1;
  late WebViewController _controller2;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith('https://flutter.dev') ||
                request.url.startsWith('https://docs.flutter.dev')) {
              return NavigationDecision.navigate;
            }

            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://flutter.dev'),
      );

    _controller1 = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset('assets/index.html');

    _controller2 = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(
        '''
        <head><title>HTML</title></head>
        <body><h1>Read Local HTML file</h1></body>
        </html>
        ''',
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () async {
              if (await _controller.canGoBack()) {
                _controller.goBack();
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          IconButton(
            onPressed: () async {
              if (await _controller.canGoForward()) {
                _controller.goForward();
              }
            },
            icon: const Icon(Icons.arrow_forward),
          ),
          IconButton(
            onPressed: () {
              _controller.reload();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          const Divider(thickness: 5, height: 5),
          Expanded(
            child: WebViewWidget(controller: _controller1),
          ),
          const Divider(thickness: 5, height: 5),
          Expanded(
            child: WebViewWidget(controller: _controller2),
          ),
        ],
      ),
    );
  }
}
