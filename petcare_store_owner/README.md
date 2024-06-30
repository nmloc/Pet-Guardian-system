# Pet Guardian app for Store Owners
A pet care application built with Flutter & Firebase based on [Riverpod Architecture](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/) for store owners to manage their own store and staffs from the palm of their hands:

<p align="center">
<a href="https://youtu.be/MiUW7bkm-Qk">
<img src="https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExZmFmbmFxaXZhazh0Y3VxMndoaWExczk4MHk3Z2k3MXYyODg5YWt2NSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/QeToSRcCzfRF8lVR0v/giphy.gif" width="186" height="421" />
</a>
</p>

## Features
- **Onboarding page**
- **Full authentication flow** (using Google account)
- **Pet Profiles**: users can view, create, edit, and delete products classified into 3 types: insurance, vaccines, grooming services.
- **Orders**: users can view all orders belonging to their own stores.
- **Demand Forecast**: users can view the system's predicted sales results for each product type for the upcoming months.

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

See the [pubspec.yaml](pubspec.yaml) file for the complete list.

## [License: MIT](LICENSE.md)
