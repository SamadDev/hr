import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DropdownButtonWidget<T> extends StatelessWidget {
  DropdownButtonWidget({
    Key key,
    this.isRequired,
    this.isSubmit,
    this.value,
    this.labelText,
    this.hintText,
    this.controller,
    this.enabled,
    this.isDropdown,
    this.onChanged,
    this.inputFormatters,
    this.icon,
    this.maxLines,
    this.items,
    this.validator,
  }) : super(key: key);

  final T value;
  final bool isRequired;
  final bool isSubmit;
  final String labelText;
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T> onChanged;
  final bool enabled;
  final bool isDropdown;
  final List<TextInputFormatter> inputFormatters;
  final int maxLines;
  FormFieldValidator<T> validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText == null
              ? Container()
              : Text(
                  labelText,
                  style: TextStyle(
                    fontFamily: context.locale.languageCode == "en"
                        ? "aileron"
                        : "DroidKufi",
                    color: (isRequired == true && isSubmit == true && value  == null) ? Colors.red : Color(0xff29304D),
                    fontSize: 15,
                  ),
                ),
          SizedBox(
            height: labelText == null ? 0 : 5,
          ),
          Container(
            height: 51,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
    border: Border.all(
    color: (isRequired == true && isSubmit == true && value  == null) ? Colors.red : Colors.transparent,
    ),
              color: Color(0xffF7F7F7),
            ),
            child: Row(
              children: [
                this.icon != null
                    ? Container(
                        child: Icon(
                          this.icon,
                          color: Color(0xff8A959E),
                          size: 18,
                        ),
                      )
                    : Container(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: icon == null ? 5 : 14),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        hint: Text(hintText ?? ""),
                        value: value,
                        //underline: SizedBox(),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color:  Colors.transparent),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          errorStyle: TextStyle(height: 0),
                        ),
                        icon: Icon(Icons.keyboard_arrow_down),
                        validator: validator,
                        items: items,
                        onChanged: onChanged,
                        isExpanded: true,
                      ),
                    ),
                  ),
                ),
                isDropdown == true
                    ? Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Color(0xff8A959E),
                        size: 18,
                      )
                    : Container()
              ],
            ),
          ),
          (isRequired == true && isSubmit == true && value  == null)
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
