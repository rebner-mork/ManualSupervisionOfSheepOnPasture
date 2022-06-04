import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web/utils/custom_widgets.dart';
import 'package:web/utils/styles.dart';
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

  final TextEditingController farmNameController = TextEditingController();
  final TextEditingController farmAddressController = TextEditingController();
  final TextEditingController farmNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _readFarmInfo();
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
          const SizedBox(height: 20),
          const Text('Min gård', style: pageHeadlineTextStyle),
          const SizedBox(height: 20),
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
                          onFieldSubmitted: (_) => _saveFarmInfo(),
                          decoration: customInputDecoration(
                              labelText: 'Navn', icon: Icons.badge)))),
              const Spacer()
            ],
          ),
          const InputFieldSpacer(),
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
                          onFieldSubmitted: (_) => _saveFarmInfo(),
                          decoration: customInputDecoration(
                              labelText: 'Adresse', icon: Icons.place)))),
              const Spacer()
            ],
          ),
          const InputFieldSpacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  flex: 9,
                  child: Container(
                      constraints: const BoxConstraints(minWidth: 95),
                      child: const Text('Gårdsnummer',
                          style: TextStyle(fontSize: 16)))),
              const Spacer(),
              Flexible(
                  flex: 8,
                  child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: TextFormField(
                          key: const Key('inputFarmNumber'),
                          controller: farmNumberController,
                          validator: (input) => validateEartagFarmNumber(input),
                          onChanged: (_) {
                            _onFieldChanged();
                          },
                          onFieldSubmitted: (_) => _saveFarmInfo(),
                          decoration: customInputDecoration(
                              labelText: 'Nummer', icon: Icons.local_offer)))),
              const Spacer()
            ],
          ),
          const InputFieldSpacer(),
          _loadingData
              ? const LoadingData()
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
              onPressed: _saveFarmInfo,
              child: const Text(
                "Lagre",
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(150, 50),
              ))
        ]));
  }

  Future<void> _readFarmInfo() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference farmCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentReference farmDoc = farmCollection.doc(uid);

    DocumentSnapshot<Object?> doc = await farmDoc.get();
    if (doc.exists) {
      farmNameController.text = doc.get('name') ?? '';
      farmAddressController.text = doc.get('address') ?? '';
      farmNumberController.text = doc.get('farmNumber') ?? '';
    }
    setState(() {
      _loadingData = false;
    });
  }

  Future<void> _saveFarmInfo() async {
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
            'address': farmAddressController.text,
            'farmNumber': farmNumberController.text
          });
        } else {
          farmDoc.set({
            'maps': null,
            'ties': null,
            'eartags': null,
            'personnel': [FirebaseAuth.instance.currentUser!.email],
            'name': farmNameController.text,
            'address': farmAddressController.text,
            'farmNumber': farmNumberController.text
          });
        }
        setState(() {
          _feedback = 'Gårdsinformasjon lagret';
        });
      } catch (e) {
        debugPrint('exception: ' + e.toString());
      }
    }
  }
}
