// models/user.dart
class User {
  final int? id;
  final String fullName;
  final String email;
  final String dateOfBirth;
  final String mobileNumber;
  final double? weight;
  final double? height;
  final String? gender;
  final UserGoal? goals;
  final List<DailyLog>? dailyLogs;

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.dateOfBirth,
    required this.mobileNumber,
    this.weight,
    this.height,
    this.gender,
    this.goals,
    this.dailyLogs,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      dateOfBirth: json['date_of_birth'],
      mobileNumber: json['mobile_number'],
      weight: double.tryParse(json['weight'] ?? '') ?? 0.0,
      height: double.tryParse(json['height'] ?? '') ?? 0.0,
      gender: json['gender'],
      goals: json['goals'] != null ? UserGoal.fromJson(json['goals']) : null,
      dailyLogs: json['daily_logs'] != null
          ? List<DailyLog>.from(
          json['daily_logs'].map((x) => DailyLog.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'date_of_birth': dateOfBirth,
      'mobile_number': mobileNumber,
      'weight': weight,
      'height': height,
      'gender': gender,
      'goals': goals?.toJson(),
      'daily_logs': dailyLogs?.map((x) => x.toJson()).toList(),
    };
  }
}

// models/user_goal.dart
class UserGoal {
  final int? id;
  final int userId;
  final List<String> selectedGoals;
  final double targetWeight;
  final int? dailyCalorieTarget;

  UserGoal({
    this.id,
    required this.userId,
    required this.selectedGoals,
    required this.targetWeight,
    this.dailyCalorieTarget,
  });

  factory UserGoal.fromJson(Map<String, dynamic> json) {
    return UserGoal(
      id: json['id'],
      userId: json['user_id'],
      selectedGoals: List<String>.from(json['selected_goals']),
      targetWeight: json['target_weight'].toDouble(),
      dailyCalorieTarget: json['daily_calorie_target'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'selected_goals': selectedGoals,
      'target_weight': targetWeight,
      'daily_calorie_target': dailyCalorieTarget,
    };
  }
}

// models/daily_log.dart
class DailyLog {
  final int? id;
  final int userId;
  final int caloriesConsumed;
  final int caloriesBurned;
  final int stepsTaken;
  final DateTime logDate;

  DailyLog({
    this.id,
    required this.userId,
    required this.caloriesConsumed,
    required this.caloriesBurned,
    required this.stepsTaken,
    required this.logDate,
  });

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    return DailyLog(
      id: json['id'],
      userId: json['user_id'],
      caloriesConsumed: json['calories_consumed'],
      caloriesBurned: json['calories_burned'],
      stepsTaken: json['steps_taken'],
      logDate: DateTime.parse(json['log_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'calories_consumed': caloriesConsumed,
      'calories_burned': caloriesBurned,
      'steps_taken': stepsTaken,
      'log_date': logDate.toIso8601String(),
    };
  }
}

// models/weekly_review.dart
class WeeklyReview {
  final int totalCaloriesConsumed;
  final int totalCaloriesBurned;
  final int totalSteps;
  final List<DailyLog> dailyLogs;
  final List<String> insights;

  WeeklyReview({
    required this.totalCaloriesConsumed,
    required this.totalCaloriesBurned,
    required this.totalSteps,
    required this.dailyLogs,
    required this.insights,
  });

  factory WeeklyReview.fromJson(Map<String, dynamic> json) {
    return WeeklyReview(
      totalCaloriesConsumed: json['total_calories_consumed'],
      totalCaloriesBurned: json['total_calories_burned'],
      totalSteps: json['total_steps'],
      dailyLogs: List<DailyLog>.from(
          json['daily_logs'].map((x) => DailyLog.fromJson(x))),
      insights: List<String>.from(json['insights']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_calories_consumed': totalCaloriesConsumed,
      'total_calories_burned': totalCaloriesBurned,
      'total_steps': totalSteps,
      'daily_logs': dailyLogs.map((x) => x.toJson()).toList(),
      'insights': insights,
    };
  }
}