import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'comments_record.g.dart';

abstract class CommentsRecord
    implements Built<CommentsRecord, CommentsRecordBuilder> {
  static Serializer<CommentsRecord> get serializer =>
      _$commentsRecordSerializer;

  DocumentReference? get userDocumentReference;

  DocumentReference? get postDocumentReference;

  DateTime? get createdAt;

  int? get noOfComments;

  String? get order;

  int? get depth;

  String? get content;

  BuiltList<String>? get files;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(CommentsRecordBuilder builder) => builder
    ..noOfComments = 0
    ..order = ''
    ..depth = 0
    ..content = ''
    ..files = ListBuilder();

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('comments');

  static Stream<CommentsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<CommentsRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  CommentsRecord._();
  factory CommentsRecord([void Function(CommentsRecordBuilder) updates]) =
      _$CommentsRecord;

  static CommentsRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createCommentsRecordData({
  DocumentReference? userDocumentReference,
  DocumentReference? postDocumentReference,
  DateTime? createdAt,
  int? noOfComments,
  String? order,
  int? depth,
  String? content,
}) {
  final firestoreData = serializers.toFirestore(
    CommentsRecord.serializer,
    CommentsRecord(
      (c) => c
        ..userDocumentReference = userDocumentReference
        ..postDocumentReference = postDocumentReference
        ..createdAt = createdAt
        ..noOfComments = noOfComments
        ..order = order
        ..depth = depth
        ..content = content
        ..files = null,
    ),
  );

  return firestoreData;
}
