import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/size_config.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'submit_sdd_form.dart';

class SubmitSDD extends StatefulWidget {
  final String supervisorEmail;
  final String sddDate;
  final String groupID;
  SubmitSDD(
      {@required this.supervisorEmail,
      @required this.sddDate,
      @required this.groupID});
  @override
  _SubmitSDDState createState() => _SubmitSDDState();
}

class _SubmitSDDState extends State<SubmitSDD> {
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
                      "Submit SDD before ${widget.sddDate.substring(6, 8)}-${widget.sddDate.substring(4, 6)}-${widget.sddDate.substring(0, 4)}",
                      textAlign: TextAlign.center,
                      // style: GoogleFonts.teko(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 18,
                      //     color: kPrimaryColor.withOpacity(0.8)),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.06),
                    SubmitSDDForm(
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
