import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
Singleton Service for interacting with Cloud Firestore
 */
class FirestoreService {
  static final FirestoreService _firestoreService =
      FirestoreService._privateConstructor();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // firestore collection path values
  static const String _survey_response_path = "survey_responses";
  static const String _survey_questions_path = "survey_questions";
  static const String _respnonses_sub_collection_path = "responses";

  factory FirestoreService() {
    return _firestoreService;
  }

  FirestoreService._privateConstructor();

  // get all answeres stored on Firestore
  Stream<List<SurveyResponse>> getSurveyResponses() {
    return _db
        .collection(_respnonses_sub_collection_path)
        // .get() //future
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((doc) => SurveyResponse.fromMap(doc.data()))
            .toList());
  }

  // save single response or answer to Firestore
  Future<void> saveSurveyResponse(SurveyResponse response) {
    return _db
        .collection(_survey_response_path)
        .doc(_auth.currentUser.uid)
        .collection(_respnonses_sub_collection_path)
        .doc()
        .set(response.toMap());
  }

  // save a list or collection of answeres at once to Firestore
  Future<void> saveAllSurveyResponse(List<SurveyResponse> responses) {
    WriteBatch batch = _db.batch();
    for (final res in responses) {
      DocumentReference _docRef = _db
          .collection(_survey_response_path)
          .doc(_auth.currentUser.uid)
          .collection(_respnonses_sub_collection_path)
          .doc();
      batch.set(_docRef, res.toMap());
    }

    batch.commit();
    return null;
  }

  // get list of questions from firestore
  Stream<List<QuestionItem>> getSurveyQuestions() {
    /* the document id from each question is used as a question id when constructing 
      QuestionItem from map values
    */
    return _db
        .collection(_survey_questions_path)
        // .get() //future
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((doc) => QuestionItem.fromMap({
                  ...doc.data(),
                  ...{"id": doc.id}
                }))
            .toList());
  }
}
