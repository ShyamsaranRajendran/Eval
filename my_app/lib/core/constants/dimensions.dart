import 'package:flutter/material.dart';

// Standard dimensions and spacing
class AppDimensions {
  // Padding and Margins
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Margins (same as padding for consistency)
  static const double marginXS = paddingXS;
  static const double marginS = paddingS;
  static const double marginM = paddingM;
  static const double marginL = paddingL;
  static const double marginXL = paddingXL;
  static const double marginXXL = paddingXXL;

  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircular = 100.0;

  // Border Width
  static const double borderThin = 1.0;
  static const double borderMedium = 2.0;
  static const double borderThick = 4.0;

  // Icon Sizes
  static const double iconXS = 12.0;
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;

  // Avatar Sizes
  static const double avatarS = 32.0;
  static const double avatarM = 48.0;
  static const double avatarL = 64.0;
  static const double avatarXL = 96.0;

  // Button Heights
  static const double buttonHeightS = 32.0;
  static const double buttonHeightM = 44.0;
  static const double buttonHeightL = 56.0;

  // Input Field Heights
  static const double inputHeightS = 40.0;
  static const double inputHeightM = 48.0;
  static const double inputHeightL = 56.0;

  // Card and Container
  static const double cardElevation = 2.0;
  static const double cardMinHeight = 120.0;
  static const double containerMinHeight = 80.0;

  // List Items
  static const double listItemHeight = 72.0;
  static const double listItemHeightCompact = 56.0;
  static const double listItemHeightExpanded = 88.0;

  // App Bar
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 4.0;

  // Drawer
  static const double drawerWidth = 280.0;

  // Divider
  static const double dividerHeight = 1.0;
  static const double dividerThickness = 0.5;

  // Bottom Navigation
  static const double bottomNavHeight = 60.0;

  // Floating Action Button
  static const double fabSize = 56.0;
  static const double fabSizeSmall = 40.0;

  // Progress Indicators
  static const double progressIndicatorSize = 24.0;
  static const double progressIndicatorStroke = 3.0;

  // Chart Dimensions
  static const double chartHeight = 200.0;
  static const double chartHeightLarge = 300.0;
  static const double chartBarWidth = 20.0;

  // Content Width Constraints
  static const double maxContentWidth = 1200.0;
  static const double maxFormWidth = 600.0;
  static const double maxCardWidth = 400.0;

  // Screen Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
}

// EdgeInsets presets for common use cases
class AppPadding {
  static const EdgeInsets zero = EdgeInsets.zero;

  // Symmetric padding
  static const EdgeInsets horizontalXS = EdgeInsets.symmetric(
    horizontal: AppDimensions.paddingXS,
  );
  static const EdgeInsets horizontalS = EdgeInsets.symmetric(
    horizontal: AppDimensions.paddingS,
  );
  static const EdgeInsets horizontalM = EdgeInsets.symmetric(
    horizontal: AppDimensions.paddingM,
  );
  static const EdgeInsets horizontalL = EdgeInsets.symmetric(
    horizontal: AppDimensions.paddingL,
  );
  static const EdgeInsets horizontalXL = EdgeInsets.symmetric(
    horizontal: AppDimensions.paddingXL,
  );

  static const EdgeInsets verticalXS = EdgeInsets.symmetric(
    vertical: AppDimensions.paddingXS,
  );
  static const EdgeInsets verticalS = EdgeInsets.symmetric(
    vertical: AppDimensions.paddingS,
  );
  static const EdgeInsets verticalM = EdgeInsets.symmetric(
    vertical: AppDimensions.paddingM,
  );
  static const EdgeInsets verticalL = EdgeInsets.symmetric(
    vertical: AppDimensions.paddingL,
  );
  static const EdgeInsets verticalXL = EdgeInsets.symmetric(
    vertical: AppDimensions.paddingXL,
  );

  // All sides padding
  static const EdgeInsets allXS = EdgeInsets.all(AppDimensions.paddingXS);
  static const EdgeInsets allS = EdgeInsets.all(AppDimensions.paddingS);
  static const EdgeInsets allM = EdgeInsets.all(AppDimensions.paddingM);
  static const EdgeInsets allL = EdgeInsets.all(AppDimensions.paddingL);
  static const EdgeInsets allXL = EdgeInsets.all(AppDimensions.paddingXL);
  static const EdgeInsets allXXL = EdgeInsets.all(AppDimensions.paddingXXL);

  // Screen padding (safe area aware)
  static const EdgeInsets screen = EdgeInsets.all(AppDimensions.paddingM);
  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(
    horizontal: AppDimensions.paddingM,
  );
  static const EdgeInsets screenVertical = EdgeInsets.symmetric(
    vertical: AppDimensions.paddingM,
  );

  // Card content padding
  static const EdgeInsets card = EdgeInsets.all(AppDimensions.paddingM);
  static const EdgeInsets cardCompact = EdgeInsets.all(AppDimensions.paddingS);
  static const EdgeInsets cardExpanded = EdgeInsets.all(AppDimensions.paddingL);

  // List item padding
  static const EdgeInsets listItem = EdgeInsets.symmetric(
    horizontal: AppDimensions.paddingM,
    vertical: AppDimensions.paddingS,
  );
  static const EdgeInsets listItemExpanded = EdgeInsets.symmetric(
    horizontal: AppDimensions.paddingM,
    vertical: AppDimensions.paddingM,
  );

  // Form padding
  static const EdgeInsets form = EdgeInsets.all(AppDimensions.paddingL);
  static const EdgeInsets formField = EdgeInsets.symmetric(
    vertical: AppDimensions.paddingS,
  );

  // Dialog padding
  static const EdgeInsets dialog = EdgeInsets.all(AppDimensions.paddingL);
  static const EdgeInsets dialogTitle = EdgeInsets.fromLTRB(
    AppDimensions.paddingL,
    AppDimensions.paddingL,
    AppDimensions.paddingL,
    AppDimensions.paddingM,
  );
  static const EdgeInsets dialogContent = EdgeInsets.symmetric(
    horizontal: AppDimensions.paddingL,
  );
  static const EdgeInsets dialogActions = EdgeInsets.fromLTRB(
    AppDimensions.paddingL,
    AppDimensions.paddingM,
    AppDimensions.paddingL,
    AppDimensions.paddingL,
  );
}

// BorderRadius presets
class AppBorderRadius {
  static const BorderRadius none = BorderRadius.zero;

  static const BorderRadius xs = BorderRadius.all(
    Radius.circular(AppDimensions.radiusXS),
  );
  static const BorderRadius s = BorderRadius.all(
    Radius.circular(AppDimensions.radiusS),
  );
  static const BorderRadius m = BorderRadius.all(
    Radius.circular(AppDimensions.radiusM),
  );
  static const BorderRadius l = BorderRadius.all(
    Radius.circular(AppDimensions.radiusL),
  );
  static const BorderRadius xl = BorderRadius.all(
    Radius.circular(AppDimensions.radiusXL),
  );
  static const BorderRadius circular = BorderRadius.all(
    Radius.circular(AppDimensions.radiusCircular),
  );

  // Top only radius
  static const BorderRadius topS = BorderRadius.only(
    topLeft: Radius.circular(AppDimensions.radiusS),
    topRight: Radius.circular(AppDimensions.radiusS),
  );
  static const BorderRadius topM = BorderRadius.only(
    topLeft: Radius.circular(AppDimensions.radiusM),
    topRight: Radius.circular(AppDimensions.radiusM),
  );
  static const BorderRadius topL = BorderRadius.only(
    topLeft: Radius.circular(AppDimensions.radiusL),
    topRight: Radius.circular(AppDimensions.radiusL),
  );

  // Bottom only radius
  static const BorderRadius bottomS = BorderRadius.only(
    bottomLeft: Radius.circular(AppDimensions.radiusS),
    bottomRight: Radius.circular(AppDimensions.radiusS),
  );
  static const BorderRadius bottomM = BorderRadius.only(
    bottomLeft: Radius.circular(AppDimensions.radiusM),
    bottomRight: Radius.circular(AppDimensions.radiusM),
  );
  static const BorderRadius bottomL = BorderRadius.only(
    bottomLeft: Radius.circular(AppDimensions.radiusL),
    bottomRight: Radius.circular(AppDimensions.radiusL),
  );
}

// SizedBox presets for spacing
class AppSpacing {
  // Vertical spacing
  static const SizedBox verticalXS = SizedBox(height: AppDimensions.paddingXS);
  static const SizedBox verticalS = SizedBox(height: AppDimensions.paddingS);
  static const SizedBox verticalM = SizedBox(height: AppDimensions.paddingM);
  static const SizedBox verticalL = SizedBox(height: AppDimensions.paddingL);
  static const SizedBox verticalXL = SizedBox(height: AppDimensions.paddingXL);
  static const SizedBox verticalXXL = SizedBox(
    height: AppDimensions.paddingXXL,
  );

  // Horizontal spacing
  static const SizedBox horizontalXS = SizedBox(width: AppDimensions.paddingXS);
  static const SizedBox horizontalS = SizedBox(width: AppDimensions.paddingS);
  static const SizedBox horizontalM = SizedBox(width: AppDimensions.paddingM);
  static const SizedBox horizontalL = SizedBox(width: AppDimensions.paddingL);
  static const SizedBox horizontalXL = SizedBox(width: AppDimensions.paddingXL);
  static const SizedBox horizontalXXL = SizedBox(
    width: AppDimensions.paddingXXL,
  );
}

// Shadow presets
class AppShadows {
  static const List<BoxShadow> none = [];

  static const List<BoxShadow> small = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 2, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> large = [
    BoxShadow(color: Color(0x25000000), blurRadius: 8, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(color: Color(0x30000000), blurRadius: 16, offset: Offset(0, 8)),
  ];
}

// Responsive utilities
class ResponsiveUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppDimensions.mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppDimensions.mobileBreakpoint &&
        width < AppDimensions.desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppDimensions.desktopBreakpoint;
  }

  static double getResponsivePadding(BuildContext context) {
    if (isMobile(context)) return AppDimensions.paddingM;
    if (isTablet(context)) return AppDimensions.paddingL;
    return AppDimensions.paddingXL;
  }

  static int getResponsiveColumns(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }
}
