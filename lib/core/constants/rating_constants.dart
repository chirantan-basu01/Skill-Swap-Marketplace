/// Available rating tags that users can select
class RatingTags {
  RatingTags._();

  static const String greatTeacher = 'Great Teacher';
  static const String patient = 'Patient';
  static const String knowledgeable = 'Knowledgeable';
  static const String goodCommunicator = 'Good Communicator';
  static const String punctual = 'Punctual';
  static const String wellPrepared = 'Well Prepared';

  /// All available tags
  static const List<String> all = [
    greatTeacher,
    patient,
    knowledgeable,
    goodCommunicator,
    punctual,
    wellPrepared,
  ];
}

/// Rating validation constants
class RatingValidation {
  RatingValidation._();

  static const int minStars = 1;
  static const int maxStars = 5;
  static const int minReviewLength = 20;
  static const int maxReviewLength = 300;
}