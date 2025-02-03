import 'package:fitness_project/app/modules/personal-details/controllers/personal_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalDetailsView extends StatelessWidget {
  final controller = Get.put(PersonalDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF004AAD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Personal Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField('Full Name', Icons.person, controller.fullName),
                SizedBox(height: 15),
                _buildDatePicker(context),
                SizedBox(height: 15),
                _buildTextField('Email Address', Icons.email, controller.email),
                SizedBox(height: 15),
                _buildTextField('Mobile Number', Icons.phone, controller.mobile),
                SizedBox(height: 15),
                SizedBox(height: 15),
                _buildHeightWeightField('Weight', controller.weight, isWeight: true),
                SizedBox(height: 15),
                _buildHeightWeightField('Height', controller.height),
                SizedBox(height: 15),
                _buildGenderField(),
                SizedBox(height: 15),
                _buildTextField(
                  'Password',
                  Icons.lock,
                  controller.password,
                  isPassword: true,
                ),
                SizedBox(height: 15),
                // _buildDropdown('Select Nationality'),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      child: Text('Prev'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        minimumSize: Size(100, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: controller.register,
                      child: Text('Next'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        minimumSize: Size(100, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildGenderField() {
    List<String> genders = ['Male', 'Female', 'Other'];
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Color(0xFF2C3E50),
        borderRadius: BorderRadius.circular(25),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.gender.value.isEmpty ? null : controller.gender.value,
          hint: Text('Select Gender', style: TextStyle(color: Colors.white70)),
          isExpanded: true,
          dropdownColor: Color(0xFF2C3E50),
          items: genders.map((gen) => DropdownMenuItem(
            value: gen,
            child: Text(gen, style: TextStyle(color: Colors.white)),
          )).toList(),
          onChanged: (value) => controller.gender.value = value!,
        ),
      ),
    ));
  }

  Widget _buildTextField(String hint, IconData icon, RxString controller,
      {bool isPassword = false}) {
    return TextField(
      onChanged: (value) => controller.value = value,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Color(0xFF2C3E50),
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Obx(() => TextField(
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          // Format date as YYYY-MM-DD for MySQL
          controller.dateOfBirth.value =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
        }
      },
      controller: TextEditingController(text: _formatDisplayDate(controller.dateOfBirth.value)),
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Date of Birth',
        hintStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Color(0xFF2C3E50),
        prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    ));
  }
  Widget _buildHeightWeightField(String label, RxString controller, {bool isWeight = false}) {
    return TextField(
      onChanged: (value) => controller.value = value,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Color(0xFF2C3E50),
        prefixIcon: Icon(isWeight ? Icons.fitness_center : Icons.height, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  String _formatDisplayDate(String date) {
    if (date.isEmpty) return '';

    try {
      final parts = date.split('-');
      if (parts.length != 3) return date;

      return "${parts[2]}/${parts[1]}/${parts[0]}"; // DD/MM/YYYY for display
    } catch (e) {
      return date;
    }
  }


  Widget _buildDropdown(String hint) {
    List<String> nationalities = [
      'Lebanese',
      'American',
      'French',
      'German',
      'Other'
    ];

    return Obx(() => Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Color(0xFF2C3E50),
        borderRadius: BorderRadius.circular(25),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.nationality.value.isEmpty
              ? null
              : controller.nationality.value,
          hint: Text(hint, style: TextStyle(color: Colors.white70)),
          isExpanded: true,
          dropdownColor: Color(0xFF2C3E50),
          items: nationalities
              .map((nat) => DropdownMenuItem(
            value: nat,
            child: Text(nat, style: TextStyle(color: Colors.white)),
          ))
              .toList(),
          onChanged: (value) => controller.nationality.value = value!,
        ),
      ),
    ));
  }
}