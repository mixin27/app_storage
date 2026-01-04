import 'package:app_storage/app_storage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  await StorageService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppStorage Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const StorageDemoPage(),
    );
  }
}

class StorageDemoPage extends StatefulWidget {
  const StorageDemoPage({super.key});

  @override
  State<StorageDemoPage> createState() => _StorageDemoPageState();
}

class _StorageDemoPageState extends State<StorageDemoPage> {
  final storage = StorageService.instance;
  final secureStorage = SecureStorageService.instance;

  String _output = '';

  void _log(String message) {
    setState(() {
      _output += '$message\n';
    });
  }

  Future<void> _runBasicExamples() async {
    setState(() => _output = '--- Basic Storage Examples ---\n');

    try {
      // Save primitives
      await storage.save('user_id', '12345');
      await storage.save('age', 25);
      await storage.save('height', 5.9);
      await storage.save('is_active', true);
      _log('✓ Saved primitives');

      // Retrieve primitives
      final userId = await storage.get<String>('user_id');
      final age = await storage.get<int>('age');
      final height = await storage.get<double>('height');
      final isActive = await storage.get<bool>('is_active');
      _log('Retrieved: ID=$userId, Age=$age, Height=$height, Active=$isActive');

      // Save lists
      await storage.save('subjects', ['Math', 'Science', 'English']);
      await storage.save('grades', [85, 92, 78, 95]);
      _log('✓ Saved lists');

      // Retrieve lists
      final subjects = await storage.get<List<String>>('subjects');
      final grades = await storage.get<List<int>>('grades');
      _log('Subjects: $subjects');
      _log('Grades: $grades');

      // Save map (JSON)
      await storage.save('user_data', {
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': 'student',
        'enrolled': true,
      });
      _log('✓ Saved user data map');

      // Retrieve map
      final userData = await storage.get<Map<String, dynamic>>('user_data');
      _log('User Data: $userData');

      // Check key existence
      final exists = await storage.containsKey('user_id');
      _log('Key "user_id" exists: $exists');

      // Get all keys
      final keys = await storage.getKeys();
      _log('All keys: $keys');
    } catch (e) {
      _log('Error: $e');
    }
  }

  Future<void> _runSecureStorageExamples() async {
    setState(() => _output = '--- Secure Storage Examples ---\n');

    try {
      // Save sensitive data
      await secureStorage.save(
        'auth_token',
        'jwt_eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
      );
      await secureStorage.save('api_key', 'sk_live_1234567890abcdef');
      await secureStorage.save('password', 'MySecureP@ssw0rd!');
      _log('✓ Saved secure credentials');

      // Retrieve secure data
      final authToken = await secureStorage.get<String>('auth_token');
      final apiKey = await secureStorage.get<String>('api_key');
      _log('Auth Token: ${authToken?.substring(0, 20)}...');
      _log('API Key: ${apiKey?.substring(0, 15)}...');

      // Save secure user preferences
      await secureStorage.save('user_preferences', {
        'theme': 'dark',
        'notifications_enabled': true,
        'biometric_auth': true,
      });
      _log('✓ Saved secure preferences');

      // Retrieve secure preferences
      final prefs = await secureStorage.get<Map<String, dynamic>>(
        'user_preferences',
      );
      _log('Preferences: $prefs');

      // Check secure key
      final hasToken = await secureStorage.containsKey('auth_token');
      _log('Has auth token: $hasToken');
    } catch (e) {
      _log('Error: $e');
    }
  }

  Future<void> _runTTLExample() async {
    setState(() => _output = '--- TTL (Time-To-Live) Example ---\n');

    try {
      // Save with 5 second TTL
      await storage.save('temp_token', 'temporary_value', ttl: 5);
      _log('✓ Saved with 5 second TTL');

      // Immediate read
      var value = await storage.get<String>('temp_token');
      _log('Immediately after save: $value');

      // Wait 3 seconds
      _log('Waiting 3 seconds...');
      await Future.delayed(const Duration(seconds: 3));
      value = await storage.get<String>('temp_token');
      _log('After 3 seconds: $value');

      // Wait 3 more seconds (total 6)
      _log('Waiting 3 more seconds...');
      await Future.delayed(const Duration(seconds: 3));
      value = await storage.get<String>('temp_token');
      _log('After 6 seconds (expired): $value');
    } catch (e) {
      _log('Error: $e');
    }
  }

  Future<void> _runComplexObjectExample() async {
    setState(() => _output = '--- Complex Object Example ---\n');

    try {
      // Student model as map
      final student = {
        'id': 'STU001',
        'name': 'Alice Smith',
        'grade': 10,
        'subjects': ['Math', 'Physics', 'Chemistry'],
        'scores': {'Math': 95, 'Physics': 88, 'Chemistry': 92},
        'metadata': {'enrollment_date': '2024-01-15', 'guardian': 'Jane Smith'},
      };

      await storage.save('student_profile', student);
      _log('✓ Saved complex student object');

      final retrieved = await storage.get<Map<String, dynamic>>(
        'student_profile',
      );
      _log('Retrieved student:');
      _log('  Name: ${retrieved?['name']}');
      _log('  Grade: ${retrieved?['grade']}');
      _log('  Subjects: ${retrieved?['subjects']}');
      _log('  Scores: ${retrieved?['scores']}');
    } catch (e) {
      _log('Error: $e');
    }
  }

  Future<void> _clearStorage() async {
    setState(() => _output = '--- Clearing Storage ---\n');

    try {
      await storage.clear();
      await secureStorage.clear();
      _log('✓ All storage cleared');

      final keys = await storage.getKeys();
      final secureKeys = await secureStorage.getKeys();
      _log('Regular storage keys: $keys');
      _log('Secure storage keys: $secureKeys');
    } catch (e) {
      _log('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('LMS Storage Demo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _runBasicExamples,
                  child: const Text('Basic Storage'),
                ),
                ElevatedButton(
                  onPressed: _runSecureStorageExamples,
                  child: const Text('Secure Storage'),
                ),
                ElevatedButton(
                  onPressed: _runTTLExample,
                  child: const Text('TTL Example'),
                ),
                ElevatedButton(
                  onPressed: _runComplexObjectExample,
                  child: const Text('Complex Object'),
                ),
                ElevatedButton(
                  onPressed: _clearStorage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  _output,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
