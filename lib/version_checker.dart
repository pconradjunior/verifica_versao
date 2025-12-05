// lib/version_checker.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:version/version.dart';
import 'package:flutter/foundation.dart';

class VersionResult {
  final bool needsUpdate;
  final bool mandatory;
  final Version remoteVersion;
  final String storeUrl;

  VersionResult({
    required this.needsUpdate,
    required this.mandatory,
    required this.remoteVersion,
    required this.storeUrl,
  });
}

class VersionChecker {
  static const String remoteUrl =
      "http://10.0.2.2:8000/version.json"; // Fixed URL

  static Future<VersionResult> checkVersion(String currentVersion) async {
    try {
      final installed = Version.parse(currentVersion);

      debugPrint("Versão instalada: $installed");

      // Fetch JSON
      final response = await http.get(Uri.parse(remoteUrl));

      if (response.statusCode != 200) {
        throw Exception("Não foi possível verificar a versão");
      }

      final data = jsonDecode(response.body);

      // Pick platform-specific version
      final remoteString = Platform.isIOS
          ? data["ios_version"].toString()
          : data["android_version"].toString();

      final remoteVersion = Version.parse(remoteString);
      final storeUrl = Platform.isIOS
          ? data["ios_store_url"].toString()
          : data["android_store_url"].toString();

      final bool mandatory = data["mandatory"] == true;

      return VersionResult(
        needsUpdate: installed < remoteVersion,
        mandatory: mandatory,
        remoteVersion: remoteVersion,
        storeUrl: storeUrl,
      );
    } catch (e) {
      debugPrint("Version check error: $e");
      return VersionResult(
        needsUpdate: false,
        mandatory: false,
        remoteVersion: Version(0, 0, 0),
        storeUrl: "",
      );
    }
  }
}
