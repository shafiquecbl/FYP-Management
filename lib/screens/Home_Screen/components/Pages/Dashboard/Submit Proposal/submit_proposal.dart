import 'package:flutter/material.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/Submit%20Proposal/body.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/customAppBar.dart';

class SubmitProposal extends StatefulWidget {
  final String teacherEmail;
  SubmitProposal({@required this.teacherEmail});
  @override
  _SubmitProposalState createState() => _SubmitProposalState();
}

class _SubmitProposalState extends State<SubmitProposal> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Submit Proposal"),
      body: Bodyy(
        teacherEmail: widget.teacherEmail,
      ),
    );
  }
}
