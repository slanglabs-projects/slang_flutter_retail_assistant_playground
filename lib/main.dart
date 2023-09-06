import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:slang_retail_assistant/slang_retail_assistant.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    implements
        RetailAssistantLifeCycleObserver,
        RetailAssistantVoiceAssistListener {
  String _searchText = '';
  String _utteranceText = '';

  @override
  void initState() {
    super.initState();
    initSlangRetailAssistant();
  }

  void initSlangRetailAssistant() {
    var assistantConfig = new AssistantConfiguration()
      ..assistantId = "<AssistantId>"
      ..apiKey = "<ApiKey>";

    SlangRetailAssistant.initialize(assistantConfig);
    SlangRetailAssistant.setLifecycleObserver(this);
    SlangRetailAssistant.setOnSearchListener((searchInfo, searchUserJourney) {
      setState(() {
        try {
          JsonEncoder encoder = const JsonEncoder.withIndent('  ');
          String searchMapString = encoder.convert(searchInfo);
          _searchText = searchMapString.toString();
        } catch (e) {
          print(e);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Slang Retail PlayGround App'),
            ),
            body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              height: 45.0,
                              margin:
                              const EdgeInsets.fromLTRB(17.0, 0.0, 10.0, 0.0),
                              child: TextField(
                                controller:
                                TextEditingController(text: _utteranceText),
                                decoration: InputDecoration(
                                  labelText: 'Utterance Text',
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: _searchText));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Utterance text copied')),
                                      );
                                    },
                                    child: Icon(Icons.copy),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  _utteranceText = value;
                                },
                              )),
                        ),
                        Container(
                          height: 42,
                          width: 42,
                          margin: const EdgeInsets.only(right: 10.0),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                              padding: EdgeInsets.all(
                                  8.0), // Adjust the padding as needed
                              child: SlangConvaTriggerView(
                                  imageAsset: 'assets/mic.png')),
                        ),
                      ],
                    ),
                    Container(height: 30), // set height
                    Flexible(
                        child: FractionallySizedBox(
                            widthFactor: 0.9,
                            heightFactor: 0.98,
                            child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.black,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      '$_searchText\n',
                                      style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ))))
                  ],
                ))));
  }

  @override
  void onAssistantClosed(bool isCancelled) {
    print("onAssistantClosed " + isCancelled.toString());
  }

  @override
  void onAssistantInitFailure(String description) {
    print("onAssistantInitFailure " + description);
  }

  @override
  void onAssistantInitSuccess() {
    print("onAssistantInitSuccess");
  }

  @override
  void onAssistantInvoked() {
    print("onAssistantInvoked");
  }

  @override
  void onAssistantLocaleChanged(Map<String, String> locale) {
    print("onAssistantLocaleChanged " + locale.toString());
  }

  @override
  void onOnboardingFailure() {
    print("onOnboardingFailure");
  }

  @override
  void onOnboardingSuccess() {
    print("onOnboardingSuccess");
  }

  @override
  void onUnrecognisedUtterance(String utterance) {
    print("onUnrecognisedUtterance " + utterance);
  }

  @override
  void onUtteranceDetected(String utterance) {
    print("onUtteranceDetected " + utterance);
    _utteranceText = utterance;
  }

  @override
  void onMicPermissionDenied() {
    print("onMicPermissionDenied");
  }

  @override
  void onMicPermissionGranted() {
    print("onMicPermissionDenied");
  }

  @override
  void onCoachmarkAction(AssistantCoachmarkType coachmarkType,
      AssistantCoachmarkAction coachmarkAction) {
    print(
        "onCoachmarkAction CoachmarkType=$coachmarkType CoachmarkAction=$coachmarkAction");
  }

  @override
  void onVoiceAssistEnd(String promptId, String promptText, bool b) {
    print("onVoiceAssistEnd promptId " +
        promptId +
        " promptText " +
        promptText +
        " boolean " +
        b.toString());
  }

  @override
  void onVoiceAssistStart(String promptId, String promptText) {
    print("onVoiceAssistStart promptId " +
        promptId +
        " promptText " +
        promptText);
  }
}
