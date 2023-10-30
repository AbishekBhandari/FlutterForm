import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataEntryForm extends StatefulWidget {
  const DataEntryForm({super.key});

  @override
  State<DataEntryForm> createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _lmpDateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool status = false;
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String uri = "http://localhost/flutterApi/insert_record.php";
      var res = await http.post(Uri.parse(uri), body: {
        'name': _nameController.text,
        'age': _ageController.text,
        'lmpDate': _lmpDateController.text,
        'phoneNumber': _phoneNumberController.text,
      });
      var response = jsonDecode(res.body);
      if (response["success"]) {
        print("Record inserted");
        setState(() {
          status = true;
        });
      } else {
        print("some issues");
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _lmpDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DATA ENTRY FORM'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == '') {
                    return 'Please enter a name';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _ageController,
                validator: (value) {
                  if (value == '') {
                    return 'Please enter an age';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _lmpDateController,
                    validator: (value) {
                      if (value == '') {
                        return 'Please enter LMP date';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'LMP Date'),
                  ),
                ),
              ),
              TextFormField(
                controller: _phoneNumberController,
                validator: (value) {
                  String pattern = r'^(?:[+0]9)?[0-9]{10}$';
                  RegExp regExp = new RegExp(pattern);
                  if (!regExp.hasMatch(value!)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _ageController.text = "";
                        _nameController.text = "";
                        _lmpDateController.text = "";
                        _phoneNumberController.text = "";
                        status = false;
                      });
                    },
                    child: const Text('Clear Form'),
                  ),
                ],
              ),
              status == true ? const Text("Row inserted") : Text(""),
            ],
          ),
        ),
      ),
    );
  }
}
