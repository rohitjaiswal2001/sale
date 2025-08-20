import 'package:bid4style/Utils/Appcolor.dart';
import 'package:bid4style/utils/ValidationHelper.dart';
import 'package:bid4style/utils/extention.dart';
import 'package:bid4style/utils/permisions.dart';
import 'package:bid4style/view/Auth/widgets/authsmallwidgets.dart';
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
                if (viewModel.formKey.currentState!.validate()) return;

                viewModel.saveProfile(context);
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
                  // // Circular container for profile picture
                  // GestureDetector(
                  //   onTap: () => _showImageOptions(context, viewModel),
                  //   child: CircleAvatar(
                  //     radius: 50,
                  //     backgroundColor: AppColors.grey,
                  //     backgroundImage:
                  //         viewModel.profilePicController.text.isNotEmpty
                  //         ? CachedNetworkImageProvider(
                  //             viewModel.profilePicController.text,
                  //           )
                  //         : null,
                  //     child: viewModel.profilePicController.text.isEmpty
                  //         ? const Icon(
                  //             Icons.person,
                  //             size: 50,
                  //             color: AppColors.white,
                  //           )
                  //         : null,
                  //   ),
                  // ),

                  // CircleAvatar(
                  //                           maxRadius: 40,
                  //                           child: ClipOval(
                  //                             child:

                  //                                 // Image.network(
                  //                                 //   context
                  //                                 //       .read<Userdetailviewmodel>()
                  //                                 //       .profileimg,
                  //                                 //   fit: BoxFit.cover,
                  //                                 //   height: 70,
                  //                                 //   width: 70,
                  //                                 //   errorBuilder: (BuildContext context,
                  //                                 //       Object error,
                  //                                 //       StackTrace? stackTrace) {
                  //                                 //     return Image.asset(
                  //                                 //       "assets/images/created.png",
                  //                                 //       fit: BoxFit.cover,
                  //                                 //     ); // Fallback asset image
                  //                                 //   },
                  //                                 // ),
                  //                                 Image(
                  //                               image: context
                  //                                   .watch<EditProfileViewModel>()
                  //                                   .getProfileImageProvider(),
                  //                               fit: BoxFit.cover,
                  //                               errorBuilder:
                  //                                   (context, error, stackTrace) {
                  //                                 // Fallback to asset image if there's an error
                  //                                 return Image.asset(
                  //                                   'assets/images/created.png',
                  //                                   fit: BoxFit.cover,
                  //                                 );
                  //                               },
                  //                             ),
                  //                           )),
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
                  TextDeclarationWidget(text: "Email"),
                  TexfieldWidget(
                    color: AppColors.white,
                    controller: viewModel.emailController,
                    validator: ValidationHelper.validateEmail,
                    hint: "Enter your email",
                    focusNode: viewModel.emailFocusNode,
                    nextFocusNode: viewModel.userNameFocusNode,
                  ),
                  TextDeclarationWidget(text: "Username"),
                  TexfieldWidget(
                    color: AppColors.white,
                    controller: viewModel.userNameController,
                    validator: ValidationHelper.validateName,
                    hint: "Enter Username",
                    focusNode: viewModel.userNameFocusNode,
                    nextFocusNode: viewModel.bioFocusNode,
                  ),
                  TextDeclarationWidget(text: "Bio (Optional)"),
                  TexfieldWidget(
                    controller: viewModel.bioController,
                    hint: "Bio",
                    focusNode: viewModel.bioFocusNode,
                    maxLine: 5,
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

  void _showImageOptions(BuildContext context, EditProfileViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(context, ImageSource.gallery);
                },
              ),
              if (viewModel.profilePicController.text.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Remove Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.removeProfilePicture();
                  },
                ),
            ],
          ),
        );
      },
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
