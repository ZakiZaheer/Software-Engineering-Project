import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
class SpeechToTextService {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  Future<void> initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    if (_speechEnabled) {
      print("Speech recognition initialized successfully.");
    } else {
      print("Speech recognition initialization failed.");
    }
  }

  Future<void> startListening(Function(SpeechRecognitionResult) callBackFunction) async {
    if (_speechEnabled) {
      await _speechToText.listen(onResult: (result) {
        callBackFunction(result);
      });
    } else {
      print("Speech recognition is not enabled.");
    }
  }

  Future<void> stopListening(Function() onStop) async {
    if (_speechEnabled && _speechToText.isListening) {
      await _speechToText.stop();
      onStop();
    }
  }
}
