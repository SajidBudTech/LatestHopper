class Api {

  // static const baseUrl = "https://food.thesnaptask.com/api";
  // static const baseUrl = "http://test.thelifeshaper.com/api";

   //static const LIVE URL  = "https://abantuaudio.com/flutter/app";
     static const baseUrl = "https://abantuaudio.com/flutter/app";
 // static const baseUrl = "https://173db198c876.ngrok.io/ayurveda_new/public/api";

  static const login = "/login";
  static const loginSocial = "/login/social";
  static const register = "/register";
  static const otp = "/otp";
  static const logout = "/logout";
  static const forgotPassword = "/forgot";

  static const changePassword = "/password/change";
  static const updateProfile = "/user/update";


  static const newReleases = "/new-releases";
  static const bestSeller = "/best-sellers";
  static const abantuFavorites = "/abantu-favorites";
  static const bookDetails = "/books";
  static const discoverCategories = "/genres";
  static const discoverPage= "/discover-art";
  static const library = "/purchased-books";
  static const wishlist = "/wishlist";
  static const addToWishlist = "/add-to-wishlist";
  static const removeWishlist = "/remove-from-wishlist";

  static const categoryProduct = "/products";
  static const productByCategory = "/products_by_category";
  static const deliveryAddress = "/delivery/addresses";

  static const faq = "/faq";

  static const defaultDeliveryAddress = "/default/delivery/address";

  static const paymentOptions = "/payment/options";

  static const initiateCheckout = "/checkout/initiate";
  static const finalizecheckout = "/checkout/finalize";

  static const orders = "/orders";
  static const subscriptionUpdate = "/subscriptions";
  static const doctorFeesUpdate = "/update-appointment";
  static const orderUpdate = '/order/status/update';

  static const coupons = "/coupons";

  static const notification = "/notifications";


  // Updates .....

  static const phoneValidation = "/phone/verify";
  static const otpLogin = "/phone/login";


  static const fcmServer = 'https://fcm.googleapis.com/fcm/send';

  static const wallet = "/wallet";


  // Docotors Apis........

     static const doctors = "/doctors";
     static const doctorCategoryWise = "/doctor";
     static const doctorSpecilityWise = "/doctor-speciality";
     static const doctorsBanner = "/doctor-banners";

     static const doctorsCategories = "/doctor-categories";
     static const doctorSpecialities = "/doctor-specialities";
     static const bookAppointment = "/book-appointment";
     static const doctorAppointmentDateWise = "/doctor-by-date";
     static const userAppointmentList = "/user-appointments";

     static const subscriptionDetails = "/subscriptions";
     static const checkoutSubscription = "/subscriptions";
     static const subscriptionBenefits = "/subscription-benefits";
     static const checksubscription = "/check-subscription";



}
