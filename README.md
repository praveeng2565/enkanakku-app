# Enkanakku — Project Scope

> A single app for personal financial life-admin — expenses, loans, warranties, insurance, and reminders — that also handles shared expense splitting with friends and roommates, without needing two separate apps.

---

## The problem

Most people juggle 4–5 tools to manage their financial life: a notes app for warranty dates, a bank app for loan EMIs, WhatsApp math for splitting rent and trip costs with friends, and a mental note (often forgotten) for when the insurance premium is due. Enkanakku consolidates the personal and the shared side of "money admin" into one app, built around **reminders** as the connective thread — nothing should be missed because it lived in the wrong app.

---

## Who it's for

- **Primary:** individuals who want a single place to track expenses, loans, warranties, and insurance with proactive reminders.
- **Secondary:** small groups (roommates, trip groups, up to ~100 users total across the app) who need to split shared expenses and see a running settle-up balance, without spinning up a separate expense-splitting app.

---

## Core features (V1)

### Personal tracking
- Daily expense logging with categories and notes
- Mandatory vs. discretionary expense flagging
- Monthly expense planning — planned vs. actual comparison
- Loan / EMI tracker (home loan, gold loan, personal loan) with due-date reminders
- Product purchase + warranty tracker with expiry reminders
- Insurance tracker (all types) with premium due-date reminders

### Shared / group tracking
- Room-based expense splitting (create a room, invite members)
- Settle-up calculation — minimum number of payments to balance a group, not just raw totals
- Per-room running balance and expense history

### Platform features
- Google Sign-In, email, and phone OTP authentication, each user with a unique ID
- Anonymous demo mode with seed data — try the app without creating an account
- Push and local notifications for all reminder types
- Data export (CSV / PDF)
- Dynamic UI via server-driven feature flags (Firebase Remote Config) — toggle features and copy without a redeploy
- Light/dark theme, Tamil + English localization
- Deployed on the web (Firebase Hosting) and as an Android build

---

## Explicitly deferred (not in this project's scope)

Kept out on purpose, to keep this build focused and shippable:

| Deferred item | Reason |
|---|---|
| Password vault / credential storage | High-liability feature (real security risk if the crypto is wrong) — planned as a separate, standalone project |
| AI bill-image parsing & auto-split | Planned as a capstone phase once core features are solid; feasibility already scoped (ML Kit OCR + Gemini API) |
| Play Store / App Store publication | This build targets a live web demo + Android build for portfolio purposes, not public distribution |
| iOS build | Requires macOS tooling not available in this build environment; revisited later via cloud CI if needed |

---

## Tech stack

| Layer | Choice |
|---|---|
| Frontend | Flutter (single codebase — Web + Android) |
| State management | MobX |
| Backend | Firebase — Authentication, Firestore, Cloud Functions, Cloud Messaging |
| Hosting | Firebase Hosting |
| Dynamic UI | Firebase Remote Config |
| OCR (future) | Google ML Kit (on-device) |
| AI categorization (future) | Gemini API |
| CI | Codemagic |

**Why Firebase:** free tier (Spark plan) comfortably covers the ~100-user target — 50K MAU on Auth, 50K Firestore reads/day — with real-time sync out of the box, which matters for the shared-room feature specifically (all members see balance updates live).

---

## Data model (summary — see `MODELS.md` for full detail)

Two structurally separate trees, by design:

- **Personal data:** `users/{uid}/...` — private to that user, access rule `request.auth.uid == uid`
- **Shared data:** `rooms/{roomId}/...` with a `members` array — access rule `request.auth.uid in resource.data.members`

Keeping these separate from day one avoids the most common design mistake in apps that mix personal and shared data: a private grocery expense and a 4-person trip split are not the same kind of record and shouldn't live in the same collection.

---

## Architecture

Feature-module structure, so new trackers (e.g. a future "gold loan" sub-type or a new reminder category) can be added without touching unrelated code:

```
lib/
  core/        # auth, firestore client, notifications, theming — shared services
  features/
    expenses/
    loans/
    warranty/
    insurance/
    splits/
  shared/      # reusable widgets and models
```

---

## Status

Actively in development — see commit history for progress. Built solo, part-time, as a portfolio project demonstrating end-to-end product thinking (scoping, data modeling, security rules, and shipping a working live demo) alongside Flutter/Firebase implementation.
