class Images {
  static const String Intro1 = "assets/images/intro_1.png";
  static const String Intro2 = "assets/images/intro_2.png";
  static const String Intro3 = "assets/images/intro_3.png";
  static const String Logo = "assets/images/logo.png";

  static const String Broadcast = "assets/images/broadcast.png";
  static const String Chat = "assets/images/chat.png";
  static const String Intersect = "assets/images/intersect.png";

  ///Lottie
  static const String Writting = "assets/lottie/writing.json";
  static const String Watermelon = "assets/lottie/watermelon.json";
  static const String Network = "assets/lottie/network.json";
  static const String Loading = "assets/lottie/loading.json";
  static const String LoadingCircle = "assets/lottie/loading_circle_color.json";

  //SVG
  // static const String Astrounot = "assets/svg/astronot.svg";
  static const String Calendar = "assets/svg/calendar.svg";
  static const String Document = "assets/svg/document.svg";
  // static const String Dream = "assets/svg/dream.svg";
  static const String Error = "assets/svg/error.svg";
  // static const String Info = "assets/svg/info.svg";
  // static const String Repair = "assets/svg/repair.svg";
  // static const String Search = "assets/svg/search.svg";
  // static const String Setting = "assets/svg/setting.svg";
  static const String Warning = "assets/svg/warning.svg";
  // static const String Working = "assets/svg/working.svg";
  // static const String BeforeDawn = "assets/svg/before_dawn.svg";
  // static const String Buffer = "assets/svg/buffer.svg";
  // static const String BugFixing = "assets/svg/bug_fixing.svg";
  // static const String Collecting = "assets/svg/collecting.svg";
  static const String ForgotPassword = "assets/svg/forgot_passwod.svg";
  static const String Security = "assets/svg/security.svg";
  // static const String LocationSearch = "assets/svg/location_search.svg";
  // static const String Monitor = "assets/svg/monitor.svg";
  // static const String Moonlight = "assets/svg/moonlight.svg";
  static const String PageNotFound = "assets/svg/page_bot_found.svg";
  // static const String Relaunch = "assets/svg/relaunch.svg";
  // static const String ServerDown = "assets/svg/server_down.svg";
  // static const String AddFiles = "assets/svg/add_files.svg";
  // static const String Beer = "assets/svg/beer.svg";
  // static const String SocialGirl = "assets/svg/social_girl.svg";
  // static const String Watch = "assets/svg/watch.svg";
  // static const String Wellcome = "assets/svg/welcome.svg";
  // static const String Reading = "assets/svg/reading.svg";
  // static const String ServerStatus = "assets/svg/server_status.svg";

  static const String ImageBg = "assets/images/image_bg.png";
  static const String ImageError = "assets/images/image_error.png";

  static const String LogoutConfirmation = "assets/svg/logout_confirm.svg";
  static const String NoConnection = "assets/svg/no_connection.svg";
  static const String NoConnection2 = "assets/svg/no_connection2.svg";
  static const String Update = "assets/svg/update.svg";
  static const String LogoutConfirm = "assets/svg/logout_confirm.svg";
  static const String Empty = "assets/svg/empty.svg";

  ///Singleton factory
  static final Images _instance = Images._internal();

  factory Images() {
    return _instance;
  }

  Images._internal();
}
