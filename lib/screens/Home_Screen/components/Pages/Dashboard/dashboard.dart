import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/Get%20Supervisors/get_supervisors.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/Get_Students/get_students.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/Submit%20Report/Submit_Report.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/Submit%20SRS/submit_srs.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/Submit%20SDD/submit_SDD.dart';
import 'package:fyp_management/widgets/customAppBar.dart';
import 'package:fyp_management/widgets/stepper.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  final int proposalDate;
  final int srsDate;
  final int sddDate;
  final int reportDate;
  Dashboard({
    @required this.proposalDate,
    @required this.srsDate,
    @required this.sddDate,
    @required this.reportDate,
  });
  static String routeName = "/sDashboard";
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User user = FirebaseAuth.instance.currentUser;
  int currentStep;
  String batch;
  String groupID;
  String supervisorEmail;
  String supervisorName;
  String department;
  int dateTime = int.parse(DateFormat("yyyy-MM-dd")
      .format(DateTime.now())
      .replaceAll(new RegExp(r'[^\w\s]+'), ''));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Dashboard"),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(user.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          currentStep = snapshot.data['Current Step'];
          department = snapshot.data['Department'];
          groupID = snapshot.data['GroupID'];
          batch = snapshot.data['Batch'];
          supervisorEmail = snapshot.data['Supervisor'];
          supervisorName = snapshot.data['Supervisor Name'];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                  width: MediaQuery.of(context).size.width,
                  color: hexColor,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: currentStep == 1
                        ? Step1()
                        : currentStep == 2
                            ? Step2()
                            : currentStep == 3
                                ? Step3()
                                : currentStep == 4
                                    ? Step4()
                                    : currentStep == 5
                                        ? Step5()
                                        : Success(),
                  ),
                ),
              ),
              Container(
                child:
                    // if group is not completed then show students list //
                    currentStep == 1
                        ? GetStudents(department: department, batch: batch)
                        :
                        // if group is completed then show list of supervisor //
                        currentStep == 2
                            ? GetSupervisors(
                                department:
                                    department == 'SE' ? 'CS' : department,
                              )
                            // if group is confirmed then go for SRS Submission //
                            : currentStep == 3 &&
                                    widget.proposalDate < dateTime &&
                                    dateTime <= widget.srsDate
                                ? SubmitSRS(
                                    supervisorEmail: supervisorEmail,
                                    supervisorName: supervisorName,
                                    srsDate: widget.srsDate.toString(),
                                    groupID: groupID,
                                  )
                                // if SRS is Submitted then go for SDD Submission //
                                : currentStep == 4 &&
                                        widget.srsDate < dateTime &&
                                        dateTime <= widget.sddDate
                                    ? SubmitSDD(
                                        supervisorEmail: supervisorEmail,
                                        sddDate: widget.sddDate.toString(),
                                        groupID: groupID,
                                      )
                                    // if SDD is Submitted then go for Report Submission //
                                    : currentStep == 5 &&
                                            widget.sddDate < dateTime &&
                                            dateTime <= widget.reportDate
                                        ? SubmitReport(
                                            supervisorEmail: supervisorEmail,
                                            reportDate:
                                                widget.reportDate.toString(),
                                            groupID: groupID,
                                          )
                                        // else check for these messages  //
                                        : Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Text(
                                                currentStep == 3
                                                    ? 'Your invitation is accepted by:\n$supervisorName\n Wait until ${widget.srsDate.toString().substring(6, 8)}-${widget.srsDate.toString().substring(4, 6)}-${widget.srsDate.toString().substring(0, 4)} to Submit SRS'
                                                    : currentStep == 4
                                                        ? 'Your SRS is Submitted\n Wait until ${widget.srsDate.toString().substring(6, 8)}-${widget.srsDate.toString().substring(4, 6)}-${widget.srsDate.toString().substring(0, 4)} to Submit SDD'
                                                        : currentStep == 5
                                                            ? 'Your SDD is Submitted\n Wait until ${widget.sddDate.toString().substring(6, 8)}-${widget.sddDate.toString().substring(4, 6)}-${widget.sddDate.toString().substring(0, 4)} to Submit Report'
                                                            : 'Congratulations! 🎉🎉🎉\nYou have Submitted all the Documents Successfully ✔',
                                                textAlign: TextAlign.center,
                                                style: stylee,
                                              ),
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
