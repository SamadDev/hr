import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nandrlon/config/themes/light.theme.dart';


Color primaryColor = Color(box.read('primaryColor') == null
    ? 0xff124993
    : int.parse(box.read('primaryColor')));
var crmUrl = "https://crm-api.dottech.co";
var numberFormat = NumberFormat('#,###.##', 'en_Us');
var phoneMask = new MaskTextInputFormatter(mask: "+964 (###) ###-####");
String saveMessage = "Record has been saved successfully";
String updateMessage = "Record has been updated successfully";
String deleteMessage = "Record has been deleted successfully";
String errorMessage = "Something error please contact support";
EdgeInsets showModalBottomSheetPadding = EdgeInsets.fromLTRB(15, 15, 15, 0);
double constBorderRadius = 8.0;
