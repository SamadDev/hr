class Survey {
  int id;
  String name;
  int noOfQuestions;
  String description;
  List<Questions> questions;

  Survey({
    this.id,
    this.name,
    this.noOfQuestions,
    this.description,
    this.questions,
  });

  Survey.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    noOfQuestions = json['noOfQuestions'];
    description = json['description'];
    if (json['questions'] != null) {
      questions = new List<Questions>();
      json['questions'].forEach((v) {
        questions.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['noOfQuestions'] = this.noOfQuestions;
    data['description'] = this.description;
    if (this.questions != null) {
      data['questions'] = this.questions.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static List<Survey> toList(parsed) {
    return parsed.map<Survey>((json) => Survey.fromJson(json)).toList();
  }
}

class Questions {
  int id;
  int surveyId;
  String title;
  bool required;
  int surveyQuestionTypeId;
  bool collapsed = true;
  String helpText;
  List<Values> values;

  Questions({
    this.id,
    this.surveyId,
    this.title,
    this.required,
    this.surveyQuestionTypeId,
    this.collapsed,
    this.helpText,
    this.values,
  });

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    surveyId = json['surveyId'];
    title = json['title'];
    required = json['required'];
    surveyQuestionTypeId = json['surveyQuestionTypeId'];
    helpText = json['helpText'];
    if (json['values'] != null) {
      values = [];
      json['values'].forEach((v) {
        values.add(new Values.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['surveyId'] = this.surveyId;
    data['title'] = this.title;
    data['required'] = this.required;
    data['surveyQuestionTypeId'] = this.surveyQuestionTypeId;
    data['helpText'] = this.helpText;
    if (this.values != null) {
      data['values'] = this.values.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Values {
  int id;
  int surveyQuestionId;
  String value;

  Values({
    this.id,
    this.surveyQuestionId,
    this.value,
  });

  Values.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    surveyQuestionId = json['surveyQuestionId'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['surveyQuestionId'] = this.surveyQuestionId;
    data['value'] = this.value;
    return data;
  }
}
