import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pnbfoods/common/warna.dart';

class TextFormFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Widget prefixIcon;
  final bool numberOnly;

  const TextFormFieldCustom({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.numberOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
      controller: controller,
      inputFormatters: <TextInputFormatter>[
        if (numberOnly) FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        prefixIconColor: Warna.warnaAccent,
        labelStyle: TextStyle(fontSize: 16),
        filled: true,
        fillColor: Colors.white,
        floatingLabelStyle: TextStyle(color: Warna.warnaTextGray, fontSize: 16),
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class TextArea extends StatelessWidget {
  final TextEditingController controller;
  final int minLines;
  final int maxLines;
  final IconData icon;
  final String title;

  const TextArea({
    super.key,
    required this.controller,
    required this.minLines,
    required this.maxLines,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.only(top: 15, left: 15),
            child: Row(
              children: [Icon(icon, size: 20), SizedBox(width: 5), Text(title)],
            ),
          ),
          TextFormField(
            controller: controller,
            minLines: minLines,
            maxLines: maxLines,
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Warna.warnaTextGray),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Stok extends StatelessWidget {

  final Function(bool) enabled;
  final bool checkboxValue;
  final TextEditingController controller;
  final VoidCallback onPressedMinus;
  final VoidCallback onPressedPlus;
  final Function(PointerDownEvent) onTapOutside;

  const Stok({super.key, required this.controller, required this.checkboxValue, required this.enabled, required this.onPressedMinus, required this.onPressedPlus, required this.onTapOutside});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: checkboxValue, 
                    onChanged: (value) {
                      enabled(value!);
                    }
                  ),
                  Text("Stok"),
                  SizedBox(width: checkboxValue ? 0 : 15,)
                ],
              ),
              Visibility(
                visible: checkboxValue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: onPressedMinus, 
                      icon: Icon(Icons.remove)
                    ),
                    SizedBox(
                      width: 35,
                      height: 35,
                      child: TextFormField(
                        controller: controller,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onTapOutside: (tap) {
                          onTapOutside(tap);
                        },
                        minLines: 1,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          filled: true,
                          fillColor: Warna.warnaAccent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none
                          )
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onPressedPlus, 
                      icon: Icon(Icons.add)
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ],
    );
  }
}

class DropdownButtonFormFieldCustom<T> extends StatelessWidget {
  final T? initialValue;
  final IconData icon;
  final List<DropdownMenuItem<T>> items;
  final Function(T) onChanged;

  const DropdownButtonFormFieldCustom({super.key, required this.initialValue, required this.icon, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DropdownButtonFormField(
      initialValue: initialValue,
      items: items,
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        prefixIconColor: Warna.warnaAccent,
        labelStyle: TextStyle(fontSize: 16),
        filled: true,
        fillColor: Colors.white,
        floatingLabelStyle: TextStyle(
          color: Warna.warnaTextGray,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none
        )
      ),
      onChanged: (T? value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}

class DropdownFormFieldCustom extends StatelessWidget {
  final String? value;
  final String labelText;
  final Widget prefixIcon;
  final List<String> items;
  final Function(String?) onChanged;

  const DropdownFormFieldCustom({
    super.key,
    required this.value,
    required this.labelText,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        prefixIconColor: Warna.warnaAccent,
        labelStyle: const TextStyle(fontSize: 16),
        filled: true,
        fillColor: Colors.white,
        floatingLabelStyle: TextStyle(color: Warna.warnaTextGray, fontSize: 16),
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: Colors.white,
      items: items.map((item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }
}