import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/customAppBar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'reject_invitation_form.dart';

class RejectInvitation extends StatefulWidget {
  final String docID;
  final String studentEmail;
  RejectInvitation({@required this.docID, @required this.studentEmail});
  @override
  _RejectInvitationState createState() => _RejectInvitationState();
}

class _RejectInvitationState extends State<RejectInvitation> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Reject Proposal"),
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
                  RejectInvitationForm(
                    docID: widget.docID,
                    studentEmail: widget.studentEmail,
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
