import 'package:flutter/material.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/Submit%20Proposal/submit_proposal_form.dart';
import 'package:fyp_management/size_config.dart';
import 'package:google_fonts/google_fonts.dart';

class Bodyy extends StatefulWidget {
  final String teacherEmail;
  Bodyy({@required this.teacherEmail});
  @override
  _BodyyState createState() => _BodyyState();
}

class _BodyyState extends State<Bodyy> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Submit proposal to invite supervisor",
                  style: GoogleFonts.teko(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                SubmitProposalForm(
                  teacherEmail: widget.teacherEmail,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
