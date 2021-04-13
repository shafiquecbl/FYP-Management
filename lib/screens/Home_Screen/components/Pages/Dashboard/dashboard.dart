import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/Get%20Supervisors/get_supervisors.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/Get_Students/get_students.dart';
import 'package:fyp_management/widgets/customAppBar.dart';
import 'package:fyp_management/widgets/stepper.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  static String routeName = "/sDashboard";
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User user = FirebaseAuth.instance.currentUser;

  String studentDepartment = 'CS';
  String teacherDeparment = 'CS';
  String batch = 'B';
  int groupMembers = 0;
  int currentStep = 1;

  int proposalDate;
  int srsDate;
  int sddDate;
  int reportDate;

  int dateTime = int.parse(DateFormat("yyyy-MM-dd")
      .format(DateTime.now())
      .replaceAll(new RegExp(r'[^\w\s]+'), ''));

  @override
  void initState() {
    super.initState();
    setState(() {
      getUserProfile();
      getGroupMembers();
    });
  }

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
                          dateTime <= proposalDate && currentStep == 1
                              ? Steps(
                                  step: 1,
                                  iconColor: currentStep == 1
                                      ? kPrimaryColor
                                      : greyColor,
                                  text: 'Invite Students',
                                  textColor: currentStep == 1
                                      ? Colors.black
                                      : greyColor,
                                )
                              : Container(),
                          dateTime <= proposalDate && currentStep == 2
                              ? Steps(
                                  step: 2,
                                  iconColor: currentStep == 2
                                      ? kPrimaryColor
                                      : greyColor,
                                  text: 'Invite Supervisor',
                                  textColor: currentStep == 2
                                      ? Colors.black
                                      : greyColor,
                                )
                              : Container(),
                          dateTime <= proposalDate
                              ? Steps(
                                  step: 3,
                                  iconColor: currentStep == 3
                                      ? kPrimaryColor
                                      : greyColor,
                                  text: 'Submit Proposal',
                                  textColor: currentStep == 3
                                      ? Colors.black
                                      : greyColor,
                                )
                              : Container(),
                          proposalDate >= dateTime && dateTime <= srsDate
                              ? Steps(
                                  step: 4,
                                  iconColor: currentStep == 4
                                      ? kPrimaryColor
                                      : greyColor,
                                  text: 'Submit SRS',
                                  textColor: currentStep == 4
                                      ? Colors.black
                                      : greyColor,
                                )
                              : Container(),
                          srsDate >= dateTime && dateTime <= sddDate
                              ? Steps(
                                  step: 5,
                                  iconColor: currentStep == 5
                                      ? kPrimaryColor
                                      : greyColor,
                                  text: 'Submit SDD',
                                  textColor: currentStep == 5
                                      ? Colors.black
                                      : greyColor,
                                )
                              : Container(),
                          sddDate >= dateTime && dateTime <= reportDate
                              ? LastStep(
                                  step: 6,
                                  iconColor: currentStep == 6
                                      ? kPrimaryColor
                                      : greyColor,
                                  text: 'Submit Report',
                                  textColor: currentStep == 6
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
              // if group is completed then show list of supervisor //
              currentStep == 2
                  ? GetSupervisors(
                      department: teacherDeparment,
                    )
                  :
                  // if group is not completed then show students list //
                  GetStudents(department: studentDepartment, batch: batch)
            ],
          );
        },
      ),
    );
  }

  getUserProfile() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .get()
        .then((value) {
      setState(() {
        studentDepartment = value['Department'];
        batch = value['Batch'];
        currentStep = value['Current Step'];
      });
    });
  }

  getGroupMembers() {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Group Members')
        .snapshots();
    return stream.listen((event) {
      setState(() {
        groupMembers = event.docs.length;
      });
    });
  }
}
