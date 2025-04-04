import 'package:fitness_project/app/models/models.dart';
import 'package:fitness_project/app/modules/be-fit/controllers/be_fit_controller.dart';
import 'package:fitness_project/global/constants.dart';
import 'package:fitness_project/global/widgets/food_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CaloriesController extends GetxController {
  final calorieController = TextEditingController();

  void updateCalories(int newCalories) {
    calorieController.text = newCalories.toString();
  }
}

class StepsController extends GetxController {
  final stepController = TextEditingController();

  void updateCalories(int newCalories) {
    stepController.text = newCalories.toString();
  }
}

class BeFitView extends StatelessWidget {
  final controller = Get.put(BeFitController());
  final CaloriesController cController = Get.put(CaloriesController());
  final StepsController sController = Get.put(StepsController());
  final ValueNotifier<int> caloriesEaten = ValueNotifier<int>(0);
  final ValueNotifier<int> stepsTaken = ValueNotifier<int>(0);
  final ValueNotifier<int> caloriesBurned = ValueNotifier<int>(0);


  void calculateCaloriesBurned() {
    caloriesBurned.value = (stepsTaken.value * 0.04).toInt(); // Example: 0.04 calories per step
  }


  @override
  Widget build(BuildContext context) {
    final _widgets = [
      _buildHomeWidget(),
      _buildRestaurantsWidget(),
      _buildSearchWidget(),
      _buildProfileWidget(),
    ];
    return Obx(() => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.person, color: blueInternational),
          onPressed: () {
            controller.selectedIndex.value = 3;
          },
        ),
        title: Text(
          'Be Fit',
          style: TextStyle(
            color: greenInternational,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: blueInternational),
            onPressed: () {
              controller.selectedIndex.value = 2;
            },
          ),
          IconButton(
            icon: Icon(Icons.power_settings_new, color: Colors.red),
            onPressed: () async {
              await controller.logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: _widgets[controller.selectedIndex.value],
        ),
      ),
      bottomNavigationBar: _buildCustomBottomNav(),
    ));
  }

  Widget _buildHomeWidget() {
    return Column(
      children: [
        _buildStepsCaloriesReport(),
        SizedBox(height: 20),
        _buildCaloriesCard(),
        SizedBox(height: 20),
        _buildWeekReviewCard(),
      ],
    );
  }

  int calculateAge(DateTime dob) {
    DateTime today = DateTime.now();
    int age = today.year - dob.year;

    // Adjust age if birthday hasn't occurred yet this year
    if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
      age--;
    }

    return age;
  }

  Widget _buildCaloriesCard() {
    return Obx(() {
      final report = controller.weeklyReview.value;
      final todayLog = report?.dailyLogs.isNotEmpty == true
          ? report!.dailyLogs.last
          : null;
      DateTime dob = DateTime(1995, 8, 25);
      int age = calculateAge(dob);
      User? user = controller.currentUser.value;
      double? dailyCalorie = 0.0;
      if(user?.gender != null && user?.weight != null && user?.height != null) {
        if(user?.gender == 'male') {
          dailyCalorie = 88.362 +
              (13.397 * (user?.weight ?? 0)) +
              (4.799 * (user?.height ?? 0)) -
              (5.677 * (age ?? 0));
        } else {
          dailyCalorie = 447.593 + (9.247 * (user?.weight ?? 0)) + (3.098 * (user?.height ?? 0)) - (4.330 * age);
        }
      }


      final dailyGoal = dailyCalorie.toInt();
      final remainingCalories = todayLog != null
          ? dailyGoal - todayLog.caloriesConsumed + todayLog.caloriesBurned
          : dailyGoal;

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: greenInternational, width: 2),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Calories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: greenInternational,
                    ),
                  ),
                  if (report?.insights.isNotEmpty == true)
                    Tooltip(
                      message: report!.insights.first,
                      child: Icon(Icons.info_outline, color: Colors.orange),
                    ),
                ],
              ),
              Text(
                'Remaining = Goal - Food + Exercise',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: greenInternational,
                          width: 10,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          remainingCalories.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: greenInternational,
                          ),
                        ),
                        Text(
                          'remaining',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Goal: $dailyGoal',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Food: ${todayLog?.caloriesConsumed ?? 0}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Exercise: ${todayLog?.caloriesBurned ?? 0}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStepsCaloriesReport() {
    return Obx(() {
      final report = controller.weeklyReview.value;

      final todayLog = report?.dailyLogs?.isNotEmpty == true
          ? report!.dailyLogs.last
          : null;
      if(todayLog != null) {
        cController.calorieController.text = todayLog.caloriesConsumed!.toString();
        sController.stepController.text = todayLog.stepsTaken!.toString();
      }

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: greenInternational, width: 2),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],

        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child:
                    TextField(
                      controller: cController.calorieController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // ✅ Only numbers
                      decoration: InputDecoration(hintText: "Calories"),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      caloriesEaten.value = int.tryParse(cController.calorieController.text) ?? 0;
                      controller.updateCalories(caloriesEaten.value);
                      controller.fetchWeeklyReview();
                    },
                    child: Text("Update"),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child:
                    TextField(
                      controller: sController.stepController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // ✅ Only numbers
                      decoration: InputDecoration(hintText: "Steps"),
                    )
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      stepsTaken.value = int.tryParse(sController.stepController.text) ?? 0;
                      controller.updateSteps(stepsTaken.value);
                      controller.fetchWeeklyReview();
                      calculateCaloriesBurned();
                    },
                    child: Text("Update Steps"),
                  ),
                ],

              )
            ],
          ),
        ),
      );
    });
  }
  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
  Widget _buildWeekReviewCard() {
    return Obx(() {
      final report = controller.weeklyReview.value;
      final logs = report?.dailyLogs ?? [];
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: greenInternational, width: 2),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Week in Review',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: greenInternational,
                    ),
                  ),

                ],
              ),

              SizedBox(height: 20),

              Text(
                'Daily Steps: ${report?.todayStepsTaken ?? 0}',
                style: TextStyle(
                  fontSize: 14,
                  color: blueInternational,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (index) {
                  // Correctly calculate the date for this index
                  final date = DateTime.now().subtract(Duration(days: 6 - index));
                  print("date is: " + date.toString());
                  final day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];
                  print("day is: " + day.toString());
                  // Find the log that matches this date
                  final log = logs.firstWhere(
                        (l) => DateTime.parse(l.logDate.toString()).day == date.day,
                    orElse: () => DailyLog(
                      userId: controller!.currentUser!.value!.id!,
                      caloriesConsumed: 12,
                      stepsTaken: 0,
                      caloriesBurned: 0,
                      logDate: date,
                    ),
                  );


                  final steps = log?.stepsTaken ?? 0;
                  final progress = steps / 10000; // Assuming 10000 steps is the daily goal
                  return _buildDayProgress(
                    day: day,
                    isActive: date.day == DateTime.now().day, // Mark today
                    progress: progress,
                    steps: steps,
                  );
                }),
              ),
              SizedBox(height: 20),
              Text(
                'Daily Burned Calories: ${report?.todayCaloriesBurned ?? 0}',
                style: TextStyle(
                  fontSize: 14,
                  color: blueInternational,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (index) {
                  // Correctly calculate the date for this index
                  final date = DateTime.now().subtract(Duration(days: 6 - index));
                  final day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];

                  // Find the log that matches this date
                  final log = logs.firstWhere(
                          (l) => DateTime.parse(l.logDate.toString()).day == date.day,
                      orElse: () => DailyLog(userId: controller!.currentUser!.value!.id!, caloriesConsumed: 12, stepsTaken: 0, caloriesBurned: 0, logDate: date));
                  final caloriesBurned = log?.caloriesBurned ?? 0;
                  final progress = caloriesBurned / 10000; // Assuming 10000 steps is the daily goal
                  return _buildDayProgress(
                    day: day,
                    isActive: date.day == DateTime.now().day, // Mark today
                    progress: progress,
                    steps: caloriesBurned,
                  );
                }),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Weekly Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: blueInternational,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem(
                        'Calories\nConsumed',
                        '${report?.totalCaloriesConsumed ?? 0}',
                        Icons.restaurant,
                      ),
                      _buildSummaryItem(
                        'Calories\nBurned',
                        '${report?.totalCaloriesBurned ?? 0}',
                        Icons.local_fire_department,
                      ),
                      _buildSummaryItem(
                        'Total\nSteps',
                        '${report?.totalSteps ?? 0}',
                        Icons.directions_walk,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: greenInternational),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: blueInternational,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDayProgress({
    required String day,
    required bool isActive,
    required double progress,
    required int steps,
  }) {
    return Container(
      width: 35,
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? blueInternational : Colors.grey[600],
              fontSize: 12,
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: 80,
            width: 6,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              heightFactor: progress.clamp(0.0, 1.0),
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: greenInternational,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            '${(steps / 1000).toStringAsPrecision(1)}k',
            style: TextStyle(
              fontSize: 10,
              color: isActive ? blueInternational : Colors.grey[600],
            ),
          ),

          SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildRestaurantsWidget() {
    final List<FoodItem> foods = [
      FoodItem(
        name: 'Grilled Chicken Breast',
        image: 'assets/chicken.png',
        calories: 165,
        protein: 31,
        carbs: 0,
        fats: 3.6,
      ),
      FoodItem(
        name: 'Quinoa Bowl',
        image: 'assets/quinoa.png',
        calories: 120,
        protein: 4.4,
        carbs: 21.3,
        fats: 1.9,
      ),
      FoodItem(
        name: 'Salmon Fillet',
        image: 'assets/salmon.png',
        calories: 208,
        protein: 22,
        carbs: 0,
        fats: 13,
      ),
      FoodItem(
        name: 'Avocado',
        image: 'assets/avocado.png',
        calories: 160,
        protein: 2,
        carbs: 8.5,
        fats: 14.7,
      ),
      FoodItem(
        name: 'Spinach (Raw)',
        image: 'assets/spinach.png',
        calories: 23,
        protein: 2.9,
        carbs: 3.6,
        fats: 0.4,
      ),
      FoodItem(
        name: 'Sweet Potato',
        image: 'assets/sweet_potato.png',
        calories: 86,
        protein: 1.6,
        carbs: 20.1,
        fats: 0.1,
      ),
      FoodItem(
        name: 'Greek Yogurt (Plain)',
        image: 'assets/greek_yogurt.png',
        calories: 59,
        protein: 10,
        carbs: 3.6,
        fats: 0.4,
      ),
      FoodItem(
        name: 'Eggs (Boiled)',
        image: 'assets/eggs.png',
        calories: 155,
        protein: 13,
        carbs: 1.1,
        fats: 10.6,
      ),
      FoodItem(
        name: 'Almonds',
        image: 'assets/almonds.png',
        calories: 579,
        protein: 21.2,
        carbs: 21.6,
        fats: 49.9,
      ),
      FoodItem(
        name: 'Oats (Dry)',
        image: 'assets/oats.png',
        calories: 389,
        protein: 16.9,
        carbs: 66.3,
        fats: 6.9,
      ),
      FoodItem(
        name: 'Apple',
        image: 'assets/apple.png',
        calories: 52,
        protein: 0.3,
        carbs: 13.8,
        fats: 0.2,
      ),
      FoodItem(
        name: 'Banana',
        image: 'assets/banana.png',
        calories: 89,
        protein: 1.1,
        carbs: 22.8,
        fats: 0.3,
      ),
      FoodItem(
        name: 'Broccoli (Cooked)',
        image: 'assets/broccoli.png',
        calories: 55,
        protein: 3.7,
        carbs: 11.2,
        fats: 0.6,
      ),
      FoodItem(
        name: 'Chicken Thigh (Grilled)',
        image: 'assets/chicken_thigh.png',
        calories: 209,
        protein: 26,
        carbs: 0,
        fats: 10.9,
      ),
      FoodItem(
        name: 'Tuna (Canned in Water)',
        image: 'assets/tuna.png',
        calories: 132,
        protein: 28,
        carbs: 0,
        fats: 1.2,
      ),
    ];

    return Column(
      children: [
        for (var food in foods)
          Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.food_bank,
                        size: 40, color: greenInternational),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Per 100g',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            _buildNutrientInfo('Calories', '${food.calories}'),
                            _buildNutrientInfo('Protein', '${food.protein}g'),
                            _buildNutrientInfo('Carbs', '${food.carbs}g'),
                            _buildNutrientInfo('Fats', '${food.fats}g'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchWidget() {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Daily Goal Achieved!',
        'message': 'Congratulations! You\'ve reached your calorie goal today.',
        'time': '2h ago',
        'type': 'achievement',
      },
      {
        'title': 'Workout Reminder',
        'message': 'Time for your scheduled evening workout.',
        'time': '5h ago',
        'type': 'reminder',
      },
      {
        'title': 'New Badge Earned',
        'message': 'You\'ve earned the "7-Day Streak" badge!',
        'time': '1d ago',
        'type': 'badge',
      },
    ];

    return Column(
        children: [
        for (var notification in notifications)
    Container(
        decoration: BoxDecoration(
        border: Border(
        bottom: BorderSide(color: Colors.grey[300]!),
        ),
        ),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: greenInternational.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getNotificationIcon(notification['type']),
                color: greenInternational,
              ),
            ),
            title: Text(
              notification['title'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(notification['message']),
                SizedBox(height: 5),
                Text(
                  notification['time'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ],
    );
  }

  String calculateBMIClassification(double bmi) {
    // Convert height from cm to meters

    // Determine the BMI classification
    if (bmi < 16) {
      return "Severe Thinness";
    } else if (bmi >= 16 && bmi <= 17) {
      return "Moderate Thinness";
    } else if (bmi >= 17 && bmi <= 18.50) {
      return "Mild Thinness";
    } else if (bmi >= 18.50 && bmi <= 25) {
      return "Normal";
    } else if (bmi >= 25 && bmi <= 30) {
      return "Overweight";
    } else if (bmi >= 30 && bmi <= 35) {
      return "Obese Class I";
    } else if (bmi >= 35 && bmi <= 40) {
      return "Obese Class II";
    } else if (bmi > 40) {
      return "Obese Class III";
    } else {
      return "Obesity Class III (Very Severe or Morbid)";
    }
  }

  Widget _buildProfileWidget() {
    return Obx(() {
      final user = controller.currentUser.value;
      if (user == null) return Center(child: CircularProgressIndicator());
      double bmi = 0.0;
      if(user.height != 0 && user.height != null) {
        bmi = (user.weight ?? 0.0) / ((user.height!.toDouble() * user.height!.toDouble()) / 10000);
      }

      
      return Column(
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: greenInternational,
                child: Text(
                  user.fullName.substring(0, 2).toUpperCase(),
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                user.fullName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.email,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _buildProfileSection('Personal Information', [
                  {'title': 'Mobile', 'value': user.mobileNumber},
                  {'title': 'Date of Birth', 'value': user.dateOfBirth},
                  {'title': 'Height', 'value': '${user.height ?? "Not set"} cm'},
                  {'title': 'Weight', 'value': '${user.weight ?? "Not set"} kg'},
                  {'title': 'Gender', 'value': user.gender ?? "Not set"},
                  {'title': 'BMI', 'value': bmi.toStringAsFixed(2).toString() + " (" + calculateBMIClassification(bmi) + ")" ?? "Not set"},
                ]),
                if (user.goals != null) ...[
                  SizedBox(height: 20),
                  _buildProfileSection('Goals', [
                    {'title': 'Target Weight', 'value': '${user.goals!.targetWeight} kg'},
                    {'title': 'Daily Calories', 'value': '${user.goals!.dailyCalorieTarget ?? "Not set"}'},
                    {'title': 'Selected Goals', 'value': user.goals!.selectedGoals.join(", ")},
                  ]),
                ],
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildProfileSection(String title, List<Map<String, String>> items) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: blueInternational,
            ),
          ),
          Divider(),
          ...items.map((item) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['title']!,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  item['value']!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: greenInternational,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'achievement':
        return Icons.emoji_events;
      case 'reminder':
        return Icons.access_time;
      case 'badge':
        return Icons.stars;
      default:
        return Icons.notifications;
    }
  }

  Widget _buildCustomBottomNav() {
    return Obx(() => Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: blueInternational,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.home,
                color: controller.selectedIndex.value == 0 ? Colors.white : Colors.grey),
            onPressed: () => controller.selectedIndex.value = 0,
          ),
          IconButton(
            icon: Icon(Icons.restaurant_menu,
                color: controller.selectedIndex.value == 1 ? Colors.white : Colors.grey),
            onPressed: () => controller.selectedIndex.value = 1,
          ),
          IconButton(
            icon: Icon(Icons.notifications,
                color: controller.selectedIndex.value == 2 ? Colors.white : Colors.grey),
            onPressed: () => controller.selectedIndex.value = 2,
          ),
          IconButton(
            icon: Icon(Icons.person,
                color: controller.selectedIndex.value == 3 ? Colors.white : Colors.grey),
            onPressed: () => controller.selectedIndex.value = 3,
          ),
        ],
      ),
    ));
  }
}