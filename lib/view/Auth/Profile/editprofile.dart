import 'package:bid4style/Utils/Appcolor.dart';
import 'package:bid4style/utils/ValidationHelper.dart';
import 'package:bid4style/utils/extention.dart';
import 'package:bid4style/utils/permisions.dart';
import 'package:bid4style/view/Auth/widgets/textsmallwidgets.dart';
import 'package:bid4style/viewModal/ProfileViewmodal.darrt/editprofileviewmodal.dart';
import 'package:bid4style/widgets/ButtonWidget.dart';
import 'package:bid4style/widgets/TextFieldWidget.dart';
import 'package:bid4style/widgets/apploader.dart';
import 'package:bid4style/widgets/commonDivider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditProfileViewModel(),
      child: const _EditProfileScreen(),
    );
  }
}

class _EditProfileScreen extends StatefulWidget {
  const _EditProfileScreen();

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<_EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          final viewModel = context.read<EditProfileViewModel>();
          viewModel.initializeControllers(context);
        } catch (e) {
          print("Error initializing controllers: $e");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditProfileViewModel>();

    return LoadingOverlay(
      isLoading: viewModel.isLoading,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Edit Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                if (viewModel.formKey.currentState!.validate()) {
                  // ✅ Save profile only if validation passed
                  viewModel.saveProfile(context);
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: viewModel.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      onEditImageFunction(context, viewModel);
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: (viewModel.selectedImage != null)
                          ? FileImage(viewModel.selectedImage!)
                          : (viewModel.imgurl != null &&
                                viewModel.imgurl!.isNotEmpty)
                          ? context
                                .watch<EditProfileViewModel>()
                                .getProfileImageProviderProfileView(
                                  selectedImage: viewModel.selectedImage,
                                )
                          : null,
                      child:
                          (viewModel.selectedImage == null &&
                              (viewModel.imgurl == null ||
                                  viewModel.imgurl == "" ||
                                  viewModel.imgurl!.isEmpty))
                          ? const Icon(
                              Icons.camera_alt_outlined,
                              size: 50,
                              color: Colors.white,
                            )
                          : context
                                .watch<EditProfileViewModel>()
                                .isProfileImageLoading
                          ? Icon(Icons.person)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextDeclarationWidget(text: "Name"),
                  TexfieldWidget(
                    color: AppColors.white,
                    controller: viewModel.userNameController,
                    validator: ValidationHelper.validateName,
                    hint: "Enter Name",
                    focusNode: viewModel.userNameFocusNode,
                    nextFocusNode: viewModel.emailFocusNode,
                  ),
                  TextDeclarationWidget(text: "Email"),
                  TexfieldWidget(
                    color: AppColors.white,
                    controller: viewModel.emailController,
                    validator: ValidationHelper.validateEmail,
                    hint: "Enter your email",
                    focusNode: viewModel.emailFocusNode,
                    nextFocusNode: viewModel.phnoFocusNode,
                  ),

                  TextDeclarationWidget(text: "Phone No."),
                  TexfieldWidget(
                    controller: viewModel.phoneController,
                    hint: "Enter your Phone no.",
                    validator: ValidationHelper.validatePhoneInternational,
                    focusNode: viewModel.phnoFocusNode,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> onEditImageFunction(
    BuildContext context,
    EditProfileViewModel viewModel,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            width: context.mediaQueryWidth * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            height: 190,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: context.mediaQueryWidth * 0.2,
                  height: 4,
                  padding: const EdgeInsets.all(8),
                  color: AppColors.grey,
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.black,
                  ),
                  title: Text(
                    'Camera',
                    style: TextStyle(color: AppColors.black),
                  ),
                  onTap: () async {
                    bool permissionStatus = await PermissionService()
                        .requestGalleryPermission();

                    if (!permissionStatus) return;

                    bool added = await viewModel.clickImage(context);

                    if (added) {
                      print("Adde--- $added");

                      // Delay to avoid pop conflicts (iOS animation issue)
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
                const CustomGradientDivider(),
                ListTile(
                  leading: Icon(Icons.photo, color: AppColors.black),
                  title: Text(
                    'Gallery',
                    style: TextStyle(color: AppColors.black),
                  ),
                  onTap: () async {
                    bool permissionStatus = await PermissionService()
                        .requestGalleryPermission();
                    if (permissionStatus) {
                      bool added = await viewModel.pickImageProfile(context);

                      if (added) {
                        print("Adde--- $added");
                        Navigator.pop(context);
                      }
                    } else {
                      return;
                    }
                  },
                ),
                const CustomGradientDivider(),
                ListTile(
                  leading: Icon(Icons.delete, color: AppColors.red),
                  title: Text('Remove', style: TextStyle(color: AppColors.red)),
                  onTap: () {
                    viewModel.removeImageoption();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
