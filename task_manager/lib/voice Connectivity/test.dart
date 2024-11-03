import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TaskRepetition {
  int repeatInterval;
  String repeatUnit;
  String? repeatUntil;

  TaskRepetition({
    required this.repeatInterval,
    required this.repeatUnit,
    this.repeatUntil,
  });

  Map<String, dynamic> toJson() {
    return {
      'repeatInterval': repeatInterval,
      'repeatUnit': repeatUnit,
      'repeatUntil': repeatUntil,
    };
  }
}

class TaskReminder {
  int reminderInterval;
  String reminderUnit;
  String reminderType;

  TaskReminder({
    required this.reminderInterval,
    required this.reminderUnit,
    required this.reminderType,
  });

  Map<String, dynamic> toJson() {
    return {
      'reminderInterval': reminderInterval,
      'reminderUnit': reminderUnit,
      'reminderType': reminderType,
    };
  }
}

class SubTask {
  String title;
  bool status;

  SubTask({
    required this.title,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
    };
  }
}

class Task {
  int? id;
  String title;
  String? description;
  int priority;
  String category;
  String? date;
  String? time;
  TaskRepetition? repeatPattern; // Ensure this is not duplicated
  List<TaskReminder>? reminders;
  List<SubTask>? subTasks;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.category,
    this.date,
    this.time,
    this.repeatPattern,
    this.reminders,
    this.subTasks,
  });

  // Convert Task to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'category': category,
      'date': date,
      'time': time,
      'repeatPattern': repeatPattern?.toJson(),
      'reminders': reminders?.map((reminder) => reminder.toJson()).toList(),
      'subTasks': subTasks?.map((subTask) => subTask.toJson()).toList(),
    };
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _createTask(); // Call task creation here
    });
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
      print("I am speaking: $_wordsSpoken"); // Debug: Print spoken text
    });
  }

  void _createTask() {
    // Define regex patterns for each field
    final titlePattern = RegExp(
        r"title\s+(.*?)(?=\s+(description|priority|category|date|time|repeat|reminder|subtask|$))");
    final descriptionPattern = RegExp(
        r"description\s+(.*?)(?=\s+(title|priority|category|date|time|repeat|reminder|subtask|$))");
    final priorityPattern = RegExp(r"priority\s+(low|mid|high)");
    final categoryPattern = RegExp(
        r"category\s+(.*?)(?=\s+(title|description|priority|date|time|repeat|reminder|subtask|$))");
    final datePattern = RegExp(r"date\s+([\w\s]+)");
    final timePattern = RegExp(r"time\s+([\d:apm\s]+)");
    final repeatPattern = RegExp(r"repeat\s+every\s+(\d+)\s+(\w+)");
    final untilPattern = RegExp(r"until\s+([\w\s]+)");
    final reminderPattern =
    RegExp(r"reminder\s+(\d+)\s+(\w+)\s+(notification|email|sms)");
    final subtaskPattern = RegExp(r"subtask\s+(.*)");

    // Match fields with regex
    String title = _getMatchedValue(titlePattern, "Untitled");
    String? description = _getMatchedValue(descriptionPattern);
    int priority = _parsePriority(_getMatchedValue(priorityPattern));
    String category = _getMatchedValue(categoryPattern, "Uncategorized");
    String? date = _getMatchedValue(datePattern);
    String? time = _getMatchedValue(timePattern);

    // Handle repeat pattern
    TaskRepetition? repeatPatternObj; // Changed variable name to avoid conflict
    var repeatMatch = repeatPattern.firstMatch(_wordsSpoken);
    if (repeatMatch != null) {
      repeatPatternObj = TaskRepetition(
        repeatInterval: int.parse(repeatMatch.group(1)!),
        repeatUnit: repeatMatch.group(2)!,
        repeatUntil: _getMatchedValue(untilPattern),
      );
    }

    // Handle reminders
    List<TaskReminder>? reminders;
    final reminderMatches = reminderPattern.allMatches(_wordsSpoken);
    if (reminderMatches.isNotEmpty) {
      reminders = reminderMatches.map((match) {
        return TaskReminder(
          reminderInterval: int.parse(match.group(1)!),
          reminderUnit: match.group(2)!,
          reminderType: match.group(3)!,
        );
      }).toList();
    }

    // Handle subtasks
    List<SubTask>? subTasks;
    final subTaskMatches = subtaskPattern.allMatches(_wordsSpoken);
    if (subTaskMatches.isNotEmpty) {
      subTasks = subTaskMatches.map((match) {
        return SubTask(
          title: match.group(1)!.trim(),
          status: false,
        );
      }).toList();
    }

    // Create task object
    Task newTask = Task(
      title: title,
      description: description,
      priority: priority,
      category: category,
      date: date,
      time: time,
      repeatPattern: repeatPatternObj,
      reminders: reminders,
      subTasks: subTasks,
    );

    print("Task Created: ${newTask.toJson()}");
  }

  String _getMatchedValue(RegExp pattern, [String? defaultValue]) {
    final match = pattern.firstMatch(_wordsSpoken);
    return match != null ? match.group(1)!.trim() : defaultValue ?? '';
  }

  int _parsePriority(String? priorityText) {
    switch (priorityText?.toLowerCase()) {
      case "low":
        return 1;
      case "mid":
        return 2;
      case "high":
        return 3;
      default:
        return 1; // Default to low if not specified
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Speech Demo', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? "listening..."
                    : _speechEnabled
                    ? "Tap the microphone to start listening..."
                    : "Speech not available",
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _wordsSpoken,
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
              icon:
              Icon(_speechToText.isListening ? Icons.mic : Icons.mic_none),
              onPressed:
              _speechToText.isListening ? _stopListening : _startListening,
              iconSize: 64.0,
            ),
          ],
        ),
      ),
    );
  }
}