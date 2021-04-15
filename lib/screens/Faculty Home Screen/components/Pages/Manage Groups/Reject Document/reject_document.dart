import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/components/Pages/Manage%20Groups/Reject%20Document/reject_document_form.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/customAppBar.dart';
import 'package:google_fonts/google_fonts.dart';

class RejectDocument extends StatefulWidget {
  final String doc;
  final DocumentSnapshot snapshot;
  RejectDocument({@required this.doc, @required this.snapshot});
  @override
  _RejectDocumentState createState() => _RejectDocumentState();
}

class _RejectDocumentState extends State<RejectDocument> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Reject ${widget.doc}"),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Text("Enter Reason",
                      style: GoogleFonts.teko(
                          color: kTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  RejectDocumentForm(
                    doc: widget.doc,
                    snapshot: widget.snapshot,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
