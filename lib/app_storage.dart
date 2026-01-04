/// Simple local storage wrapper providing key-value storage with type-safe
/// operations, encryption support, and easy data persistence.
///
/// **Key Features:**
/// - `StorageService` main class
/// - Type-safe getters/setters
/// - JSON serialization helpers
/// - Secure storage for sensitive data
/// - Cache expiration support
library;

export 'src/exceptions/storage_exception.dart';
export 'src/secure_storage_service.dart';
export 'src/storage_service.dart';
