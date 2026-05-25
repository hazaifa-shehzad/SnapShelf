import '../models/user_model.dart';

class DummyUser {
  DummyUser._();

  static final UserModel currentUser = UserModel(
    id: 'user_001',
    name: 'Hazaifa Shehzad',
    email: 'hazaifa@example.com',
    phone: '+92 300 0000000',
    avatarUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
    createdAt: DateTime(2026, 1, 12),
  );
}
