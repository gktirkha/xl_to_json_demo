import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel_facility/excel_facility.dart';
import 'package:xl_to_json_demo/excel_exception.dart';

class ExcelToJson {
  Future<Map<String, String?>?> convert() async {
    Excel? excel = await _getFile();
    String? sheetname;
    if (excel == null) {
      throw ExcelException("No File Selected");
    }

    List<String> tables = _getTables(excel);

    sheetname = tables[0];

    int i = 0;
    Map<String, dynamic> json = {};

    for (String table in tables) {
      List<Data?> keys = [];
      json.addAll({table: []});

      for (List<Data?> row in excel.tables[table]?.rows ?? []) {
        try {
          if (i == 0) {
            keys = row;

            if (!(validateHeader(keys, row))) {
              throw ExcelException("Invalid Headers");
            }
            i++;
          } else {
            Map<String, dynamic> temp = _getRows(keys, row);
            json[table].add(temp);
          }
        } catch (ex) {
          throw ExcelException(ex.toString());
        }
      }
      i = 0;
    }
    return {"sheet": sheetname, "data": jsonEncode(json)};
  }

  Map<String, dynamic> _getRows(List<Data?> keys, List<Data?> row) {
    Map<String, dynamic> temp = {};
    int j = 0;
    String tk = '';

    for (Data? key in keys) {
      if (key != null) {
        tk = (key.value ?? "").toString();
        if ([
          CellType.String,
          CellType.int,
          CellType.double,
          CellType.bool,
        ].contains(row[j]?.cellType)) {
          if (row[j]?.value == 'true') {
            temp[tk] = true;
          } else if (row[j]?.value == 'false') {
            temp[tk] = false;
          } else {
            temp[tk] = row[j]?.value;
          }
        } else if (row[j]?.cellType == CellType.Formula) {
          temp[tk] = row[j]?.value.toString() ?? "";
        }
        j++;
      } else {
        temp[tk] = "";
        j++;
      }
    }

    return temp;
  }

  List<String> _getTables(Excel excel) {
    List<String> keys = [];

    for (String table in excel.tables.keys) {
      keys.add(table);
    }
    if (keys.isEmpty) {
      throw ExcelException("Unable to retrieve sheet names");
    }

    return keys;
  }

  Future<Excel?> _getFile() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv', 'xls'],
    );
    if (file != null && file.files.isNotEmpty) {
      Uint8List bytes = file.files.first.bytes!;

      return Excel.decodeBytes(bytes);
    } else {
      return null;
    }
    // to load form assests
    // final res = await rootBundle.load("assets/Format_Bulk_Assessment.xlsx");
    // if (res != null) {
    //   return Excel.decodeBytes(res.buffer.asInt8List());
    // } else {
    //   return null;
    // }
  }

  bool validateHeader(List<Data?> keys, List<Data?> row) {
    List<String> validHeader = [
      "question",
      "question_type",
      "question_image_offline_link",
      "option_a_type",
      "option_a_content",
      "option_b_type",
      "option_b_content",
      "option_c_type",
      "option_c_content",
      "option_d_type",
      "option_d_content",
      "correct_feedback",
      "incorrect_feedback",
      "feedback_image_offline_link"
    ];

    int j = 0;

    for (Data? key in keys) {
      if (j == validHeader.length - 1) break;
      if (key != null) {
        if (row[j]?.value.toString() == validHeader[j]) {
          j++;
          continue;
        } else {
          throw ExcelException("Invalid Headers");
        }
      }
    }
    return true;
  }
}
