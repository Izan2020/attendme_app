import 'dart:convert';

import 'package:crypto/crypto.dart';

String calculateSHA256(String input) {
  var bytes = utf8.encode(input); // Encode the input string as UTF-8
  var digest = sha256.convert(bytes); // Calculate the SHA-256 hash

  return digest.toString(); // Convert the hash to a string
}
