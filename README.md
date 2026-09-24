# OpenMinds

Application mobile de **formation des bénévoles** sur des thématiques citoyennes (inclusion,
environnement, égalité, tolérance, citoyenneté) : catalogue de formations, inscription aux
sessions, quiz, badges et certifications, avec un espace dédié aux bénévoles, aux formateurs et
aux administrateurs.

Proof of Concept réalisé en équipe de 6 pour la **SAÉ S4-01** du BUT Informatique (IUT Paris
Rives de Seine, Université Paris Cité), à partir d'un cahier des charges de l'association
**France Bénévolat**. Rendu le 5 avril 2026.
Ce dépôt est un fork du [dépôt de l'équipe](https://github.com/AKLOUF/SAE_S4).

**Stack** : Flutter (Dart) · Firebase Authentication · Cloud Firestore (temps réel) · notifications locales

---

## 🎯 Problématique

Il n'existait pas d'outil moderne et centralisé pour former les bénévoles à ces thématiques.
Comment concevoir une application mobile accessible qui leur permette de se former, tout en
donnant aux formateurs et aux administrateurs les outils pour piloter et suivre ces formations ?

---

## ✨ Fonctionnalités

À la connexion, chaque utilisateur est redirigé vers l'espace correspondant à son rôle.

**Bénévole**
- Création de compte et connexion
- Catalogue des formations par thématique, avec le détail et les sessions de chacune
- Inscription aux sessions (places limitées), avec rappel par notification avant la session
- Quiz de validation avec correction immédiate : un score d'au moins 70 % donne un badge
- Tableau de bord : badges obtenus et résultats des quiz
- Parcours de certification : une certification OpenMinds par thématique, une fois toutes les formations associées validées

**Formateur**
- Suivi en temps réel de ses sessions et de la liste des inscrits
- Création de sessions (formation, date, horaires, nombre maximum de participants)
- Validation de la présence des bénévoles, qui leur attribue automatiquement un badge de participation
- Inscription manuelle de bénévoles à une session

**Administrateur**
- Tableau de bord avec compteurs en temps réel : bénévoles, formations, formateurs, sessions
- Création de formations, avec leur thématique et leurs sessions
- Calendrier mensuel des sessions à venir
- Page « Impact » : taux de participation, taux de réussite aux quiz, progression des bénévoles, formations les plus suivies
- Validation ou refus des demandes de certification (avec un motif en cas de refus)

### User stories implémentées (13)

| US | Profil | Description |
|---|---|---|
| US-01 | Bénévole | Créer un compte et se connecter à un espace personnalisé |
| US-02 | Bénévole | Consulter le catalogue des formations par thématique |
| US-03 | Bénévole | S'inscrire à une session et recevoir un rappel |
| US-04 | Bénévole | Accéder au contenu d'une formation et faire le quiz |
| US-06 | Bénévole | Valider une formation par quiz, avec score et badge |
| US-08 | Bénévole | Consulter sa progression (badges, résultats) |
| US-10 | Bénévole | Suivre un parcours complet et obtenir une certification |
| US-11 | Formateur | Voir en temps réel les participants inscrits à ses sessions |
| US-12 | Formateur | Valider la présence d'un bénévole, ce qui déclenche un badge |
| US-15 | Admin | Créer des formations, leurs thématiques et leurs sessions |
| US-16 | Admin | Gérer le calendrier des sessions |
| US-17 | Admin | Suivre les statistiques globales |
| US-18 | Admin | Valider et gérer les certifications |

---

## 🏗️ Architecture

Architecture en trois couches : **écrans Flutter** (par profil), **services** (logique métier et
accès aux données), **Firebase** (authentification et base Firestore). Les écrans écoutent les
données Firestore en temps réel via `StreamBuilder` : un changement (inscription, validation…)
se répercute immédiatement chez tous les utilisateurs concernés.

```text
lib/
├── main.dart          # Initialisation Firebase, routes par rôle
├── models/            # Formation, Session, QuizResult, Badge, User (conversion Firestore)
├── services/          # AuthService, FormationService, QuizService, CertificationService, NotificationService
└── screens/
    ├── benevole/      # Connexion (commune aux 3 rôles), tableau de bord, catalogue, détail, quiz, parcours, sessions
    ├── formateur/     # Sessions et participants
    └── admin/         # Statistiques, création de formations, calendrier, impact, certifications
```

**Données Firestore**
- `users` : profil et rôle, avec les sous-collections `badges`, `quiz_results` et `certifications`
- `formations` : titre, description, thématique, formateur, date de création, statut actif
- `sessions` : formation, date, horaires, nombre maximum de participants, statut, avec la sous-collection `inscrits`

Les règles de sécurité Firestore (accès par rôle) sont configurées dans la console Firebase et
ne sont pas versionnées dans ce dépôt.

---

## 🧩 Difficultés rencontrées

| Problème | Solution |
|---|---|
| Index composites Firestore manquants (`where` + `orderBy`) | Tri effectué côté client en Dart |
| Compteurs de sessions bloqués à 0 après une inscription | Lecture en temps réel de la sous-collection `inscrits` plutôt que d'un champ dénormalisé |
| Taux de réussite aux quiz toujours à 0 dans l'écran Impact | Lecture depuis la sous-collection `users/{uid}/quiz_results` au lieu d'une collection racine inexistante |
| Erreurs silencieuses à l'inscription | Affichage du vrai message d'erreur Firebase et validation côté client (nom obligatoire, mot de passe de 6 caractères minimum) |
| Coordination de 6 développeurs | Branches par fonctionnalité et revues de code croisées avant chaque fusion |

---

## 👥 Équipe

| Membre | Rôle | Responsabilités principales |
|---|---|---|
| Aklouf Imaddedine | Lead Developer & Architect | Architecture Firebase, authentification multi-rôle, coordination Git |
| Ali Ben Akremi | Project Manager & Developer | Espace bénévole (catalogue, détail, quiz), logique de scoring et de certification |
| **Tanim Veer** | **Flutter Developer & Tests** | **Tableau de bord bénévole (flux Firestore imbriqués), écran de détail des formations, intégration Firestore temps réel, tests de non-régression** |
| Adam Mokadem | Developer & Tests | Interface formateur (participants, présences), tests fonctionnels, suivi des bugs |
| Paul Aernout | Developer & Docs | Tableau de bord administrateur et statistiques, documentation, rapport |
| Yassine Bakhtaoui | Developer & Intégration | Écran de création de formation, configuration Firebase et génération de l'APK |

L'équipe a utilisé l'IA (Claude, ChatGPT) comme assistant pour apprendre Flutter/Dart, générer du
code de base et déboguer. Chaque suggestion était relue et testée avant d'être intégrée,
notamment à cause d'API Firebase parfois inventées par l'IA.

---

## ▶️ Lancer le projet

Prérequis : [Flutter](https://docs.flutter.dev/get-started/install) (Dart ≥ 3.11) et un appareil ou émulateur **Android**.
La configuration Firebase fournie (`lib/firebase_options.dart`) ne couvre que la plateforme Android.

```bash
flutter pub get
flutter run
```

## ✅ Tests

- **Tests fonctionnels** (pendant le projet) : 8 scénarios validés manuellement sur Android, dont
  le parcours complet d'un bénévole (inscription → session → quiz → badge → certification), les
  cas de refus (session complète, mauvais mot de passe) et la mise à jour en temps réel des
  compteurs administrateur.
- **Tests unitaires** (ajoutés après le rendu) : 12 tests sur les modèles de données — lecture et
  écriture Firestore (y compris les anciens noms de champs), pourcentage de réussite d'un quiz,
  places restantes et session complète.

```bash
flutter test
```

---

## 🔭 Perspectives

- Notifications push via Firebase Cloud Messaging (US-09)
- Mode hors ligne (US-05)
- Génération d'attestations PDF (US-07)
- Contenus plus riches dans les formations (vidéos, ressources)
- Publication sur le Google Play Store et l'App Store
