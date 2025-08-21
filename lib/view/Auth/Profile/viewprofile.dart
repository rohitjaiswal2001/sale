// File: profile_screen.dart
// The view file for the profile screen

import 'package:bid4style/Utils/Appcolor.dart';
import 'package:bid4style/utils/textstyle.dart';
import 'package:bid4style/view/Auth/Profile/editprofile.dart';
import 'package:bid4style/view/Auth/Profile/changePassword.dart';

import 'package:bid4style/view/BidManagment/Mybid.dart';
import 'package:bid4style/view/BidManagment/createBid.dart';
import 'package:bid4style/view/FirstPage.dart';
import 'package:bid4style/view/Wishlist/wishlistView.dart';
import 'package:bid4style/viewModal/AuthviewModel/logoutViewModel.dart';
import 'package:bid4style/viewModal/ProfileViewmodal.darrt/editprofileviewmodal.dart';
import 'package:bid4style/viewModal/ProfileViewmodal.darrt/userDetailViewMode.dart';

import 'package:bid4style/viewModal/profileviewModal/profileviewmodal.dart';
import 'package:bid4style/widgets/apploader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetailViewmodel>(
      builder: (context, viewModel, child) {
        viewModel.loadProfile();
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(0),
                  children: [
                    Container(
                      // padding:
                      height: 250,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/profilleback.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            maxRadius: 40,
                            minRadius: 40,
                            backgroundColor: AppColors.grey,
                            child: ClipOval(
                              child: Image(
                                image: viewModel.getProfileImageProvider(),
                                fit: BoxFit.cover,
                                width: 80, // match diameter
                                height: 80, // match diameter
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          Text(
                            viewModel.profiledata?.data?.userName ?? "",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              viewModel.profiledata?.data?.bio ?? "",
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomListTile(
                      leadingIcon: Icons.edit,
                      title: 'Edit Profile',
                      onTap: () {
                        // // Example: Update profile using ViewModel
                        // viewModel.updateProfile(
                        //   name: 'new phone',
                        //   email: 'New email',

                        //   bio: 'New Bio',
                        //   phone: 'New Phone',
                        // );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    CustomListTile(
                      leadingIcon: Icons.lock,
                      title: 'Password',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),
                    CustomListTile(
                      leadingIcon: Icons.shopping_bag,
                      title: 'My Products',
                      onTap: () {
                        // Navigate to products
                      },
                    ),
                    CustomListTile(
                      leadingIcon: Icons.gavel,
                      title: 'Bid Management',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BidManagementScreen(
                              tabTitles: [
                                'All Bids',
                                'Won Bids',
                                'Lost Bids',
                                'Ongoing',
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    CustomListTile(
                      leadingIcon: Icons.gavel,
                      title: 'Add new Bid',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddNewAuctionScreen(),
                          ),
                        );
                      },
                    ),
                    CustomListTile(
                      leadingIcon: Icons.favorite_border,
                      title: 'Watchlist',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => WishlistScreen()),
                        );
                        // Handle watchlist
                      },
                    ),
                    CustomListTile(
                      leadingIcon: Icons.exit_to_app,
                      title: 'Logout',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ChangeNotifierProvider(
                              create: (context) => Logoutviewmodel(),
                              child: Consumer<Logoutviewmodel>(
                                builder: (context, logoutViewModel, child) {
                                  return LoadingOverlay(
                                    isLoading: logoutViewModel.isLogoutLoading,
                                    child: Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.logout,
                                              color: AppColors.themecolor,
                                              size: 35,
                                            ),
                                            SizedBox(height: 15),
                                            Text(
                                              "Logout?",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "Are you sure you want to log out?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            SizedBox(height: 25),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey[300],
                                                    foregroundColor:
                                                        Colors.black,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(
                                                      context,
                                                    ).pop(); // Close dialog
                                                  },
                                                  child: Text("Cancel"),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.themecolor,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    final success =
                                                        await logoutViewModel
                                                            .appDataLogout(
                                                              context,
                                                            );
                                                    if (success &&
                                                        context.mounted) {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              const FirstPage(),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Text("Logout"),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Privacy Policy', style: footerTextStyle),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('|', style: footerTextStyle),
                    ),
                    Text('Term and Conditions', style: footerTextStyle),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('|', style: footerTextStyle),
                    ),
                    Text('FAQs', style: footerTextStyle),
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
