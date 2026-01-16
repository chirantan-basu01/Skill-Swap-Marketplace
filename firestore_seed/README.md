# Firestore Setup Guide

## 1. Deploy Security Rules

### Option A: Firebase Console (Recommended for first time)
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project: `skill-swap-marketplace-6e668`
3. Navigate to **Firestore Database** → **Rules**
4. Copy contents of `firestore.rules` and paste
5. Click **Publish**

### Option B: Firebase CLI
```bash
# Make sure you're logged in
firebase login:use basuchirantan001@gmail.com

# Deploy rules
firebase deploy --only firestore:rules
```

---

## 2. Seed Categories

### Option A: Firebase Console (Manual)
1. Go to **Firestore Database** → **Data**
2. Click **Start collection**
3. Collection ID: `categories`
4. Add documents manually using the data from `categories.json`

### Option B: Use the Dart Seed Script
Run this one-time script after implementing the Firebase initialization:

```dart
// lib/scripts/seed_categories.dart
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedCategories() async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();

  final categories = [
    {
      'id': 'technology',
      'name': 'Technology',
      'icon': 'computer',
      'order': 1,
      'skills': [
        {'id': 'flutter', 'name': 'Flutter'},
        {'id': 'dart', 'name': 'Dart'},
        {'id': 'python', 'name': 'Python'},
        // ... add more from categories.json
      ],
    },
    // ... add more categories
  ];

  for (final category in categories) {
    final docRef = firestore.collection('categories').doc(category['id'] as String);
    batch.set(docRef, category);
  }

  await batch.commit();
  print('Categories seeded successfully!');
}
```

### Option C: Quick Manual Setup (7 documents)

Create these 7 documents in the `categories` collection:

| Document ID | name | icon | order |
|-------------|------|------|-------|
| technology | Technology | computer | 1 |
| design | Design | brush | 2 |
| music | Music | music_note | 3 |
| languages | Languages | translate | 4 |
| business | Business | business | 5 |
| lifestyle | Lifestyle | self_improvement | 6 |
| academic | Academic | school | 7 |

Each document should have a `skills` array field with the skills from `categories.json`.

---

## 3. Verify Setup

After deployment, verify:

1. **Rules**: Try to read/write without authentication - should fail
2. **Categories**: Check that all 7 categories appear in Firestore Console

---

## Collection Structure

```
firestore/
├── users/{userId}
├── categories/{categoryId}
├── swaps/{swapId}
├── chats/{chatId}
│   └── messages/{messageId}
├── transactions/{userId}
│   └── history/{transactionId}
└── reports/{reportId}
```

---

## Firestore Indexes

Indexes will be created automatically as you develop. When you see an error like:
```
The query requires an index. You can create it here: [link]
```
Click the link to create the required index.

Common indexes you'll likely need:
- `swaps`: (requesterId, status) and (providerId, status)
- `chats`: (participants, updatedAt)
- `users`: (skillsOffered.skillId, status)