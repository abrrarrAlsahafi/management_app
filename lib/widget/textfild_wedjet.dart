import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFormFieldWidget extends StatelessWidget {
  final onChanged;
  final validator;
  final hintText;
  final onSave;
  final prefixIcon;
  final suffixIcon;
  final keyboardType;
  final onFieldSubmitted;
  bool autofocus;
  final focus;
  final onEditingComplete;
  final textInputAction;

  TextFormFieldWidget({Key key,this.keyboardType, this.onChanged, this.validator, this.hintText,
    this.onSave, this.prefixIcon, this.suffixIcon, this.focus,
    this.onFieldSubmitted, this.autofocus, this.onEditingComplete, this.textInputAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
          textInputAction: textInputAction,
          onEditingComplete: onEditingComplete,
        autofocus: autofocus==null?false:autofocus,
          onFieldSubmitted:onFieldSubmitted,
        focusNode: focus,
          keyboardType:keyboardType,
          onChanged: onChanged,
          validator:validator,
          onSaved: onSave,
          cursorColor: const Color(0xff336699),
          // onChanged: ()=>,
          decoration: InputDecoration(
            // labelText: 'Email',
            labelStyle: TextStyle(
              color: const Color(0xff336699),
              fontSize: 12,
            ),
            hintText:hintText, //: str,
            hintStyle: TextStyle(
              color: Colors.black45,
              fontSize: 12,
            ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon
          )
      ),
    );
  }
}
