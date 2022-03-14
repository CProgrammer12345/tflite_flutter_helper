import 'dart:io';
import 'package:download_assets/download_assets.dart';
import "package:flutter/material.dart";
import 'main.dart';
import "localdb.dart";
class ModelSelectionPage extends StatefulWidget {
  const ModelSelectionPage({Key? key}) : super(key: key);

  @override
  _ModelSelectionPageState createState() => _ModelSelectionPageState();
}

class _ModelSelectionPageState extends State<ModelSelectionPage> {
  DownloadAssetsController downloadAssetsController = DownloadAssetsController();
  String message = "Press the download button to start the download";
  bool downloaded = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    await downloadAssetsController.init();
    downloaded = await downloadAssetsController.assetsDirAlreadyExists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TfLite Flutter Helper',
              style: TextStyle(color: Colors.white)),
        ),
        body: Center(
            child: Column(
                children: [
                  ElevatedButton(
                      onPressed: _downloadAssets,
                      child: Text(
                          "Download"
                      )
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("go");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                    },
                    child: Text("Try It"),
                  ),
                ]

            )
        )
    );
  }


  Future _downloadAssets() async {
    bool assetsDownloaded = await downloadAssetsController.assetsDirAlreadyExists();
    try {
      await downloadAssetsController.startDownload(
        assetsUrl: "https://firebasestorage.googleapis.com/v0/b/example-6fd34.appspot.com/o/examplecalvin%2Fassets.zip?alt=media&token=c4c65ae3-665c-47cc-b417-903811f75033",
        onProgress: (progressValue) {
          downloaded = false;
          setState(() {
            if (progressValue < 100) {
              message = "Downloading - ${progressValue.toStringAsFixed(2)}";
              print(message);
            } else {
              message = "Download completed\nClick in refresh button to force download";
              print(message);
              LocalDB.modelName = "animalblood_model.tflite";
              LocalDB.labelName = "animalblood_labels.txt";

              LocalDB.modelFile = File(downloadAssetsController.assetsDir.toString() + "/" + LocalDB.modelName);
              LocalDB.labelFile = File(downloadAssetsController.assetsDir.toString() + "/" + LocalDB.labelName);
              downloaded = true;
              print(downloadAssetsController.assetsDir);
            }
          });
        },
      );
    }
    on DownloadAssetsException catch (e) {
      print(e.toString());
      setState(() {
        downloaded = false;
        message = "Error: ${e.toString()}";
      });
    }
  }
}
