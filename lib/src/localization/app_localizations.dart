import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ms.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ms')
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @malay.
  ///
  /// In en, this message translates to:
  /// **'Malay'**
  String get malay;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @noTransactionfound.
  ///
  /// In en, this message translates to:
  /// **'No Transaction Found'**
  String get noTransactionfound;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @parkingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pay Parking Status'**
  String get parkingStatus;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout'**
  String get logoutDesc;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @aboutMe.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutMe;

  /// No description provided for @emailPassword.
  ///
  /// In en, this message translates to:
  /// **'E-Mail & Password'**
  String get emailPassword;

  /// No description provided for @listOfVehicle.
  ///
  /// In en, this message translates to:
  /// **'List of Vehicle'**
  String get listOfVehicle;

  /// No description provided for @shareThisApp.
  ///
  /// In en, this message translates to:
  /// **'Share This App'**
  String get shareThisApp;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @termAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Term & Conditions'**
  String get termAndConditions;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT INFO'**
  String get accountInfo;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID Card Number'**
  String get idNumber;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @seasonPass.
  ///
  /// In en, this message translates to:
  /// **'Season Pass'**
  String get seasonPass;

  /// No description provided for @reserveBays.
  ///
  /// In en, this message translates to:
  /// **'Reserve Bays'**
  String get reserveBays;

  /// No description provided for @compound.
  ///
  /// In en, this message translates to:
  /// **'Compound'**
  String get compound;

  /// No description provided for @parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking;

  /// No description provided for @enforcement.
  ///
  /// In en, this message translates to:
  /// **'Enforcement'**
  String get enforcement;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @selectItem.
  ///
  /// In en, this message translates to:
  /// **'Select Item'**
  String get selectItem;

  /// No description provided for @pleaseWriteHere.
  ///
  /// In en, this message translates to:
  /// **'Please write here'**
  String get pleaseWriteHere;

  /// No description provided for @carPlate.
  ///
  /// In en, this message translates to:
  /// **'Car Plate'**
  String get carPlate;

  /// No description provided for @addPlateNo.
  ///
  /// In en, this message translates to:
  /// **'Add Plate No'**
  String get addPlateNo;

  /// No description provided for @addVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get addVehicle;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorDesc.
  ///
  /// In en, this message translates to:
  /// **'Cannot add more than 2 vehicles'**
  String get errorDesc;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @confirmDeletion.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeletion;

  /// No description provided for @confirmDeletionDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the plate number'**
  String get confirmDeletionDesc;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @tokenBalance.
  ///
  /// In en, this message translates to:
  /// **'Token Balance'**
  String get tokenBalance;

  /// No description provided for @updatedOn.
  ///
  /// In en, this message translates to:
  /// **'Updated On'**
  String get updatedOn;

  /// No description provided for @parkingTimeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Parking Time Remaining'**
  String get parkingTimeRemaining;

  /// No description provided for @ourService.
  ///
  /// In en, this message translates to:
  /// **'Our Service'**
  String get ourService;

  /// No description provided for @summons.
  ///
  /// In en, this message translates to:
  /// **'Summons'**
  String get summons;

  /// No description provided for @parking2.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking2;

  /// No description provided for @monthlyPass.
  ///
  /// In en, this message translates to:
  /// **'Monthly Pass'**
  String get monthlyPass;

  /// No description provided for @transportInfo.
  ///
  /// In en, this message translates to:
  /// **'Transport Info'**
  String get transportInfo;

  /// No description provided for @transportInfo2.
  ///
  /// In en, this message translates to:
  /// **'Transport Info'**
  String get transportInfo2;

  /// No description provided for @newsUpdate.
  ///
  /// In en, this message translates to:
  /// **'News Update'**
  String get newsUpdate;

  /// No description provided for @selectState.
  ///
  /// In en, this message translates to:
  /// **'Select State'**
  String get selectState;

  /// No description provided for @selectPbt.
  ///
  /// In en, this message translates to:
  /// **'Select PBT'**
  String get selectPbt;

  /// No description provided for @onStreet.
  ///
  /// In en, this message translates to:
  /// **'On Street'**
  String get onStreet;

  /// No description provided for @plateNumber.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plateNumber;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @paymentDesc.
  ///
  /// In en, this message translates to:
  /// **'Please Pay and Park Responsibly'**
  String get paymentDesc;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// No description provided for @successful.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get successful;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank You'**
  String get thankYou;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back To Home'**
  String get backToHome;

  /// No description provided for @statusTopUpWallet.
  ///
  /// In en, this message translates to:
  /// **'Status Top Up Wallet'**
  String get statusTopUpWallet;

  /// No description provided for @monthlyPass2.
  ///
  /// In en, this message translates to:
  /// **'M O N T H L Y\nP A S S'**
  String get monthlyPass2;

  /// No description provided for @amount2.
  ///
  /// In en, this message translates to:
  /// **'A M O U N T'**
  String get amount2;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @companyRegistration.
  ///
  /// In en, this message translates to:
  /// **'Company Registration'**
  String get companyRegistration;

  /// No description provided for @totalLotRequired.
  ///
  /// In en, this message translates to:
  /// **'Total Lot Required'**
  String get totalLotRequired;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @viewReserveBay.
  ///
  /// In en, this message translates to:
  /// **'View Reserve Bay'**
  String get viewReserveBay;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @reserveDetails.
  ///
  /// In en, this message translates to:
  /// **'Reserve\nDetails'**
  String get reserveDetails;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @tnc.
  ///
  /// In en, this message translates to:
  /// **'T&C'**
  String get tnc;

  /// No description provided for @ssmNumber.
  ///
  /// In en, this message translates to:
  /// **'SSM Number'**
  String get ssmNumber;

  /// No description provided for @businessType.
  ///
  /// In en, this message translates to:
  /// **'Business Type'**
  String get businessType;

  /// No description provided for @address1.
  ///
  /// In en, this message translates to:
  /// **'Address 1'**
  String get address1;

  /// No description provided for @address2.
  ///
  /// In en, this message translates to:
  /// **'Address 2'**
  String get address2;

  /// No description provided for @address3.
  ///
  /// In en, this message translates to:
  /// **'Address 3'**
  String get address3;

  /// No description provided for @postcode.
  ///
  /// In en, this message translates to:
  /// **'Postcode'**
  String get postcode;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @secondName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get secondName;

  /// No description provided for @totalLot.
  ///
  /// In en, this message translates to:
  /// **'Total Lot'**
  String get totalLot;

  /// No description provided for @lotNumber.
  ///
  /// In en, this message translates to:
  /// **'Lot Number'**
  String get lotNumber;

  /// No description provided for @intendedDesignatedBay.
  ///
  /// In en, this message translates to:
  /// **'Intended Designated Bay'**
  String get intendedDesignatedBay;

  /// No description provided for @companyRegistrationCertificate.
  ///
  /// In en, this message translates to:
  /// **'Company Registration Certificate'**
  String get companyRegistrationCertificate;

  /// No description provided for @identificationCard.
  ///
  /// In en, this message translates to:
  /// **'Identification Card (Front & Back)'**
  String get identificationCard;

  /// No description provided for @addReserveBay.
  ///
  /// In en, this message translates to:
  /// **'Add Reserve Bay'**
  String get addReserveBay;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @personInCharge.
  ///
  /// In en, this message translates to:
  /// **'Person In Charge'**
  String get personInCharge;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @reload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @token.
  ///
  /// In en, this message translates to:
  /// **'Token'**
  String get token;

  /// No description provided for @paymentDesc2.
  ///
  /// In en, this message translates to:
  /// **'You will be bring to 3rd Party website for Reload Token. Please ensure the detail above is accurate.'**
  String get paymentDesc2;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgetPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginDesc.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account'**
  String get loginDesc;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accountDesc.
  ///
  /// In en, this message translates to:
  /// **'This section is for your\naccount information'**
  String get accountDesc;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @addressDesc.
  ///
  /// In en, this message translates to:
  /// **'This section is for your\naddress information'**
  String get addressDesc;

  /// No description provided for @carPlateNumber.
  ///
  /// In en, this message translates to:
  /// **'Car Plate Number'**
  String get carPlateNumber;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @forgetPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter email address associated with your account and we\'ll send email the OTP to reset your email.'**
  String get forgetPasswordDesc;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Key-in the OTP that have been sent through your email. The OTP will expired in 10 minutes.'**
  String get resetPasswordDesc;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @viewPDF.
  ///
  /// In en, this message translates to:
  /// **'View PDF'**
  String get viewPDF;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @exitApp.
  ///
  /// In en, this message translates to:
  /// **'Exit Application'**
  String get exitApp;

  /// No description provided for @exitAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close this application? This action cannot be undone.'**
  String get exitAppDesc;

  /// No description provided for @closeReceipt.
  ///
  /// In en, this message translates to:
  /// **'Close Receipt'**
  String get closeReceipt;

  /// No description provided for @closeReceiptDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close the receipt? This action cannot be undone.'**
  String get closeReceiptDesc;

  /// No description provided for @offenderIdNo.
  ///
  /// In en, this message translates to:
  /// **'Offender ID No.'**
  String get offenderIdNo;

  /// No description provided for @noticeNo.
  ///
  /// In en, this message translates to:
  /// **'Notice No.'**
  String get noticeNo;

  /// No description provided for @enterSearchTerm.
  ///
  /// In en, this message translates to:
  /// **'Enter Search Term'**
  String get enterSearchTerm;

  /// No description provided for @vehicleNo.
  ///
  /// In en, this message translates to:
  /// **'Vehicle No.'**
  String get vehicleNo;

  /// No description provided for @offencesAct.
  ///
  /// In en, this message translates to:
  /// **'Offences Act'**
  String get offencesAct;

  /// No description provided for @offencesDate.
  ///
  /// In en, this message translates to:
  /// **'Offences Date'**
  String get offencesDate;

  /// No description provided for @compoundDesc.
  ///
  /// In en, this message translates to:
  /// **'There no records of Compound.'**
  String get compoundDesc;

  /// No description provided for @typeOfOffences.
  ///
  /// In en, this message translates to:
  /// **'Type Of Offences'**
  String get typeOfOffences;

  /// No description provided for @compoundRate.
  ///
  /// In en, this message translates to:
  /// **'Compound Rate'**
  String get compoundRate;

  /// No description provided for @compountPaymentDesc.
  ///
  /// In en, this message translates to:
  /// **'Please make payment before this date'**
  String get compountPaymentDesc;

  /// No description provided for @receiptNo.
  ///
  /// In en, this message translates to:
  /// **'Receipt No.'**
  String get receiptNo;

  /// No description provided for @expiredDate.
  ///
  /// In en, this message translates to:
  /// **'Expired Date'**
  String get expiredDate;

  /// No description provided for @newsDesc.
  ///
  /// In en, this message translates to:
  /// **'There no promotion for now.'**
  String get newsDesc;

  /// No description provided for @notificationDesc.
  ///
  /// In en, this message translates to:
  /// **'You have no notifications.'**
  String get notificationDesc;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @setAsMain.
  ///
  /// In en, this message translates to:
  /// **'Set As Main'**
  String get setAsMain;

  /// No description provided for @contactReload.
  ///
  /// In en, this message translates to:
  /// **'If the reload problem, please contact CityCarPark helpline at '**
  String get contactReload;

  /// No description provided for @emailReload.
  ///
  /// In en, this message translates to:
  /// **'\nor email to our customer service '**
  String get emailReload;

  /// No description provided for @contactParking.
  ///
  /// In en, this message translates to:
  /// **'If the pay parking problem, please contact CityCarPark helpline at '**
  String get contactParking;

  /// No description provided for @emailParking.
  ///
  /// In en, this message translates to:
  /// **'\nor email to our customer service '**
  String get emailParking;

  /// No description provided for @contactMonthlyPass.
  ///
  /// In en, this message translates to:
  /// **'If the pay monthly pass problem, please contact CityCarPark helpline at '**
  String get contactMonthlyPass;

  /// No description provided for @emailMonthlyPass.
  ///
  /// In en, this message translates to:
  /// **'\nor email to our customer service '**
  String get emailMonthlyPass;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @actTitle.
  ///
  /// In en, this message translates to:
  /// **'Road Transport Act 1987'**
  String get actTitle;

  /// No description provided for @actDesc.
  ///
  /// In en, this message translates to:
  /// **'Road Transport Order \n(Provision Regarding Parking)'**
  String get actDesc;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteDesc;

  /// No description provided for @typeDelete.
  ///
  /// In en, this message translates to:
  /// **'Type \'DELETE\' to confirm'**
  String get typeDelete;

  /// No description provided for @successDelete.
  ///
  /// In en, this message translates to:
  /// **'Account successfully deleted'**
  String get successDelete;

  /// No description provided for @confirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get confirmPayment;

  /// No description provided for @confirmPaymentDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to confirm this payment?'**
  String get confirmPaymentDesc;

  /// No description provided for @areas.
  ///
  /// In en, this message translates to:
  /// **'Areas'**
  String get areas;

  /// No description provided for @selectAreaError.
  ///
  /// In en, this message translates to:
  /// **'Area Cannot be empty'**
  String get selectAreaError;

  /// No description provided for @selectLocationError.
  ///
  /// In en, this message translates to:
  /// **'Location Cannot be empty'**
  String get selectLocationError;

  /// No description provided for @autoDeduct.
  ///
  /// In en, this message translates to:
  /// **'Auto-Deduct'**
  String get autoDeduct;

  /// No description provided for @autoDeductDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically use your token balance for parking fees at supported locations.'**
  String get autoDeductDescription;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works:'**
  String get howItWorks;

  /// No description provided for @howItWorksPoint1.
  ///
  /// In en, this message translates to:
  /// **'Make sure your token balance is sufficient before parking.'**
  String get howItWorksPoint1;

  /// No description provided for @howItWorksPoint2.
  ///
  /// In en, this message translates to:
  /// **'If your token balance is sufficient, parking fees will be auto-deducted.'**
  String get howItWorksPoint2;

  /// No description provided for @howItWorksPoint3.
  ///
  /// In en, this message translates to:
  /// **'If your token balance is insufficient, manual payment will be required.'**
  String get howItWorksPoint3;

  /// No description provided for @keepBalanceTopped.
  ///
  /// In en, this message translates to:
  /// **'Keep your balance topped up for a seamless parking experience.'**
  String get keepBalanceTopped;

  /// No description provided for @autoDeductNotification.
  ///
  /// In en, this message translates to:
  /// **'Auto-deduct will automatically deduct parking fees. You will receive a confirmation notification before each deduction.'**
  String get autoDeductNotification;

  /// No description provided for @definitions_title.
  ///
  /// In en, this message translates to:
  /// **'1. Definitions'**
  String get definitions_title;

  /// No description provided for @definitions_intro.
  ///
  /// In en, this message translates to:
  /// **'For the purposes of this Agreement, unless otherwise stated, the following terms shall have the meanings assigned below:'**
  String get definitions_intro;

  /// No description provided for @account_label.
  ///
  /// In en, this message translates to:
  /// **'Account(s):'**
  String get account_label;

  /// No description provided for @activation_label.
  ///
  /// In en, this message translates to:
  /// **'Activation:'**
  String get activation_label;

  /// No description provided for @agreement_label.
  ///
  /// In en, this message translates to:
  /// **'Agreement:'**
  String get agreement_label;

  /// No description provided for @compound_label.
  ///
  /// In en, this message translates to:
  /// **'Compound:'**
  String get compound_label;

  /// No description provided for @customer_label.
  ///
  /// In en, this message translates to:
  /// **'Customer:'**
  String get customer_label;

  /// No description provided for @device_label.
  ///
  /// In en, this message translates to:
  /// **'Device:'**
  String get device_label;

  /// No description provided for @ccp_label.
  ///
  /// In en, this message translates to:
  /// **'CCP:'**
  String get ccp_label;

  /// No description provided for @ccp_system_label.
  ///
  /// In en, this message translates to:
  /// **'CCP System:'**
  String get ccp_system_label;

  /// No description provided for @financier_label.
  ///
  /// In en, this message translates to:
  /// **'Financier:'**
  String get financier_label;

  /// No description provided for @information_label.
  ///
  /// In en, this message translates to:
  /// **'Information:'**
  String get information_label;

  /// No description provided for @mobile_telephone_label.
  ///
  /// In en, this message translates to:
  /// **'Mobile Telephone:'**
  String get mobile_telephone_label;

  /// No description provided for @monthly_passes_label.
  ///
  /// In en, this message translates to:
  /// **'Monthly Passes:'**
  String get monthly_passes_label;

  /// No description provided for @parking_charges_label.
  ///
  /// In en, this message translates to:
  /// **'Parking Charges:'**
  String get parking_charges_label;

  /// No description provided for @token_label.
  ///
  /// In en, this message translates to:
  /// **'Token:'**
  String get token_label;

  /// No description provided for @user_label.
  ///
  /// In en, this message translates to:
  /// **'User:'**
  String get user_label;

  /// No description provided for @service_label.
  ///
  /// In en, this message translates to:
  /// **'Service:'**
  String get service_label;

  /// No description provided for @taxes_label.
  ///
  /// In en, this message translates to:
  /// **'Taxes:'**
  String get taxes_label;

  /// No description provided for @value_added_services_label.
  ///
  /// In en, this message translates to:
  /// **'Value-Added Services:'**
  String get value_added_services_label;

  /// No description provided for @account_desc.
  ///
  /// In en, this message translates to:
  /// **'An account established for the Customer with CCP or its subsidiaries to enable subscription and use of the Services.'**
  String get account_desc;

  /// No description provided for @activation_desc.
  ///
  /// In en, this message translates to:
  /// **'The point in time when the Service is formally activated within the CCP System.'**
  String get activation_desc;

  /// No description provided for @agreement_desc.
  ///
  /// In en, this message translates to:
  /// **'The registration agreement, together with these Terms and Conditions, including any subsequent amendments, variations, or modifications introduced by CCP at its sole discretion.'**
  String get agreement_desc;

  /// No description provided for @compound_desc.
  ///
  /// In en, this message translates to:
  /// **'A penalty imposed by municipal councils for traffic or parking violations committed by vehicle owners or drivers.'**
  String get compound_desc;

  /// No description provided for @customer_desc.
  ///
  /// In en, this message translates to:
  /// **'An individual or legal entity authorised to use the Services, including but not limited to sole proprietors, partnerships, corporations, and government agencies.'**
  String get customer_desc;

  /// No description provided for @device_desc.
  ///
  /// In en, this message translates to:
  /// **'Any hardware utilised to access CCP’s Services, including but not limited to servers, computers, laptops, tablets, mobile phones, and associated accessories.'**
  String get device_desc;

  /// No description provided for @ccp_desc.
  ///
  /// In en, this message translates to:
  /// **'CityCarPark, with its principal place of business at 1-1A, 1-1B, 1-2A, 1-2B, Taman, Jln. UP 1/3, Ukay Perdana, 68000 Ampang, Selangor.'**
  String get ccp_desc;

  /// No description provided for @ccp_system_desc.
  ///
  /// In en, this message translates to:
  /// **'The proprietary technology operated by CCP for parking payments, compound payments, and other services introduced from time to time.'**
  String get ccp_system_desc;

  /// No description provided for @financier_desc.
  ///
  /// In en, this message translates to:
  /// **'A licensed institution as defined in the Banking and Financial Institutions Act 1989.'**
  String get financier_desc;

  /// No description provided for @information_desc.
  ///
  /// In en, this message translates to:
  /// **'Any data, content, or material generated, accessed, transmitted, or disclosed via the Services or the CCP System, including personal data.'**
  String get information_desc;

  /// No description provided for @mobile_telephone_desc.
  ///
  /// In en, this message translates to:
  /// **'Wireless communication equipment comprising a transmitter, receiver, and associated accessories used for the Service.'**
  String get mobile_telephone_desc;

  /// No description provided for @monthly_passes_desc.
  ///
  /// In en, this message translates to:
  /// **'Parking fees payable to city councils on a monthly basis, inclusive of applicable charges or taxes.'**
  String get monthly_passes_desc;

  /// No description provided for @parking_charges_desc.
  ///
  /// In en, this message translates to:
  /// **'Time-bounded parking fees imposed by city councils, inclusive of applicable charges or taxes.'**
  String get parking_charges_desc;

  /// No description provided for @token_desc.
  ///
  /// In en, this message translates to:
  /// **'A pre-paid credit purchased by the Customer for use of the Services, valid for three (3) years from the date of purchase.'**
  String get token_desc;

  /// No description provided for @user_desc.
  ///
  /// In en, this message translates to:
  /// **'The Customer, or in the case of an entity, any individual designated as the principal user of the Service.'**
  String get user_desc;

  /// No description provided for @service_desc.
  ///
  /// In en, this message translates to:
  /// **'Facilities offered by CCP, including mobile-enabled parking payments, compound payments, and other value-added services.'**
  String get service_desc;

  /// No description provided for @taxes_desc.
  ///
  /// In en, this message translates to:
  /// **'Government-imposed levies (e.g., Sales and Services Tax) payable by the Customer under prevailing law.'**
  String get taxes_desc;

  /// No description provided for @value_added_services_desc.
  ///
  /// In en, this message translates to:
  /// **'Additional features, applications, or facilities introduced by CCP from time to time for subscription or use in conjunction with the Service.'**
  String get value_added_services_desc;

  /// No description provided for @period_agreement_label.
  ///
  /// In en, this message translates to:
  /// **'2. Period of Agreement'**
  String get period_agreement_label;

  /// No description provided for @period_agreement_desc.
  ///
  /// In en, this message translates to:
  /// **'This Agreement shall take effect upon activation of the Customer’s account or mobile telephone connection to the Service and shall remain in force until terminated in accordance with these Terms and Conditions. CCP reserves the right to use any Information provided from the date of disclosure by the Customer.'**
  String get period_agreement_desc;

  /// No description provided for @account_security_label.
  ///
  /// In en, this message translates to:
  /// **'3. Account, Security, and Payment'**
  String get account_security_label;

  /// No description provided for @account_security_desc.
  ///
  /// In en, this message translates to:
  /// **'To access the Services, the Customer must register an Account by providing accurate and complete details, including identification information (NRIC/passport), contact details, and a secure password.'**
  String get account_security_desc;

  /// No description provided for @account_register_label.
  ///
  /// In en, this message translates to:
  /// **'By registering, the Customer expressly:'**
  String get account_register_label;

  /// No description provided for @account_register_1.
  ///
  /// In en, this message translates to:
  /// **'1. Consents to the processing of personal data for the purpose of service provision'**
  String get account_register_1;

  /// No description provided for @account_register_2.
  ///
  /// In en, this message translates to:
  /// **'2. Undertakes to pay all applicable fees, charges, and taxes associated with the Services'**
  String get account_register_2;

  /// No description provided for @additional_provisions_label.
  ///
  /// In en, this message translates to:
  /// **'Additional provisions:'**
  String get additional_provisions_label;

  /// No description provided for @additional_provisions_1.
  ///
  /// In en, this message translates to:
  /// **'Tokens and Monthly Passes purchased are non-refundable and non-transferable.'**
  String get additional_provisions_1;

  /// No description provided for @additional_provisions_2.
  ///
  /// In en, this message translates to:
  /// **'Tokens shall expire three (3) years from the purchase date.'**
  String get additional_provisions_2;

  /// No description provided for @additional_provisions_3.
  ///
  /// In en, this message translates to:
  /// **'In cases of bank delays or system disruptions, CCP will coordinate with municipal councils or concessionaires to resolve issues promptly.'**
  String get additional_provisions_3;

  /// No description provided for @additional_provisions_4.
  ///
  /// In en, this message translates to:
  /// **'Any disputes concerning charges must be submitted in writing within fourteen (14) days of the billing date. If no objection is received, the bill shall be deemed accurate and binding.'**
  String get additional_provisions_4;

  /// No description provided for @additional_provisions_5.
  ///
  /// In en, this message translates to:
  /// **'CCP reserves the right to recover unpaid sums, including legal costs, and statements signed by CCP officers shall constitute conclusive evidence of debt.'**
  String get additional_provisions_5;

  /// No description provided for @customer_responsibilities_label.
  ///
  /// In en, this message translates to:
  /// **'4. Customer Responsibilities'**
  String get customer_responsibilities_label;

  /// No description provided for @customer_shall.
  ///
  /// In en, this message translates to:
  /// **'The Customer shall:'**
  String get customer_shall;

  /// No description provided for @customer_responsibilities_1.
  ///
  /// In en, this message translates to:
  /// **'Use the Service responsibly and at their own risk.'**
  String get customer_responsibilities_1;

  /// No description provided for @customer_responsibilities_2.
  ///
  /// In en, this message translates to:
  /// **'Report fraud, unauthorised use, or irregularities within 24 hours of discovery.'**
  String get customer_responsibilities_2;

  /// No description provided for @customer_responsibilities_3.
  ///
  /// In en, this message translates to:
  /// **'Ensure the security of devices and software used for accessing the Service.'**
  String get customer_responsibilities_3;

  /// No description provided for @customer_responsibilities_4.
  ///
  /// In en, this message translates to:
  /// **'Not misuse the Service for unlawful purposes, third-party rights infringement, harassment, or spamming.'**
  String get customer_responsibilities_4;

  /// No description provided for @customer_responsibilities_5.
  ///
  /// In en, this message translates to:
  /// **'Comply with all technical upgrades, system changes, or instructions issued by CCP.'**
  String get customer_responsibilities_5;

  /// No description provided for @customer_responsibilities_6.
  ///
  /// In en, this message translates to:
  /// **'Accept responsibility for verifying whether their use of the Service breaches applicable laws or codes of conduct.'**
  String get customer_responsibilities_6;

  /// No description provided for @ccp_rights_liabilities_label.
  ///
  /// In en, this message translates to:
  /// **'5. Rights and Liabilities of CCP'**
  String get ccp_rights_liabilities_label;

  /// No description provided for @ccp_rights_liabilities_1.
  ///
  /// In en, this message translates to:
  /// **'CCP shall not be liable for losses or damages (direct, indirect, or consequential) arising from:'**
  String get ccp_rights_liabilities_1;

  /// No description provided for @ccp_rights_liabilities_1a.
  ///
  /// In en, this message translates to:
  /// **'Service modifications, interruptions, or suspension.'**
  String get ccp_rights_liabilities_1a;

  /// No description provided for @ccp_rights_liabilities_1b.
  ///
  /// In en, this message translates to:
  /// **'Malfunctions or defects in devices, mobile telephones, or the CCP System.'**
  String get ccp_rights_liabilities_1b;

  /// No description provided for @ccp_rights_liabilities_1c.
  ///
  /// In en, this message translates to:
  /// **'Customer’s inability to access or utilise the Service.'**
  String get ccp_rights_liabilities_1c;

  /// No description provided for @ccp_rights_liabilities_1d.
  ///
  /// In en, this message translates to:
  /// **'Data loss, viruses, or unauthorised access outside CCP’s reasonable control.'**
  String get ccp_rights_liabilities_1d;

  /// No description provided for @ccp_rights_liabilities_2.
  ///
  /// In en, this message translates to:
  /// **'CCP reserves the right to:'**
  String get ccp_rights_liabilities_2;

  /// No description provided for @ccp_rights_liabilities_2a.
  ///
  /// In en, this message translates to:
  /// **'Suspend, modify, or terminate Services for system maintenance, regulatory requirements, or suspected fraud.'**
  String get ccp_rights_liabilities_2a;

  /// No description provided for @ccp_rights_liabilities_2b.
  ///
  /// In en, this message translates to:
  /// **'Amend these Terms and Conditions at its discretion. Continued use of Services constitutes acceptance of amendments.'**
  String get ccp_rights_liabilities_2b;

  /// No description provided for @ccp_rights_liabilities_2c.
  ///
  /// In en, this message translates to:
  /// **'Retain Tokens for settlement of outstanding dues upon termination.'**
  String get ccp_rights_liabilities_2c;

  /// No description provided for @ccp_rights_liabilities_3.
  ///
  /// In en, this message translates to:
  /// **'The Customer shall indemnify CCP against all claims, actions, or losses resulting from misuse of the Service.'**
  String get ccp_rights_liabilities_3;

  /// No description provided for @force_majeure_label.
  ///
  /// In en, this message translates to:
  /// **'6. Force Majeure'**
  String get force_majeure_label;

  /// No description provided for @force_majeure_desc.
  ///
  /// In en, this message translates to:
  /// **'CCP shall not be held liable for failure or delay in performance resulting from events beyond its reasonable control, including natural disasters, war, civil unrest, industrial disputes, government directives, or other unforeseen circumstances.'**
  String get force_majeure_desc;

  /// No description provided for @waiver_misc_label.
  ///
  /// In en, this message translates to:
  /// **'7. Waiver and Miscellaneous Provisions:'**
  String get waiver_misc_label;

  /// No description provided for @waiver_misc_1.
  ///
  /// In en, this message translates to:
  /// **'Failure by CCP to exercise a right shall not constitute a waiver of that right.'**
  String get waiver_misc_1;

  /// No description provided for @waiver_misc_2.
  ///
  /// In en, this message translates to:
  /// **'This Agreement is governed by the laws of Malaysia, and disputes shall fall under the exclusive jurisdiction of the Malaysian courts.'**
  String get waiver_misc_2;

  /// No description provided for @waiver_misc_3.
  ///
  /// In en, this message translates to:
  /// **'Notices may be delivered by hand, post, email, SMS, or application messaging.'**
  String get waiver_misc_3;

  /// No description provided for @waiver_misc_4.
  ///
  /// In en, this message translates to:
  /// **'The Customer may not assign rights under this Agreement without prior consent, CCP may assign obligations at its discretion.'**
  String get waiver_misc_4;

  /// No description provided for @waiver_misc_5.
  ///
  /// In en, this message translates to:
  /// **'Invalid provisions shall not affect the enforceability of the remainder of the Agreement.'**
  String get waiver_misc_5;

  /// No description provided for @waiver_misc_6.
  ///
  /// In en, this message translates to:
  /// **'CCP reserves the right to verify customer information and reject registrations without liability.'**
  String get waiver_misc_6;

  /// No description provided for @data_protection_label.
  ///
  /// In en, this message translates to:
  /// **'8. Data Protection Obligations'**
  String get data_protection_label;

  /// No description provided for @data_protection_desc.
  ///
  /// In en, this message translates to:
  /// **'CCP is committed to compliance with the Personal Data Protection Act 2010. All personal data will be processed in accordance with CCP’s Privacy Notice, which forms an integral part of these Terms. By registering or continuing use of the Service, the Customer consents to such processing and disclosure of data as required for service provision.'**
  String get data_protection_desc;

  /// No description provided for @disclaimer_label.
  ///
  /// In en, this message translates to:
  /// **'9. Disclaimer'**
  String get disclaimer_label;

  /// No description provided for @disclaimer_1.
  ///
  /// In en, this message translates to:
  /// **'All content within the CCP System is protected by copyright © CityCarPark 2016–2025. Reproduction or distribution is prohibited without written consent.'**
  String get disclaimer_1;

  /// No description provided for @disclaimer_2.
  ///
  /// In en, this message translates to:
  /// **'“CCP” and associated marks are registered trademarks of CityCarPark. Other product names are trademarks of their respective owners.'**
  String get disclaimer_2;

  /// No description provided for @disclaimer_3.
  ///
  /// In en, this message translates to:
  /// **'Information is provided “as is” without warranties of accuracy, completeness, or fitness for purpose.'**
  String get disclaimer_3;

  /// No description provided for @disclaimer_4.
  ///
  /// In en, this message translates to:
  /// **'CCP is not responsible for third-party content or external websites linked through its system.'**
  String get disclaimer_4;

  /// No description provided for @disclaimer_5.
  ///
  /// In en, this message translates to:
  /// **'CCP shall not be liable for damages (direct, indirect, or consequential) resulting from use of its Services.'**
  String get disclaimer_5;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @introduction_label.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get introduction_label;

  /// No description provided for @introduction_desc.
  ///
  /// In en, this message translates to:
  /// **'This Privacy Data Notice is issued to inform you that your personal information is being collected and processed by, or on behalf of, CityCarPark (hereinafter referred to as “CCP,” “we”, “our”, or “us”). For the purposes of this Notice, the terms “personal data” and “processing” shall carry the definitions provided under the Personal Data Protection Act 2010 (PDPA).'**
  String get introduction_desc;

  /// No description provided for @categories_label.
  ///
  /// In en, this message translates to:
  /// **'2. Categories of Personal Data Collected'**
  String get categories_label;

  /// No description provided for @categories_desc.
  ///
  /// In en, this message translates to:
  /// **'CCP collects only such personal information as is necessary for the proper administration of our services and for the fulfilment of legitimate business purposes. The categories of personal data we may obtain include, but are not limited to:'**
  String get categories_desc;

  /// No description provided for @identification_label.
  ///
  /// In en, this message translates to:
  /// **'Identification and contact details:'**
  String get identification_label;

  /// No description provided for @identification_desc.
  ///
  /// In en, this message translates to:
  /// **'Full name, date of birth, national identification number or passport number (including copies, where necessary), e-mail address, telephone number, and, where relevant, bank account or payment card details.'**
  String get identification_desc;

  /// No description provided for @transaction_label.
  ///
  /// In en, this message translates to:
  /// **'Transactional information:'**
  String get transaction_label;

  /// No description provided for @transaction_desc.
  ///
  /// In en, this message translates to:
  /// **'Records of parking payments, token top-ups, and other transactions undertaken through our digital or physical platforms.'**
  String get transaction_desc;

  /// No description provided for @digital_label.
  ///
  /// In en, this message translates to:
  /// **'Digital interaction data:'**
  String get digital_label;

  /// No description provided for @digital_desc.
  ///
  /// In en, this message translates to:
  /// **'Information gathered from your use of our mobile applications, websites, and online platforms (including referring websites, browsing behaviour, content accessed, duration of visits, and analytical data from tools such as Google Analytics).'**
  String get digital_desc;

  /// No description provided for @feedback_label.
  ///
  /// In en, this message translates to:
  /// **'Feedback and communications:'**
  String get feedback_label;

  /// No description provided for @feedback_desc.
  ///
  /// In en, this message translates to:
  /// **'Responses submitted via feedback forms, surveys, or customer support interactions.'**
  String get feedback_desc;

  /// No description provided for @marketing_label.
  ///
  /// In en, this message translates to:
  /// **'Marketing and promotional data:'**
  String get marketing_label;

  /// No description provided for @marketing_desc.
  ///
  /// In en, this message translates to:
  /// **'Details provided during participation in campaigns, contests, loyalty programmes, or partnerships undertaken by CCP or its authorised affiliates.'**
  String get marketing_desc;

  /// No description provided for @third_party_label.
  ///
  /// In en, this message translates to:
  /// **'Third-party information:'**
  String get third_party_label;

  /// No description provided for @third_party_desc.
  ///
  /// In en, this message translates to:
  /// **'Personal data obtained from external sources such as financial institutions, credit reporting agencies, or other entities legally permitted to disclose such information.'**
  String get third_party_desc;

  /// No description provided for @purposes_label.
  ///
  /// In en, this message translates to:
  /// **'3. Purposes of Processing'**
  String get purposes_label;

  /// No description provided for @purposes_desc.
  ///
  /// In en, this message translates to:
  /// **'Your personal data may be processed for one or more of the following purposes:'**
  String get purposes_desc;

  /// No description provided for @account_service_label.
  ///
  /// In en, this message translates to:
  /// **'Account and service administration:'**
  String get account_service_label;

  /// No description provided for @account_service_desc.
  ///
  /// In en, this message translates to:
  /// **'Registering, verifying, and maintaining your account and identity'**
  String get account_service_desc;

  /// No description provided for @services_label.
  ///
  /// In en, this message translates to:
  /// **'Provision of services:'**
  String get services_label;

  /// No description provided for @services_desc.
  ///
  /// In en, this message translates to:
  /// **'Facilitating transactions, processing payments, issuing receipts, and maintaining records for financial, audit, and regulatory purposes.'**
  String get services_desc;

  /// No description provided for @regulatory_label.
  ///
  /// In en, this message translates to:
  /// **'Regulatory compliance:'**
  String get regulatory_label;

  /// No description provided for @regulatory_desc.
  ///
  /// In en, this message translates to:
  /// **'Fulfilling legal, anti-money laundering, and risk management obligations.'**
  String get regulatory_desc;

  /// No description provided for @communication_label.
  ///
  /// In en, this message translates to:
  /// **'Communication:'**
  String get communication_label;

  /// No description provided for @communication_desc.
  ///
  /// In en, this message translates to:
  /// **'Corresponding with you regarding enquiries, complaints, updates, or administrative notices.'**
  String get communication_desc;

  /// No description provided for @personalisation_label.
  ///
  /// In en, this message translates to:
  /// **'Personalisation:'**
  String get personalisation_label;

  /// No description provided for @personalisation_desc.
  ///
  /// In en, this message translates to:
  /// **'Enhancing user experience on our platforms, including targeted content, advertisements, and loyalty programmes.'**
  String get personalisation_desc;

  /// No description provided for @research_label.
  ///
  /// In en, this message translates to:
  /// **'Research and analytics:'**
  String get research_label;

  /// No description provided for @research_desc.
  ///
  /// In en, this message translates to:
  /// **'Conducting market surveys, customer profiling, statistical analysis, and service improvement studies.'**
  String get research_desc;

  /// No description provided for @marketing_outreach_label.
  ///
  /// In en, this message translates to:
  /// **'Marketing and outreach:'**
  String get marketing_outreach_label;

  /// No description provided for @marketing_outreach_desc.
  ///
  /// In en, this message translates to:
  /// **'Providing information about products, services, programmes, or promotional activities organised or sponsored by CCP or its affiliates.'**
  String get marketing_outreach_desc;

  /// No description provided for @data_management_label.
  ///
  /// In en, this message translates to:
  /// **'Data management:'**
  String get data_management_label;

  /// No description provided for @data_management_desc.
  ///
  /// In en, this message translates to:
  /// **'Storing, backing up, and securing data (whether locally or internationally) for operational continuity and disaster recovery.'**
  String get data_management_desc;

  /// No description provided for @legal_disclosure_label.
  ///
  /// In en, this message translates to:
  /// **'Legal disclosure:'**
  String get legal_disclosure_label;

  /// No description provided for @legal_disclosure_desc.
  ///
  /// In en, this message translates to:
  /// **'Complying with statutory, regulatory, or judicial requirements, or making disclosures mandated by law.'**
  String get legal_disclosure_desc;

  /// No description provided for @general_business_label.
  ///
  /// In en, this message translates to:
  /// **'General business purposes:'**
  String get general_business_label;

  /// No description provided for @general_business_desc.
  ///
  /// In en, this message translates to:
  /// **'Supporting the management, maintenance, and strategic development of CCP’s services.'**
  String get general_business_desc;

  /// No description provided for @sources_label.
  ///
  /// In en, this message translates to:
  /// **'4. Sources of Personal Data'**
  String get sources_label;

  /// No description provided for @sources_desc.
  ///
  /// In en, this message translates to:
  /// **'Your data may be collected directly from you through interactions such as:'**
  String get sources_desc;

  /// No description provided for @sources_account.
  ///
  /// In en, this message translates to:
  /// **'Account registration or subscription to services.'**
  String get sources_account;

  /// No description provided for @sources_events.
  ///
  /// In en, this message translates to:
  /// **'Participation in events, surveys, contests, or loyalty programmes.'**
  String get sources_events;

  /// No description provided for @sources_purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase of tokens, passes, or related services through CCP platforms.'**
  String get sources_purchase;

  /// No description provided for @sources_communications.
  ///
  /// In en, this message translates to:
  /// **'Communications with our customer service representatives.'**
  String get sources_communications;

  /// No description provided for @sources_feedback.
  ///
  /// In en, this message translates to:
  /// **'Submissions of feedback or complaints.'**
  String get sources_feedback;

  /// No description provided for @sources_third_party.
  ///
  /// In en, this message translates to:
  /// **'Additionally, CCP may obtain your information indirectly from authorised third parties, including business partners, subsidiaries, financial institutions, or public directories where you have provided consent.'**
  String get sources_third_party;

  /// No description provided for @data_subject_label.
  ///
  /// In en, this message translates to:
  /// **'5. Your Rights as a Data Subject'**
  String get data_subject_label;

  /// No description provided for @data_subject_desc.
  ///
  /// In en, this message translates to:
  /// **'Under the PDPA, you are entitled to exercise the following rights in respect of your personal data:'**
  String get data_subject_desc;

  /// No description provided for @right_access_label.
  ///
  /// In en, this message translates to:
  /// **'Access: '**
  String get right_access_label;

  /// No description provided for @right_access_desc.
  ///
  /// In en, this message translates to:
  /// **'to request confirmation and information about your personal data being processed (Section 30(2) PDPA).'**
  String get right_access_desc;

  /// No description provided for @right_correction_label.
  ///
  /// In en, this message translates to:
  /// **'Correction: '**
  String get right_correction_label;

  /// No description provided for @right_correction_right.
  ///
  /// In en, this message translates to:
  /// **'to request rectification of inaccurate, incomplete, or outdated information.'**
  String get right_correction_right;

  /// No description provided for @right_restriction_label.
  ///
  /// In en, this message translates to:
  /// **'Restriction: '**
  String get right_restriction_label;

  /// No description provided for @right_restriction_desc.
  ///
  /// In en, this message translates to:
  /// **'to limit the processing of your personal data under circumstances permitted by law.'**
  String get right_restriction_desc;

  /// No description provided for @right_withdrawal_label.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal: '**
  String get right_withdrawal_label;

  /// No description provided for @right_withdrawal_desc.
  ///
  /// In en, this message translates to:
  /// **'to opt out of receiving marketing or promotional communications by following the unsubscribe instructions provided in our correspondence.'**
  String get right_withdrawal_desc;

  /// No description provided for @right_deletion_label.
  ///
  /// In en, this message translates to:
  /// **'Deletion: '**
  String get right_deletion_label;

  /// No description provided for @right_deletion_desc.
  ///
  /// In en, this message translates to:
  /// **'to request removal of your data from our systems, subject to statutory exceptions.'**
  String get right_deletion_desc;

  /// No description provided for @data_requests_contact.
  ///
  /// In en, this message translates to:
  /// **'All requests or complaints should be submitted in writing to cs@citycarpark.my. Please note that CCP may lawfully refuse certain requests in circumstances permitted by the PDPA, and reasons for such refusal will be communicated within the statutory timeline.'**
  String get data_requests_contact;

  /// No description provided for @disclosure_label.
  ///
  /// In en, this message translates to:
  /// **'6. Disclosure of Data to Third Parties'**
  String get disclosure_label;

  /// No description provided for @disclosure_desc.
  ///
  /// In en, this message translates to:
  /// **'CCP may disclose your personal data to the following categories of recipients:'**
  String get disclosure_desc;

  /// No description provided for @disclosure_companies.
  ///
  /// In en, this message translates to:
  /// **'Companies within the CCP corporate group (including subsidiaries, related entities, and shareholders).'**
  String get disclosure_companies;

  /// No description provided for @disclosure_advisers.
  ///
  /// In en, this message translates to:
  /// **'Professional advisers, agents, contractors, service providers, vendors, and business partners.'**
  String get disclosure_advisers;

  /// No description provided for @disclosure_banks.
  ///
  /// In en, this message translates to:
  /// **'Banks, financial institutions, and insurance companies involved in facilitating transactions.'**
  String get disclosure_banks;

  /// No description provided for @disclosure_successors.
  ///
  /// In en, this message translates to:
  /// **'Successors or parties involved in corporate exercises, such as mergers, acquisitions, or restructuring.'**
  String get disclosure_successors;

  /// No description provided for @disclosure_government.
  ///
  /// In en, this message translates to:
  /// **'Government agencies, regulators, municipal councils, and statutory bodies, whether domestic or foreign, where legally required.'**
  String get disclosure_government;

  /// No description provided for @disclosure_confidential.
  ///
  /// In en, this message translates to:
  /// **'All third parties receiving your data will be expected to treat it as confidential and use it solely for legitimate purposes aligned with this Notice.'**
  String get disclosure_confidential;

  /// No description provided for @data_subjects_label.
  ///
  /// In en, this message translates to:
  /// **'7. Obligations of Data Subjects'**
  String get data_subjects_label;

  /// No description provided for @data_subjects_desc.
  ///
  /// In en, this message translates to:
  /// **'You are required to ensure that the personal data provided to CCP is complete, accurate, and up to date. Failure to supply such information may impede our ability to deliver services effectively. You are also expected to promptly update us regarding any changes to your personal data.'**
  String get data_subjects_desc;

  /// No description provided for @security_label.
  ///
  /// In en, this message translates to:
  /// **'8. Security of Personal Data'**
  String get security_label;

  /// No description provided for @security_desc.
  ///
  /// In en, this message translates to:
  /// **'CCP is committed to safeguarding personal data through appropriate administrative, technical, and physical security measures, including but not limited to encryption, firewalls, and secure socket layers. While we strive to ensure robust protection, we acknowledge that no system can guarantee absolute security. CCP shall not be held liable for unauthorised access or breaches beyond our reasonable control.'**
  String get security_desc;

  /// No description provided for @retention_label.
  ///
  /// In en, this message translates to:
  /// **'9. Retention of Data'**
  String get retention_label;

  /// No description provided for @retention_desc.
  ///
  /// In en, this message translates to:
  /// **'Your personal data will be retained only for as long as necessary to fulfil the purposes outlined in this Notice, or as required by applicable laws and regulations.'**
  String get retention_desc;

  /// No description provided for @amendments_label.
  ///
  /// In en, this message translates to:
  /// **'10. Amendments to this Notice'**
  String get amendments_label;

  /// No description provided for @amendments_desc.
  ///
  /// In en, this message translates to:
  /// **'CCP reserves the right to revise this Privacy Data Notice from time to time. Any amendments will be communicated via our mobile application or other communication channels deemed appropriate by CCP.'**
  String get amendments_desc;

  /// No description provided for @language_label.
  ///
  /// In en, this message translates to:
  /// **'11. Language and Interpretation'**
  String get language_label;

  /// No description provided for @language_desc.
  ///
  /// In en, this message translates to:
  /// **'In the event of discrepancies between the English version of this Notice and its Bahasa Malaysia counterpart, the English version shall prevail.'**
  String get language_desc;

  /// No description provided for @external_websites_label.
  ///
  /// In en, this message translates to:
  /// **'12. External Websites'**
  String get external_websites_label;

  /// No description provided for @external_websites_desc.
  ///
  /// In en, this message translates to:
  /// **'Where our platform contains links to third-party websites, please note that this Privacy Notice does not apply once you leave CCP’s digital environment. CCP does not control such websites and shall not be responsible for their privacy practices. Users are encouraged to review the privacy policies of external sites before providing personal data.'**
  String get external_websites_desc;

  /// No description provided for @describeIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue in detail..'**
  String get describeIssue;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message'**
  String get typeYourMessage;

  /// No description provided for @commonIssues.
  ///
  /// In en, this message translates to:
  /// **'Common Issues'**
  String get commonIssues;

  /// No description provided for @alreadyPaidNoTicket.
  ///
  /// In en, this message translates to:
  /// **'Already paid parking but no issue ticket'**
  String get alreadyPaidNoTicket;

  /// No description provided for @terminalOff.
  ///
  /// In en, this message translates to:
  /// **'Terminal off'**
  String get terminalOff;

  /// No description provided for @purchaseFailure.
  ///
  /// In en, this message translates to:
  /// **'Purchase failure'**
  String get purchaseFailure;

  /// No description provided for @appIssueSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'App issue submitted successfully'**
  String get appIssueSubmittedSuccessfully;

  /// No description provided for @submissionFailed.
  ///
  /// In en, this message translates to:
  /// **'Submission failed. Please try again.'**
  String get submissionFailed;

  /// No description provided for @vehicleBlocked.
  ///
  /// In en, this message translates to:
  /// **'Vehicle blocked'**
  String get vehicleBlocked;

  /// No description provided for @securityIssues.
  ///
  /// In en, this message translates to:
  /// **'Security issues'**
  String get securityIssues;

  /// No description provided for @cleanlinessProblems.
  ///
  /// In en, this message translates to:
  /// **'Cleanliness problems'**
  String get cleanlinessProblems;

  /// No description provided for @pleaseSelectIssue.
  ///
  /// In en, this message translates to:
  /// **'Please select an issue'**
  String get pleaseSelectIssue;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @selectedDate.
  ///
  /// In en, this message translates to:
  /// **'Selected Date'**
  String get selectedDate;

  /// No description provided for @name2.
  ///
  /// In en, this message translates to:
  /// **'Name:'**
  String get name2;

  /// No description provided for @date2.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get date2;

  /// No description provided for @time2.
  ///
  /// In en, this message translates to:
  /// **'Time:'**
  String get time2;

  /// No description provided for @email2.
  ///
  /// In en, this message translates to:
  /// **'Email:'**
  String get email2;

  /// No description provided for @description2.
  ///
  /// In en, this message translates to:
  /// **'Description:'**
  String get description2;

  /// No description provided for @total2.
  ///
  /// In en, this message translates to:
  /// **'Total:'**
  String get total2;

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agree;

  /// No description provided for @parkingAutoDeductTitle.
  ///
  /// In en, this message translates to:
  /// **'Parking Payment Will Be Deducted'**
  String get parkingAutoDeductTitle;

  /// No description provided for @parkingDescription.
  ///
  /// In en, this message translates to:
  /// **'An Enforcement Officer has entered this area.\nParking payment for vehicle {plateNumber} is required.'**
  String parkingDescription(Object plateNumber);

  /// No description provided for @validityPeriod.
  ///
  /// In en, this message translates to:
  /// **'Validity period: {time}'**
  String validityPeriod(Object time);

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @hoursValue.
  ///
  /// In en, this message translates to:
  /// **'{hours} Hour'**
  String hoursValue(Object hours);

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @amountValue.
  ///
  /// In en, this message translates to:
  /// **'RM {amount}'**
  String amountValue(Object amount);

  /// No description provided for @autoDeductInfo.
  ///
  /// In en, this message translates to:
  /// **'The payment amount will be calculated automatically and deducted from your token balance.\n\nPlease confirm within '**
  String get autoDeductInfo;

  /// No description provided for @autoDeductInfoBold.
  ///
  /// In en, this message translates to:
  /// **'2 minutes'**
  String get autoDeductInfoBold;

  /// No description provided for @autoDeductInfoSuffix.
  ///
  /// In en, this message translates to:
  /// **' to avoid penalty action.'**
  String get autoDeductInfoSuffix;

  /// No description provided for @parking_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Parking Confirmed'**
  String get parking_confirmed;

  /// No description provided for @parkingPaidMessage.
  ///
  /// In en, this message translates to:
  /// **'Parking payment for'**
  String get parkingPaidMessage;

  /// No description provided for @parkingPaidMessage1.
  ///
  /// In en, this message translates to:
  /// **'for vehicle {plate} has been successfully deducted from your token balance.'**
  String parkingPaidMessage1(Object plate);

  /// No description provided for @qrPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'QR Payment'**
  String get qrPaymentTitle;

  /// No description provided for @qrPaymentInstructions.
  ///
  /// In en, this message translates to:
  /// **'1. Please screenshot the QR.\n2. Open your banking app to make payment.\n3. Complete the payment within the given time.\n4. Do not close this screen.\n5. Return to the app after payment.'**
  String get qrPaymentInstructions;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Please select a payment method'**
  String get selectPaymentMethod;

  /// No description provided for @importantNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Important Notice'**
  String get importantNoticeTitle;

  /// No description provided for @reloadRedirectNotice.
  ///
  /// In en, this message translates to:
  /// **'You will be redirected to a 3rd party website for Reload Token. Please ensure the details above are accurate before proceeding.'**
  String get reloadRedirectNotice;

  /// No description provided for @insufficientBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Insufficient Token Balance'**
  String get insufficientBalanceTitle;

  /// No description provided for @insufficientBalanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Your token balance is insufficient to complete this payment.'**
  String get insufficientBalanceDesc;

  /// No description provided for @insufficientBalanceAction1.
  ///
  /// In en, this message translates to:
  /// **'Please tap'**
  String get insufficientBalanceAction1;

  /// No description provided for @insufficientBalanceAction2.
  ///
  /// In en, this message translates to:
  /// **' Top Up'**
  String get insufficientBalanceAction2;

  /// No description provided for @insufficientBalanceAction3.
  ///
  /// In en, this message translates to:
  /// **' to continue.'**
  String get insufficientBalanceAction3;

  /// No description provided for @topUp.
  ///
  /// In en, this message translates to:
  /// **'Top Up'**
  String get topUp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ms'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ms':
      return AppLocalizationsMs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
