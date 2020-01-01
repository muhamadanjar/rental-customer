const bool devMode = false;
const String apiURL = devMode == true ? "http://192.168.43.110/api":"http://utama-trans.com/new/api";
const double textScaleFactor = 1.0;
const google_android_api = 'AIzaSyAKl4qWeBABIDPoxo_CHvWuIfgkKoEzS7c';
const google_web_api = 'AIzaSyAyGT-CSg1nb0YBLihgn8vk9zfbbkk-f1c';


class RoutePaths {
  static const String Index = '/';
  static const String Login = 'login';
  static const String Register = 'register';
  static const String Help = 'help';
  static const String Dashboard = 'dashboard';
  static const String Home = 'home-page';
  static const String Settings = 'settings';
  static const String Payment = 'payment';
  static const String OrderComplete = 'order-complete-page';
  static const String MyTrip = 'my-trip';
  static const String TopUp = 'topup';
  static const String Promo = 'promo';
  static const String Rental = 'rental';
  static const String Forgot = 'forgot';
  static const String Legal = 'legal';
  static const String Profile = 'profile';
  static const String EditProfile = 'edit_profile';
  static const String Notifications = 'notifications';
  static const String ChangePassword = 'change_password';
  static const String ChangeProfile = 'change_profile';
  static const String Splash = 'splash';
}

class ResourceLink{
  static final baseUri = apiURL;
  static final loginUrl = baseUri + "/auth/login";
  static final registerUrl = baseUri + "/auth/register";
  static final logoutUrl = baseUri + "/auth/logout";
  static final updateLocation =  baseUri + "/user/update_position";
  static final getUser =  baseUri + "/auth/user";
  static final postUpdateStatus =  baseUri + "/user/changeonline";
  static final checkTrans =  baseUri + "/driver/checkjob";
  static final postBooking =  baseUri + "/booking";
  static final getPackage =  baseUri + "/rent_package";
  static final getPromo = baseUri + "/get_promo";
  static final getTypeCar = baseUri + "/type_car";
  static final getService = baseUri + "/get_servicetype";
  static final getBank = baseUri + "/get_bank";
  static final postRequestSaldo = baseUri + "/post_request_saldo";
  static final postUploadBukti = baseUri + "/post_upload_bukti";
}