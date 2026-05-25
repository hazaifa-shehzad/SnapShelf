import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/album_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/photo_provider.dart';
import 'providers/upload_provider.dart';
import 'providers/user_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PhotoStorageRoot());
}

class PhotoStorageRoot extends StatelessWidget {
  const PhotoStorageRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AlbumProvider()),
        ChangeNotifierProvider(create: (_) => PhotoProvider()),
        ChangeNotifierProvider(create: (_) => UploadProvider()),
      ],
      child: const App(),
    );
  }
}
