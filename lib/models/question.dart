import 'dart:convert';

enum QuestionType {
  multipleChoice,
  trueFalse,
  fieldPosition,
  orderPlay,
  matchPairs,
  fillBlank,
  tacticalScenario,
  formation,
  refereeDecision,
  timed,
}

QuestionType questionTypeFromString(String s) {
  switch (s) {
    case 'multiple_choice': return QuestionType.multipleChoice;
    case 'true_false': return QuestionType.trueFalse;
    case 'field_position': return QuestionType.fieldPosition;
    case 'order_play': return QuestionType.orderPlay;
    case 'match_pairs': return QuestionType.matchPairs;
    case 'fill_blank': return QuestionType.fillBlank;
    case 'tactical_scenario': return QuestionType.tacticalScenario;
    case 'formation': return QuestionType.formation;
    case 'referee_decision': return QuestionType.refereeDecision;
    case 'timed': return QuestionType.timed;
    default: return QuestionType.multipleChoice;
  }
}

String questionTypeToString(QuestionType t) {
  switch (t) {
    case QuestionType.multipleChoice: return 'multiple_choice';
    case QuestionType.trueFalse: return 'true_false';
    case QuestionType.fieldPosition: return 'field_position';
    case QuestionType.orderPlay: return 'order_play';
    case QuestionType.matchPairs: return 'match_pairs';
    case QuestionType.fillBlank: return 'fill_blank';
    case QuestionType.tacticalScenario: return 'tactical_scenario';
    case QuestionType.formation: return 'formation';
    case QuestionType.refereeDecision: return 'referee_decision';
    case QuestionType.timed: return 'timed';
  }
}

class Question {
  final String id;
  final int level;
  final QuestionType type;
  final String question;
  final List<String> options;
  final int answer;
  final String explanation;
  final int difficulty;

  Question({
    required this.id,
    required this.level,
    required this.type,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.difficulty,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      level: json['level'] as int,
      type: questionTypeFromString(json['type'] as String),
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      answer: json['answer'] as int,
      explanation: json['explanation'] as String,
      difficulty: json['difficulty'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'level': level,
    'type': questionTypeToString(type),
    'question': question,
    'options': options,
    'answer': answer,
    'explanation': explanation,
    'difficulty': difficulty,
  };

  bool isCorrect(int selected) => selected == answer;
}

class QuestionAnswer {
  final String questionId;
  final bool correct;
  final DateTime answeredAt;

  QuestionAnswer({
    required this.questionId,
    required this.correct,
    required this.answeredAt,
  });

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'correct': correct,
    'answeredAt': answeredAt.toIso8601String(),
  };

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) => QuestionAnswer(
    questionId: json['questionId'] as String,
    correct: json['correct'] as bool,
    answeredAt: DateTime.parse(json['answeredAt'] as String),
  );
}
