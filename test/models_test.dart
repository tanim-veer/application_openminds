import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openminds/models/badge_model.dart';
import 'package:openminds/models/formation_model.dart';
import 'package:openminds/models/quiz_result_model.dart';
import 'package:openminds/models/session_model.dart';
import 'package:openminds/models/user_model.dart';

void main() {
  final date = DateTime(2026, 3, 20, 9, 30);

  group('FormationModel', () {
    test('lit une formation complète depuis Firestore', () {
      final f = FormationModel.fromFirestore({
        'titre': 'Accueil du public',
        'description': 'Bases de l\'accueil',
        'formateurId': 'f1',
        'dateCreation': Timestamp.fromDate(date),
        'thematique': 'accueil',
        'isActive': false,
      }, 'id1');

      expect(f.id, 'id1');
      expect(f.titre, 'Accueil du public');
      expect(f.dateCreation, date);
      expect(f.categories, ['accueil']);
      expect(f.isActive, isFalse);
    });

    test('accepte les anciens noms de champs (createdBy, createdAt)', () {
      final f = FormationModel.fromFirestore({
        'createdBy': 'f2',
        'createdAt': Timestamp.fromDate(date),
      }, 'id2');

      expect(f.formateurId, 'f2');
      expect(f.dateCreation, date);
      expect(f.categories, ['inclusion']);
      expect(f.isActive, isTrue);
    });

    test('toMap réécrit la catégorie dans le champ thematique', () {
      final f = FormationModel(
        id: 'x',
        titre: 't',
        description: 'd',
        formateurId: 'f',
        dateCreation: date,
        categories: ['numerique'],
        isActive: true,
      );
      expect(f.toMap()['thematique'], 'numerique');
    });
  });

  group('QuizResultModel', () {
    test('calcule le pourcentage de réussite', () {
      final r = QuizResultModel.fromMap({
        'score': 7,
        'totalQuestions': 10,
        'completedAt': Timestamp.fromDate(date),
        'badgeObtenu': true,
      }, 'q1');

      expect(r.pourcentage, closeTo(70, 1e-9));
      expect(r.completedAt, date);
      expect(r.badgeObtenu, isTrue);
    });

    test('un quiz sans question vaut 0 % au lieu de diviser par zéro', () {
      final r = QuizResultModel.fromMap({'score': 0, 'totalQuestions': 0}, 'q2');
      expect(r.pourcentage, 0);
    });
  });

  group('SessionModel', () {
    SessionModel session(int inscrits, {int max = 3}) => SessionModel(
          id: 's',
          formationId: 'f',
          formateurId: 'fo',
          date: date,
          participantsIds: List.generate(inscrits, (i) => 'b$i'),
          statut: 'planifiee',
          maxParticipants: max,
        );

    test('compte les places restantes', () {
      expect(session(1).placesRestantes, 2);
      expect(session(1).estComplet, isFalse);
    });

    test('est complète quand le nombre maximum d\'inscrits est atteint', () {
      expect(session(3).estComplet, isTrue);
      expect(session(3).placesRestantes, 0);
    });

    test('toMap puis fromMap redonne la même session', () {
      final origine = session(2).copyWith(heureDebut: '09:00', heureFin: '11:00');
      final relue = SessionModel.fromMap(origine.toMap(), 's');

      expect(relue.date, origine.date);
      expect(relue.participantsIds, origine.participantsIds);
      expect(relue.heureDebut, '09:00');
      expect(relue.maxParticipants, 3);
    });

    test('lit l\'ancien champ "formation" comme titre de formation', () {
      final s = SessionModel.fromMap({'formation': 'Premiers secours'}, 's');
      expect(s.formationTitre, 'Premiers secours');
      expect(s.statut, 'planifiee');
      expect(s.maxParticipants, 20);
    });

    test('copyWith ne modifie que les champs demandés', () {
      final s = session(1).copyWith(statut: 'terminee');
      expect(s.statut, 'terminee');
      expect(s.participantsIds, ['b0']);
    });
  });

  test('UserModel : un utilisateur sans rôle est bénévole par défaut', () {
    final u = UserModel.fromMap({'email': 'a@b.fr', 'createdAt': Timestamp.fromDate(date)}, 'u1');
    expect(u.role, 'benevole');
    expect(u.createdAt, date);
  });

  test('BadgeModel : lit la date d\'obtention depuis un Timestamp', () {
    final b = BadgeModel.fromMap({'titre': 'Expert', 'obtenuLe': Timestamp.fromDate(date)}, 'b1');
    expect(b.titre, 'Expert');
    expect(b.obtenuLe, date);
  });
}
