# Manuell oppfølging av sau på beite

## Mobile app
Make sure to be inside the `./app` directory to run commands towards the mobile app.

### Testing
Due to Flutter not yet supporting integration tests directly in browsers, they have to run on an emulator/AVD (Android virtual device). The AVD has to be a digital device as the tests relies on a localhost connection (i.e. not a physical device).

<b>Unit & widget tests</b>: `flutter test`

<b>Integration tests</b>: `firebase emulators:exec --only auth 'flutter test ./integration_test/int_test.dart'`

## Web app
Make sure to be inside the `./web` directory to run commands towards the web app.

### Deploy to Firebase

To manually deploy the latest version of the app to Firebase hosting run these commands:

`git pull`

`flutter build web`

`firebase deploy`
