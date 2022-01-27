import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web/utils/custom_widgets.dart';

class MyFarm extends StatefulWidget {
  const MyFarm({Key? key}) : super(key: key);

  @override
  State<MyFarm> createState() => _MyFarmState();
}

class _MyFarmState extends State<MyFarm> {
  _MyFarmState();

  final _formKey = GlobalKey<FormState>();
  late String _farmName, _farmAddress;
  String _feedback = '';
  bool _validationActivated = false;
  bool _loadingData = true;

  var farmNameController = TextEditingController();
  var farmAddressController = TextEditingController();

  String? validateLength(String? input, String feedback) {
    if (input!.isEmpty) {
      return feedback;
    }
    return null;
  }

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
      _formKey.currentState!.save();
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
                              validateLength(input, 'Skriv gårdsnavn'),
                          onSaved: (input) => _farmName = input.toString(),
                          onChanged: (_) {
                            _onFieldChanged();
                          },
                          onFieldSubmitted: (_) => _saveFarm(),
                          decoration:
                              customInputDecoration('Navn', Icons.badge)))),
              const Spacer()
            ],
          ),
          customFieldSpacing(),
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
                              validateLength(input, 'Skriv adresse'),
                          onSaved: (input) => _farmAddress = input.toString(),
                          onChanged: (_) {
                            _onFieldChanged();
                          },
                          onFieldSubmitted: (_) => _saveFarm(),
                          decoration:
                              customInputDecoration('Adresse', Icons.place)))),
              const Spacer()
            ],
          ),
          customFieldSpacing(),
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
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test@gmail.com', password: '12345678'); // TODO: remove
    String? currentUser = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference farmCollection =
        FirebaseFirestore.instance.collection('farm');
    DocumentReference farmDoc = farmCollection.doc(currentUser);

    await farmDoc.get().then((doc) => {
          if (doc.exists)
            {
              debugPrint('Dokument eksisterer'),
              debugPrint("print: " + doc.data().toString()),
              _farmName = doc.get('name'),
              _farmAddress = doc.get('address'),
              farmNameController.text = _farmName,
              farmAddressController.text = _farmAddress
            }
          else
            {
              debugPrint('Dokument eksisterer ikke'),
            },
        });
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
      _formKey.currentState!.save();
      try {
        String? currentUser = FirebaseAuth.instance.currentUser!.uid;

        CollectionReference farmCollection =
            FirebaseFirestore.instance.collection('farm');
        DocumentReference farmDoc = farmCollection.doc(currentUser);

        await farmDoc.get().then((doc) => {
              if (doc.exists)
                {
                  debugPrint('Dokument eksisterer'),
                  farmDoc.update({'name': _farmName, 'address': _farmAddress})
                }
              else
                {
                  debugPrint('Dokument eksisterer ikke'),
                  farmDoc.set({'name': _farmName, 'address': _farmAddress})
                },
            });
        setState(() {
          _feedback = 'Gårdsinfo lagret';
        });
      } catch (e) {
        debugPrint('exception: ' + e.toString());
      }
    }
  }
}
