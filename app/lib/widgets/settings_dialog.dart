import 'package:flutter/material.dart';
import 'package:app/utils/styles.dart';
import 'package:app/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
        clipBehavior: Clip.none,
        child: SingleChildScrollView(
          child: Padding(
              padding:
                  const EdgeInsets.only(left: 6, top: 26, right: 6, bottom: 26),
              child: ListBody(children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Innstillinger',
                      style: settingsHeadlineTextStyle,
                      textAlign: TextAlign.center,
                    )),
                ...speechSettings(context),
                ...mapSettings(context),
              ])),
        ));
  }
}

List<Widget> speechSettings(BuildContext context) {
  return [
    Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(
          'Tale',
          style: settingsHeadlineTwoTextStyle,
          textAlign: TextAlign.center,
        )),
    ...Provider.of<SettingsProvider>(context).sttAvailable == null
        ? [
            const Text(
              'Blir tilgjengelig under oppsynstur',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            )
          ]
        : Provider.of<SettingsProvider>(context).sttAvailable!
            ? <Widget>[
                SettingsSwitchListTile(
                  tooltipText: 'Taleregistrerings-dialog starter automatisk',
                  settingText: 'Autostart dialog',
                  value: Provider.of<SettingsProvider>(context).autoDialog,
                  onChanged: (_) {
                    Provider.of<SettingsProvider>(context, listen: false)
                        .toggleAutoDialog();
                  },
                  margin: const EdgeInsets.only(left: 15),
                ),
                SettingsSwitchListTile(
                    tooltipText: 'Det som ble tolket leses tilbake',
                    settingText: 'Les tilbake',
                    value: Provider.of<SettingsProvider>(context).readBack,
                    onChanged: (_) {
                      Provider.of<SettingsProvider>(context, listen: false)
                          .toggleReadBack();
                    },
                    margin: const EdgeInsets.only(left: 35))
              ]
            : <Widget>[
                Row(children: [
                  Tooltip(
                      message:
                          'Enheten er ikke konfigurert for offline taleregistrering. '
                          'Last ned språkpakken engelsk(US) på enhetens innstillinger og restart appen. '
                          'Samsung-brukere må muligens skru av Samsung voice typing.',
                      preferBelow: true,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                      child: Icon(
                        Icons.info,
                        size: 36,
                        color: Colors.grey.shade600,
                      ),
                      triggerMode: TooltipTriggerMode.tap,
                      showDuration: const Duration(seconds: 30)),
                  Text(
                    'Tale-til-tekst ikke konfigurert',
                    style: settingsTextStyle,
                    textAlign: TextAlign.center,
                  )
                ]),
              ]
  ];
}

List<Widget> mapSettings(BuildContext context) {
  return [
    Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(
          'Kart',
          style: settingsHeadlineTwoTextStyle,
          textAlign: TextAlign.center,
        )),
    SettingsSwitchListTile(
      tooltipText: 'Kartet følger din bevegelse',
      settingText: 'Autoflytt kart',
      value: Provider.of<SettingsProvider>(context).autoMoveMap,
      onChanged: (_) {
        Provider.of<SettingsProvider>(context, listen: false)
            .toggleAutoMoveMap();
      },
      margin: const EdgeInsets.only(left: 35),
    ),
  ];
}

class SettingsSwitchListTile extends StatelessWidget {
  const SettingsSwitchListTile(
      {required this.tooltipText,
      required this.settingText,
      required this.value,
      required this.onChanged,
      this.margin,
      Key? key})
      : super(key: key);

  final String settingText;
  final String tooltipText;
  final bool value;
  final Function(bool) onChanged;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        title: Text(
          settingText,
          style: settingsTextStyle,
        ),
        activeColor: Colors.green,
        secondary: Tooltip(
            message: tooltipText,
            preferBelow: true,
            textStyle: const TextStyle(fontSize: 16, color: Colors.white),
            margin: margin,
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Icon(
              Icons.info,
              size: 38,
              color: Colors.grey.shade600,
            ),
            triggerMode: TooltipTriggerMode.tap),
        value: value,
        onChanged: onChanged);
  }
}
