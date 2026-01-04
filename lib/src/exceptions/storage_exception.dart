/// Custom exception for storage operations
class StorageException implements Exception {
  /// Error message
  final String message;

  /// Key associated with the error
  final String? key;

  /// Original error that caused the exception
  final dynamic originalError;

  /// Creates a new instance of [StorageException]
  StorageException(this.message, {this.key, this.originalError});

  @override
  String toString() {
    final buffer = StringBuffer('StorageException: $message');
    if (key != null) {
      buffer.write(' (key: $key)');
    }
    if (originalError != null) {
      buffer.write('\nOriginal error: $originalError');
    }
    return buffer.toString();
  }
}

/// Exception for type mismatch errors
class TypeMismatchException extends StorageException {
  /// Expected type
  final Type expectedType;

  /// Actual type
  final Type actualType;

  /// Creates a new instance of [TypeMismatchException]
  TypeMismatchException(this.expectedType, this.actualType, {String? key})
    : super(
        'Type mismatch: expected $expectedType but got $actualType',
        key: key,
      );
}

/// Exception for serialization errors
class SerializationException extends StorageException {
  /// Creates a new instance of [SerializationException]
  SerializationException(super.message, {super.key, super.originalError});
}
