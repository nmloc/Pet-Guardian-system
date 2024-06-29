# Pet Guardian app for Pet Owners
A pet care application built with Flutter & Firebase based on [Riverpod Architecture](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/) for pet owners to manage their pet profiles and book a diverse range of services from the palm of their hands:

<p align="center">
<a href="https://youtu.be/-KFwN-y89og">
<img src="https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNmt6OThxcGdzODRvZjhmMnhmMTZ5ZXMxdmQyenJhZm1manF1M3o0OSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/IcSQaTQoicsAzgcztm/giphy.gif" width="186" height="421" />
</a>
</p>

## Features
- **Onboarding page**
- **Full authentication flow** (using Google account)
- **Pet Profiles**: users can view, create, edit, and delete their own pet profiles.
- **Orders**: for each pet profile, user can view, create, the corresponding orders of categorized pet care services (Insurance, Vaccine and Grooming).
- **Payment**: user can use their credit/debit card to pay for their orders.

All the data is persisted with Firestore and is kept in sync across multiple devices.

## Packages in use
- [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod) for data caching, dependency injection, and more.
- [Riverpod Generator](https://pub.dev/packages/riverpod_generator) and [Riverpod Lint](https://pub.dev/packages/riverpod_lint) for the latest Riverpod APIs.
- [GoRouter](https://pub.dev/packages/go_router) for navigation.
- [Firebase Auth](https://pub.dev/packages/firebase_auth) for authentication.
- [Cloud Firestore](https://pub.dev/packages/cloud_firestore) as a realtime database.
- [RxDart](https://pub.dev/packages/rxdart) for combining multiple Firestore collections as needed.
- [Intl](https://pub.dev/packages/intl) for currency, date, time formatting.
- [Mocktail](https://pub.dev/packages/mocktail) for testing.
- [Equatable](https://pub.dev/packages/equatable) to reduce boilerplate code in model classes.
- [Flutter Stripe](https://pub.dev/packages/flutter_stripe) to integrate pre-built payments UI and process payments via Stripe.

See the [pubspec.yaml](pubspec.yaml) file for the complete list.

## [License: MIT](LICENSE.md)
