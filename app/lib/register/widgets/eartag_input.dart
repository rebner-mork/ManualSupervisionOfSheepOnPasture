import 'package:app/utils/field_validation.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';

class EartagInput extends StatefulWidget {
  const EartagInput(
      {required this.formKey,
      required this.countryCodeController,
      required this.farmNumberController,
      required this.individualNumberController,
      required this.isValidationActivated,
      Key? key})
      : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController countryCodeController;
  final TextEditingController farmNumberController;
  final TextEditingController individualNumberController;
  final bool isValidationActivated;

  @override
  State<EartagInput> createState() => _EartagInputState();
}

class _EartagInputState extends State<EartagInput> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
          width: 97,
          height: textFormFieldHeight,
          child: TextFormField(
              textAlign: TextAlign.center,
              controller: widget.countryCodeController,
              style: const TextStyle(fontSize: 18),
              validator: (_) =>
                  validateEartagCountryCode(widget.countryCodeController.text),
              onChanged: (_) {
                if (widget.isValidationActivated) {
                  widget.formKey.currentState!.validate();
                }
              },
              decoration: InputDecoration(
                  labelText: 'Landskode',
                  labelStyle: TextStyle(
                      fontSize:
                          widget.countryCodeController.text.isEmpty ? 13 : 18),
                  border: const OutlineInputBorder()))),
      const SizedBox(width: 10),
      SizedBox(
          width: 120,
          height: textFormFieldHeight,
          child: TextFormField(
              textAlign: TextAlign.center,
              controller: widget.farmNumberController,
              style: const TextStyle(fontSize: 18),
              validator: (_) =>
                  validateEartagFarmNumber(widget.farmNumberController.text),
              onChanged: (_) {
                if (widget.isValidationActivated) {
                  widget.formKey.currentState!.validate();
                }
              },
              keyboardType: const TextInputType.numberWithOptions(),
              decoration: const InputDecoration(
                  labelText: 'Gårdsnr', border: OutlineInputBorder()))),
      const SizedBox(width: 10),
      SizedBox(
          width: 90,
          height: textFormFieldHeight,
          child: TextFormField(
              textAlign: TextAlign.center,
              controller: widget.individualNumberController,
              style: const TextStyle(fontSize: 18),
              validator: (_) => validateEartagIndividualNumber(
                  widget.individualNumberController.text),
              onChanged: (_) {
                if (widget.isValidationActivated) {
                  widget.formKey.currentState!.validate();
                }
              },
              keyboardType: const TextInputType.numberWithOptions(),
              decoration: const InputDecoration(
                  labelText: 'Individ', border: OutlineInputBorder())))
    ]);
  }
}
