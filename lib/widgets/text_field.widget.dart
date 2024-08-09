import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    Key key,
    this.labelText,
    this.errorText,
    this.backgroundColor,
    this.hintText,
    this.controller,
    this.iconData,
    this.enabled,
    this.isSubmit,
    this.isLoading,
    this.isDropdown,
    this.onChanged,
    this.isRequired,
    this.inputFormatters,
    this.maxLines,
    this.initialValue,
    this.keyboardType,
    this.fontWeight,
    this.textInputAction,
    this.margin,
    this.focusNode,
    this.autofocus,
    this.validator,
  }) : super(key: key);

  final FocusNode focusNode;
  final String labelText;
  bool autofocus = false;
  final String errorText;
  final Color backgroundColor;
  final String hintText;
  final IconData iconData;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final bool isSubmit;
  final bool isLoading;
  final bool isDropdown;
  final bool isRequired;
  final List<TextInputFormatter> inputFormatters;
  final int maxLines;
  final String initialValue;
  TextInputType keyboardType;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry margin;
  TextInputAction textInputAction;
  FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText == null
              ? Container()
              : Text(
                  labelText,
                  style: TextStyle(
                    color: (isRequired == true &&
                            isSubmit == true &&
                            (initialValue == null || initialValue.isEmpty))
                        ? Colors.red
                        : Color(0xff29304D),
                    fontSize: 15,
                    fontFamily: context.locale.languageCode == "en" ? "aileron" : "DroidKufi",
                  ),
                ),
          SizedBox(
            height: labelText == null ? 0 : 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: isRequired == true &&
                        isSubmit == true &&
                        (initialValue == null || initialValue.isEmpty)
                    ? Colors.red
                    : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(5.0),
              color:
                  backgroundColor == null ? Color(0xffF7F7F7) : backgroundColor,
            ),
            child: Row(
              children: [
                isLoading == true
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                          strokeWidth: 2,
                        ),
                      )
                    : this.iconData != null
                        ? Container(
                            child: Icon(
                              this.iconData,
                              color: Color(0xff8A959E),
                              size: 18,
                            ),
                          )
                        : Container(),
                Expanded(
                  child: Container(
                    child: TextFormField(
                      key: key,
                      textInputAction: textInputAction ?? TextInputAction.done,
                      maxLines: maxLines,
                      focusNode: focusNode,
                      autofocus: autofocus == null ? false : autofocus,
                      initialValue: initialValue,
                      inputFormatters: inputFormatters,
                      enabled: enabled == null ? true : enabled,
                      controller: controller,
                      onChanged: onChanged,
                      validator: validator,
                      keyboardType: keyboardType,
                      decoration: InputDecoration(
                        counterText: "",
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(
                          iconData == null ? 5 : 15,
                          12,
                          10,
                          12,
                        ),
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: TextStyle(
                          color: Color(0x8C323232),
                          fontSize: 15,
                        ),
                        errorStyle: TextStyle(height: 0),
                      ),
                      style: TextStyle(
                        fontWeight: fontWeight,
                        color: Color(
                          0xff323232,
                        ),
                      ),
                    ),
                  ),
                ),
                isDropdown == true
                    ? Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 23,
                      )
                    : Container()
              ],
            ),
          ),
          isRequired == true &&
                  isSubmit == true &&
                  (initialValue == null || initialValue.isEmpty)
              ? Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    "This filed is required",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
