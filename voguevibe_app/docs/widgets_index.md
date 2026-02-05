# Project Widget Index

This file documents all reusable UI widget classes in the VogueVibe app.

---

## Navigation

---

### CustomFlexibleAppBar

**File:** lib/core/widgets/appbar.dart
**Type:** Widget (PreferredSizeWidget)
**Description:** Custom app bar with optional title, leading icon, and action image slots. Used as the main top navigation bar throughout the app.

---

### CustomBottomNavBar

**File:** lib/core/widgets/bottom_navigation_bar.dart
**Type:** StatefulWidget
**Description:** Responsive bottom navigation bar with 4 tabs (Home, Cart, Favorites, Profile). Handles selection state and notifies parent via callback.

---

## Buttons

---

### AppButton

**File:** lib/core/widgets/app_button.dart
**Type:** Widget
**Description:** Reusable elevated button with optional icon, customizable width/height, styled with app theme colors.

---

### PrimaryActionButton

**File:** lib/core/widgets/app_button.dart
**Type:** Widget
**Description:** Premium responsive CTA button with rounded aesthetic and responsive sizing (70% screen width). Main call-to-action button across the app.

---

## Inputs

---

### AuthTextField

**File:** lib/features/auth/presentation/widgets/auth_form_field.dart
**Type:** Widget
**Description:** Styled text field for authentication forms (Sign In/Sign Up). Supports password masking and responsive width constraints.

---

### AppTextField

**File:** lib/core/widgets/app_text_field.dart
**Type:** Widget
**Description:** Reusable styled text field widget for general form inputs.

---

## Containers

---

### GlassContainer

**File:** lib/core/widgets/glass_container.dart
**Type:** Widget
**Description:** Reusable glassmorphism container widget for frosted glass UI effects.

---

## Feedback

---

### LoadingIndicator

**File:** lib/core/widgets/loading_indicator.dart
**Type:** Widget
**Description:** Reusable loading indicator widget for async operations and loading states.

---

## Home Widgets

---

### SectionHeader

**File:** lib/features/home/presentation/widgets/section_header.dart
**Type:** Widget
**Description:** Section header widget for labeling content sections (Trending, Sale, New Arrivals, etc.).

---

### ProductCardWidget

**File:** lib/features/home/presentation/widgets/product_card.dart
**Type:** Widget
**Description:** Glassmorphism product card with image, name, price, favorite toggle button, and add-to-cart button. Used for displaying products in home grid.

---

### ProductCategorySection

**File:** lib/features/home/presentation/widgets/category_section.dart
**Type:** Widget
**Description:** Section container displaying a category title and a 2-column grid of ProductCardWidgets. Handles favorite and add-to-cart callbacks by index.

---

### ProductCardData

**File:** lib/features/home/presentation/widgets/category_section.dart
**Type:** Data Model
**Description:** Data class holding product information (imagePath, tooltip, name, price, isFavorite) for use with ProductCategorySection.

---

### CategorySelector

**File:** lib/features/home/presentation/widgets/category_selector.dart
**Type:** Widget
**Description:** Pill-shaped segmented control for switching between product categories (e.g., New, Trending, Future). Animated selection with responsive width.

---

### PromotionalCard

**File:** lib/features/home/presentation/widgets/offer_widget.dart
**Type:** Widget
**Description:** Promotional banner card with background image, gradient overlay, label text, headline, and action button. Used for offers and campaigns on the home page.

---

## Category Widgets

---

### CategoryCard

**File:** lib/features/categories/presentation/widgets/category_card.dart
**Type:** Widget
**Description:** Category card widget for displaying product categories.

---

## Product Widgets

---

### ProductImageGallery

**File:** lib/features/product/presentation/widgets/product_image_gallery.dart
**Type:** Widget
**Description:** Image gallery widget for displaying multiple product images with navigation.

---

### VariantSelector

**File:** lib/features/product/presentation/widgets/variant_selector.dart
**Type:** Widget
**Description:** Size/Color variant selector widget for product customization options.

---

### PriceTag

**File:** lib/features/product/presentation/widgets/price_tag.dart
**Type:** Widget
**Description:** Price display widget showing original and sale prices.

---

## Cart Widgets

---

### CartProductCard

**File:** lib/features/cart/presentation/widgets/cart_item_card.dart
**Type:** Widget
**Description:** Cart item card with product image, name, price, quantity controls (increase/decrease), and remove button. 80% screen width with glassmorphism styling.

---

### CartSummaryBar

**File:** lib/features/cart/presentation/widgets/cart_summary.dart
**Type:** Widget
**Description:** Bottom bar displaying total price and checkout button (AppButton). Glassmorphism styling with upward shadow and rounded top corners.

---

### QuantitySelector

**File:** lib/features/cart/presentation/widgets/quantity_selector.dart
**Type:** Widget
**Description:** Quantity increment/decrement widget for adjusting item quantities.

---

## Favorites Widgets

---

### FavoriteItemCard

**File:** lib/features/favorites/presentation/widgets/favorite_item_card.dart
**Type:** Widget
**Description:** Favorite item card widget for displaying saved/wishlisted products.

---

## Checkout Widgets

---

### OrderSummarySection

**File:** lib/features/checkout/presentation/widgets/order_summary_card.dart
**Type:** Widget
**Description:** Glassmorphism order summary card showing products list, subtotal, shipping, and total. Used on checkout screen before payment.

---

### ProductModel

**File:** lib/features/checkout/presentation/widgets/order_summary_card.dart
**Type:** Data Model
**Description:** Data class for checkout products (image, name, quantity, price) used by OrderSummarySection.

---

## Profile Widgets

---

### ProfileHeader

**File:** lib/features/profile/presentation/widgets/profile_header.dart
**Type:** Widget
**Description:** Profile header widget displaying user avatar, name, and email.

---

### ProfileMenuItem

**File:** lib/features/profile/presentation/widgets/profile_menu_item.dart
**Type:** Widget
**Description:** Profile menu item widget for navigation options in the profile screen.

---

### OrderHistoryCard

**File:** lib/features/profile/presentation/widgets/order_history_card.dart
**Type:** Widget
**Description:** Order history item card widget for displaying past orders.

---
