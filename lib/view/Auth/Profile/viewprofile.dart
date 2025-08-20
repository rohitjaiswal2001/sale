// File: profile_screen.dart
// The view file for the profile screen

import 'package:bid4style/utils/textstyle.dart';
import 'package:bid4style/view/Auth/Profile/editprofile.dart';
import 'package:bid4style/view/Auth/Profile/changePassword.dart';
import 'package:bid4style/view/BidManagment/Mybid.dart';
import 'package:bid4style/view/BidManagment/createBid.dart';
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
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            // backgroundImage: NetworkImage(
                            //   'https://example.com/avatar.jpg',
                            // ), // Replace with actual image URL
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
                        // Handle watchlist
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
