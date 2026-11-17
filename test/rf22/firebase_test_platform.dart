// Test-only platform interception: no native plugin, credentials or network.
// These adapters verify application callbacks, NOT Firestore Rules or native retries.
// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';

final testFirestore = MemoryFirestore();
final testAuth = MemoryAuth();
Future<void> initializeTestFirebase() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
  FirebaseFirestorePlatform.instance = testFirestore;
  FirebaseAuthPlatform.instance = testAuth;
  await Firebase.initializeApp();
}

class MemoryFirestore extends FirebaseFirestorePlatform {
  FakeFirebaseFirestore db = FakeFirebaseFirestore();
  Future<void> Function()? beforeRetry;
  bool failCommit = false;
  int attempts = 0;
  void reset(FakeFirebaseFirestore value) {
    db = value;
    beforeRetry = null;
    failCommit = false;
    attempts = 0;
  }

  @override
  FirebaseFirestorePlatform delegateFor({
    required FirebaseApp app,
    required String databaseId,
  }) => this;
  @override
  CollectionReferencePlatform collection(String path) =>
      MemoryCollection(this, path);
  @override
  DocumentReferencePlatform doc(String path) => MemoryDocument(this, path);
  Future<DocumentSnapshotPlatform> read(String path) async =>
      DocumentSnapshotPlatform(
        this,
        path,
        (await db.doc(path).get()).data(),
        InternalSnapshotMetadata(hasPendingWrites: false, isFromCache: false),
      );
  @override
  Future<T?> runTransaction<T>(
    TransactionHandler<T> handler, {
    Duration timeout = const Duration(seconds: 30),
    int maxAttempts = 5,
  }) async {
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      attempts++;
      final transaction = MemoryTransaction(this);
      final result = await handler(transaction);
      final retry = beforeRetry;
      beforeRetry = null;
      if (retry != null) {
        await retry();
        continue;
      }
      if (failCommit) {
        throw StateError('Injected commit failure');
      }
      // Batch only runs after a successful callback. The real atomicity and
      // conflict engine still require Firebase Emulator integration tests.
      final batch = db.batch();
      for (final write in transaction.writes) {
        batch.update(db.doc(write.$1), write.$2);
      }
      await batch.commit();
      return result;
    }
    throw StateError('Retry budget exhausted');
  }
}

class MemoryCollection extends CollectionReferencePlatform {
  MemoryCollection(MemoryFirestore super.firestore, super.path);
  @override
  DocumentReferencePlatform doc([String? path]) =>
      firestore.doc('$thisPath/${path ?? "generated"}');
  String get thisPath => path;
}

class MemoryDocument extends DocumentReferencePlatform {
  MemoryDocument(MemoryFirestore super.firestore, super.path);
  @override
  Future<DocumentSnapshotPlatform> get([
    GetOptions options = const GetOptions(),
  ]) => (firestore as MemoryFirestore).read(path);
}

class MemoryTransaction extends TransactionPlatform {
  final MemoryFirestore store;
  final writes = <(String, Map<String, dynamic>)>[];
  MemoryTransaction(this.store);
  @override
  Future<DocumentSnapshotPlatform> get(String documentPath) =>
      store.read(documentPath);
  @override
  TransactionPlatform update(
    String documentPath,
    Map<FieldPath, dynamic> data,
  ) {
    writes.add((
      documentPath,
      {
        for (final entry in data.entries)
          entry.key.components.join('.'): entry.value,
      },
    ));
    return this;
  }
}

class MemoryAuth extends FirebaseAuthPlatform {
  String? uid = 'teacher';
  @override
  FirebaseAuthPlatform delegateFor({required FirebaseApp app}) => this;
  @override
  FirebaseAuthPlatform setInitialValues({
    InternalUserDetails? currentUser,
    String? languageCode,
  }) => this;
  @override
  UserPlatform? get currentUser => uid == null ? null : MemoryUser(this, uid!);
}

class MemoryUser extends UserPlatform {
  MemoryUser(MemoryAuth auth, String uid)
    : super(
        auth,
        MemoryMultiFactor(auth),
        InternalUserDetails(
          userInfo: InternalUserInfo(
            uid: uid,
            isAnonymous: false,
            isEmailVerified: true,
          ),
          providerData: [],
        ),
      );
}

class MemoryMultiFactor extends MultiFactorPlatform {
  MemoryMultiFactor(super.auth);
}
