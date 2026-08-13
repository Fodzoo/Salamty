import 'package:flutter/material.dart';
import 'package:salamty/core/resourses/app_colors.dart';
import 'package:salamty/core/widgets/logo_body.dart';
import 'package:salamty/features/login/presentation/login_screen.dart';
import 'package:salamty/features/sign_up/presentation/widgets/login.dart';

class HealthProfileScreen extends StatefulWidget {

  const HealthProfileScreen({super.key});

  @override
  State<HealthProfileScreen> createState() => _HealthProfileScreenState();
}

class _HealthProfileScreenState extends State<HealthProfileScreen> {
  String? bloodType;


  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController diseasesController = TextEditingController();
  TextEditingController allergiesController = TextEditingController();



  void goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Back Button
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.arrow_back, color: Colors.grey),
                  SizedBox(width: 6),
                  Text(
                    "Back",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            LogoBody(),
            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.BgColorWhite,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 20),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Health Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Step 2 of 2",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Height & Weight
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Height (cm)",
                              style: TextStyle(color: Color(0x88000000)),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Weight (kg)",
                              style: TextStyle(color: Color(0x88000000)),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Blood Type Dropdown
                  const Text(
                    "Blood Type",
                    style: TextStyle(color: Color(0x88000000)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: const Text(
                        "Select Blood Type",
                        style: TextStyle(color: Color(0x88000000)),
                      ),

                      value: bloodType,
                      items: const [
                        DropdownMenuItem(
                          value: "A+",
                          child: Text(
                            "A+",
                            style: TextStyle(color: Color(0x88000000)),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "A-",
                          child: Text(
                            "A-",
                            style: TextStyle(color: Color(0x88000000)),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "B+",
                          child: Text(
                            "B+",
                            style: TextStyle(color: Color(0x88000000)),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "B-",
                          child: Text(
                            "B-",
                            style: TextStyle(color: Color(0x88000000)),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "AB+",
                          child: Text(
                            "AB+",
                            style: TextStyle(color: Color(0x88000000)),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "AB-",
                          child: Text(
                            "AB-",
                            style: TextStyle(color: Color(0x88000000)),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "O+",
                          child: Text(
                            "O+",
                            style: TextStyle(color: Color(0x88000000)),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "O-",
                          child: Text(
                            "O-",
                            style: TextStyle(color: Color(0x88000000)),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          bloodType = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Chronic Diseases
                  const Text(
                    "Chronic Diseases",
                    style: TextStyle(color: Color(0x88000000)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "None",
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Allergies
                  const Text(
                    "Allergies",
                    style: TextStyle(color: Color(0x88000000)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "None",
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Back",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: goToLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF209cb9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Complete",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Login(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
