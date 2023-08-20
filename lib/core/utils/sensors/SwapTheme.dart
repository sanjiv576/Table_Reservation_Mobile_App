class SwapThem {
  static int counter = 0;

  static bool turnDarkMode({required bool isDark, required double x}) {
    if (x > 1) {
      // print('Crossed x range');
      counter++;
      if (counter > 2) {
        //reset
        counter = 0;
        // swap the dark/light mode
        isDark ? false : true;
      }
    }
    return isDark;
  }
}
