import 'package:flutter/material.dart';
class MedicationAppbar extends StatelessWidget {
  const MedicationAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: Color(0xFF0059BB),
            ),
          ),
        ),
        Text(
          "Medications",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0059BB),
          ),
        ),
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Hero(
            tag: 'medication_icon',
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.medical_services,
                color: Colors.orange[400],
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
