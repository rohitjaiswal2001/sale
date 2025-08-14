class AppUrl {
  static const String baseUrl = 'https://bid4stylepgre.visionvivante.in';
  // "http://192.168.3.62:3003";
  // Auth
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String signUp = '$baseUrl/auth/signup';
  static const String verifyOtp = '$baseUrl/auth/check-otp';

  //Profile
  static const String getProfile = '$baseUrl/auth/profile';
  static const String getPlan = '$baseUrl/v1/tier';
  static const String submithelp = '$baseUrl/v1/contact-us';
  static const String updatepassword = '$baseUrl/auth/reset-password';
  static const String addJournal = '$baseUrl/v1/create-journal';
  static const String sortedjournal = '$baseUrl/v1/sorted-journals';
  static const String deletejournal = '$baseUrl/v1/delete-journal/';
  static const String singleDetail = '$baseUrl/v1/get-single-journal/';
  static const String Userdetail = '$baseUrl/user-detail';
  static const String deleteUser = '$baseUrl/delete?id=';
  static const String changePassword = '$baseUrl/change-password/';
  static const String editprofile = '$baseUrl/update-profile';
  static const String removepic = '$baseUrl/remove-profile-picture';
  static const String renamejournal = '$baseUrl/v1/rename-journal/';
  static const String copytoaccount = '$baseUrl/v1/copy-journal/';

  // static const String sendEdit='$baseUrl'
  static const String addsubscription = '$baseUrl/add-subscription';
  static const String cancelSubscription = '$baseUrl/cancel-subscription';
  static const String pauseSubscription = '$baseUrl/pause-subscription';
  static const String resumeSubscription = '$baseUrl/resume-subscription';
  static const String updateSubscription = '$baseUrl/update-subscription';
  static const String shareEmail = '$baseUrl/v1/share-files/';
  static const String shareEmailFolder = '$baseUrl/v1/share-folder/';
  // static const String storage = '$baseUrl/bucket-storage';
  static const String make_private = '$baseUrl/v1/change-private-status/';
  static const String editTitleDesc = '$baseUrl/v1/new-update';
  static const String sharedJournal = '$baseUrl/v1/me-shared-journals';
  static const String getcurrentplan = '$baseUrl/get-current_plan';
  static const String transferjournal = '$baseUrl/v1/ownership-transfer/';
  static const String createfolder = '$baseUrl/v1/create-folder';
  static const String getmyfolder = '$baseUrl/v1/get-my-folders';
  static const String renameFolder = '$baseUrl/v1/folder-rename/';
  static const String deleteFolder = '$baseUrl/v1/folder-delete/';
  static const String assignFolder = '$baseUrl/v1/assign-journal';
  static const String folderdetail = '$baseUrl/v1/folder-details';
  static const String searchfolder = '$baseUrl/v1/search-folder';
  static const String myshared = '$baseUrl/v1/journals-shared-to';
  static const String meshared = '$baseUrl/v1/me-shared-journals';
  static const String getshareduser = '$baseUrl/v1/get-shared-users';
  static const String removeshareduser = '$baseUrl/v1/remove-user-access';
  static const String privacypolicy = '$baseUrl/v1/page/privacy-policy';
  static const String removeme = '$baseUrl/v1/remove-shared-journal/';
  static const String termsandcondition =
      '$baseUrl/v1/page/terms-and-condition';
  static const String transferownershipfiles = '$baseUrl/transfer-ownership';
  static const String exportRequest = '$baseUrl/export-media';
  static const String getRetrivalPlan = '$baseUrl/v1/reactive-plans';
  static const String editFolder = '$baseUrl/v1/update-folder';
  static const String getMysharedfolder = '$baseUrl/v1/my-shared-folders';
  static const String getMesharedfolder = '$baseUrl/v1/me-shared-folders';
  static const String getsharedfolderuser = '$baseUrl/v1/shared-folder-detail/';

  static const String requestPlan = '$baseUrl/v1/create-custom-request';

  static const String updatefcm = '$baseUrl/update-fcm-token';

  static const String fqs = '$baseUrl/v1/faq';

  static const String getselectedFolders = '$baseUrl/v1/get-journal-folders/';

  static String alert = '$baseUrl/get-activity';
}
