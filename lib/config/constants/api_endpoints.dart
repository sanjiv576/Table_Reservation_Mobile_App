// api connection
class ApiEndpoints {
  static const Duration connectionTimeout = Duration(seconds: 2000);
  static const Duration receiveTimeout = Duration(seconds: 2000);

// for android
  static const String baseUrl = "http://10.0.2.2:3004";

  // for android  mobile--> ip address win
  // static const String baseUrl = "http://192.168.1.65:3004";

  // college ip address
  // static const String baseUrl = "http://192.168.137.1:3004";



  // ----------------- Auth Routes = 6 -----------------
  static const String login = "/users/login";
  static const String register = "/users/register";
  static const String logout = "/users/logout";
  // GET, PUT, DELETE in /users/:userId
  static const String getUserAccount = "/users/";
  static const String updateUserAccount = "/users/";
  static const String deleteUserAccount = "/users/";
  // GET all users' reviews
  static const String getAllUserReviews = '/users/reviews';

  // ----------------- Restaurant Routes  = 24 -----------------
  static const String getAllRestaurants = "/restaurants";
  static const String createARestaurant = "/restaurants";
  static const String getARestaurantById = "/restaurants/";
  static const String updateRestaurantById = "/restaurants/";
  static const String deleteARestaurantById = "/restaurants/";

  // --------------------- Reviews -------------------
  // GET, POST reviews by restaurantId i.e /restaurants/:restaurantId/reviews
  static const String getAllReviewsByRestaurantId = "/restaurants/";
  static const String createAReviewByRestaurantId = "/restaurants/";
  // GET, PUT, DELETE a review by restaurantId i.e /restaurants/:restaurantId/reviews/:reviewId
  static const String getAReviewByRestaurantId = "/restaurants/";
  static const String updateAReviewByRestaurantId = "/restaurants/";
  static const String deleteAReviewByRestaurantId = "/restaurants/";

  // --------------------- Food Menu -------------------
  // GET, POST in /restaurants/:restaurantId/menu
  static const String getFoodMenu = "/restaurants/";
  static const String createAFoodItem = "/restaurants/";
  // GET, PUT, DELETE /:restaurantId/menu/:foodItemId
  static const String getAFoodItem = "/restaurants/";
  static const String updateAFoodItem = "/restaurants/";
  static const String deleteAFoodItem = "/restaurants/";

  // --------------------- Food Order -------------------
// GET, POST in /:restaurantId/foodOrder
  static const String getAllFoodOrders = "/restaurants/";
  static const String createAFoodOrder = "/restaurants/";
// GET, PUT, DELETE in /:restaurantId/foodOrder/:foodOrderId
  static const String getAFoodOrder = "/restaurants/";
  static const String updateAFoodOrder = "/restaurants/";
  static const String deleteAFoodOrder = "/restaurants/";

  // --------------------- Add to Favorite -------------------
// GET, POST in /:restaurantId/favorite
  static const String getAllFavorites = "/restaurants/getAll/favorite";
  static const String createFavorite = "/restaurants/";
// GET, DELETE in /:restaurantId/favorite/:favoriteId
  static const String getAFavorite = "/restaurants/";
  static const String deleteAFavorite = "/restaurants/";

  // ----------------- Reservation Routes  = 6 -----------------
  static const String getAllReservationsByCustomer =
      "/reservations"; // by customer only

  // GET, PUT, DELETE in /reservations/:reservationId ==> by customer only
  static const String getAReservation = "/reservations/";
  static const String updateAReservation = "/reservations/";
  static const String deleteAReservation = "/reservations/";

  // GET, POST in /reservations/user/:restaurantId
  static const String createReservation = "/reservations/user/";
  static const String getAllReservationsByOwner = "/reservations/user/";

  // ----------------- Upload Image Routes = 1  -----------------
  static const String uploadImage = "/uploads";
  // Note: below end point we send image id as a header
  // static const String imageUrl = "http://10.0.2.2:3004/uploads/";
  static const String imageUrl = "$baseUrl/uploads/";
}
