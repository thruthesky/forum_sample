import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../components/comment_edit_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../custom_code/widgets/index.dart' as custom_widgets;
import '../flutter_flow/custom_functions.dart' as functions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostViewWidget extends StatefulWidget {
  const PostViewWidget({
    Key? key,
    this.postDocumentReference,
  }) : super(key: key);

  final DocumentReference? postDocumentReference;

  @override
  _PostViewWidgetState createState() => _PostViewWidgetState();
}

class _PostViewWidgetState extends State<PostViewWidget> {
  CommentsRecord? createdChildComment;
  CommentsRecord? createdComment;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PostsRecord>(
      stream: PostsRecord.getDocument(widget.postDocumentReference!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primaryColor,
              ),
            ),
          );
        }
        final postViewPostsRecord = snapshot.data!;
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryColor,
            automaticallyImplyLeading: true,
            title: Text(
              postViewPostsRecord.title!,
              style: FlutterFlowTheme.of(context).title2.override(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 22,
                  ),
            ),
            actions: [],
            centerTitle: false,
            elevation: 2,
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0x3257636C),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                            child: SelectionArea(
                                child: Text(
                              postViewPostsRecord.content!,
                              style: FlutterFlowTheme.of(context).bodyText1,
                            )),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FFButtonWidget(
                                onPressed: () async {
                                  final commentsCreateData =
                                      createCommentsRecordData(
                                    userDocumentReference: currentUserReference,
                                    noOfComments: 0,
                                    createdAt: getCurrentTimestamp,
                                  );
                                  var commentsRecordReference =
                                      CommentsRecord.collection.doc();
                                  await commentsRecordReference
                                      .set(commentsCreateData);
                                  createdComment =
                                      CommentsRecord.getDocumentFromData(
                                          commentsCreateData,
                                          commentsRecordReference);
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: CommentEditWidget(
                                          postDocument: postViewPostsRecord,
                                          commentDocument: createdComment,
                                        ),
                                      );
                                    },
                                  ).then((value) => setState(() {}));

                                  setState(() {});
                                },
                                text: '댓글 작성',
                                options: FFButtonOptions(
                                  height: 40,
                                  color:
                                      FlutterFlowTheme.of(context).primaryColor,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .subtitle2
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                      ),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  if (Navigator.of(context).canPop()) {
                                    context.pop();
                                  }
                                  context.pushNamed(
                                    'PostEdit',
                                    queryParams: {
                                      'postDocument': serializeParam(
                                        postViewPostsRecord,
                                        ParamType.Document,
                                      ),
                                    }.withoutNulls,
                                    extra: <String, dynamic>{
                                      'postDocument': postViewPostsRecord,
                                    },
                                  );
                                },
                                text: '수정',
                                options: FFButtonOptions(
                                  height: 40,
                                  color:
                                      FlutterFlowTheme.of(context).primaryColor,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .subtitle2
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                      ),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  await widget.postDocumentReference!.delete();
                                  context.pop();
                                },
                                text: '삭제',
                                options: FFButtonOptions(
                                  height: 40,
                                  color:
                                      FlutterFlowTheme.of(context).primaryColor,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .subtitle2
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                      ),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                          child: Builder(
                            builder: (context) {
                              final files = postViewPostsRecord.files!.toList();
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    List.generate(files.length, (filesIndex) {
                                  final filesItem = files[filesIndex];
                                  return Image.network(
                                    filesItem,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                }),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: StreamBuilder<List<CommentsRecord>>(
                            stream: queryCommentsRecord(
                              queryBuilder: (commentsRecord) => commentsRecord
                                  .where('postDocumentReference',
                                      isEqualTo: widget.postDocumentReference)
                                  .orderBy('order'),
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryColor,
                                    ),
                                  ),
                                );
                              }
                              List<CommentsRecord>
                                  commentsQueryCommentsRecordList =
                                  snapshot.data!;
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                    commentsQueryCommentsRecordList.length,
                                    (commentsQueryIndex) {
                                  final commentsQueryCommentsRecord =
                                      commentsQueryCommentsRecordList[
                                          commentsQueryIndex];
                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      custom_widgets.CommentIndent(
                                        width: 80,
                                        height: 10,
                                        indent: functions.indent(
                                            commentsQueryCommentsRecord.depth),
                                      ),
                                      Expanded(
                                        child: FutureBuilder<UsersRecord>(
                                          future: UsersRecord.getDocumentOnce(
                                              commentsQueryCommentsRecord
                                                  .userDocumentReference!),
                                          builder: (context, snapshot) {
                                            // Customize what your widget looks like when it's loading.
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child: SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              );
                                            }
                                            final commentAuthorUsersRecord =
                                                snapshot.data!;
                                            return Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 16, 16, 16),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SelectionArea(
                                                        child: Text(
                                                      commentAuthorUsersRecord
                                                          .displayName!,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText1,
                                                    )),
                                                    SelectionArea(
                                                        child: Text(
                                                      commentsQueryCommentsRecord
                                                          .content!,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText1,
                                                    )),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        FFButtonWidget(
                                                          onPressed: () async {
                                                            final commentsCreateData =
                                                                createCommentsRecordData(
                                                              userDocumentReference:
                                                                  currentUserReference,
                                                              noOfComments: 0,
                                                              createdAt:
                                                                  getCurrentTimestamp,
                                                            );
                                                            var commentsRecordReference =
                                                                CommentsRecord
                                                                    .collection
                                                                    .doc();
                                                            await commentsRecordReference
                                                                .set(
                                                                    commentsCreateData);
                                                            createdChildComment =
                                                                CommentsRecord
                                                                    .getDocumentFromData(
                                                                        commentsCreateData,
                                                                        commentsRecordReference);

                                                            final commentsUpdateData =
                                                                {
                                                              'noOfComments':
                                                                  FieldValue
                                                                      .increment(
                                                                          1),
                                                            };
                                                            await commentsQueryCommentsRecord
                                                                .reference
                                                                .update(
                                                                    commentsUpdateData);
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Padding(
                                                                  padding: MediaQuery.of(
                                                                          context)
                                                                      .viewInsets,
                                                                  child:
                                                                      CommentEditWidget(
                                                                    postDocument:
                                                                        postViewPostsRecord,
                                                                    commentDocument:
                                                                        createdChildComment,
                                                                    parentCommentDocument:
                                                                        commentsQueryCommentsRecord,
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                setState(
                                                                    () {}));

                                                            setState(() {});
                                                          },
                                                          text: '댓글',
                                                          options:
                                                              FFButtonOptions(
                                                            height: 40,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryColor,
                                                            textStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .subtitle2
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                        FFButtonWidget(
                                                          onPressed: () async {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Padding(
                                                                  padding: MediaQuery.of(
                                                                          context)
                                                                      .viewInsets,
                                                                  child:
                                                                      CommentEditWidget(
                                                                    commentDocument:
                                                                        commentsQueryCommentsRecord,
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                setState(
                                                                    () {}));
                                                          },
                                                          text: '수정',
                                                          options:
                                                              FFButtonOptions(
                                                            height: 40,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryColor,
                                                            textStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .subtitle2
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
