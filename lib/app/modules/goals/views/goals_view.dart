// goals_view.dart
import 'package:fitness_project/app/modules/goals/controllers/goals_controller.dart';
import 'package:fitness_project/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalsView extends StatelessWidget {
  final controller = Get.put(GoalsController());

  final List<String> availableGoals = [
    'Lose Weight',
    'Gain Weight',
    'Maintain Weight',
    'Build Muscle',
    'Improve Fitness',
    'Better Sleep',
    'Eat Healthier',
    'Track Nutrition'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF004AAD),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFF4CAF50)),
                    onPressed: () => Get.back(),
                  ),
                  Text(
                    'Goals',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Let\'s Start With goals',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Text(
                'Select up to 3 goals that are most important to you',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Obx(() => controller.goalsError.value != null
                  ? Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  controller.goalsError.value!,
                  style: TextStyle(color: Colors.red[300]),
                ),
              )
                  : SizedBox.shrink()),
              SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2,
                  ),
                  itemCount: availableGoals.length,
                  itemBuilder: (context, index) {
                    return _buildGoalCard(availableGoals[index]);
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Set your target weight',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Obx(() => TextField(
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) => controller.goalWeight.value = value,
                      decoration: InputDecoration(
                        hintText: 'Target Weight',
                        hintStyle: TextStyle(color: Colors.white70),
                        errorText: controller.weightError.value,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF4CAF50)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF4CAF50)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF4CAF50)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Obx(() => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.weightUnit.value,
                          dropdownColor: Color(0xFF004AAD),
                          style: TextStyle(color: Colors.white),
                          items: ['kg', 'lbs'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: controller.updateWeightUnit,
                        ),
                      )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.saveGoals(),
                child: controller.isLoading.value
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4CAF50),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(String goal) {
    return Obx(() {
      final isSelected = controller.isSelected(goal);
      return GestureDetector(
        onTap: () => controller.toggleGoal(goal),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF4CAF50) : Colors.transparent,
            border: Border.all(
              color: Color(0xFF4CAF50),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                if (isSelected) SizedBox(width: 5),
                Text(
                  goal,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}