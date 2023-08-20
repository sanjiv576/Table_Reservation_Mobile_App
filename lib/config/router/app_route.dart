import '../../check_internet.dart';
import '../../features/auth/presentation/view/customer_profile_view.dart';
import '../../features/auth/presentation/view/owner_review_view.dart';
import '../../features/auth/presentation/view/sign_in_view.dart';
import '../../features/auth/presentation/view/sign_up_view.dart';
import '../../features/customer_dashboard/presentation/view/bottom_navigation_view.dart';
import '../../features/customer_dashboard/presentation/view/customer_dashboard_view.dart';
import '../../features/food_menu/presentation/view/customer_food_menu_view.dart';
import '../../features/food_menu/presentation/view/owner_add_menu_view.dart';
import '../../features/food_order/presentation/view/customer_food_order_view.dart';
import '../../features/food_order/presentation/view/food_order_view.dart';
import '../../features/food_order/presentation/view/owner_food_order_view.dart';
import '../../features/food_order/presentation/view/owner_individual_order_view.dart';
import '../../features/intro/presentation/view/intro_view.dart';
import '../../features/owner_dashboard/presentation/view/owner_dashboard_view.dart';
import '../../features/password_recovery/presentation/view/password_recovery_view.dart';
import '../../features/reservation/presentation/view/customer_confirmation_view.dart';
import '../../features/reservation/presentation/view/customer_reservation_history_view.dart';
import '../../features/reservation/presentation/view/customer_reservation_view.dart';
import '../../features/reservation/presentation/view/owner_reservation_request_view.dart';
import '../../features/reservation/presentation/view/owner_reservation_view.dart';
import '../../features/restaurant/presentation/view/customer_favorite_view.dart';
import '../../features/restaurant/presentation/view/owner_profile_view.dart';
import '../../features/restaurant/presentation/view/restaurant_fill_details_view.dart';
import '../../features/restaurant/presentation/view/restaurant_view.dart';
import '../../features/splash/presentation/view/splash_view.dart';
import '../../features/user_verification/presentation/view/user_verification_view.dart';

class AppRoute {
  AppRoute._();

  static const String signUpRoute = '/signUp';
  static const String signInRoute = '/signIn';
  static const String userVerificationRoute = '/userVerification';
  static const String introductionRoute = '/introduction';
  static const String splashRoute = '/splash';
  static const String ownerDashboardRoute = '/ownerDashboard';
  static const String fillRestaurantDetailsRoute = '/fillRestaurantDetails';
  static const String ownerProfileRoute = '/ownerProfile';
  static const String ownerReviewRoute = '/ownerReview';
  static const String ownerReservationRoute = '/ownerReservation';
  static const String ownerReservationRequestRoute = '/ownerReservationRequest';
  static const String passwordRecoveryRoute = '/passwordRecovery';
  static const String ownerFoodOrderRoute = '/ownerFoodOrder';
  static const String ownerIndividualOrderRoute = '/ownerIndividualOrder';
  static const String customerDashboardRoute = '/customerDashboard';
  static const String navigationRoute = '/navigation';
  static const String customerReservationRoute = '/customerReservation';
  static const String restaurantRoute = '/restaurant';
  static const String customerProfileRoute = '/customerProfile';
  static const String customerReservationHistoryRoute =
      '/customerReservationHistory';
  static const String customerFavoriteRoute = '/customerFavorite';
  static const String customerConfirmationViewRoute =
      '/customerConfirmationView';

  static const String ownerAddMenuViewRoute = '/ownerAddMenuView';
  static const String customerFoodOrderRoute = '/customerFoodOrder';
  static const String internetRoute = '/internet';
  static const String foodOrderRoute = '/foodOrderRoute';
  static const String customerFoodMenuViewRoute = '/foodMenuView';

  static getApplicaionRoute() {
    return {
      signUpRoute: (context) => const SignUpView(),
      signInRoute: (context) => const SignInView(),
      userVerificationRoute: (context) => const UserVerificationView(),
      introductionRoute: (context) => IntroView(),
      splashRoute: (context) => const SplashView(),
      ownerDashboardRoute: (context) => OwnerDashboardView(),
      fillRestaurantDetailsRoute: (context) =>
          const RestaurantFillDetailsView(),
      ownerProfileRoute: (context) => const OwnerProfileView(),
      ownerReviewRoute: (context) => const OwnerReviewView(),
      ownerReservationRoute: (context) => OwnerReservationView(),
      ownerReservationRequestRoute: (context) =>
          const OwnerReservationRequestView(),
      passwordRecoveryRoute: (context) => const PasswordRecoveryView(),
      ownerFoodOrderRoute: (context) => OwnerFoodOrderView(),
      ownerIndividualOrderRoute: (context) => OwnerIndividalOrderView(),
      customerDashboardRoute: (context) => const CustomerDashboardView(),
      navigationRoute: (context) => const BottomNavigationView(),
      customerReservationRoute: (context) => const CustomerReservationView(),
      restaurantRoute: (context) => const RestaurantView(),
      customerProfileRoute: (context) => const CustomerProfileView(),
      customerReservationHistoryRoute: (context) =>
          CustomerReservationHistoryView(),
      customerFavoriteRoute: (context) => const CustomerFavoriteView(),
      customerConfirmationViewRoute: (context) =>
          const CustomerConfirmationView(),
      ownerAddMenuViewRoute: (context) => const OwnerAddMenuView(),
      customerFoodOrderRoute: (context) => const CustomerFoodOrderView(),
      internetRoute: (context) => const InternetCheck(),
      foodOrderRoute: (context) => const FoodOrderView(),
      customerFoodMenuViewRoute: (context) => CustomerFoodMenuView(),
    };
  }
}
