import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'providers/album_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/photo_provider.dart';
import 'providers/upload_provider.dart';
import 'providers/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const PhotoStorageRoot());
}

class PhotoStorageRoot extends StatelessWidget {
  const PhotoStorageRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<AlbumProvider>(create: (_) => AlbumProvider()),
        ChangeNotifierProvider<PhotoProvider>(create: (_) => PhotoProvider()),
        ChangeNotifierProvider<UploadProvider>(create: (_) => UploadProvider()),
      ],
      child: const App(),
    );
  }
}
