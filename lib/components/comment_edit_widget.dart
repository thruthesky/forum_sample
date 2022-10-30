import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../flutter_flow/custom_functions.dart' as functions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentEditWidget extends StatefulWidget {
  const CommentEditWidget({
    Key? key,
    this.postDocument,
    this.commentDocument,
    this.parentCommentDocument,
  }) : super(key: key);

  final PostsRecord? postDocument;
  final CommentsRecord? commentDocument;
  final CommentsRecord? parentCommentDocument;

  @override
  _CommentEditWidgetState createState() => _CommentEditWidgetState();
}

class _CommentEditWidgetState extends State<CommentEditWidget> {
  TextEditingController? contentController;

  @override
  void initState() {
    super.initState();
    contentController = TextEditingController();
  }

  @override
  void dispose() {
    contentController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectionArea(
                child: Text(
              '글: ${widget.postDocument!.title}',
              style: FlutterFlowTheme.of(context).bodyText1,
            )),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
              child: TextFormField(
                controller: contentController,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: '코멘트 입력',
                  hintStyle: FlutterFlowTheme.of(context).bodyText2,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: FlutterFlowTheme.of(context).bodyText1,
                maxLines: 6,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FFButtonWidget(
                    onPressed: () async {
                      if (widget.postDocument != null) {
                        final commentsUpdateData = {
                          ...createCommentsRecordData(
                            userDocumentReference: currentUserReference,
                            postDocumentReference:
                                widget.postDocument!.reference,
                            order: valueOrDefault<String>(
                              functions.getCommentOrder(
                                  widget.parentCommentDocument != null
                                      ? valueOrDefault<int>(
                                          widget.parentCommentDocument!
                                              .noOfComments,
                                          0,
                                        )
                                      : valueOrDefault<int>(
                                          widget.postDocument!.noOfComments,
                                          0,
                                        ),
                                  widget.parentCommentDocument != null
                                      ? widget.parentCommentDocument!.order
                                      : functions.getNullValue(),
                                  valueOrDefault<int>(
                                    functions.increaseInteger(
                                        widget.parentCommentDocument != null
                                            ? widget
                                                .parentCommentDocument!.depth
                                            : 0),
                                    0,
                                  )),
                              '0',
                            ),
                            depth: functions.increaseInteger(
                                widget.parentCommentDocument != null
                                    ? valueOrDefault<int>(
                                        widget.parentCommentDocument!.depth,
                                        0,
                                      )
                                    : 0),
                            content: contentController!.text,
                          ),
                          'createdAt': FieldValue.serverTimestamp(),
                        };
                        await widget.commentDocument!.reference
                            .update(commentsUpdateData);
                      } else {
                        final commentsUpdateData = createCommentsRecordData(
                          userDocumentReference: currentUserReference,
                          content: contentController!.text,
                        );
                        await widget.commentDocument!.reference
                            .update(commentsUpdateData);
                      }

                      if (!(widget.commentDocument!.postDocumentReference !=
                          null)) {
                        final postsUpdateData = {
                          'noOfComments': FieldValue.increment(1),
                        };
                        await widget.postDocument!.reference
                            .update(postsUpdateData);
                      }
                      Navigator.pop(context);
                    },
                    text: '저장',
                    options: FFButtonOptions(
                      width: 130,
                      height: 40,
                      color: FlutterFlowTheme.of(context).primaryColor,
                      textStyle:
                          FlutterFlowTheme.of(context).subtitle2.override(
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
          ],
        ),
      ),
    );
  }
}
