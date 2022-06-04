# Manuell oppfølging av sau på beite

This repo is the code base for a Master Thesis in Informatics at Norwegian University of Science and Technology (NTNU). the code base includes to Flutter apps, one for mobile and one for web. The main target for the system is to simplify and streamline supervision of sheep on pasture by digitization.

## Install

1. Make sure to have installed Flutter (https://docs.flutter.dev/get-started/install?gclid=Cj0KCQjwheyUBhD-ARIsAHJNM-N5RQh9P649FMnAWndrrK_1N1BNeNEIqMrUb4rtx7toyT9eDgLMAQ4aAjwTEALw_wcB&gclsrc=aw.ds)
2. Download this repo
3. Run `flutter pub get` in both `./app` or `./web` to download dependencies
4. Apps are now ready to run


## Mobile app

The mobile app i is located in `./app` directory and all commands towards the mobile app are executed in this repo.

The mobile part of the system is used in field while supervising.

### Testing
Due to Flutter not yet supporting integration tests directly in browsers, they have to run on an emulator/AVD (Android virtual device). The AVD has to be a digital device as the tests relies on a localhost connection (i.e. not a physical device).

<b>Unit & widget tests</b>: `flutter test`

<b>Integration tests</b>: `firebase emulators:exec 'flutter test integration_test'`

## Web app

The mobile app i is located in `./app` directory and all commands towards the mobile app are executed in this repo.

The web part of the system is for administrating and getting overview of supervision.

The webapp is currently hosted at: https://master-backend-93896.web.app/#login-page

### Deploy to Firebase

To manually deploy the latest version of the app to Firebase hosting run these commands:

`git pull`

`flutter build web`

`firebase deploy`

