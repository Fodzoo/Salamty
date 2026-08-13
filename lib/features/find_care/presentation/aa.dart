// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:salamty/features/find_care/presentation/widgets/find_care_appbar.dart';
//
// class FindCareScreen extends StatefulWidget {
//   const FindCareScreen({super.key});
//
//   @override
//   State<FindCareScreen> createState() => _FindCareScreenState();
// }
//
// class _FindCareScreenState extends State<FindCareScreen> {
//   String selectedFilter = "All";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF8F9FA),
//       body: SafeArea(
//         child: Column(
//           children: [
//             /// APP BAR
//             FindCareAppbar(),
//             /// SEARCH
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Container(
//                 height: 50,
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.search, color: Colors.grey),
//                     const SizedBox(width: 10),
//
//                     Expanded(
//                       child: TextField(
//                         decoration: const InputDecoration(
//                           hintText: "Search hospitals, clinics...",
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//
//                     const Icon(Icons.tune, color: Color(0xFF0059BB)),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             /// FILTERS
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 children: [
//                   /// ALL
//                   InkWell(
//                     borderRadius: BorderRadius.circular(20),
//                     onTap: () {
//                       setState(() {
//                         selectedFilter = "All";
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: selectedFilter == "All"
//                             ? Color(0xFF0059BB)
//                             : const Color(0xFFEAEAEA),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         "All",
//                         style: TextStyle(
//                           color: selectedFilter == "All"
//                               ? Colors.white
//                               : Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(width: 10),
//
//                   /// HOSPITALS
//                   InkWell(
//                     borderRadius: BorderRadius.circular(20),
//                     onTap: () {
//                       setState(() {
//                         selectedFilter = "Hospitals";
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: selectedFilter == "Hospitals"
//                             ? Color(0xFF0059BB)
//                             : const Color(0xFFEAEAEA),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         "Hospitals",
//                         style: TextStyle(
//                           color: selectedFilter == "Hospitals"
//                               ? Colors.white
//                               : Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(width: 10),
//
//                   /// CLINICS
//                   InkWell(
//                     borderRadius: BorderRadius.circular(20),
//                     onTap: () {
//                       setState(() {
//                         selectedFilter = "Clinics";
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: selectedFilter == "Clinics"
//                             ? Color(0xFF0059BB)
//                             : const Color(0xFFEAEAEA),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         "Clinics",
//                         style: TextStyle(
//                           color: selectedFilter == "Clinics"
//                               ? Colors.white
//                               : Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(width: 10),
//
//                   /// DENTISTS
//                   InkWell(
//                     borderRadius: BorderRadius.circular(20),
//                     onTap: () {
//                       setState(() {
//                         selectedFilter = "Dentists";
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: selectedFilter == "Dentists"
//                             ? Color(0xFF0059BB)
//                             : const Color(0xFFEAEAEA),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         "Dentists",
//                         style: TextStyle(
//                           color: selectedFilter == "Dentists"
//                               ? Colors.white
//                               : Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             /// MAP
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Container(
//                 height: 220,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: GoogleMap(
//                     initialCameraPosition: const CameraPosition(
//                       target: LatLng(30.033333, 31.233334), // القاهرة
//                       zoom: 14,
//                     ),
//                     zoomControlsEnabled: false,
//                     myLocationButtonEnabled: false,
//                     markers: {
//                       const Marker(
//                         markerId: MarkerId("main"),
//                         position: LatLng(30.033333, 31.233334),
//                         infoWindow: InfoWindow(title: "City General Hospital"),
//                       ),
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             /// HEADER
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "32 Providers Nearby",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   TextButton(
//                     onPressed: () {},
//                     child: Text(
//                       "See all",
//                       style: TextStyle(color: Color(0xFF0059BB)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             /// LIST
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 itemCount: 4,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 14),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(18),
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               width: 60,
//                               height: 60,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade300,
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text(
//                                     "City General Hospital",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   const Text(
//                                     "General Practice • Surgery",
//                                     style: TextStyle(color: Colors.grey),
//                                   ),
//                                   const SizedBox(height: 6),
//
//                                   Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.navigation,
//                                         size: 16,
//                                         color: Colors.green,
//                                       ),
//                                       const SizedBox(width: 4),
//                                       const Text("0.8 km"),
//                                       const SizedBox(width: 10),
//
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 8,
//                                           vertical: 4,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: Colors.green.shade100,
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                         child: const Text(
//                                           "Open 24/7",
//                                           style: TextStyle(color: Colors.green),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                             const Row(
//                               children: [
//                                 Icon(
//                                   Icons.star,
//                                   color: Colors.orange,
//                                   size: 18,
//                                 ),
//                                 Text("4.8"),
//                               ],
//                             ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 12),
//
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 12,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: Color(0xFF0059BB)),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.location_on,
//                                       color: Color(0xFF0059BB),
//                                     ),
//                                     SizedBox(width: 6),
//                                     Text("Directions"),
//                                   ],
//                                 ),
//                               ),
//                             ),
//
//                             const SizedBox(width: 10),
//
//                             Expanded(
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 12,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Color(0xFF0059BB),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.calendar_today,
//                                       color: Colors.white,
//                                       size: 18,
//                                     ),
//                                     SizedBox(width: 6),
//                                     Text(
//                                       "Book",
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
