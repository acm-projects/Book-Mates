// Flutter web plugin registrant file.
//
// Generated file. Do not edit.
//

// @dart = 2.13
// ignore_for_file: type=lint

import 'package:cloud_firestore_web/cloud_firestore_web.dart';
<<<<<<< HEAD
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:firebase_core_web/firebase_core_web.dart';
=======
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:firebase_storage_web/firebase_storage_web.dart';
import 'package:restart_app/restart_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
>>>>>>> 9d9f291a17bad6675046530918afd3efb4a8917c
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins([final Registrar? pluginRegistrar]) {
  final Registrar registrar = pluginRegistrar ?? webPluginRegistrar;
  FirebaseFirestoreWeb.registerWith(registrar);
<<<<<<< HEAD
  FirebaseAuthWeb.registerWith(registrar);
  FirebaseCoreWeb.registerWith(registrar);
=======
  FilePickerWeb.registerWith(registrar);
  FirebaseAuthWeb.registerWith(registrar);
  FirebaseCoreWeb.registerWith(registrar);
  FirebaseStorageWeb.registerWith(registrar);
  RestartWeb.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
>>>>>>> 9d9f291a17bad6675046530918afd3efb4a8917c
  registrar.registerMessageHandler();
}
