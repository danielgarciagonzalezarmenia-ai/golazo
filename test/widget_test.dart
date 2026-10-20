import 'package:flutter_test/flutter_test.dart';
import 'package:golazo/models/question.dart';

void main() {
  test('Question.fromJson parse correctamente', () {
    final q = Question.fromJson({
      'id': 'q1',
      'level': 1,
      'type': 'multiple_choice',
      'question': '¿Pregunta?',
      'options': ['A', 'B', 'C', 'D'],
      'answer': 0,
      'explanation': 'Explicación',
      'difficulty': 1,
    });
    expect(q.id, 'q1');
    expect(q.level, 1);
    expect(q.isCorrect(0), isTrue);
    expect(q.isCorrect(1), isFalse);
  });

  test('questionTypeFromString mapea tipos', () {
    expect(questionTypeFromString('true_false'), QuestionType.trueFalse);
    expect(questionTypeFromString('timed'), QuestionType.timed);
  });
}
