import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'LocalStorageService.dart';
import 'ServiceLocator.dart';

/*
Singleton Service for interacting with Cloud Firestore
 */
class FirestoreService {
  static final FirestoreService _firestoreService =
      FirestoreService._privateConstructor();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // firestore collection path values
  static const String _survey_response_path = "survey_responses";
  static const String _survey_questions_path = "survey_questions";

  factory FirestoreService() {
    return _firestoreService;
  }

  FirestoreService._privateConstructor();

  // get all responses or answeres submitted by all users
  Stream<List<SurveyResponse>> getAllSurveyResponses() {
    return _db
        .collection(_survey_response_path)
        // .get() //future
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((doc) => SurveyResponse.fromMap(doc.data()))
            .toList());
  }

  /* get all response values answered by current anonymous user
    users data is stored under random ids and response don't contain identifying information
    so user's anonymity and privacy is secured
  */
  Stream<List<SurveyResponse>> getCurrentUserSurveyResponses() {
    return _db
        .collection(_survey_response_path)
        .where("userId",
            isEqualTo: locator<LocalStorageService>().anonymousUserId)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((doc) => SurveyResponse.fromMap(doc.data()))
            .toList());
  }

  // save single response or answer to Firestore
  Future<void> saveSurveyResponse(SurveyResponse response) {
    return _db.collection(_survey_response_path).doc().set(response.toMap());
  }

  // save a list or collection of answeres at once to Firestore
  Future<void> saveAllSurveyResponse(List<SurveyResponse> responses) {
    WriteBatch batch = _db.batch();
    for (final res in responses) {
      DocumentReference _docRef = _db.collection(_survey_response_path).doc();
      batch.set(_docRef, res.toMap());
    }

    batch.commit();
    return null;
  }

  // get list of questions from firestore, returns all questions from 'survey_questions' collections
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

  // get single question by id from survey_questions collection
  Stream<QuestionItem> getQuestionById(String questionId) {
    return _db
        .collection(_survey_questions_path)
        .doc(questionId)
        .snapshots()
        .map((snapshots) => QuestionItem.fromMap({
              ...snapshots.data(),
              ...{"id": snapshots.id}
            }));
  }
}