class Flashcard {
  int? id;
  final int topicId; // Change from String topic to int topicId
  final String question;
  final String answer;

  Flashcard({
    this.id,
    required this.topicId, // Updated to use topicId
    required this.question,
    required this.answer,
  });

  // Adjust the copy method accordingly
  Flashcard copy({
    int? id,
    int? topicId,
    String? question,
    String? answer,
  }) =>
      Flashcard(
        id: id ?? this.id,
        topicId: topicId ?? this.topicId,
        question: question ?? this.question,
        answer: answer ?? this.answer,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topicId': topicId, // Reflecting the change to topicId
      'question': question,
      'answer': answer,
    };
  }

  // Adjust the fromMap factory for topicId
  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      topicId: map['topicId'], // Use the correct field from the map
      question: map['question'],
      answer: map['answer'],
    );
  }
}
