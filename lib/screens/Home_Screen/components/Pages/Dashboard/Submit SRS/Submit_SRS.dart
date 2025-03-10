import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/size_config.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'submit_srs_form.dart';

class SubmitSRS extends StatefulWidget {
  final String supervisorEmail;
  final String supervisorName;
  final String srsDate;
  final String groupID;
  SubmitSRS(
      {@required this.supervisorEmail,
      @required this.supervisorName,
      @required this.srsDate,
      @required this.groupID});
  @override
  _SubmitSRSState createState() => _SubmitSRSState();
}

class _SubmitSRSState extends State<SubmitSRS> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Card(
              elevation: 2,
              color: hexColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    Text(
                      "Your invitation is accepted by: \n${widget.supervisorName}. \nSubmit SRS before ${widget.srsDate.substring(6, 8)}-${widget.srsDate.substring(4, 6)}-${widget.srsDate.substring(0, 4)}",
                      textAlign: TextAlign.center,
                      // style: GoogleFonts.teko(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 18,
                      //     color: kPrimaryColor.withOpacity(0.8)),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.06),
                    SubmitSRSForm(
                      teacherEmail: widget.supervisorEmail,
                      groupID: widget.groupID,
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.08),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
