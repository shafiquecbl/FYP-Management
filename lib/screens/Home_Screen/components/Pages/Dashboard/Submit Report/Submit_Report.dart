import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/size_config.dart';

import 'submit_report_form.dart';
// import 'package:google_fonts/google_fonts.dart';

class SubmitReport extends StatefulWidget {
  final String supervisorEmail;
  final String reportDate;
  final String groupID;
  SubmitReport(
      {@required this.supervisorEmail,
      @required this.reportDate,
      @required this.groupID});
  @override
  _SubmitReportState createState() => _SubmitReportState();
}

class _SubmitReportState extends State<SubmitReport> {
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
                      "Submit Report before ${widget.reportDate.substring(6, 8)}-${widget.reportDate.substring(4, 6)}-${widget.reportDate.substring(0, 4)}",
                      textAlign: TextAlign.center,
                      // style: GoogleFonts.teko(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 18,
                      //     color: kPrimaryColor.withOpacity(0.8)),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.06),
                    SubmitReportForm(
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
