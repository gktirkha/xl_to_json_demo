class Question {
  String name;
  String? file_name;
  String? file_path;
  String type;
  int number;
  List<Option> options;

  Question({
    required this.name,
    this.file_name,
    this.file_path,
    required this.type,
    required this.number,
    required this.options,
  });

  factory Question.fromJson(dynamic json, int num) {
    return Question(
        name: json["question"],
        type: json["question_type"],
        number: num,
        options: optionFromList(json));
  }
}

List<Question> questionFromJSon(json) {
  List<Question> questions = [];
  for (int i = 0; i < json.length; i++) {
    questions.add(Question.fromJson(json[i], i + 1));
  }
  return questions;
}

class Option {
  String text;
  String? file_name;
  String? file_path;
  int number;
  bool is_answer;
  String? file_mime_type;
  String type;
  Option({
    required this.text,
    this.file_name,
    this.file_path,
    required this.number,
    required this.is_answer,
    this.file_mime_type,
    required this.type,
  });
}

List<Option> optionFromList(dynamic json) {
  List<Option> options = [];
  Option optionA = Option(
      text: json["option_a_content"],
      number: 1,
      is_answer: true,
      type: json["option_a_type"]);
  Option optionB = Option(
      text: json["option_b_content"],
      number: 2,
      is_answer: false,
      type: json["option_b_type"]);

  Option optionC = Option(
      text: json["option_c_content"],
      number: 3,
      is_answer: false,
      type: json["option_c_type"]);
  Option optionD = Option(
      text: json["option_d_content"],
      number: 4,
      is_answer: false,
      type: json["option_d_type"]);

  options.add(optionA);
  options.add(optionB);
  options.add(optionC);
  options.add(optionD);
  return options;
}
