import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:web/trips/detailed/registration_details/timestamp_widget.dart';
import 'package:web/utils/constants.dart';
import 'package:web/utils/custom_widgets.dart';
import 'package:web/utils/other.dart';
import 'package:web/utils/styles.dart';

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
  bool _isLoading = true;
  late final List<String> _photoUrls = [];
  late final List<String> eartag;

  @override
  void initState() {
    super.initState();
    _loadImages();
    eartag = (widget.registration['eartag'] as String).split('-');
  }

  void _loadImages() async {
    List urls = widget.registration['photos'] as List;

    if (urls.isNotEmpty) {
      for (dynamic url in urls) {
        String downloadUrl =
            await FirebaseStorage.instance.ref().child(url).getDownloadURL();
        _photoUrls.add(downloadUrl);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.fromLTRB(2.0, 10, 2.0, 5.0),
      title: const Text('Kadaver',
          style: dialogHeadlineTextStyle, textAlign: TextAlign.center),
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (widget.registration['tieColor'] == '0') const SizedBox(width: 45),
          Text('${eartag[0]}-${eartag[1]}\n${eartag[2]}-${eartag[3]}',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center),
          const SizedBox(width: 25),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey,
          ),
          const SizedBox(width: 25),
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
          const SizedBox(width: 40)
        ]),
        const SizedBox(height: 10),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SizedBox(
                width: textSize(
                                text: '${widget.registration['note']}',
                                style: registrationNoteTextStyle)
                            .width >
                        registrationNoteWidthNarrow
                    ? registrationNoteWidthWide
                    : registrationNoteWidthNarrow,
                child: Text(
                    (widget.registration['note'] as String).isEmpty
                        ? 'Ingen notat'
                        : '${widget.registration['note']}',
                    style: registrationNoteTextStyle,
                    textAlign: TextAlign.center))),
        _isLoading
            ? const LoadingData(smallCircleOnly: true)
            : _photoUrls.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text('Ingen bilder',
                        style: registrationNoteTextStyle,
                        textAlign: TextAlign.center))
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ...(_photoUrls)
                        .map((photoUrl) => Row(children: [
                              const SizedBox(width: 8),
                              Image.network(
                                photoUrl,
                                width: 300,
                              ),
                              const SizedBox(width: 8)
                            ]))
                        .toList()
                  ]),
        const SizedBox(height: 5),
        TimestampWidget(timestamp: widget.registration['timestamp']),
      ],
    );
  }
}
