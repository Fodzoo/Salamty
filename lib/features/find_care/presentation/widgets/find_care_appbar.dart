import 'package:flutter/material.dart';
class FindCareAppbar extends StatelessWidget {
  const FindCareAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
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
          SizedBox(width: 6),
          Text(
            "Find Care",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0059BB),
            ),
          ),
          Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
