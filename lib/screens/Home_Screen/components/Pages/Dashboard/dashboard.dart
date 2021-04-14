import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/Get%20Supervisors/get_supervisors.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/Get_Students/get_students.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/Submit%20SRS/submit_srs.dart';
import 'package:fyp_management/widgets/customAppBar.dart';
import 'package:fyp_management/widgets/stepper.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  final String department;
  final String batch;
  final int currentStep;
  final String supervisorName;
  final String supervisorEmail;
  Dashboard(
      {@required this.department,
      @required this.batch,
      @required this.currentStep,
      @required this.supervisorName,
      @required this.supervisorEmail});
  static String routeName = "/sDashboard";
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User user = FirebaseAuth.instance.currentUser;
  int proposalDate;
  int srsDate;
  int sddDate;
  int reportDate;

  int dateTime = int.parse(DateFormat("yyyy-MM-dd")
      .format(DateTime.now())
      .replaceAll(new RegExp(r'[^\w\s]+'), ''));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Dashboard"),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Dates')
            .doc('dates')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          proposalDate = snapshot.data['proposal'];
          srsDate = snapshot.data['srs'];
          sddDate = snapshot.data['sdd'];
          reportDate = snapshot.data['report'];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: hexColor,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 15, bottom: 15),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          dateTime <= proposalDate && widget.currentStep < 2
                              ? Steps(
                                  step: 1,
                                  iconColor: widget.currentStep == 1
                                      ? kPrimaryColor
                                      : greyColor,
                                  text: 'Invite Students',
                                  textColor: widget.currentStep == 1
                                      ? Colors.black
                                      : greyColor,
                                )
                              : Container(),
                          dateTime <= proposalDate && widget.currentStep < 3
                              ? Steps(
                                  step: 2,
                                  iconColor: widget.currentStep == 2
                                      ? kPrimaryColor
                                      : greyColor,
                                  text: 'Invite Supervisor',
                                  textColor: widget.currentStep == 2
                                      ? Colors.black
                                      : greyColor,
                                )
                              : Container(),
                          proposalDate >= dateTime &&
                                  dateTime <= srsDate &&
                                  widget.currentStep < 4
                              ? Steps(
                                  step: 3,
                                  iconColor: widget.currentStep == 3
                                      ? kPrimaryColor
                                      : greyColor,
                                  text: 'Submit SRS',
                                  textColor: widget.currentStep == 3
                                      ? Colors.black
                                      : greyColor,
                                )
                              : Container(),
                          srsDate >= dateTime &&
                                  dateTime <= sddDate &&
                                  widget.currentStep < 5
                              ? Steps(
                                  step: 4,
                                  iconColor: widget.currentStep == 4
                                      ? kPrimaryColor
                                      : greyColor,
                                  text: 'Submit SDD',
                                  textColor: widget.currentStep == 4
                                      ? Colors.black
                                      : greyColor,
                                )
                              : Container(),
                          sddDate >= dateTime &&
                                  dateTime <= reportDate &&
                                  widget.currentStep < 6
                              ? LastStep(
                                  step: 5,
                                  iconColor: widget.currentStep == 5
                                      ? kPrimaryColor
                                      : greyColor,
                                  text: 'Submit Report',
                                  textColor: widget.currentStep == 5
                                      ? Colors.black
                                      : greyColor,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // if group is not completed then show students list //
              widget.currentStep == 1
                  ? GetStudents(
                      department: widget.department, batch: widget.batch)
                  :
                  // if group is completed then show list of supervisor //
                  widget.currentStep == 2
                      ? GetSupervisors(
                          department: widget.department == 'SE'
                              ? 'CS'
                              : widget.department,
                        )
                      // if group is confirmed then ask for SRS Submission //
                      : widget.currentStep == 3 &&
                              proposalDate < dateTime &&
                              dateTime <= srsDate
                          ? SubmitSRS(
                              supervisorEmail: widget.supervisorEmail,
                              supervisorName: widget.supervisorName,
                              srsDate: sddDate.toString(),
                            )
                          : Container(
                              child: Center(
                                child: Text(
                                  widget.currentStep == 3
                                      ? 'Your invitation is accepted by:\n${widget.supervisorName}\n Wait until ${srsDate.toString().substring(6, 8)}-${srsDate.toString().substring(4, 6)}-${srsDate.toString().substring(0, 4)} to Submit SRS'
                                      : '',
                                  textAlign: TextAlign.center,
                                  style: stylee,
                                ),
                              ),
                            )
            ],
          );
        },
      ),
    );
  }
}
