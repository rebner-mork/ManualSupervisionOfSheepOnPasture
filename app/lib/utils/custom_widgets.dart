import 'dart:ui';

import 'package:app/utils/other.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';

class InputFieldSpacer extends StatelessWidget {
  const InputFieldSpacer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 18);
  }
}

class AppbarBodySpacer extends StatelessWidget {
  const AppbarBodySpacer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 20);
  }
}

const double defaultIconSize = 35;

class LoadingData extends StatefulWidget {
  const LoadingData(
      {this.text = 'Laster inn...', this.smallCircleOnly = false, Key? key})
      : super(key: key);

  final String text;
  final bool smallCircleOnly;

  @override
  State<LoadingData> createState() => _LoadingDataState();
}

class _LoadingDataState extends State<LoadingData>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    _animationController.reset();

    _colorTween = _animationController.drive(
        ColorTween(begin: Colors.green.shade700, end: Colors.green.shade300));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: widget.smallCircleOnly
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: _colorTween,
                  strokeWidth: 2.5,
                ))
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                    height: 48,
                    width: 48,
                    child: CircularProgressIndicator(
                      valueColor: _colorTween,
                      strokeWidth: 6,
                    )),
                const SizedBox(height: 10),
                Text(
                  widget.text,
                  style: feedbackTextStyle,
                )
              ]));
  }
}

class InputRowIcon extends StatelessWidget {
  const InputRowIcon(
      {required this.text,
      required this.controller,
      required this.iconData,
      required this.color,
      this.iconSize = defaultIconSize,
      this.scrollController,
      this.isFieldValid = true,
      this.onChanged,
      this.globalKey,
      this.ownKey,
      Key? key})
      : super(key: key);

  final String text;
  final TextEditingController controller;
  final IconData iconData;
  final Color color;
  final double iconSize;
  final ScrollController? scrollController;
  final bool isFieldValid;
  final VoidCallback? onChanged;
  final GlobalKey? globalKey;
  final GlobalKey? ownKey;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        key: ownKey,
        children: [
          SizedBox(
              width: 45,
              child: Container(
                  width: defaultIconSize + 3,
                  color: color == Colors.white
                      ? Colors.grey.shade400
                      : Colors.transparent,
                  child: Icon(iconData, color: color, size: iconSize))),
          const SizedBox(width: 8),
          SizedBox(
              width: 115,
              child: Text(
                text,
                style: const TextStyle(fontSize: 19),
              )),
          const SizedBox(width: 7),
          SizedBox(
              width: 70,
              child: Container(
                  constraints: const BoxConstraints(maxWidth: 70),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: controller,
                    onFieldSubmitted: (_) => {
                      if (scrollController != null && globalKey != null)
                        scrollToKey(
                            scrollController: scrollController!,
                            key: globalKey!),
                    },
                    onChanged: (_) => {
                      if (onChanged != null) {onChanged!()}
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          gapPadding: 4.0,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          borderSide: isFieldValid
                              ? const BorderSide(color: Colors.grey)
                              : const BorderSide(color: Colors.red)),
                      enabledBorder: OutlineInputBorder(
                          gapPadding: 4.0,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          borderSide: isFieldValid
                              ? const BorderSide(color: Colors.grey)
                              : const BorderSide(color: Colors.red)),
                      hintText: '0',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    ),
                  )))
        ]);
  }
}

class InputRowImage extends StatelessWidget {
  const InputRowImage(
      {required this.text,
      required this.controller,
      required this.imagePath,
      this.isSmall = false,
      this.isSheepAndLamb = false,
      this.scrollController,
      this.isFieldValid = true,
      this.onChanged,
      this.globalKey,
      this.ownKey,
      Key? key})
      : super(key: key);

  final String text;
  final TextEditingController controller;
  final String imagePath;
  final bool isSmall;
  final bool isSheepAndLamb;
  final ScrollController? scrollController;
  final bool isFieldValid;
  final VoidCallback? onChanged;
  final GlobalKey? globalKey;
  final GlobalKey? ownKey;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        key: ownKey,
        children: [
          isSheepAndLamb
              ? SizedBox(
                  width: 85,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image(image: AssetImage(imagePath), height: 35),
                      Image(image: AssetImage(imagePath), height: 45)
                    ],
                  ))
              : isSmall
                  ? SizedBox(
                      width: 45,
                      child: Image(image: AssetImage(imagePath), height: 35))
                  : Image(image: AssetImage(imagePath), height: 45),
          const SizedBox(width: 8),
          SizedBox(
              width: 115,
              child: Text(
                text,
                style: const TextStyle(fontSize: 19),
              )),
          const SizedBox(width: 7),
          SizedBox(
              width: 70,
              child: TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                controller: controller,
                onFieldSubmitted: (_) => {
                  if (scrollController != null && globalKey != null)
                    scrollToKey(
                        scrollController: scrollController!, key: globalKey!),
                },
                onChanged: (_) => {
                  if (onChanged != null) {onChanged!()}
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      gapPadding: 4.0,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      borderSide: isFieldValid
                          ? const BorderSide(color: Colors.grey)
                          : const BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(
                      gapPadding: 4.0,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      borderSide: isFieldValid
                          ? const BorderSide(color: Colors.grey)
                          : const BorderSide(color: Colors.red)),
                  hintText: '0',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                ),
              )),
          if (isSheepAndLamb) const SizedBox(width: 40)
        ]);
  }
}

class InputDividerWithHeadline extends StatelessWidget {
  const InputDividerWithHeadline(
      {required this.headline, this.globalKey, Key? key})
      : super(key: key);

  final String headline;
  final GlobalKey? globalKey;

  @override
  Widget build(BuildContext context) {
    return Column(key: globalKey, children: [
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Flexible(
            child: Divider(
          thickness: 3,
          color: Colors.grey,
          endIndent: 5,
        )),
        Flexible(
            flex: 5,
            child: Text(
              headline,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            )),
        const Flexible(
            child: Divider(
          thickness: 3,
          color: Colors.grey,
          indent: 5,
        ))
      ]),
      const SizedBox(height: 10),
    ]);
  }
}

Future<bool> cancelRegistrationDialog(BuildContext context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: AlertDialog(
              title: const Text("Avbryte registrering?"),
              content: const Text('Data i registreringen vil gå tapt.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Ja, avbryt')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Nei, fortsett'))
              ],
            ));
      });
}

class CompleteRegistrationButton extends StatelessWidget {
  const CompleteRegistrationButton(
      {required this.context, required this.onPressed, Key? key})
      : super(key: key);

  final BuildContext context;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom == 0
        ? FloatingActionButton.extended(
            heroTag: 'completeOralRegistrationButton',
            onPressed: onPressed,
            label: const Text('Fullfør registrering',
                style: TextStyle(fontSize: 19)))
        : FloatingActionButton(
            onPressed: onPressed,
            child: const Icon(
              Icons.check,
              size: 35,
            ));
  }
}

class StartDialogButton extends StatelessWidget {
  const StartDialogButton({required this.onPressed, Key? key})
      : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'startDialogButton',
      onPressed: onPressed,
      child: const Icon(Icons.mic, size: 30),
    );
  }
}

class SettingsIcon extends StatelessWidget {
  const SettingsIcon({required this.iconSize, Key? key}) : super(key: key);

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.settings,
      color: Colors.black,
      size: iconSize,
    );
  }
}
