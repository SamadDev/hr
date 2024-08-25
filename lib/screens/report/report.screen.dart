import 'package:flutter/material.dart';
import 'package:nandrlon/helper/formatter.dart';
import 'package:nandrlon/helper/snackbar.dart';
import 'package:nandrlon/models/crm/customer/customer.dart';
import 'package:nandrlon/models/crm/report/report-parameter.dart';
import 'package:nandrlon/models/menu.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/services/menu.service.dart';
import 'package:nandrlon/widgets/alert-dialog-widget.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/button.widget.dart';
import 'package:nandrlon/widgets/dropdown.widget.dart';
import 'package:nandrlon/widgets/form.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';
import 'package:nandrlon/widgets/pdf-viewr.dart';
import 'package:nandrlon/widgets/text_field.widget.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen();

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ReportParameters _reportParameters = ReportParameters();

  List<Menu> _menus;
  bool _isLoading = true;
  bool _isSubmit = false;
  List<Customer> _customers = [];

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  onLoad() async {
    var menus = await MenuService.getMenus(3);

    setState(() {
      _menus = menus;
      _isLoading = false;
    });
  }

  onReset() {
    setState(() {
      _isSubmit = false;
      _reportParameters = new ReportParameters();
    });
  }

  onGenerate() {
    setState(() {
      _isSubmit = true;
    });

    if (_reportParameters.menu == null) {
      showInSnackBar(SnackBarType.Valid, context);
      return;
    }

    var parameters = _reportParameters.toQueryString(_reportParameters);

    // var parameters = "customerId=" +
    //     (_reportParameters.customer?.id.toString() ?? "") +
    //     "fromDate=" +
    //     (_reportParameters.fromDate ?? "") +
    //     ",toDate=" +
    //     (_reportParameters.toDate ?? "");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewr(
          title: _reportParameters.menu.name,
          reportName: _reportParameters.menu.url,
          fileName: _reportParameters.menu.url,
          parameters: parameters,
        ),
      ),
    );
  }

  Future<List<Customer>> getCustomers(searchText) async {
    return await CustomerService.filter(searchText);
  }

  customerModalBottomSheet(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
          return AlterDialogWidget(
            items: _customers,
            onTap: (index) {
              setState(() {
                _reportParameters.customer = _customers[index];
                _reportParameters.customerId = _customers[index].id;
              });
              Navigator.pop(context);
            },
            onSearch: (value) async {
              var customers = await getCustomers(value);
              mystate(() {
                _customers = customers;
              });
            },
          );
        });
      },
    );
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme:
                ColorScheme.light(primary: Theme.of(context).primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );

    if (picked != null) return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      layoutBackgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: "Report",
      ),
      body: _isLoading
          ? LoadingWidget()
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      FormListTile(
                        title: "General Info",
                        widget: Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              DropdownButtonWidget(
                                labelText: "Report",
                                value: _reportParameters.menu,
                                key: Key(_reportParameters.menu?.name),
                                isRequired: true,
                                isSubmit: _isSubmit,
                                items: _menus.map((Menu menu) {
                                  return DropdownMenuItem(
                                    value: menu,
                                    child: Text(
                                      menu.name,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (Menu menu) {
                                  setState(() {
                                    _reportParameters.menu = menu;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () => customerModalBottomSheet(context),
                                child: TextFieldWidget(
                                  labelText: "Customer",
                                  isDropdown: true,
                                  enabled: false,
                                  key: Key(_reportParameters.customer?.name),
                                  initialValue:
                                      _reportParameters.customer?.name ?? "",
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        var date = await _selectDate(context);
                                        if (date != null) {
                                          setState(() {
                                            _reportParameters.fromDate =
                                                dateFormat.format(date);
                                            _reportParameters.fromDate =
                                                dateFormat.format(date);
                                          });
                                        }
                                      },
                                      child: Container(
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    40) /
                                                2,
                                        child: TextFieldWidget(
                                          labelText: "From Date",
                                          key: Key(_reportParameters.fromDate),
                                          initialValue:
                                              _reportParameters.fromDate,
                                          hintText: _reportParameters.fromDate,
                                          enabled: false,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  40) /
                                              2,
                                      child: GestureDetector(
                                        onTap: () async {
                                          var date = await _selectDate(context);
                                          if (date != null) {
                                            setState(() {
                                              _reportParameters.toDate =
                                                  dateFormat.format(date);
                                              _reportParameters.toDate =
                                                  dateFormat.format(date);
                                            });
                                          }
                                        },
                                        child: TextFieldWidget(
                                          labelText: "To Date",
                                          key: Key(_reportParameters.toDate),
                                          initialValue:
                                              _reportParameters.toDate,
                                          hintText: _reportParameters.toDate,
                                          enabled: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 50),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                          width: MediaQuery.of(context).size.width / 2 - 35,
                          height: 50,
                          title: "Generate",
                          onPressed: () => onGenerate(),
                        ),
                        ButtonWidget(
                          width: MediaQuery.of(context).size.width / 2 - 35,
                          height: 50,
                          color: Colors.grey,
                          title: "Reset",
                          onPressed: () => onReset(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
