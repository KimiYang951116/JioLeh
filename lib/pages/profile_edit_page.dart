import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:jio_leh/theme.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  String? _selectedMonth;

  static const _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  Widget build(BuildContext context) {
    final titleSize = context.scaledFont(AppTextSizes.heading);
    final labelSize = context.scaledFont(AppTextSizes.label);
    final fieldSize = context.scaledFont(AppTextSizes.body);
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: titleSize + 2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 100),
                      FilledButton(
                        onPressed: () => Navigator.maybePop(context),
                        child: const Text("Back"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "PROFILE PHOTO",
                    style: TextStyle(
                      fontSize: labelSize,
                      color: AppColors.onboardingSubtitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt,
                              size: 40,
                            ),
                            Text(
                              "Add a photo",
                              style: TextStyle(fontSize: labelSize),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "DISPLAY NAME",
                    style: TextStyle(
                      fontSize: labelSize,
                      color: AppColors.onboardingSubtitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0F1E1B16),
                            blurRadius: 24,
                            offset: Offset(0, 8),
                          ),
                        ]
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "What should we call you?",
                          hintStyle: TextStyle(
                            fontSize: fieldSize,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                        ),
                      ),
                    ),                                          
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "BIO",
                    style: TextStyle(
                      fontSize: labelSize,
                      color: AppColors.onboardingSubtitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      width: double.infinity,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0F1E1B16),
                            blurRadius: 24,
                            offset: Offset(0, 8),
                          ),
                        ]
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "What should we call you?",
                          hintStyle: TextStyle(
                            fontSize: fieldSize,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "BIRTHDAY",
                    style: TextStyle(
                      fontSize: labelSize,
                      color: AppColors.onboardingSubtitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0F1E1B16),
                                blurRadius: 24,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            decoration: InputDecoration(
                              hintText: "DD",
                              hintStyle: TextStyle(
                                fontSize: fieldSize,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0F1E1B16),
                                blurRadius: 24,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButton<String>(
                              value: _selectedMonth,
                              hint: Text(
                                "Month",
                                style: TextStyle(
                                  fontSize: fieldSize,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              isExpanded: true,
                              style: TextStyle(
                                fontSize: fieldSize,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              dropdownColor: AppColors.lightBackground,
                              borderRadius: BorderRadius.circular(18),
                              items: _months.map((String month) {
                                return DropdownMenuItem<String>(
                                  value: month,
                                  child: Text(
                                    month,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) =>
                                  setState(() => _selectedMonth = value),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0F1E1B16),
                                blurRadius: 24,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            decoration: InputDecoration(
                              hintText: "YYYY",
                              hintStyle: TextStyle(
                                fontSize: fieldSize,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: LogoColors.forestLogo,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: LogoColors.forestLogo,
                            blurRadius: 0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.lightWidgetBackground,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF4B443B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          onPressed: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check, size: 20),
                              SizedBox(width: 8),
                              Text('All saved'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
