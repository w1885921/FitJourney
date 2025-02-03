import 'dart:convert';

import 'dart:developer';

class ApiError {
  final Error error;
  ApiError({
    required this.error,
  });

  ApiError copyWith({
    Error? error,
  }) {
    return ApiError(
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'error': error.toMap(),
    };
  }

  factory ApiError.fromMap(Map<String, dynamic> map) {
    return ApiError(
      error: Error.fromMap(map['error']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiError.fromJson(String source) {
    log('Error:\n$source');
    return ApiError.fromMap(json.decode(source));
  }

  @override
  String toString() => 'ApiError(error: $error)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApiError && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

class Error {
  final String code;
  final String label;
  final String message;
  final String debugger;
  Error({
    this.code = '',
    this.label = 'ERROR',
    this.message = '',
    this.debugger = '',
  });

  Error copyWith({
    String? code,
    String? label,
    String? message,
    String? debugger,
  }) {
    return Error(
      code: code ?? this.code,
      label: label ?? this.label,
      message: message ?? this.message,
      debugger: debugger ?? this.debugger,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'label': label,
      'message': message,
      'debugger': debugger,
    };
  }

  factory Error.fromMap(Map<String, dynamic> map) {
    return Error(
      code: map['code'] ?? '',
      label: map['label'] ?? '',
      message: map['message'] ?? '',
      debugger: map['debugger'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Error.fromJson(String source) => Error.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Error(code: $code, label: $label, message: $message, debugger: $debugger)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Error &&
        other.code == code &&
        other.label == label &&
        other.message == message &&
        other.debugger == debugger;
  }

  @override
  int get hashCode {
    return code.hashCode ^
        label.hashCode ^
        message.hashCode ^
        debugger.hashCode;
  }
}
