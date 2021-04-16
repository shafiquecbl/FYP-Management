import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp_management/widgets/snack_bar.dart';
import 'package:intl/intl.dart';

class SetData {
  User user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser.uid.toString();
  static DateTime now = DateTime.now();
  String dateTime = DateFormat("dd-MM-yyyy h:mma").format(now);
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future sendInvite(context, receiverEmail) async {
    await firestore
        .collection('Users')
        .doc(receiverEmail)
        .collection('Invites')
        .doc(user.email)
        .set({
      'Registeration No': user.email.substring(0, 12),
      'Email': user.email,
    }).then((value) => {
              Navigator.maybePop(context),
              Snack_Bar.show(context, "Invite sent successfully!"),
            });
  }

  Future sendInviteToTeacher(context,
      {@required teacherEmail,
      @required proposal,
      @required member1,
      @required member2}) async {
    String groupID;
    String department;
    String batch;
    await firestore.collection('Users').doc(user.email).get().then((value) => {
          groupID = value['GroupID'],
          batch = value['Batch'],
          department = value['Department']
        });

    return await firestore
        .collection('Users')
        .doc(teacherEmail)
        .collection('Invites')
        .doc(groupID)
        .set({
      'Email': user.email,
      'Member 1': member1,
      'Member 2': member2,
      'GroupID': groupID,
      'Batch': batch,
      'Department': department,
      'Proposal': proposal
    }).then((value) => {
              Navigator.maybePop(context).then((value) =>
                  Snack_Bar.show(context, "Invite sent successfully!"))
            });
  }

  Future submitSRS(
    context, {
    @required groupID,
    @required teacherEmail,
    @required srs,
  }) async {
    return await firestore
        .collection('Users')
        .doc(teacherEmail)
        .collection('Groups')
        .doc(groupID)
        .update({'SRS': srs, 'SRS Status': 'Submitted', 'SRS By': user.email});
  }

  Future submitSDD(
    context, {
    @required groupID,
    @required teacherEmail,
    @required sdd,
  }) async {
    return await firestore
        .collection('Users')
        .doc(teacherEmail)
        .collection('Groups')
        .doc(groupID)
        .update({'SDD': sdd, 'SDD Status': 'Submitted', 'SDD By': user.email});
  }

  Future submitReport(
    context, {
    @required groupID,
    @required teacherEmail,
    @required report,
  }) async {
    return await firestore
        .collection('Users')
        .doc(teacherEmail)
        .collection('Groups')
        .doc(groupID)
        .update({
      'Report': report,
      'Report Status': 'Submitted',
      'Report By': user.email
    });
  }

  Future acceptInvite(
    context, {
    @required receiverEmail,
    @required receiverRegNo,
  }) async {
    await firestore
        .collection('Users')
        .doc(user.email)
        .collection('Group Members')
        .doc(receiverEmail)
        .set({
      'Registeration No': receiverRegNo,
      'Email': receiverEmail,
    });

    await firestore
        .collection('Users')
        .doc(receiverEmail)
        .collection('Group Members')
        .doc(user.email)
        .set({
      'Registeration No': user.email.substring(0, 12),
      'Email': user.email,
    });

    await firestore
        .collection('Users')
        .doc(user.email)
        .collection('Invites')
        .doc(receiverEmail)
        .delete()
        .then((value) => {
              Navigator.maybePop(context),
            });
  }

  Future accept2ndInvite(context,
      {@required receiverEmail,
      @required receiverRegNo,
      @required previousMemberEmail,
      @required department,
      @required batch}) async {
    String groupID;
    String dep;
    String batch;
    int step = 2;

    //getting and assigning groupID
    await firestore.collection('Users').doc(user.email).get().then((value) => {
          dep = value['Department'],
          batch = value['Batch'],
          firestore
              .collection('Groups')
              .doc(dep)
              .collection(batch)
              .get()
              .then((value) => {
                    groupID = '$dep-${value.docs.length + 1}',
                  })
        });
    await firestore.collection('Users').doc(user.email).update({
      'GroupID': groupID,
    });

    await firestore.collection('Users').doc(user.email).update({
      'GroupID': groupID,
    });

    await firestore.collection('Users').doc(receiverEmail).update({
      'GroupID': groupID,
    });

    await firestore.collection('Users').doc(previousMemberEmail).update({
      'GroupID': groupID,
    });

    await firestore.collection('Groups').doc(dep).collection(batch).add({
      'GroupID': groupID,
      'Member 1': user.email,
      'Member 2': receiverEmail,
      'Member 3': previousMemberEmail
    });
    ///////////////////////////////////
    await firestore
        .collection('Users')
        .doc(user.email)
        .collection('Group Members')
        .doc(receiverEmail)
        .set({
      'Registeration No': receiverRegNo,
      'Email': receiverEmail,
    });

    await firestore
        .collection('Users')
        .doc(previousMemberEmail)
        .collection('Group Members')
        .doc(receiverEmail)
        .set({
      'Registeration No': receiverRegNo,
      'Email': receiverEmail,
    });

    await firestore
        .collection('Users')
        .doc(receiverEmail)
        .collection('Group Members')
        .doc(previousMemberEmail)
        .set({
      'Registeration No': previousMemberEmail.substring(0, 12),
      'Email': previousMemberEmail,
    });

    await firestore
        .collection('Users')
        .doc(receiverEmail)
        .collection('Group Members')
        .doc(user.email)
        .set({
      'Registeration No': user.email.substring(0, 12),
      'Email': user.email,
    });

    ///////////////////////////////////////////////////////////////////////////

    await firestore
        .collection('Students')
        .doc(department)
        .collection(batch)
        .doc(receiverEmail)
        .delete();

    await firestore
        .collection('Students')
        .doc(department)
        .collection(batch)
        .doc(previousMemberEmail)
        .delete();

    await firestore
        .collection('Students')
        .doc(department)
        .collection(batch)
        .doc(user.email)
        .delete();

    await firestore
        .collection('Users')
        .doc(user.email)
        .collection('Invites')
        .doc(receiverEmail)
        .delete();

    //////////////////////////////////////
    await firestore
        .collection('Users')
        .doc(user.email)
        .update({'Current Step': step});
    await firestore
        .collection('Users')
        .doc(receiverEmail)
        .update({'Current Step': step});
    return await firestore
        .collection('Users')
        .doc(previousMemberEmail)
        .update({'Current Step': step}).then((value) => {
              Navigator.pop(context),
            });
  }

  Future accept3rdInvite(context,
      {@required receiverEmail,
      @required receiverRegNo,
      @required previousMemberEmail,
      @required department,
      @required batch}) async {
    String groupID;
    String dep;
    String batch;

    //getting and assigning groupID
    await firestore.collection('Users').doc(user.email).get().then((value) => {
          dep = value['Department'],
          batch = value['Batch'],
          firestore
              .collection('Groups')
              .doc(dep)
              .collection(batch)
              .get()
              .then((value) => {
                    groupID = '$dep-${value.docs.length + 1}',
                  })
        });
    await firestore.collection('Users').doc(user.email).update({
      'GroupID': groupID,
    });

    await firestore.collection('Users').doc(user.email).update({
      'GroupID': groupID,
    });

    await firestore.collection('Users').doc(receiverEmail).update({
      'GroupID': groupID,
    });

    await firestore.collection('Users').doc(previousMemberEmail).update({
      'GroupID': groupID,
    });

    await firestore.collection('Groups').doc(dep).collection(batch).add({
      'GroupID': groupID,
      'Member 1': user.email,
      'Member 2': receiverEmail,
      'Member 3': previousMemberEmail
    });
    ///////////////////////////////////

    await firestore
        .collection('Users')
        .doc(receiverEmail)
        .collection('Group Members')
        .doc(user.email)
        .set({
      'Registeration No': user.email.substring(0, 12),
      'Email': user.email,
    });
    await firestore
        .collection('Users')
        .doc(user.email)
        .collection('Group Members')
        .doc(receiverEmail)
        .set({
      'Registeration No': receiverRegNo,
      'Email': receiverEmail,
    });

    await firestore
        .collection('Users')
        .doc(user.email)
        .collection('Group Members')
        .doc(previousMemberEmail)
        .set({
      'Registeration No': previousMemberEmail.substring(0, 12),
      'Email': previousMemberEmail,
    });

    await firestore
        .collection('Users')
        .doc(previousMemberEmail)
        .collection('Group Members')
        .doc(user.email)
        .set({
      'Registeration No': user.email.substring(0, 12),
      'Email': user.email,
    });

    ///////////////////////////////////////////////////////////////////////////

    await firestore
        .collection('Students')
        .doc(department)
        .collection(batch)
        .doc(receiverEmail)
        .delete();

    await firestore
        .collection('Students')
        .doc(department)
        .collection(batch)
        .doc(previousMemberEmail)
        .delete();

    await firestore
        .collection('Students')
        .doc(department)
        .collection(batch)
        .doc(user.email)
        .delete();

    return await firestore
        .collection('Users')
        .doc(user.email)
        .collection('Invites')
        .doc(receiverEmail)
        .delete()
        .then((value) => {
              Navigator.pop(context),
            });
  }
}
