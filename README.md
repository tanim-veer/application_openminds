# OpenMinds

Application mobile de **formation des bénévoles** d'une association : catalogue de formations,
quiz, badges, inscriptions aux sessions et demandes de certification, avec un espace différent
pour les bénévoles, les formateurs et les administrateurs.

Projet d'équipe de BUT Informatique (SAÉ S4, Axe 2 — Exploration technologique mobile).
Ce dépôt est un fork du [dépôt de l'équipe](https://github.com/AKLOUF/SAE_S4).

**Stack** : Flutter (Dart) · Firebase (Authentication, Cloud Firestore, Cloud Messaging) · notifications locales · Provider

---

## 👥 Équipe

- Aklouf Imaddedine — Lead Developer & Architect
- Ali Ben Akremi — Project Manager & Developer
- Tanim Veer — Flutter Developer & Tests
- Adam Mokadem — Developer & Tests
- Paul Aernout — Developer & Docs
- Yassine Bakhtaoui — Developer & Intégration

---

## ✨ Fonctionnalités

À la connexion, chaque utilisateur est redirigé vers l'espace correspondant à son rôle.

**Bénévole**
- Catalogue des formations, avec le détail et les sessions prévues de chacune
- Inscription aux sessions (nombre de places limité)
- Quiz de fin de formation : un score d'au moins 70 % donne un badge
- Parcours personnel : résultats des quiz, badges obtenus, demandes de certification
- Rappels de session par notification

**Formateur**
- Gestion de ses sessions : planification, participants, statut (planifiée, en cours, terminée)

**Administrateur**
- Création de formations
- Calendrier de toutes les sessions
- Validation ou refus des demandes de certification (avec un motif en cas de refus)
- Statistiques et suivi de l'impact du programme

---

## 🏗️ Architecture

```text
lib/
├── main.dart          # Initialisation Firebase, routes par rôle
├── models/            # Formation, Session, QuizResult, Badge, User (conversion Firestore)
├── services/          # Accès Firestore et logique : auth, formations, quiz, certifications, notifications
└── screens/
    ├── benevole/      # Connexion, tableau de bord, catalogue, quiz, parcours, sessions
    ├── formateur/     # Sessions du formateur
    └── admin/         # Création de formations, calendrier, certifications, statistiques, impact
```

Données Firestore : `users`, `sessions` (et leurs `inscrits`), `quiz_results`, `badges`,
`certifications`, `certifications_demandes`, `rappels`.

---

## ▶️ Lancer le projet

Prérequis : [Flutter](https://docs.flutter.dev/get-started/install) (Dart ≥ 3.11) et un appareil ou émulateur **Android**.
La configuration Firebase fournie (`lib/firebase_options.dart`) ne couvre que la plateforme Android.

```bash
flutter pub get
flutter run
```

## ✅ Tests

```bash
flutter test
```

12 tests unitaires couvrent les modèles de données : lecture et écriture Firestore (y compris
les anciens noms de champs), calcul du pourcentage de réussite d'un quiz, places restantes et
session complète.
