import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/user_controller.dart';

class ChangeUserDob extends StatelessWidget {
  const ChangeUserDob({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    final List<int> days = List.generate(31, (index) => index + 1);
    final List<String> months = [
      'Một', 'Hai', 'Ba', 'Bốn', 'Năm', 'Sáu',
      'Bảy', 'Tám', 'Chín', 'Mười', 'Mười một', 'Mười hai'
    ];
    final List<int> years = List.generate(100, (index) => DateTime.now().year - index);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ngày sinh', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bạn có biết ngày sinh bật mí rất nhiều về bạn',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 16.0),

            Form(
              key: controller.profileFormKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: DropdownButtonFormField<int>(
                          value: controller.day.value,
                          items: days.map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString(), style: const TextStyle(fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            controller.day.value = newValue ?? 1;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Ngày',
                          ),
                          validator: (value) => value == null ? 'Ngày không được để trống' : null,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        flex: 3,
                        child: DropdownButtonFormField<String>(
                          value: controller.month.value,
                          items: months.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            controller.month.value = newValue ?? months[0];
                          },
                          decoration: const InputDecoration(
                            labelText: 'Tháng',
                          ),
                          validator: (value) => value == null ? 'Tháng không được để trống' : null,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        flex: 2,
                        child: DropdownButtonFormField<int>(
                          value: controller.year.value,
                          items: years.map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString(), style: const TextStyle(fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            controller.year.value = newValue ?? DateTime.now().year;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Năm',
                          ),
                          validator: (value) => value == null ? 'Năm không được để trống' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final dob = DateTime(
                          controller.year.value,
                          months.indexOf(controller.month.value) + 1,
                          controller.day.value,
                        ).toIso8601String().split("T").first;
                        controller.dob.text = dob;
                        controller.updateUserProfile();
                      },
                      child: const Text('Lưu'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

