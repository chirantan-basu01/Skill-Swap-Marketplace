import 'package:cloud_firestore/cloud_firestore.dart';

/// Configuration for pagination
class PaginationConfig {
  /// Number of items to fetch per page
  final int pageSize;

  /// Maximum total items to fetch (for memory management)
  final int maxItems;

  const PaginationConfig({
    this.pageSize = 20,
    this.maxItems = 200,
  });

  static const defaultConfig = PaginationConfig();
}

/// State for paginated data
class PaginatedState<T> {
  /// The list of items loaded so far
  final List<T> items;

  /// Whether we're currently loading
  final bool isLoading;

  /// Whether there are more items to load
  final bool hasMore;

  /// Error message if any
  final String? error;

  /// The last document snapshot for cursor-based pagination
  final DocumentSnapshot? lastDocument;

  /// Total items loaded
  int get itemCount => items.length;

  /// Whether this is the initial load (no items yet)
  bool get isInitialLoad => items.isEmpty && isLoading;

  /// Whether we can load more
  bool get canLoadMore => hasMore && !isLoading;

  const PaginatedState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.lastDocument,
  });

  PaginatedState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? hasMore,
    String? error,
    bool clearError = false,
    DocumentSnapshot? lastDocument,
    bool clearLastDocument = false,
  }) {
    return PaginatedState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      lastDocument: clearLastDocument ? null : (lastDocument ?? this.lastDocument),
    );
  }

  /// Create initial loading state
  factory PaginatedState.loading() {
    return const PaginatedState(isLoading: true);
  }

  /// Create error state
  factory PaginatedState.error(String message) {
    return PaginatedState(error: message, isLoading: false, hasMore: false);
  }

  /// Reset to initial state
  PaginatedState<T> reset() {
    return const PaginatedState();
  }
}

/// Helper class for building paginated Firestore queries
class PaginatedQuery {
  /// Create a query with pagination support
  static Query<Map<String, dynamic>> withPagination(
    Query<Map<String, dynamic>> baseQuery, {
    required int limit,
    DocumentSnapshot? startAfter,
  }) {
    var query = baseQuery.limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    return query;
  }
}