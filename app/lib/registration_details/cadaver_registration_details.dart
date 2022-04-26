import 'dart:io';

import 'package:app/registration_details/timestamp_widget.dart';
import 'package:app/utils/camera/display_photo_widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';

class CadaverRegistrationDetails extends StatefulWidget {
  const CadaverRegistrationDetails({required this.registration, Key? key})
      : super(key: key);

  final Map<String, dynamic> registration;

  @override
  State<CadaverRegistrationDetails> createState() =>
      _CadaverRegistrationDetailsState();
}

class _CadaverRegistrationDetailsState
    extends State<CadaverRegistrationDetails> {
  late final List<String> eartag;

  @override
  void initState() {
    super.initState();
    eartag = (widget.registration['eartag'] as String).split('-');
    debugPrint(widget.registration.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.fromLTRB(0, 5, 0.0, 8),
      title: const Text('Kadaver',
          style: dialogHeadlineTextStyle, textAlign: TextAlign.center),
      children: [
        Text('${eartag[0]}-${eartag[1]}\n${eartag[2]}-${eartag[3]}',
            style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
        const SizedBox(height: 2),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            widget.registration['tieColor'] == '0'
                ? Icons.disabled_by_default
                : FontAwesome.black_tie,
            size: 30,
            color: widget.registration['tieColor'] == '0'
                ? Colors.grey
                : Color(int.parse(widget.registration['tieColor'], radix: 16)),
          ),
          widget.registration['tieColor'] == '0'
              ? Text(
                  colorValueToStringGui['${widget.registration['tieColor']}']! +
                      ' slips',
                  style: registrationDetailsDescriptionTextStyle)
              : Text(
                  colorValueToStringGui['${widget.registration['tieColor']}']!,
                  style: registrationDetailsDescriptionTextStyle),
        ]),
        const SizedBox(height: 2),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Text(
                (widget.registration['note'] as String).isEmpty
                    ? 'Ingen notat'
                    : '${widget.registration['note']}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center)),
        (widget.registration['photos'] as List).isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text('Ingen bilder',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center))
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ...(widget.registration['photos'] as List)
                    .map((photoUrl) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DisplayPhotoWidget(
                                  photoPath: photoUrl as String,
                                  showDeleteButton: false)));
                        },
                        child: Container(
                          height: 150,
                          width: 100,
                          foregroundDecoration: BoxDecoration(
                              image: DecorationImage(
                            image: FileImage(File(photoUrl as String)),
                            fit: BoxFit.contain,
                          )),
                        )))
                    .toList()
              ]),
        const SizedBox(height: 10),
        TimestampWidget(date: widget.registration['timestamp'])
      ],
    );
  }
}
