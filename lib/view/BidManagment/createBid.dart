// import 'package:bid4style/Utils/ValidationHelper.dart';
// import 'package:bid4style/utils/Appcolor.dart';
// import 'package:bid4style/view/Auth/widgets/authsmallwidgets.dart';
// import 'package:bid4style/widgets/CustomTextstyle.dart';
// import 'package:bid4style/widgets/TextFieldWidget.dart';
// import 'package:flutter/material.dart';

// class AddNewAuctionScreen extends StatefulWidget {
//   @override
//   _AddNewAuctionScreenState createState() => _AddNewAuctionScreenState();
// }

// class _AddNewAuctionScreenState extends State<AddNewAuctionScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final AddNewAuctionViewModel viewModel = AddNewAuctionViewModel();

//   @override
//   void dispose() {
//     viewModel.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: AppColors.grey),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text('Add New Auction'),
//         titleTextStyle: CustomTextStyle.heading20,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => AddNewAuctionScreen()),
//               );
//             },
//             icon: const Icon(Icons.check),
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Color(0xFF007BFF), width: 2),
//         ),
//         margin: EdgeInsets.all(10.0),
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextDeclarationWidget(text: "Title"),
//                 TexfieldWidget(
//                   controller: viewModel.titleController,
//                   hint: "Title",
//                   validator: (value) => ValidationHelper.validateGeneral(value),
//                 ),
//                 SizedBox(height: 10),
//                 TextDeclarationWidget(text: "Category"),
//                 TexfieldWidget(
//                   controller: viewModel.categoryController,
//                   hint: "Category",
//                   validator: (value) =>
//                       value!.isEmpty ? 'Enter a category' : null,
//                 ),
//                 SizedBox(height: 10),
//                 TextDeclarationWidget(text: "Description"),
//                 TexfieldWidget(
//                   controller: viewModel.descriptionController,
//                   hint: "Description",
//                   maxLine: 3,
//                 ),
//                 SizedBox(height: 10),
//                 TextDeclarationWidget(text: "Start Price"),
//                 TexfieldWidget(
//                   controller: viewModel.startPriceController,
//                   hint: "Start Price",
//                   keyboardType: TextInputType.number,
//                 ),
//                 SizedBox(height: 10),
//                 TextDeclarationWidget(text: "Notes"),
//                 TexfieldWidget(
//                   controller: viewModel.notesController,
//                   hint: "Notes",
//                   maxLine: 2,
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF007BFF),
//                     padding: EdgeInsets.symmetric(
//                       vertical: 12.0,
//                       horizontal: 20.0,
//                     ),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       viewModel.images.add('https://via.placeholder.com/100');
//                     });
//                   },
//                   child: Text(
//                     'Add Image',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Wrap(
//                   spacing: 10,
//                   children: viewModel.images
//                       .map((image) => Image.network(image, height: 100))
//                       .toList(),
//                 ),
//                 SizedBox(height: 20),
//                 TextDeclarationWidget(text: "Select Category Type"),
//                 DropdownButton<String>(
//                   hint: Text('Select Category Type'),
//                   value: viewModel.categoryType.isNotEmpty
//                       ? viewModel.categoryType
//                       : null,
//                   items: <String>['Type 1', 'Type 2', 'Type 3'].map((
//                     String value,
//                   ) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (value) =>
//                       setState(() => viewModel.categoryType = value!),
//                   dropdownColor: Colors.white,
//                   style: TextStyle(color: Colors.black),
//                   underline: Container(height: 2, color: Color(0xFF007BFF)),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF007BFF),
//                     padding: EdgeInsets.symmetric(
//                       vertical: 12.0,
//                       horizontal: 20.0,
//                     ),
//                   ),
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       // Submit logic here
//                     }
//                   },
//                   child: Text('Submit', style: TextStyle(color: Colors.white)),
//                 ),
//                 SizedBox(height: 10),
//                 Text('412-2254', style: TextStyle(color: Colors.grey)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AddNewAuctionViewModel {
//   final titleController = TextEditingController();
//   final categoryController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final startPriceController = TextEditingController();
//   final notesController = TextEditingController();
//   String categoryType = '';
//   List<String> images = [];

//   void dispose() {
//     titleController.dispose();
//     categoryController.dispose();
//     descriptionController.dispose();
//     startPriceController.dispose();
//     notesController.dispose();
//   }
// }

import 'package:bid4style/Utils/ValidationHelper.dart';
import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/view/Auth/widgets/textsmallwidgets.dart';
import 'package:bid4style/widgets/CustomTextstyle.dart';
import 'package:bid4style/widgets/TextFieldWidget.dart';
import 'package:bid4style/widgets/dropdownwidget.dart';
import 'package:flutter/material.dart';

class AddNewAuctionScreen extends StatefulWidget {
  @override
  _AddNewAuctionScreenState createState() => _AddNewAuctionScreenState();
}

class _AddNewAuctionScreenState extends State<AddNewAuctionScreen> {
  final _formKey = GlobalKey<FormState>();
  final AddNewAuctionViewModel viewModel = AddNewAuctionViewModel();

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add New Auction'),
        titleTextStyle: CustomTextStyle.heading20,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddNewAuctionScreen()),
              );
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.themecolor.withOpacity(0.2),
            width: 2,
          ),
        ),
        margin: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextDeclarationWidget(text: "Title"),
                TexfieldWidget(
                  controller: viewModel.titleController,
                  hint: "Title",
                  validator: (value) => ValidationHelper.validateGeneral(value),
                  focusNode: viewModel.titleFocusNode,
                  nextFocusNode: viewModel.categoryFocusNode,
                ),
                SizedBox(height: 10),
                TextDeclarationWidget(text: "Category"),
                TexfieldWidget(
                  controller: viewModel.categoryController,
                  hint: "Category",
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a category' : null,
                  focusNode: viewModel.categoryFocusNode,
                  nextFocusNode: viewModel.descriptionFocusNode,
                ),
                SizedBox(height: 10),
                TextDeclarationWidget(text: "Description"),
                TexfieldWidget(
                  controller: viewModel.descriptionController,
                  hint: "Description",
                  maxLine: 3,
                  focusNode: viewModel.descriptionFocusNode,
                  nextFocusNode: viewModel.startPriceFocusNode,
                ),
                SizedBox(height: 10),
                TextDeclarationWidget(text: "Start Price"),
                TexfieldWidget(
                  controller: viewModel.startPriceController,
                  hint: "Start Price",
                  keyboardType: TextInputType.number,
                  focusNode: viewModel.startPriceFocusNode,
                  nextFocusNode: viewModel.notesFocusNode,
                ),
                SizedBox(height: 10),
                TextDeclarationWidget(text: "Notes"),
                TexfieldWidget(
                  controller: viewModel.notesController,
                  hint: "Notes",
                  maxLine: 2,
                  focusNode: viewModel.notesFocusNode,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF007BFF),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      viewModel.images.add('https://via.placeholder.com/100');
                    });
                  },
                  child: Text(
                    'Add Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: viewModel.images
                      .map((image) => Image.network(image, height: 100))
                      .toList(),
                ),
                SizedBox(height: 20),
                TextDeclarationWidget(text: "Select Category Type"),
                CustomDropdown(
                  hintText: 'Select Category Type',
                  value: viewModel.categoryType.isNotEmpty
                      ? viewModel.categoryType
                      : null,
                  items: <String>['Type 1', 'Type 2', 'Type 3'],
                  onChanged: (value) =>
                      setState(() => viewModel.categoryType = value!),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF007BFF),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Submit logic here
                    }
                  },
                  child: Text('Submit', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 10),
                Text('412-2254', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddNewAuctionViewModel {
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final startPriceController = TextEditingController();
  final notesController = TextEditingController();
  String categoryType = '';
  List<String> images = [];

  final titleFocusNode = FocusNode();
  final categoryFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final startPriceFocusNode = FocusNode();
  final notesFocusNode = FocusNode();

  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    startPriceController.dispose();
    notesController.dispose();
    titleFocusNode.dispose();
    categoryFocusNode.dispose();
    descriptionFocusNode.dispose();
    startPriceFocusNode.dispose();
    notesFocusNode.dispose();
  }
}
