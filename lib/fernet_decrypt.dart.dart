import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;

/// Python’dan olingan 32-byte Fernet kalit (base64 formatda)
const fernetKeyBase64 = 'YpS0G0c8QJ8xXxXf0qEN2e_YWa2KukxZ9fWrl7QoUgY=';

String decryptFernet(String encryptedTextBase64) {
  final key = base64Url.decode(fernetKeyBase64);
  final token = base64.decode(encryptedTextBase64);

  if (token[0] != 0x80) {
    throw Exception("Noto'g'ri versiya");
  }

  final iv = token.sublist(9, 25); // timestamp bilan birga IV
  final ciphertext = token.sublist(25, token.length - 32);

  final encrypter = encrypt.Encrypter(encrypt.AES(
    encrypt.Key(key),
    mode: encrypt.AESMode.cbc,
    padding: 'PKCS7',
  ));

  final decrypted = encrypter.decryptBytes(
    encrypt.Encrypted(Uint8List.fromList(ciphertext)),
    iv: encrypt.IV(iv),
  );

  return utf8.decode(decrypted);
}
