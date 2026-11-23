# Changes Overview

This file explains, in general terms, what was changed in the app and why, so you can keep track of the work. It covers four rounds of work:

1. **Completing the screens and connecting them to the real backend** (from the design)
2. **Making the whole app work well on foldable phones**
3. **Fixing the Register form and verifying the whole app on a real foldable emulator**
4. **Making Sign up work and verifying the signed-in screens on a real account**

---

## Part 1 — Screens connected to the real API

### What the app can do now

| Screen | What it does |
|---|---|
| **Home** | Search, promo banner, categories, best sellers, brands. Tapping a category or brand opens its products. "view all" opens the Categories tab or the full best-seller list. |
| **Categories** (the "Men" / "Women" frames in the design) | A list of categories on the left; the selected category's banner and subcategories on the right. Tapping either opens the product list. |
| **Product List** | Products filtered by category, subcategory, brand, or search word. Sort by price, best selling, or top rated. More products load automatically as you scroll. |
| **Product Details** | Images, price (with old price crossed out when discounted), rating, sold count, description, quantity picker, total price, add to cart, add to wishlist, "Out of stock" when unavailable. |
| **Cart** | Your real cart: change quantities, remove items, see the total, and check out (cash on delivery to your first saved address). |
| **Wishlist** | Your saved products: remove them or add them to the cart. Pull down to refresh. |
| **Account** | Shows who is signed in. Edit name, e-mail, mobile, password, and address. Log out. |

Every screen that loads data shows a **loading** spinner, an **error** message with a Retry button, an **empty** message when there is nothing to show, and the content when it succeeds.

The heart (wishlist) and the add-to-cart buttons behave the same on every screen, and a short message ("Added to cart", "Removed from wishlist", or an error) appears wherever you are.

### Where the data comes from

All data comes from your Postman collection **"Route E-commerce App"** (`https://ecommerce.routemisr.com`). No product data is hard-coded and no endpoints were invented.

- **Public** (no login needed): categories, subcategories, brands, products, product details.
- **Signed-in** (sent with your login token automatically): cart, wishlist, profile update, password change, addresses, orders.

The login token is attached automatically by one central piece of code (`api/dio/auth_interceptor.dart`) only to the endpoints that need it, so screens never handle the token themselves.

### What the backend does not provide (so the app does not fake it)

- **Sizes and colours** — products have no such data, so those pickers were removed from Product Details.
- **Subcategory pictures** — the API has none, so a neutral icon tile is shown.
- **"Subcategories of a category"** — the endpoint returns all subcategories regardless, so the app filters them itself.
- **Promotions** — no endpoint; the existing banner images stay.
- **Search** — the API's `keyword` filter returns nothing for any word (checked on the live server). The app therefore searches product titles itself (see Part 3).
- **"Get my profile"** — no endpoint; your name/e-mail are remembered from login. Users logged in *before* this update see an empty name until they log in again.
- **Card checkout** — needs a browser plugin the project doesn't have; checkout is cash on delivery.

### How the code is organised (unchanged style, extended)

The project's existing structure from `flutterSkill.md` was followed. A user action travels through the layers in this order:

```
Screen → ViewModel (Cubit) → Use case → Repository → Data source → API (Retrofit/Dio)
```

- **Screens** only draw things and pass taps to their ViewModel.
- **ViewModels** hold the screen's state (loading / error / empty / success).
- **Use cases** are one action each (e.g. "add to cart").
- **Repositories / data sources** talk to the API and turn server data into app data.

Cart and wishlist ViewModels are shared by the whole app, so a heart tapped on the product list also shows as filled on the details screen and in the Wishlist tab.

### Bugs fixed along the way

- **Error messages never appeared before.** Network errors crashed silently and screens stayed on the loading spinner forever. The error handling (`api/dio/dio_interceptor.dart` and the data sources) was fixed so errors now reach the screen with a Retry button.
- **Generated API code didn't compile** after regeneration because two package versions were out of step. `retrofit` is now limited to `>=4.7.2 <4.9.0` in `pubspec.yaml`.
- **Your login token was printed in request logs** in every build. Request logging now runs only in debug builds.
- **Product Details price row** would have crashed at runtime in one layout; fixed.

---

## Part 2 — Foldable phone support

Foldables change size while the app is open: a narrow **cover screen** when folded, a wide almost-square **inner screen** when unfolded, plus landscape and split-screen. The app now adapts to whatever space it is given instead of assuming one phone size.

### 1. Sizes no longer blow up or shrink

The app scales everything from a phone-sized design (430 × 932) using `flutter_screenutil`. On an unfolded foldable that would have made every button, image, and text about **twice as big**, and in landscape heights would shrink to about **40%**.

Now the scaling is **capped between 85% and 115%** of the design (`core/utils/app_layout.dart`, used in `main.dart`). Extra space on big screens is used by the layouts below instead of by giant components. This updates live when you fold or unfold.

### 2. Navigation moves to the side on wide screens

| Folded (narrow) | Unfolded / landscape (wide) |
|---|---|
| Bottom navigation bar (as in the design) | Navigation rail on the left side |

This is decided in one place (`widgets/adaptive_navigation_shell.dart`), using Material 3 width breakpoints (compact < 600, medium < 840, expanded < 1200 …). The current tab, its scroll position, and selections (e.g. the chosen category) are kept when you fold or unfold — this was broken at first and fixed in Part 3. Navigation buttons now also have names for screen readers ("Home", "Categories", "Wishlist", "Account").

### 3. Screens use the extra space sensibly

| Screen | On a wide (unfolded) screen |
|---|---|
| **Product Details** | **Two panes**: images on one half, details and "Add to cart" on the other. If the phone has a fold or hinge down the middle, the split lands exactly on it so nothing is cut in half. |
| **Product List** | More columns of products appear automatically. |
| **Categories** | More subcategory columns appear automatically. |
| **Home** | Content is centred with a comfortable maximum width; the banner stops growing taller. |
| **Cart, Wishlist** | Centred list with a readable maximum width instead of stretched rows. |
| **Account, Login, Register** | Centred form width instead of stretching edge to edge. |

### 4. Hinges and half-opened folds

Some devices have a physical gap (hinge) between two panels, or are used half-opened like a book.

- Two-pane screens split **on the hinge**, one pane per side.
- Single-pane screens that would sit **under a physical hinge** are moved to one side of it.
- Dialogs (e.g. editing your profile) already avoid the hinge automatically.

(`widgets/adaptive_two_pane.dart` and `widgets/responsive_center.dart`.)

### 5. Nothing gets cut off on the small cover screen

- **Register** screen now scrolls (it used to overflow in landscape / on short screens).
- **Cart and Wishlist rows** grow with their content instead of having a fixed height, and their price + button wrap onto a second line when there isn't room (narrow cover screen or large system text).
- **"Sold" pill** and **home banner** no longer use fixed sizes.
- The app does **not** lock orientation, and Android is already configured not to restart the screen when folding (`AndroidManifest.xml` was checked; no change needed).

### How this was checked

Automated tests simulate real foldable shapes (`test/foldable/foldable_layout_test.dart`):

- Folded cover screen (360 × 780), folded landscape (780 × 360), unfolded (884 × 1000) with a centre fold, and a two-panel device with a 34 dp hinge.
- Normal and 1.5× text size.
- They check: the right navigation appears, panes split on the fold/hinge, content avoids the hinge, widths are capped, and **no layout overflows**.

These tests caught a real overflow on the cover screen with large text, which was fixed.

The app was then run on a real foldable emulator — see Part 3.

---

## Part 3 — Register fix and full verification on a foldable

### Register form fixed

All four Register fields (name, mobile, e-mail, password) were connected to the **same** text controller, so typing in one field showed the same text in all of them. Each field now has its own controller. The screen also owns and cleans up its controllers properly, so typed text is no longer lost when the screen rebuilds (for example when folding or unfolding). The phone and e-mail fields now open the matching keyboard.

The "Sign up" button was made to work in Part 4.

### How the whole app was verified

Everything was tested on a **Pixel 10 Pro Fold** Android emulator, using the **real backend**, in all three physical postures:

| Posture | Window | Result |
|---|---|---|
| Unfolded (flat) | 852 × 883, fold down the middle | All tests pass |
| Folded (cover screen) | 443 × 970 | All tests pass |
| Half-opened (book) | 852 × 883, half-opened fold | All tests pass |

The on-device tests (`integration_test/app_flow_test.dart`) drive the real app like a user would: Home → category → product list → loading the 2nd page → sorting by price → product details → quantity and total → Categories tab → subcategory → search → Wishlist and Account, plus Login → Register. They also check the right navigation appears for each posture and that the details screen splits exactly on the fold.

Each screen was also **photographed folded and unfolded, folding the device while the app was running**, and the pictures were reviewed by eye.

Only screens that work without logging in were tested in this round. The signed-in screens were verified in Part 4.

### Bugs found by this verification, and fixed

| Problem | What you would have seen | Fix |
|---|---|---|
| **Folding reset every tab** | After folding/unfolding, Categories jumped back to the first category; tabs reloaded and lost their scroll position | The navigation shell now keeps the same structure in both modes, so tabs survive (`widgets/adaptive_navigation_shell.dart`) |
| **Ratings were cut off** | Every product card showed "Review ..." instead of "Review (4.8) ⭐" | The rating gets all the space up to the "+" button (`widgets/product_item.dart`) |
| **Search never found anything** | Any search showed "No products found" | The server's search filter is broken, so the app now fetches the catalogue and matches product titles itself (`api/data_sources/remote/product_remote_data_source_impl.dart`) |
| **Slideshow dots invisible** | Only one page dot showed over white areas of images | Inactive dots are now light navy instead of white |
| **Cart/Wishlist rows overflowed** | On the narrow cover screen with large text, the price and button didn't fit | They wrap onto a second line when needed |
| **Product Details price row** | Would have crashed when the screen opened | Fixed layout of the price next to the title |

Each fix has an automated test so the problem can't silently come back.

### Running the checks yourself

```
flutter analyze
flutter test
flutter test integration_test -d <device id>
```

On a foldable emulator you can switch posture between runs with `adb emu fold` / `adb emu unfold`. The `integration_test` package (part of the Flutter SDK) was added as a development-only dependency for this; it is not included in the app you ship.

---

## Part 4 — Sign up, and the signed-in screens verified on a real account

### Sign up now works

The **Sign up** button did nothing: the screen's logic file was empty and the sign-up action wasn't connected to anything. Now:

- Every field is checked before sending (name, mobile number, e-mail, password strength), with the error shown under the field.
- The account is created on the real backend. On success you are signed in and taken to Home; your name, e-mail and phone are remembered for the Account screen.
- If the server refuses (for example, the e-mail is already registered), its message is shown in a dialog.
- There is now an **"Already have an account? Login"** link — before, going to Register left no way back to Login.

The design has a single password field, so the same value is sent as the "confirm password" the API requires.

### Login and Sign up show the real reason for failures

Network errors from the login and sign-up requests are now converted once, in the same place as every other feature. Before, Login could show a technical message like *"Instance of 'ServerException'"* in some cases; both screens now show the server's own message (e.g. "Incorrect email or password").

### Verified on a real signed-in account

You signed in on the Pixel 10 Pro Fold emulator, and the signed-in screens were tested on your account against the live backend:

- **Wishlist:** tapping a heart saves the product on the server, the heart fills, it appears on the Wishlist screen, and removing it there removes it on the server.
- **Cart:** adding 2 from Product Details puts 2 in the cart on the server; the Cart screen shows the right quantity and a total that matches the server; + and − change the quantity on the server; the bin icon removes it.
- **Account:** shows your real name, e-mail and phone; addresses load without errors.
- Screens were also photographed folded and unfolded while folding the device live.

Your account was left exactly as it was: the test uses a product that was in neither your cart nor your wishlist, and removes it again at the end (checked on the server). It never checked out, placed an order, edited your profile, added an address, or logged out.

The test is `integration_test/signed_in_flow_test.dart`. It needs a signed-in session on the device and must be run **on its own** — running the whole `integration_test` folder reinstalls the app between files, which signs you out first. Without a session it simply reports "SKIPPED".

### Problems found on the signed-in screens, and fixed

| Problem | What you would have seen | Fix |
|---|---|---|
| **Cart quantity buttons and Wishlist "Add to Cart" in the wrong place** | They sat right next to the price instead of at the right edge of the card, as in the design | The price row now spans the card, so the action sits at the right edge; on very narrow screens with large text it wraps below the price instead of overflowing |

A test now checks this position on folded and unfolded screens.

### Still not checked

- **Check Out** was deliberately not pressed — it places a real order. It sends the order to your first saved address; your account currently has no address, so it would ask you to add one first.
- **Editing** name, e-mail, phone or password, and **adding an address** were not exercised, so your account data stays unchanged. Their screens open and validate input, but saving them against the server is untested.

---

## Files at a glance

**New shared building blocks**
- `core/utils/app_layout.dart` — breakpoints, scale cap, fold/hinge detection
- `widgets/adaptive_navigation_shell.dart` — bottom bar vs side rail
- `widgets/adaptive_two_pane.dart` — hinge-aware side-by-side panes
- `widgets/responsive_center.dart` — readable max width, hinge avoidance
- `widgets/product_item.dart`, `product_card.dart`, `price_text.dart`, `favorite_button.dart`, `quantity_item.dart`, `app_network_image.dart`, `main_empty.dart`

**New features / screens**
- `features/tabs/product_list_tab/` — Product List
- `features/tabs/category_tab/` — rebuilt Categories
- `features/tabs/cart_tab/`, `fav_tab/`, `profile/` — Cart, Wishlist, Account (with their ViewModels)
- `features/tabs/product_details_tab/` — rebuilt Product Details

**Backend connection**
- `api/` — endpoints, request/response models, mappers, data sources, auth interceptor
- `data/`, `domain/` — repositories, use cases, and app data models for cart, wishlist, orders, user, products

**Tests**
- `test/api/mappers_test.dart`, `test/api/product_search_test.dart`, `test/features/cart_and_wishlist_view_model_test.dart`, `test/features/register_screen_test.dart`, `test/foldable/foldable_layout_test.dart` (32 tests, all passing)
- `integration_test/app_flow_test.dart` — runs the real app on a device against the live API (2 tests, passing in all 3 fold postures)
- `integration_test/signed_in_flow_test.dart` — wishlist, cart and account on a signed-in device; leaves the account unchanged (run on its own)

**Removed** (replaced or hard-coded)
- Old product cubit/widgets under `category_tab`, the hard-coded size/colour pickers, unused cart response models.

---

## Things worth knowing

- **Formatting-only changes:** the code formatter was run over the whole `lib/` folder, so about 37 files you didn't ask to change (auth, mappers, models, `app_theme`, `validation` …) had **spacing/line breaks** adjusted. Their behaviour is unchanged.
- **Pre-existing issues left as they were** (outside this work):
  - `login_screen.dart` has an e-mail and password **typed into the code** as default values. The server rejects them ("Incorrect email or password"), and they should be removed before sharing or releasing the app.
  - The eye icon on password fields doesn't toggle visibility yet.
  - 13 analyzer warnings/notes in older files (mostly widgets whose fields aren't `final`).
