import 'package:fitness_project/app/modules/verification-code/controllers/verification_code_controller.dart';
import 'package:fitness_project/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationCodeView extends StatelessWidget {
  final VerificationCodeController controller = Get.put(VerificationCodeController());
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
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
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.red),
            onPressed: () async {
              await controller.logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Your email is not verified. Please check your inbox.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 20),

            // Code Input Field
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Verification Code",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                bool isVerified = await controller.sendVerificationEmail(codeController.text);
                print("isVerified");
                print(isVerified);
                if (isVerified) {
                  Get.offNamed('/be-fit'); // Redirect after verification
                } else {
                  Get.snackbar(
                    "Verification Needed",
                    "Please enter a valid verification code.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text("Continue to App"),
            ),
            const SizedBox(height: 20),

            // Resend Verification Code Button
            ElevatedButton(
              onPressed: () async {
                await controller.resendCode();
                Get.snackbar(
                  "Email Sent",
                  "Please check your inbox for the verification email.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              child: const Text("Resend Verification Email"),
            ),
            const SizedBox(height: 20),

            // Continue to App Button

          ],
        ),
      ),
    );
  }
}
