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
firebase login

# Deploy rules
firebase deploy --only firestore:rules
```

---

## 2. Seed Categories

### Option A: In-App Seeding (Recommended)

The app has a built-in seeder accessible from the Settings screen (debug mode only):

1. Run the app in **debug mode**
2. Go to **Profile** → **Settings**
3. Scroll down to **Developer** section
4. Tap **"Seed Categories"**

This uses `lib/core/utils/firestore_seeder.dart` which seeds all 7 categories with 14-15 skills each.

**To reseed (delete and recreate):** Tap **"Reseed Categories"**

### Option B: Firebase Console (Manual)

Create these 7 documents in the `categories` collection:

| Document ID | name | icon | order |
|-------------|------|------|-------|
| technology | Technology | 💻 | 1 |
| creative | Creative | 🎨 | 2 |
| music | Music | 🎵 | 3 |
| languages | Languages | 🌍 | 4 |
| business | Business | 💼 | 5 |
| lifestyle | Lifestyle | 🧘 | 6 |
| academic | Academic | 📚 | 7 |

Each document should have a `skills` array. See full skill lists below.

---

## 3. Category Skills Reference

### Technology (💻)
Python, JavaScript, Flutter, React, iOS Development, Android Development, Web Development, Data Science, Machine Learning, Cloud Computing, Cybersecurity, DevOps, UI/UX Design, Database Management, Blockchain

### Creative (🎨)
Graphic Design, Photography, Video Editing, Illustration, Animation, 3D Modeling, Painting, Drawing, Calligraphy, Pottery, Knitting, Jewelry Making, Woodworking, Interior Design

### Music (🎵)
Piano, Guitar, Violin, Drums, Singing, Music Production, DJ Skills, Music Theory, Songwriting, Bass Guitar, Ukulele, Saxophone, Flute, Audio Engineering

### Languages (🌍)
English, Spanish, French, German, Mandarin Chinese, Japanese, Korean, Italian, Portuguese, Arabic, Hindi, Russian, Sign Language, Dutch

### Business (💼)
Marketing, Sales, Accounting, Project Management, Public Speaking, Negotiation, Leadership, Entrepreneurship, Financial Planning, Business Strategy, Content Marketing, SEO, Social Media Marketing, E-commerce

### Lifestyle (🧘)
Yoga, Meditation, Fitness Training, Nutrition, Cooking, Baking, Gardening, Home Organization, Fashion Styling, Makeup, Personal Training, Life Coaching, Mindfulness, Dance

### Academic (📚)
Mathematics, Physics, Chemistry, Biology, History, Literature, Philosophy, Economics, Psychology, Statistics, Writing, Research Methods, SAT/ACT Prep, Essay Writing

---

## 4. Verify Setup

After seeding, verify:

1. **Categories**: Check that all 7 categories appear in Firestore Console
2. **Skills**: Each category should have 14-15 skills in the `skills` array
3. **App**: Home screen should show category tiles with correct emojis

---

## 5. Collection Structure

```
firestore/
├── users/{userId}
│   ├── displayName, email, photoUrl
│   ├── skillsOffered[], skillsWanted[]
│   ├── rating { average, count }
│   ├── credits, swapsCompleted
│   └── lastActiveAt, createdAt
│
├── categories/{categoryId}
│   ├── name, icon, order
│   └── skills[] { name, categoryId }
│
├── swaps/{swapId}
│   ├── requesterId, providerId
│   ├── requesterSkill, providerSkill
│   ├── status, duration
│   └── createdAt, updatedAt
│
├── chats/{chatId}
│   ├── participants[], swapId
│   ├── lastMessage, lastMessageAt
│   └── messages/{messageId}
│       ├── senderId, content, type
│       └── createdAt, readAt
│
├── transactions/{transactionId}
│   ├── userId, type, amount
│   ├── relatedSwapId, description
│   └── createdAt
│
└── reports/{reportId}
    ├── reporterId, reportedUserId
    ├── reason, description
    └── status, createdAt
```

---

## 6. Firestore Indexes

Indexes will be created automatically as you develop. When you see an error like:
```
The query requires an index. You can create it here: [link]
```
Click the link to create the required index.

### Common indexes needed:
- `users`: (status, lastActiveAt DESC)
- `swaps`: (requesterId, status) and (providerId, status)
- `chats`: (participants, updatedAt DESC)
- `transactions`: (userId, createdAt DESC)

---

## 7. Match Algorithm

The app uses a sophisticated match algorithm to recommend users:

| Component | Max Points | Description |
|-----------|-----------|-------------|
| Skill Overlap | 50 | Perfect match (bidirectional) = 40+, One-way = 20+ |
| Rating | 20 | User's star rating scaled to points |
| Activity | 15 | Recent activity bonus (today = 15, yesterday = 12, etc.) |
| Experience | 15 | Completed swaps count (capped at 15) |

**Perfect Match**: Both users teach what the other wants to learn.

See `lib/core/utils/match_calculator.dart` for implementation details.