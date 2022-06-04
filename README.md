# Manuell oppfølging av sau på beite

This repo is the code base for a master thesis in Informatics at Norwegian University of Science and Technology (NTNU). The code base includes two Flutter apps, one for mobile and one for web. The main target for the system is to improve the efficiency, and streamline supervision, of sheep on pasture through digitization.

## Install

1. Make sure to have installed Flutter (https://docs.flutter.dev/get-started/install)
2. Download this repo
3. Run `flutter pub get` in both `./app` and `./web` to download dependencies
4. Apps are now ready to run


## Mobile app

The mobile app is located in the `./app` directory and all commands towards this app are executed in this directory.

The mobile part of the system is used in field while supervising.

## Web app

The web app is located in the `./web` directory and all commands towards this app are executed in this directory.

The web part of the system is used for administrating and getting an overview of supervision.

The web app is currently hosted at: https://master-backend-93896.web.app


## Testing
Due to Flutter not yet supporting integration tests directly in browsers, they have to run on an emulator/AVD (Android virtual device). The AVD has to be a digital device as the tests relies on a localhost connection (i.e. not a physical device).

<b>Unit & widget tests</b>: `flutter test`

<b>Integration tests</b>: `firebase emulators:exec 'flutter test integration_test'`
