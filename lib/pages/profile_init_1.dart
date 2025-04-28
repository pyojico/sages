// import 'package:flutter/material.dart';
// import 'profile_init_2.dart';

// class ProfileInit1 extends StatelessWidget {
//   const ProfileInit1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const Text('Wi-Fi Permission',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 16),
//               const Text('We need Wi-Fi access to connect your devices.'),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () => Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ProfileInit2()),
//                 ),
//                 child: const Text('Grant Permission'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ProfileInit2()),
//                 ),
//                 child: const Text('Skip for now'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
