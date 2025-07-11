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

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

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
  /// **'Forget Password'**
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
