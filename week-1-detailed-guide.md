# Week 1 — Detailed Step-by-Step Guide

Goal by Sunday night: Firebase project live, GitHub repo public with clean structure, wireframes + data model documented, and Google Sign-In actually working end to end in the browser.

---

## Monday (1–1.5h) — Lock scope and name

1. Open a new file in your repo (create it even before the repo exists, in a local folder for now): `PROJECT_SCOPE.md`.
2. Write two lists:
   - **Must-have for V1 demo:** personal expenses + mandatory expenses + monthly planning, loan/EMI tracker, warranty tracker, insurance tracker, room-based friend split, reminders, export, dynamic UI via Remote Config.
   - **Explicitly deferred:** password vault (separate project), AI bill scanning (Phase 10), iOS build.
   Writing the "deferred" list down matters as much as the must-have list — it's what stops scope creep three weeks from now.
3. Pick the app name. Based on our earlier brainstorm, go with **Enkanakku** unless something else has stuck with you more. Don't overthink this — it's a portfolio project, not a trademark filing.
4. Decide the package/bundle ID now so it's consistent everywhere: `com.<yourname>.Enkanakku` (e.g. `com.praveen.Enkanakku`). You'll need this exact string in Firebase and in `flutter create`.

**Done when:** `PROJECT_SCOPE.md` exists with both lists, name and package ID decided.

---

## Tuesday (1–1.5h) — Firebase project setup

1. Go to [console.firebase.google.com](https://console.firebase.google.com) → **Add project** → name it `Enkanakku-app` (or your chosen name). Google Analytics: leave it enabled — it's free and gives you a small "I instrumented analytics" talking point later.
2. Once created, go to **Build → Authentication → Get started**. Enable these sign-in providers now:
   - **Google** (just toggle on, no extra config needed for now)
   - **Email/Password** (optional backup)
   - **Anonymous** (this powers your future demo mode — enable it now, costs nothing)
   - Leave **Phone** off for today — you'll enable it in Week 2 when you actually build that flow, since it requires switching to the Blaze plan.
3. Go to **Build → Firestore Database → Create database**.
   - Region: pick `asia-south1` (Mumbai) for lowest latency from Chennai.
   - Start in **test mode** for now (open rules, 30-day expiry). You'll write real security rules in Week 4 before you add the room-split feature — test mode is fine while you're the only one touching data.
4. If/when you enable Phone Auth later and it asks you to upgrade to Blaze: go to **Project Settings → Usage and billing → Details & settings**, link a billing account, then immediately go to **Google Cloud Console → Billing → Budgets & alerts** and set a budget alert at ₹100. This takes 2 minutes and means you'll get an email long before anything could ever cost real money.
5. Note your **Project ID** (shown in Project Settings) — you'll need it tomorrow.

**Done when:** Firebase project exists, Auth providers (Google, Email, Anonymous) enabled, Firestore created in test mode.

---

## Wednesday (1–1.5h) — Repo, Flutter skeleton, folder architecture

1. Create a **public** GitHub repo named `Enkanakku-app` (public matters — this is your portfolio piece).
2. Locally, create the Flutter project (skip iOS since you don't have a Mac yet — you can add the platform later without any rework):
   ```
   flutter create --platforms=android,web --org com.praveen Enkanakku_app
   cd Enkanakku_app
   ```
3. Initialize git and connect to GitHub:
   ```
   git init
   git add .
   git commit -m "Initial Flutter project skeleton"
   git branch -M main
   git remote add origin https://github.com/<you>/Enkanakku-app.git
   git push -u origin main
   ```
4. Build out the folder architecture from the plan (empty folders don't get tracked by git, so drop a `.gitkeep` or a stub file in each):
   ```
   lib/
     core/
       auth/
       firestore/
       notifications/
       theme/
     features/
       expenses/
       loans/
       warranty/
       insurance/
       splits/
     shared/
       widgets/
       models/
   ```
5. Commit: `"Add feature-module folder structure"`.
6. Copy `PROJECT_SCOPE.md` from Monday into the repo root and commit it too — it's a good README precursor.

**Done when:** Repo is public on GitHub, Flutter project builds (`flutter run -d chrome` shows the default counter app), folder structure committed.

---

## Thursday (1–1.5h) — Wireframes

1. Create a free Figma account if you don't have one, new file: `Enkanakku Wireframes`.
2. Use a mobile frame (375×812). Sketch these three screens in low fidelity — boxes and labels, no polish:
   - **Home dashboard:** this-month-spend card, upcoming-dues list (loan/insurance/warranty reminders), quick "+ Add" floating button, nav to Expenses / Loans / Rooms.
   - **Expense entry:** amount field, category picker, date, note, "Mandatory expense" toggle.
   - **Loan entry:** loan type dropdown (home/gold/personal), principal, EMI amount, due date, tenure in months.
3. Don't spend more than the allotted time on visual polish — the point is to have a target to build toward and a screenshot for your README later. Export each frame as PNG into an `assets/wireframes/` folder in your repo.

**Done when:** 3 wireframe screens exist in Figma, exported as PNGs into the repo.

---

## Friday (1–1.5h) — Firestore data model (the highest-leverage task this week)

1. Create `MODELS.md` in the repo root and write out the collections exactly:

   ```
   users/{uid}
     name, email, photoUrl, createdAt

   users/{uid}/expenses/{expenseId}
     amount, category, date, note, isMandatory, isRecurring, createdAt

   users/{uid}/loans/{loanId}
     type (home | gold | personal), principal, emiAmount,
     dueDate, tenureMonths, startDate

   users/{uid}/warranties/{itemId}
     productName, purchaseDate, warrantyMonths, expiryDate,
     retailer, billImageUrl

   users/{uid}/insurance/{policyId}
     type, provider, premiumAmount, dueDate, policyNumber

   rooms/{roomId}
     name, members: [uid, uid, ...], createdBy, createdAt

   rooms/{roomId}/expenses/{expenseId}
     amount, paidBy, splitAmong: [uid, uid, ...],
     category, date, note
   ```

2. Note next to `rooms/{roomId}/expenses` that security rules here (Week 4) will check `request.auth.uid in resource.data.members` on the parent room doc — write that note now so future-you doesn't have to rediscover it.
3. Commit `MODELS.md`.

**Done when:** `MODELS.md` committed, matches the structure above.

---

## Saturday (3–4h) — Google Sign-In, end to end

1. Install tooling (one-time):
   ```
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   firebase login
   ```
2. From your project root:
   ```
   flutterfire configure --project=<your-firebase-project-id>
   ```
   Select Android + Web platforms. This generates `lib/firebase_options.dart` and wires the native config files automatically — no manual JSON copying.
3. Add packages to `pubspec.yaml`:
   ```
   firebase_core
   firebase_auth
   google_sign_in
   cloud_firestore
   mobx
   flutter_mobx
   ```
   Then `flutter pub get`.
4. In `main.dart`:
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     runApp(const EnkanakkuApp());
   }
   ```
5. Create `lib/core/auth/auth_service.dart` with a `signInWithGoogle()` method wrapping `GoogleSignIn` + `FirebaseAuth.instance.signInWithCredential(...)`.
6. Build a minimal `LoginScreen` with one button calling that method.
7. On successful sign-in, write/merge a `users/{uid}` doc in Firestore (name, email, photoUrl, createdAt) — this is your first real Firestore write, good checkpoint.
8. Run on web to test first (fastest feedback loop): `flutter run -d chrome`. For Google Sign-In on web, add `localhost` to **Authorized domains** in Firebase Console → Authentication → Settings if it isn't there already.
9. Commit: `"Add Google Sign-In flow with Firestore user doc creation"`.

**Done when:** You can click "Sign in with Google" in Chrome, complete the flow, and see your user document appear in the Firestore console.

---

## Sunday (3–4h) — App shell

1. Add `go_router` to `pubspec.yaml` for routing.
2. Create a MobX `AuthStore` that listens to `FirebaseAuth.instance.authStateChanges()` and exposes `isSignedIn` as an observable.
3. Set up route guards: unauthenticated → `LoginScreen`; authenticated → the main shell.
4. Build `AppShell` widget: bottom navigation bar with Home / Expenses / Loans / Rooms / More (5 tabs matches your feature areas cleanly).
5. Add a basic Material 3 theme: `ColorScheme.fromSeed(seedColor: ...)`, wire a MobX `ThemeStore` for light/dark toggle (implementation can be a stub for now — full dark mode polish is Phase 8).
6. Commit: `"Add routing, app shell, and theme/auth MobX stores"`.

**Done when:** Signing in lands you on a shell with working bottom navigation between 5 empty placeholder screens.

---

## End-of-week checkpoint

By Sunday night you should be able to say all of these are true:

- [ ] `PROJECT_SCOPE.md` and `MODELS.md` committed to a **public** GitHub repo
- [ ] Firebase project live with Auth (Google/Email/Anonymous) and Firestore (test mode) enabled
- [ ] 3 wireframes in Figma, exported to the repo
- [ ] `flutter run -d chrome` → Google Sign-In → lands on app shell with 5 nav tabs
- [ ] At least 5 meaningful commits with clear messages (this history is part of your interview story)

Next Monday, Week 2 starts with hardening auth (Phone OTP + PIN/biometric lock) and the first Firestore repository layer. Ping me when you're there and I'll break that week down the same way.
