import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_swap_marketplace/core/constants/firestore_constants.dart';

/// Utility to seed initial data to Firestore
class FirestoreSeeder {
  FirestoreSeeder._();

  static final _firestore = FirebaseFirestore.instance;

  /// Seed all categories with their skills
  /// Call this once from settings/debug screen or on first app launch
  static Future<void> seedCategories() async {
    final categoriesRef = _firestore.collection(FirestoreCollections.categories);

    // Check if categories already exist
    final existing = await categoriesRef.limit(1).get();
    if (existing.docs.isNotEmpty) {
      print('Categories already seeded, skipping...');
      return;
    }

    final categories = _getCategories();

    final batch = _firestore.batch();
    for (final category in categories) {
      final docRef = categoriesRef.doc(category['id'] as String);
      batch.set(docRef, category);
    }

    await batch.commit();
    print('Successfully seeded ${categories.length} categories');
  }

  /// Force re-seed categories (deletes existing and re-creates)
  static Future<void> reseedCategories() async {
    final categoriesRef = _firestore.collection(FirestoreCollections.categories);

    // Delete existing
    final existing = await categoriesRef.get();
    final deleteBatch = _firestore.batch();
    for (final doc in existing.docs) {
      deleteBatch.delete(doc.reference);
    }
    await deleteBatch.commit();

    // Seed fresh
    final categories = _getCategories();
    final batch = _firestore.batch();
    for (final category in categories) {
      final docRef = categoriesRef.doc(category['id'] as String);
      batch.set(docRef, category);
    }
    await batch.commit();
    print('Successfully re-seeded ${categories.length} categories');
  }

  static List<Map<String, dynamic>> _getCategories() {
    return [
      {
        'id': 'technology',
        'name': 'Technology',
        'icon': '💻',
        'order': 1,
        'skills': [
          {'name': 'Python', 'categoryId': 'technology'},
          {'name': 'JavaScript', 'categoryId': 'technology'},
          {'name': 'Flutter', 'categoryId': 'technology'},
          {'name': 'React', 'categoryId': 'technology'},
          {'name': 'iOS Development', 'categoryId': 'technology'},
          {'name': 'Android Development', 'categoryId': 'technology'},
          {'name': 'Web Development', 'categoryId': 'technology'},
          {'name': 'Data Science', 'categoryId': 'technology'},
          {'name': 'Machine Learning', 'categoryId': 'technology'},
          {'name': 'Cloud Computing', 'categoryId': 'technology'},
          {'name': 'Cybersecurity', 'categoryId': 'technology'},
          {'name': 'DevOps', 'categoryId': 'technology'},
          {'name': 'UI/UX Design', 'categoryId': 'technology'},
          {'name': 'Database Management', 'categoryId': 'technology'},
          {'name': 'Blockchain', 'categoryId': 'technology'},
        ],
      },
      {
        'id': 'creative',
        'name': 'Creative',
        'icon': '🎨',
        'order': 2,
        'skills': [
          {'name': 'Graphic Design', 'categoryId': 'creative'},
          {'name': 'Photography', 'categoryId': 'creative'},
          {'name': 'Video Editing', 'categoryId': 'creative'},
          {'name': 'Illustration', 'categoryId': 'creative'},
          {'name': 'Animation', 'categoryId': 'creative'},
          {'name': '3D Modeling', 'categoryId': 'creative'},
          {'name': 'Painting', 'categoryId': 'creative'},
          {'name': 'Drawing', 'categoryId': 'creative'},
          {'name': 'Calligraphy', 'categoryId': 'creative'},
          {'name': 'Pottery', 'categoryId': 'creative'},
          {'name': 'Knitting', 'categoryId': 'creative'},
          {'name': 'Jewelry Making', 'categoryId': 'creative'},
          {'name': 'Woodworking', 'categoryId': 'creative'},
          {'name': 'Interior Design', 'categoryId': 'creative'},
        ],
      },
      {
        'id': 'music',
        'name': 'Music',
        'icon': '🎵',
        'order': 3,
        'skills': [
          {'name': 'Piano', 'categoryId': 'music'},
          {'name': 'Guitar', 'categoryId': 'music'},
          {'name': 'Violin', 'categoryId': 'music'},
          {'name': 'Drums', 'categoryId': 'music'},
          {'name': 'Singing', 'categoryId': 'music'},
          {'name': 'Music Production', 'categoryId': 'music'},
          {'name': 'DJ Skills', 'categoryId': 'music'},
          {'name': 'Music Theory', 'categoryId': 'music'},
          {'name': 'Songwriting', 'categoryId': 'music'},
          {'name': 'Bass Guitar', 'categoryId': 'music'},
          {'name': 'Ukulele', 'categoryId': 'music'},
          {'name': 'Saxophone', 'categoryId': 'music'},
          {'name': 'Flute', 'categoryId': 'music'},
          {'name': 'Audio Engineering', 'categoryId': 'music'},
        ],
      },
      {
        'id': 'languages',
        'name': 'Languages',
        'icon': '🌍',
        'order': 4,
        'skills': [
          {'name': 'English', 'categoryId': 'languages'},
          {'name': 'Spanish', 'categoryId': 'languages'},
          {'name': 'French', 'categoryId': 'languages'},
          {'name': 'German', 'categoryId': 'languages'},
          {'name': 'Mandarin Chinese', 'categoryId': 'languages'},
          {'name': 'Japanese', 'categoryId': 'languages'},
          {'name': 'Korean', 'categoryId': 'languages'},
          {'name': 'Italian', 'categoryId': 'languages'},
          {'name': 'Portuguese', 'categoryId': 'languages'},
          {'name': 'Arabic', 'categoryId': 'languages'},
          {'name': 'Hindi', 'categoryId': 'languages'},
          {'name': 'Russian', 'categoryId': 'languages'},
          {'name': 'Sign Language', 'categoryId': 'languages'},
          {'name': 'Dutch', 'categoryId': 'languages'},
        ],
      },
      {
        'id': 'business',
        'name': 'Business',
        'icon': '💼',
        'order': 5,
        'skills': [
          {'name': 'Marketing', 'categoryId': 'business'},
          {'name': 'Sales', 'categoryId': 'business'},
          {'name': 'Accounting', 'categoryId': 'business'},
          {'name': 'Project Management', 'categoryId': 'business'},
          {'name': 'Public Speaking', 'categoryId': 'business'},
          {'name': 'Negotiation', 'categoryId': 'business'},
          {'name': 'Leadership', 'categoryId': 'business'},
          {'name': 'Entrepreneurship', 'categoryId': 'business'},
          {'name': 'Financial Planning', 'categoryId': 'business'},
          {'name': 'Business Strategy', 'categoryId': 'business'},
          {'name': 'Content Marketing', 'categoryId': 'business'},
          {'name': 'SEO', 'categoryId': 'business'},
          {'name': 'Social Media Marketing', 'categoryId': 'business'},
          {'name': 'E-commerce', 'categoryId': 'business'},
        ],
      },
      {
        'id': 'lifestyle',
        'name': 'Lifestyle',
        'icon': '🧘',
        'order': 6,
        'skills': [
          {'name': 'Yoga', 'categoryId': 'lifestyle'},
          {'name': 'Meditation', 'categoryId': 'lifestyle'},
          {'name': 'Fitness Training', 'categoryId': 'lifestyle'},
          {'name': 'Nutrition', 'categoryId': 'lifestyle'},
          {'name': 'Cooking', 'categoryId': 'lifestyle'},
          {'name': 'Baking', 'categoryId': 'lifestyle'},
          {'name': 'Gardening', 'categoryId': 'lifestyle'},
          {'name': 'Home Organization', 'categoryId': 'lifestyle'},
          {'name': 'Fashion Styling', 'categoryId': 'lifestyle'},
          {'name': 'Makeup', 'categoryId': 'lifestyle'},
          {'name': 'Personal Training', 'categoryId': 'lifestyle'},
          {'name': 'Life Coaching', 'categoryId': 'lifestyle'},
          {'name': 'Mindfulness', 'categoryId': 'lifestyle'},
          {'name': 'Dance', 'categoryId': 'lifestyle'},
        ],
      },
      {
        'id': 'academic',
        'name': 'Academic',
        'icon': '📚',
        'order': 7,
        'skills': [
          {'name': 'Mathematics', 'categoryId': 'academic'},
          {'name': 'Physics', 'categoryId': 'academic'},
          {'name': 'Chemistry', 'categoryId': 'academic'},
          {'name': 'Biology', 'categoryId': 'academic'},
          {'name': 'History', 'categoryId': 'academic'},
          {'name': 'Literature', 'categoryId': 'academic'},
          {'name': 'Philosophy', 'categoryId': 'academic'},
          {'name': 'Economics', 'categoryId': 'academic'},
          {'name': 'Psychology', 'categoryId': 'academic'},
          {'name': 'Statistics', 'categoryId': 'academic'},
          {'name': 'Writing', 'categoryId': 'academic'},
          {'name': 'Research Methods', 'categoryId': 'academic'},
          {'name': 'SAT/ACT Prep', 'categoryId': 'academic'},
          {'name': 'Essay Writing', 'categoryId': 'academic'},
        ],
      },
    ];
  }
}