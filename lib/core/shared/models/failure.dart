/// Error model for handling failures across the app
class Failure {
  final String? code;
  final String? message;

  const Failure({
    this.code,
    this.message,
  });

  @override
  String toString() => 'Failure(code: $code, message: $message)';

  /// Factory constructor for Firebase exceptions
  factory Failure.fromFirebase(String code, String? message) {
    return Failure(
      code: code,
      message: _getFirebaseErrorMessage(code) ?? message,
    );
  }

  /// Get user-friendly error messages for common Firebase errors
  static String? _getFirebaseErrorMessage(String code) {
    switch (code) {
      // Auth errors
      case 'email-already-in-use':
        return 'This email is already registered. Please sign in instead.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';

      // Firestore errors
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'unavailable':
        return 'Service temporarily unavailable. Please try again.';
      case 'not-found':
        return 'The requested data was not found.';

      default:
        return null;
    }
  }
}