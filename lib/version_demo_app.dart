import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'version_checker.dart';

class VersionDemoApp extends StatefulWidget {
  const VersionDemoApp({super.key});

  @override
  State<VersionDemoApp> createState() => _VersionDemoAppState();
}

class _VersionDemoAppState extends State<VersionDemoApp> {
  String installedVersion = "";
  String message = "Verificando atualizações...";

  @override
  void initState() {
    super.initState();
    _runCheck();
  }

  Future<void> _runCheck() async {
    final package = await PackageInfo.fromPlatform();
    installedVersion = package.version;

    final result = await VersionChecker.checkVersion(installedVersion);

    if (result.needsUpdate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showUpdateDialog(
          storeUrl: result.storeUrl,
          mandatory: result.mandatory,
          newVersion: result.remoteVersion.toString(),
        );
      });
    }

    setState(() {
      message = result.needsUpdate
          ? "Atualização disponível"
          : "App está atualizado";
    });
  }

  void _showUpdateDialog({
    required bool mandatory,
    required String newVersion,
    required String storeUrl,
  }) {
    showDialog(
      context: context,
      barrierDismissible: !mandatory, // não fecha se for obrigatório
      builder: (context) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, Object? result) async {
            final navigator = Navigator.of(context);
            if (didPop) return;
            if (!mandatory) navigator.pop();
          },
          child: AlertDialog(
            title: const Text("Atualização disponível"),
            content: Text(
              mandatory
                  ? "A atualização é obrigatória.\n\nNova versão: $newVersion"
                  : "Uma nova versão está disponível.\n\nNova versão: $newVersion",
            ),
            actions: [
              if (!mandatory)
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Ignorar"),
                ),
              TextButton(
                onPressed: () {
                  // Exemplo de ação: abrir a URL da loja
                  // usando url_launcher, de acordo com a plataforma
                  debugPrint("Abrindo link da loja: $storeUrl");
                  launchUrl(Uri.parse(storeUrl));
                },
                child: const Text(" Atualizar Agora"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Verificador de Versão")),
        body: Center(
          child: Text(
            "Versão instalada: $installedVersion\n$message",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
