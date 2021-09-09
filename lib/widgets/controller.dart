import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_manager/widgets/form.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'form.dart';

class FormController {
  // Callback function to give response of status of current request.
  final void Function(String) callback;

  // Google App Script Web URL
  static const String scriptUrl =
      "https://script.google.com/macros/s/AKfycby-ZmYx71lr0fW1W9vgrrz1nm_mhF4pHUPWnRN0FZ7mvwAvP5T2IgwBtA/exec";
  static const sheetUrl =
      'https://docs.google.com/spreadsheets/d/1mi61v2g_dYLEP9US6jQ6PJ-zgtyZsl9fR684DeyMN4k/edit?usp=sharing';

  static const STATUS_SUCCESS = "SUCCESS";

  FormController(this.callback);

  void submitForm(StudentForm studentForm) async {
    try {
      await http.get(scriptUrl + studentForm.toParams()).then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            'Connection Error! Opening Google Sheet For Making Changes Manually',
        textColor: Colors.red,
      );
      await launch(sheetUrl);
    }
  }

  void updateForm(UpdateForm updateForm, int sel) async {
    try {
      await http.get(scriptUrl + updateForm.toParams()).then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      if (sel == 0) {
        Fluttertoast.showToast(
          msg:
              'Connection Error! Opening Google Sheet For Making Changes Manually',
          textColor: Colors.red,
        );
        await launch(sheetUrl);
      }
    }
  }

  void updateFeeForm(UpdateFeeForm updateFeeForm) async {
    try {
      await http.get(scriptUrl + updateFeeForm.toParams()).then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            'Connection Error! Opening Google Sheet For Making Changes Manually',
        textColor: Colors.red,
      );
      await launch(sheetUrl);
    }
  }

  void addFeeForm(AddFeeForm addFeeForm) async {
    try {
      await http.get(scriptUrl + addFeeForm.toParams()).then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            'Connection Error! Opening Google Sheet For Making Changes Manually',
        textColor: Colors.red,
      );
      await launch(sheetUrl);
    }
  }

  void addExpForm(AddExpForm addExpForm) async {
    try {
      await http.get(scriptUrl + addExpForm.toParams()).then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            'Connection Error! Opening Google Sheet For Making Changes Manually',
        textColor: Colors.red,
      );
      await launch(sheetUrl);
    }
  }

  void deleteExpForm(DeleteExpForm deleteExpForm) async {
    try {
      await http.get(scriptUrl + deleteExpForm.toParams()).then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            'Connection Error! Opening Google Sheet For Making Changes Manually',
        textColor: Colors.red,
      );
      await launch(sheetUrl);
    }
  }
}
