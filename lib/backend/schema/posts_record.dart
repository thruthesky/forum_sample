import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'posts_record.g.dart';

abstract class PostsRecord implements Built<PostsRecord, PostsRecordBuilder> {
  static Serializer<PostsRecord> get serializer => _$postsRecordSerializer;

  String? get category;

  DocumentReference? get userDocumentReference;

  String? get title;

  String? get content;

  DateTime? get createdAt;

  int? get noOfComments;

  BuiltList<DocumentReference>? get likes;

  BuiltList<String>? get files;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(PostsRecordBuilder builder) => builder
    ..category = ''
    ..title = ''
    ..content = ''
    ..noOfComments = 0
    ..likes = ListBuilder()
    ..files = ListBuilder();

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('posts');

  static Stream<PostsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<PostsRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  PostsRecord._();
  factory PostsRecord([void Function(PostsRecordBuilder) updates]) =
      _$PostsRecord;

  static PostsRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createPostsRecordData({
  String? category,
  DocumentReference? userDocumentReference,
  String? title,
  String? content,
  DateTime? createdAt,
  int? noOfComments,
}) {
  final firestoreData = serializers.toFirestore(
    PostsRecord.serializer,
    PostsRecord(
      (p) => p
        ..category = category
        ..userDocumentReference = userDocumentReference
        ..title = title
        ..content = content
        ..createdAt = createdAt
        ..noOfComments = noOfComments
        ..likes = null
        ..files = null,
    ),
  );

  return firestoreData;
}
