import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewr extends StatefulWidget {
  PDFViewr({
    Key key,
    this.reportName,
    this.title,
    this.fileName,
    this.parameters,
  }) : super(key: key);

  String reportName;
  String title;
  String fileName;
  String parameters;

  @override
  _PDFViewrState createState() => _PDFViewrState();
}

class _PDFViewrState extends State<PDFViewr> {
  String remotePDFpath;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();

    getPDF().then((f) {
      setState(() {
        remotePDFpath = f.path;
      });
    });
  }

  Future<File> getPDF() async {
    Completer<File> completer = Completer();

    var url =
        "https://crm-api.dottech.co/api/reports/?reportName=reports/${widget.reportName}&parameters=${widget.parameters}&format=pdf&inline=true&fileName=${widget.fileName}";
    
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var crmToken = prefs.getString("crmToken");
    var header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $crmToken',
    };

    final response = await http.get(Uri.parse(url), headers: header);

    if (response.statusCode == 200) {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File file = new File('$tempPath/kardo.pdf');
      await file.writeAsBytes(response.bodyBytes, flush: true);
      completer.complete(file);
    } else {
      throw Exception('Failed to load');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      layoutBackgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: widget.title,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await FlutterShare.shareFile(
                title: widget.title,
                text: widget.title,
                filePath: remotePDFpath,
                chooserTitle: widget.title,
              );
            },
            icon: Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: remotePDFpath == null
          ? LoadingWidget()
          : PDFView(
              filePath: remotePDFpath,
              enableSwipe: true,
              swipeHorizontal: true,
              fitEachPage: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              defaultPage: currentPage,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation: false,
              // if set to true the link is handled in flutter
              onRender: (_pages) {
                setState(() {
                  pages = _pages;
                  isReady = true;
                });
              },
              onError: (error) {
                setState(() {
                  errorMessage = error.toString();
                });
                
              },
              onPageError: (page, error) {
                setState(() {
                  errorMessage = '$page: ${error.toString()}';
                });
                
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
              onLinkHandler: (String uri) {
                
              },
              onPageChanged: (int page, int total) {
                
                setState(() {
                  currentPage = page;
                });
              },
            ),
    );
  }
}
