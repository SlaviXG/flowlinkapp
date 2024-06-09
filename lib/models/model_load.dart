class ModelLoad {
  final Map<String, dynamic> currentDateAndTime;
  final String textForExtraction;
  final String? metadata;

  ModelLoad({
    required this.currentDateAndTime,
    required this.textForExtraction,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_date_and_time': currentDateAndTime,
      'text_for_extraction': textForExtraction,
      'metadata': metadata,
    };
  }
}
