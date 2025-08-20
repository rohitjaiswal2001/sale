import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/view/BidManagment/createBid.dart';
import 'package:bid4style/widgets/CustomTextstyle.dart';
import 'package:flutter/material.dart';

// Customizable Bid Management Screen widget
class BidManagementScreen extends StatefulWidget {
  final String title;
  final List<String> tabTitles;
  final Color indicatorColor;
  final Color labelColor;
  final Color unselectedLabelColor;

  final double gridPadding;
  final double cardElevation;
  final double cardRadius;
  final double imageHeight;
  final double statusFontSize;
  final double nameFontSize;
  final double bidFontSize;
  final FontWeight nameFontWeight;
  final Color bidTextColor;

  const BidManagementScreen({
    super.key,
    this.title = 'Bid Management',
    this.tabTitles = const ['All Bids', 'Won Bids', 'Lost Bids', 'Ongoing'],
    this.indicatorColor = Colors.deepOrange,
    this.labelColor = Colors.black,
    this.unselectedLabelColor = Colors.grey,

    this.gridPadding = 16.0,
    this.cardElevation = 2.0,
    this.cardRadius = 12.0,
    this.imageHeight = 150.0,
    this.statusFontSize = 12.0,
    this.nameFontSize = 14.0,
    this.bidFontSize = 12.0,
    this.nameFontWeight = FontWeight.bold,
    this.bidTextColor = Colors.grey,
  });

  @override
  State<BidManagementScreen> createState() => _BidManagementScreenState();
}

class _BidManagementScreenState extends State<BidManagementScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title),
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
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Bids',
                  style: CustomTextStyle.heading20.copyWith(
                    color: widget.labelColor,
                  ),
                ),
                const SizedBox(height: 16.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.tabTitles.asMap().entries.map((entry) {
                      final index = entry.key;
                      final title = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(title),
                          labelStyle: TextStyle(
                            color: _selectedIndex == index
                                ? AppColors.themecolor
                                : widget.unselectedLabelColor,
                            fontSize: 14,
                          ),
                          showCheckmark: false,

                          backgroundColor: _selectedIndex == index
                              ? widget.indicatorColor
                              : Colors.grey[200],
                          selected: _selectedIndex == index,
                          onSelected: (bool value) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          checkmarkColor: AppColors.themecolor,

                          disabledColor: AppColors.red,
                          selectedColor: AppColors.green,
                          selectedShadowColor: AppColors.blue,
                          surfaceTintColor: AppColors.green,
                          // shadowColor: Colors.red,
                          color: WidgetStatePropertyAll(Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: _selectedIndex == index
                                  ? widget.indicatorColor
                                  : Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildGrid(BidData.tabData[_selectedIndex])),
        ],
      ),
    );
  }

  Widget _buildGrid(List<BidItem> items) {
    return GridView.builder(
      padding: EdgeInsets.all(widget.gridPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: widget.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.cardRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(widget.cardRadius),
                    ),
                    child: item.imageUrl.isEmpty
                        ? Container(
                            height: widget.imageHeight,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 50),
                          )
                        : Image.network(
                            item.imageUrl,
                            height: widget.imageHeight,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: widget.imageHeight,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Icon(Icons.error, size: 50),
                              );
                            },
                          ),
                  ),
                  Positioned(
                    top: 8.0,
                    left: 8.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: item.statusColor,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        item.status,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.statusFontSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: widget.nameFontSize,
                        fontWeight: widget.nameFontWeight,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      item.bidInfo,
                      style: TextStyle(
                        color: widget.bidTextColor,
                        fontSize: widget.bidFontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Example usage:
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const BidManagementScreen(
//         tabData: [
//           // Data for 'All Bids' tab
//           [
//             BidItem(
//               imageUrl: 'https://example.com/image1.jpg',
//               status: 'Ongoing',
//               name: 'Premium Skirt',
//               bidInfo: 'Current Bid: €22',
//               statusColor: Colors.blue,
//             ),
//             BidItem(
//               imageUrl: 'https://example.com/image2.jpg',
//               status: 'Won',
//               name: 'Casual Shirt',
//               bidInfo: 'Your Bid: €45',
//               statusColor: Colors.green,
//             ),
//           ],
//           // Data for 'Won Bids' tab
//           [
//             BidItem(
//               imageUrl: 'https://example.com/image3.jpg',
//               status: 'Won',
//               name: 'Casual Jacket',
//               bidInfo: 'Your Bid: €30',
//               statusColor: Colors.green,
//             ),
//           ],
//           // Data for 'Lost Bids' tab
//           [
//             BidItem(
//               imageUrl: 'https://example.com/image4.jpg',
//               status: 'Lost',
//               name: 'Premium Pants',
//               bidInfo: 'Current Bid: €25',
//               statusColor: Colors.red,
//             ),
//           ],
//           // Data for 'Ongoing' tab
//           [
//             BidItem(
//               imageUrl: 'https://example.com/image5.jpg',
//               status: 'Ongoing',
//               name: 'Premium Shirt',
//               bidInfo: 'Current Bid: €20',
//               statusColor: Colors.blue,
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

class BidItem {
  final String imageUrl;
  final String status;
  final String name;
  final String bidInfo;
  final Color statusColor;

  BidItem({
    required this.imageUrl,
    required this.status,
    required this.name,
    required this.bidInfo,
    required this.statusColor,
  });
}

class BidData {
  static final List<List<BidItem>> tabData = [
    // Data for 'My Bids' tab
    [
      BidItem(
        imageUrl: 'https://example.com/image1.jpg',
        status: 'Ongoing',
        name: 'Premium Skirt',
        bidInfo: 'Current Bid: €22',
        statusColor: Colors.blue,
      ),
      BidItem(
        imageUrl: 'https://example.com/image2.jpg',
        status: 'Won',
        name: 'Casual Shirt',
        bidInfo: 'Your Bid: €45',
        statusColor: Colors.green,
      ),
    ],
    // Data for 'Won Bids' tab
    [],
    // Data for 'Lost' tab
    [],
    // Data for 'Ongoing' tab
    [],
  ];
}





// import 'package:bid4style/utils/Appcolor.dart';
// import 'package:bid4style/widgets/CustomTextstyle.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class BidItem {
//   final String imageUrl;
//   final String status;
//   final String name;
//   final String bidInfo;
//   final Color statusColor;

//   BidItem({
//     required this.imageUrl,
//     required this.status,
//     required this.name,
//     required this.bidInfo,
//     required this.statusColor,
//   });

//   factory BidItem.fromJson(Map<String, dynamic> json) {
//     return BidItem(
//       imageUrl: json['imageUrl'] ?? '',
//       status: json['status'] ?? 'Unknown',
//       name: json['name'] ?? 'Unnamed Item',
//       bidInfo: json['bidInfo'] ?? 'No Bid Info',
//       statusColor: _parseStatusColor(json['status']),
//     );
//   }

//   static Color _parseStatusColor(String? status) {
//     switch (status?.toLowerCase()) {
//       case 'ongoing':
//         return Colors.blue;
//       case 'won':
//         return Colors.green;
//       case 'lost':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
// }

// class BidManagementScreen extends StatefulWidget {
//   final String title;
//   final List<String> tabTitles;
//   final Color indicatorColor;
//   final Color labelColor;
//   final Color unselectedLabelColor;
//   final Future<List<List<BidItem>>> tabDataFuture; // Use Future for API data

//   final double gridPadding;
//   final double cardElevation;
//   final double cardRadius;
//   final double imageHeight;
//   final double statusFontSize;
//   final double nameFontSize;
//   final double bidFontSize;
//   final FontWeight nameFontWeight;
//   final Color bidTextColor;

//   const BidManagementScreen({
//     super.key,
//     this.title = 'Bid Management',
//     this.tabTitles = const ['All Bids', 'Won Bids', 'Lost Bids', 'Ongoing'],
//     this.indicatorColor = Colors.deepOrange,
//     this.labelColor = Colors.black,
//     this.unselectedLabelColor = Colors.grey,
//     required this.tabDataFuture, // Required Future
//     this.gridPadding = 16.0,
//     this.cardElevation = 2.0,
//     this.cardRadius = 12.0,
//     this.imageHeight = 150.0,
//     this.statusFontSize = 12.0,
//     this.nameFontSize = 14.0,
//     this.bidFontSize = 12.0,
//     this.nameFontWeight = FontWeight.bold,
//     this.bidTextColor = Colors.grey,
//   });

//   @override
//   State<BidManagementScreen> createState() => _BidManagementScreenState();
// }

// class _BidManagementScreenState extends State<BidManagementScreen> {
//   int _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: AppColors.grey),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(widget.title),
//         titleTextStyle: CustomTextStyle.heading20,
//         centerTitle: true,
//         actions: [IconButton(onPressed: null, icon: const Icon(Icons.add))],
//       ),
//       body: FutureBuilder<List<List<BidItem>>>(
//         future: widget.tabDataFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No data available'));
//           }

//           final tabData = snapshot.data!;
//           return Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'My Bids',
//                       style: CustomTextStyle.heading20.copyWith(
//                         color: widget.labelColor,
//                       ),
//                     ),
//                     const SizedBox(height: 16.0),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: widget.tabTitles.asMap().entries.map((entry) {
//                           final index = entry.key;
//                           final title = entry.value;
//                           return Padding(
//                             padding: const EdgeInsets.only(right: 8.0),
//                             child: FilterChip(
//                               label: Text(title),
//                               labelStyle: TextStyle(
//                                 color: _selectedIndex == index
//                                     ? AppColors.themecolor
//                                     : widget.unselectedLabelColor,
//                                 fontSize: 14,
//                               ),
//                               showCheckmark: false,
//                               backgroundColor: _selectedIndex == index
//                                   ? widget.indicatorColor
//                                   : Colors.grey[200],
//                               selected: _selectedIndex == index,
//                               onSelected: (bool value) {
//                                 setState(() {
//                                   _selectedIndex = index;
//                                 });
//                               },
//                               checkmarkColor: AppColors.themecolor,
//                               disabledColor: AppColors.red,
//                               selectedColor: AppColors.green,
//                               selectedShadowColor: AppColors.blue,
//                               surfaceTintColor: AppColors.green,
//                               color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
//                                 if (states.contains(MaterialState.pressed)) {
//                                   return Colors.white; // White when pressed
//                                 }
//                                 return _selectedIndex == index ? widget.indicatorColor : Colors.grey[200]!;
//                               }),
//                               overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
//                                 if (states.contains(MaterialState.pressed)) {
//                                   return Colors.transparent; // Remove gray flash
//                                 }
//                                 return Colors.transparent;
//                               }),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 side: BorderSide(
//                                   color: _selectedIndex == index
//                                       ? widget.indicatorColor
//                                       : Colors.grey[300]!,
//                                   width: 1,
//                                 ),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16.0,
//                                 vertical: 8.0,
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(child: _buildGrid(tabData[_selectedIndex])),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildGrid(List<BidItem> items) {
//     return GridView.builder(
//       padding: EdgeInsets.all(widget.gridPadding),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 0.7,
//         crossAxisSpacing: 8.0,
//         mainAxisSpacing: 8.0,
//       ),
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         final item = items[index];
//         return Card(
//           elevation: widget.cardElevation,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(widget.cardRadius),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(widget.cardRadius),
//                     ),
//                     child: item.imageUrl.isEmpty
//                         ? Container(
//                             height: widget.imageHeight,
//                             width: double.infinity,
//                             color: Colors.grey[300],
//                             child: const Icon(Icons.image, size: 50),
//                           )
//                         : Image.network(
//                             item.imageUrl,
//                             height: widget.imageHeight,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Container(
//                                 height: widget.imageHeight,
//                                 width: double.infinity,
//                                 color: Colors.grey[300],
//                                 child: const Icon(Icons.error, size: 50),
//                               );
//                             },
//                           ),
//                   ),
//                   Positioned(
//                     top: 8.0,
//                     left: 8.0,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8.0,
//                         vertical: 4.0,
//                       ),
//                       decoration: BoxDecoration(
//                         color: item.statusColor,
//                         borderRadius: BorderRadius.circular(4.0),
//                       ),
//                       child: Text(
//                         item.status,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: widget.statusFontSize,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       item.name,
//                       style: TextStyle(
//                         fontSize: widget.nameFontSize,
//                         fontWeight: widget.nameFontWeight,
//                       ),
//                     ),
//                     const SizedBox(height: 4.0),
//                     Text(
//                       item.bidInfo,
//                       style: TextStyle(
//                         color: widget.bidTextColor,
//                         fontSize: widget.bidFontSize,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// // Function to fetch data from API
// Future<List<List<BidItem>>> fetchTabData() async {
//   final response = await http.get(Uri.parse('https://your-api-endpoint.com/bids')); // Replace with your API URL

//   if (response.statusCode == 200) {
//     final List<dynamic> data = json.decode(response.body);
//     // Assuming the API returns a list of lists or a list that can be grouped by status
//     final Map<String, List<BidItem>> groupedData = {};
//     for (var item in data) {
//       final bidItem = BidItem.fromJson(item);
//       groupedData.putIfAbsent(bidItem.status.toLowerCase(), () => []).add(bidItem);
//     }

//     // Create tabData based on tabTitles
//     final tabData = <List<BidItem>>[];
//     for (var title in ['All Bids', 'Won Bids', 'Lost Bids', 'Ongoing']) {
//       final status = title.split(' ')[0].toLowerCase();
//       tabData.add(groupedData[status] ?? []);
//     }
//     return tabData;
//   } else {
//     throw Exception('Failed to load data');
//   }
// }

// // Example usage:
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: BidManagementScreen(
//         tabDataFuture: fetchTabData(), // Pass the Future
//       ),
//     );
//   }
// }