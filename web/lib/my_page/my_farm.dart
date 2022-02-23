import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web/utils/custom_widgets.dart';
import 'package:web/utils/validation.dart';

class MyFarm extends StatefulWidget {
  const MyFarm({Key? key}) : super(key: key);

  @override
  State<MyFarm> createState() => _MyFarmState();

  static const String route = 'my-farm';
}

class _MyFarmState extends State<MyFarm> {
  _MyFarmState();

  final _formKey = GlobalKey<FormState>();
  String _feedback = '';
  bool _validationActivated = false;
  bool _loadingData = true;

  var farmNameController = TextEditingController();
  var farmAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getFarmInfo();
    });
  }

  void _onFieldChanged() {
    setState(() {
      _feedback = '';
    });
    if (_validationActivated) {
      _formKey.currentState!.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  flex: 9,
                  child: Container(
                      constraints: const BoxConstraints(minWidth: 95),
                      child: const Text('Gårdsnavn',
                          style: TextStyle(fontSize: 16)))),
              const Spacer(),
              Flexible(
                  flex: 8,
                  child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: TextFormField(
                          key: const Key('inputFarmName'),
                          controller: farmNameController,
                          validator: (input) =>
                              validateLength(input, 2, 'Skriv gårdsnavn'),
                          onChanged: (_) {
                            _onFieldChanged();
                          },
                          onFieldSubmitted: (_) => _saveFarm(),
                          decoration:
                              customInputDecoration('Navn', Icons.badge)))),
              const Spacer()
            ],
          ),
          inputFieldSpacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  flex: 9,
                  child: Container(
                      constraints: const BoxConstraints(minWidth: 95),
                      child: const Text('Gårdsadresse',
                          style: TextStyle(fontSize: 16)))),
              const Spacer(),
              Flexible(
                  flex: 8,
                  child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: TextFormField(
                          key: const Key('inputFarmAddress'),
                          controller: farmAddressController,
                          validator: (input) =>
                              validateLength(input, 2, 'Skriv gårdsadresse'),
                          onChanged: (_) {
                            _onFieldChanged();
                          },
                          onFieldSubmitted: (_) => _saveFarm(),
                          decoration:
                              customInputDecoration('Adresse', Icons.place)))),
              const Spacer()
            ],
          ),
          inputFieldSpacer(),
          _loadingData
              ? const Text('Laster data...')
              : AnimatedOpacity(
                  opacity: _validationActivated ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _feedback,
                    key: const Key('feedback'),
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
          const SizedBox(height: 25),
          ElevatedButton(
              key: const Key('saveFarmButton'),
              onPressed: _saveFarm,
              child: const Text(
                "Lagre",
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(150, 50),
              ))
        ]));
  }

  void getFarmInfo() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference farmCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentReference farmDoc = farmCollection.doc(uid);

    DocumentSnapshot<Object?> doc = await farmDoc.get();
    if (doc.exists) {
      farmNameController.text = doc.get('name') ?? '';
      farmAddressController.text = doc.get('address') ?? '';
    }
    setState(() {
      _loadingData = false;
    });
  }

  void _saveFarm() async {
    setState(() {
      _validationActivated = true;
      _feedback = '';
    });

    if (_formKey.currentState!.validate()) {
      try {
        String uid = FirebaseAuth.instance.currentUser!.uid;

        CollectionReference farmCollection =
            FirebaseFirestore.instance.collection('farms');
        DocumentReference farmDoc = farmCollection.doc(uid);

        DocumentSnapshot<Object?> doc = await farmDoc.get();
        if (doc.exists) {
          farmDoc.update({
            'name': farmNameController.text,
            'address': farmAddressController.text
          });
        } else {
          farmDoc.set({
            'maps': null,
            'ties': null,
            'eartags': null,
            'personnel': null,
            'name': farmNameController.text,
            'address': farmAddressController.text
          });
        }
        setState(() {
          _feedback = 'Gårdsinfo lagret';
        });
      } catch (e) {
        debugPrint('exception: ' + e.toString());
      }
    }
  }
}
