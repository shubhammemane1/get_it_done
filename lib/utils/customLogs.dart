// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

customLogs(text) {
  if (kDebugMode) {
    print(text.toString());
  }
}
