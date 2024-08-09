import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nandrlon/config/themes/light.theme.dart';
import 'package:nandrlon/models/crm/customer/customer-note-category.dart';
import 'package:nandrlon/models/crm/customer/customer-note.dart';
import 'package:nandrlon/models/crm/customer/customer-result.dart';
import 'package:nandrlon/services/customer.service.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:nandrlon/widgets/loading.widget.dart';

class NoteFormScreen extends StatefulWidget {
  NoteFormScreen({
    Key key,
    this.customer,
    this.customerNote,
  }) : super(key: key);
  CustomerResult customer;
  CustomerNote customerNote;

  @override
  _NoteFormScreenState createState() => _NoteFormScreenState();
}

class Continent {
  const Continent({
    this.name,
    this.size,
  });

  final String name;
  final int size;

  @override
  String toString() {
    return '$name ($size)';
  }
}

const List<Continent> continentOptions = <Continent>[
  Continent(name: 'Africa', size: 30370000),
  Continent(name: 'Antarctica', size: 14000000),
  Continent(name: 'Asia', size: 44579000),
  Continent(name: 'Australia', size: 8600000),
  Continent(name: 'Europe', size: 10180000),
  Continent(name: 'North America', size: 24709000),
  Continent(name: 'South America', size: 17840000),
];

class _NoteFormScreenState extends State<NoteFormScreen> {
  List<XFile> imageFiles = [];
  bool _isLoading = true;
  var _note = new CustomerNote();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  List<CustomerNoteCategory> _customerNoteCategories;

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  onLoad() async {
    var customerNoteCategories = await CustomerService.customerNoteCategories();

    setState(() {
      _customerNoteCategories = customerNoteCategories;
      if (widget.customerNote == null) {
        _note.id = 0;
        _note.date = DateTime.now().toIso8601String();
        _note.customerId = widget.customer.id;
      } else {
        _note = widget.customerNote;
        titleController.text = _note.subject;
        descriptionController.text = _note.note;
      }
      _isLoading = false;
    });
  }

  submit() {
    setState(() {
      _isLoading = true;
    });

    if (widget.customerNote == null) {
      save();
    } else {
      update();
    }
  }

  save() async {
    _note.subject = titleController.text;
    _note.note = descriptionController.text;

    await CustomerService.createCustomerNote(_note).then((note) {
      
      
      showInSnackBar("Note has been save successfully");
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context, note);
    }).catchError((err) {
      showInSnackBar("Something error please contact support");
    });
  }

  update() async {
    setState(() {
      _note.subject = titleController.text;
      _note.note = descriptionController.text;
    });

    await CustomerService.updateCustomerNote(_note).then((note) {
      
      showInSnackBar("Note has been updated successfully");
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context, note);
    }).catchError((err) {
      showInSnackBar("Something error please contact support");
    });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  void _openCamera(BuildContext context) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      if (pickedFile != null) imageFiles.add(pickedFile);
    });
  }

  void _openGallery(BuildContext context) async {
    Navigator.pop(context);
    final pickedFiles = await ImagePicker().pickMultiImage();

    setState(() {
      if (pickedFiles != null) imageFiles.addAll(pickedFiles);
    });
  }

  void _filePicker(BuildContext context) async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path)).toList();
    } else {
      // User canceled the picker
    }

    Navigator.pop(context);
  }

  void _modalBottomSheetMenu(context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 150,
            child: ListView(
              children: [
                ListTile(
                  onTap: () {
                    _openGallery(context);
                  },
                  title: Text("Gallery"),
                  leading: Icon(
                    Icons.account_box,
                  ),
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  onTap: () {
                    _openCamera(context);
                  },
                  title: Text("Camera"),
                  leading: Icon(
                    Icons.camera,
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: widget.customerNote == null ? "Add Note" : "Edit Note",
        actions: [
          IconButton(
            onPressed: () => _modalBottomSheetMenu(context),
            icon: Icon(
              Icons.attach_file,
            ),
          ),
          IconButton(
            onPressed: _isLoading ? null : submit,
            icon: Icon(
              Icons.check,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? LoadingWidget()
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: new BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 140,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Autocomplete<CustomerNoteCategory>(
                                initialValue: titleController.value,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  setState(() {
                                    titleController.text =
                                        textEditingValue.text;
                                  });
                                  return _customerNoteCategories
                                      .where((CustomerNoteCategory continent) =>
                                          continent.name
                                              .toLowerCase()
                                              .startsWith(textEditingValue.text
                                                  .toLowerCase()))
                                      .toList();
                                },
                                displayStringForOption:
                                    (CustomerNoteCategory option) =>
                                        option.name,
                                fieldViewBuilder: (BuildContext context,
                                    TextEditingController
                                        fieldTextEditingController,
                                    FocusNode fieldFocusNode,
                                    VoidCallback onFieldSubmitted) {
                                  return TextFormField(
                                    controller: fieldTextEditingController,
                                    focusNode: fieldFocusNode,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(15, 15, 10, 20),
                                      border: InputBorder.none,
                                      hintText: "Title",
                                      hintStyle: TextStyle(
                                        color: Color(0x8C323232),
                                        fontSize: 15,
                                      ),
                                    ),
                                  );
                                },
                                onSelected: (CustomerNoteCategory selection) {
                                  setState(() {
                                    titleController.text = selection.name;
                                  });
                                },
                                optionsViewBuilder: (BuildContext context,
                                    AutocompleteOnSelected<CustomerNoteCategory>
                                        onSelected,
                                    Iterable<CustomerNoteCategory> options) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      child: Container(
                                        width: 300,
                                        height: 300,
                                        decoration: BoxDecoration(
                                            color: backgroundColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xff4F62C0)
                                                    .withOpacity(0.15),
                                                spreadRadius: 0,
                                                blurRadius: 3,
                                                offset: Offset(0,
                                                    1), // changes position of shadow
                                              ),
                                            ]),
                                        child: ListView.builder(
                                          padding: EdgeInsets.all(10.0),
                                          itemCount: options.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final CustomerNoteCategory option =
                                                options.elementAt(index);

                                            return GestureDetector(
                                              onTap: () {
                                                onSelected(option);
                                              },
                                              child: ListTile(
                                                title: Text(
                                                  option.name,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),

                              // TextFieldWidget(
                              //   fontWeight: FontWeight.bold,
                              //   onChanged: (title) {
                              //     setState(() {
                              //       _note.subject = title;
                              //     });
                              //   },
                              //   backgroundColor: Colors.white,
                              //   hintText: "Title",
                              //   controller: titleController,
                              // ),
                              Divider(
                                height: 0,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(
                                  color: Color(0xffC323232),
                                  fontSize: 15,
                                ),
                                maxLines: 25,
                                controller: descriptionController,
                                decoration: InputDecoration(
                                  counterText: "",
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(15, 12, 10, 12),
                                  border: InputBorder.none,
                                  hintText: "Note",
                                  hintStyle: TextStyle(
                                    color: Color(0x8C323232),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Divider(),
                              imageFiles.length == 0
                                  ? Container()
                                  : Container(
                                      height: 150,
                                      padding: EdgeInsets.all(10),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: imageFiles.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    margin: EdgeInsets.only(
                                                      right: 15,
                                                    ),
                                                    child: Container(
                                                      child: Image.file(
                                                        File(imageFiles[index]
                                                            .path),
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 5,
                                                    right: 20,
                                                    child: Container(
                                                      padding: EdgeInsets.all(1),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: IconButton(
                                                        constraints: BoxConstraints(),
                                                        padding: EdgeInsets.zero,
                                                        onPressed: (){
                                                         setState(() {
                                                           imageFiles.removeAt(index);
                                                         });
                                                        } ,
                                                        icon: Icon(
                                                          Icons.clear,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
