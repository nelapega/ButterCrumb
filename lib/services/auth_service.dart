import '../models/user_model.dart';

class AuthService {
  AuthService._();

  static const String adminCode = 'BUTTER2026';
  static const String adminEmail = 'admin@buttercrumb.com';
  static const String adminPassword = 'admin123';

  static final Map<String, Map<String, String>> _admins = {
    'admin@buttercrumb.com': {
      'name': 'Admin',
      'email': 'admin@buttercrumb.com',
      'password': 'admin123',
      'code': 'BUTTER2026',
    },
  };

  // Penyimpanan sementara selama aplikasi berjalan.
  static final Map<String, Map<String, String>> _clients = {
    'customer@buttercrumb.com': {
      'name': 'Sweet Friend',
      'email': 'customer@buttercrumb.com',
      'password': 'customer123',
    },
  };

  static String? registerAdmin({
    required String name,
    required String email,
    required String password,
    String code = adminCode,
  }) {
    final normalizedEmail = email.trim().toLowerCase();

    if (name.trim().isEmpty) {
      return 'Nama tidak boleh kosong.';
    }

    if (normalizedEmail.isEmpty) {
      return 'Email tidak boleh kosong.';
    }

    if (password.isEmpty) {
      return 'Password tidak boleh kosong.';
    }

    if (_admins.containsKey(normalizedEmail)) {
      return 'Email admin sudah terdaftar.';
    }

    _admins[normalizedEmail] = {
      'name': name.trim(),
      'email': normalizedEmail,
      'password': password,
      'code': code.trim().isEmpty ? adminCode : code.trim(),
    };

    return null;
  }

  static String? getAdminName(String email) {
    return _admins[email.trim().toLowerCase()]?['name'] ?? 'Admin';
  }

  static String? registerClient({
    required String name,
    required String email,
    required String password,
  }) {
    final normalizedEmail = email.trim().toLowerCase();

    if (name.trim().isEmpty) {
      return 'Nama tidak boleh kosong.';
    }

    if (normalizedEmail.isEmpty) {
      return 'Email tidak boleh kosong.';
    }

    if (password.isEmpty) {
      return 'Password tidak boleh kosong.';
    }

    if (_clients.containsKey(normalizedEmail)) {
      return 'Email sudah terdaftar.';
    }

    _clients[normalizedEmail] = {
      'name': name.trim(),
      'email': normalizedEmail,
      'password': password,
    };

    return null;
  }

  static bool loginClient({
    required String email,
    required String password,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    final client = _clients[normalizedEmail];

    return client != null && client['password'] == password;
  }

  static String? getClientName(String email) {
    return _clients[email.trim().toLowerCase()]?['name'];
  }

  static String? getClientEmail(String email) {
    return _clients[email.trim().toLowerCase()]?['email'];
  }

  static bool updateClientName({
    required String email,
    required String name,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    final client = _clients[normalizedEmail];

    if (client == null || name.trim().isEmpty) {
      return false;
    }

    client['name'] = name.trim();
    return true;
  }

  // Mengambil daftar pelanggan tanpa mengekspos password.
  static List<UserModel> getRegisteredClients() {
    return _clients.entries.map((entry) {
      final client = entry.value;

      return UserModel(
        id: entry.key,
        name: client['name'] ?? '',
        email: client['email'] ?? entry.key,
        role: 'Client',
      );
    }).toList(growable: false);
  }

  static bool loginAdmin({
    required String email,
    required String password,
    required String code,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    final admin = _admins[normalizedEmail];

    if (admin == null) return false;

    final matchesPassword = admin['password'] == password;
    final matchesCode =
        admin['code'] == code.trim() || code.trim() == adminCode;

    return matchesPassword && matchesCode;
  }
}