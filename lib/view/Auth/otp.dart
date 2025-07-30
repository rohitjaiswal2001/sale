// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class CustomOtpField extends StatefulWidget {
//   final int length;
//   final ValueChanged<String> onSubmit;

//   const CustomOtpField({
//     super.key,
//     this.length = 6,
//     required this.onSubmit,
//   });

//   @override
//   _CustomOtpFieldState createState() => _CustomOtpFieldState();
// }

// class _CustomOtpFieldState extends State<CustomOtpField> {
//   late List<TextEditingController> _controllers;
//   late List<FocusNode> _focusNodes;
//   String otp = "";

//   @override
//   void initState() {
//     super.initState();
//     _controllers = List.generate(widget.length, (_) => TextEditingController());
//     _focusNodes = List.generate(widget.length, (_) => FocusNode());
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var node in _focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }

//   void _onChanged(String value, int index) {
//     if (value.isNotEmpty && index < widget.length - 1) {
//       _focusNodes[index + 1].requestFocus();
//     } else if (value.isEmpty && index > 0) {
//       _focusNodes[index - 1].requestFocus();
//     }

//     otp = _controllers.map((controller) => controller.text).join();
//     if (otp.length == widget.length) {
//       widget.onSubmit(otp);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: List.generate(widget.length, (index) {
//         return SizedBox(
//           width: 50,
//           child: TextField(
//             controller: _controllers[index],
//             focusNode: _focusNodes[index],
//             keyboardType: TextInputType.number,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             maxLength: 1,
//             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//             decoration: InputDecoration(
//               counterText: "",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: const BorderSide(color: Colors.grey),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: const BorderSide(color: Colors.blue, width: 2),
//               ),
//             ),
//             onChanged: (value) => _onChanged(value, index),
//           ),
//         );
//       }),
//     );
//   }
// }
