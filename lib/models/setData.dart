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

  Future sendInvite(context, receiverEmail) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Invites')
        .doc(user.email)
        .set({
      'Registeration No': user.email.substring(0, 12),
      'Email': user.email,
      'PhotoURL': user.photoURL,
    }).then((value) => {
              Navigator.maybePop(context),
              Snack_Bar.show(context, "Invite sent successfully!"),
            });
  }

  Future sendInviteToTeacher(context, teacherEmail, proposal) async {
    String groupID;
    String department;
    String batch;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .get()
        .then((value) => {
              groupID = value['GroupID'],
              batch = value['Batch'],
              department = value['Department']
            });

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(teacherEmail)
        .collection('Invites')
        .doc(groupID)
        .set({
      'GroupID': groupID,
      'Batch': batch,
      'Department': department,
      'Proposal': proposal
    }).then((value) => {
              Navigator.maybePop(context).then((value) =>
                  Snack_Bar.show(context, "Invite sent successfully!"))
            });
  }

  Future acceptInvite(context,
      {@required receiverEmail,
      @required receiverRegNo,
      @required receiverPhotoURL}) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Group Members')
        .doc(receiverEmail)
        .set({
      'Registeration No': receiverRegNo,
      'Email': receiverEmail,
      'PhotoURL': receiverPhotoURL,
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Group Members')
        .doc(user.email)
        .set({
      'Registeration No': user.email.substring(0, 12),
      'Email': user.email,
      'PhotoURL': user.photoURL,
    });

    await FirebaseFirestore.instance
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
      @required receiverPhotoURL,
      @required previousMemberEmail,
      @required previousMemberPhoto,
      @required department,
      @required batch}) async {
    String groupID;
    String dep;
    String batch;

    //getting and assigning groupID
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .get()
        .then((value) => {
              dep = value['Department'],
              batch = value['Batch'],
              FirebaseFirestore.instance
                  .collection('Groups')
                  .doc(dep)
                  .collection(batch)
                  .get()
                  .then((value) => {
                        groupID = '$dep-${value.docs.length + 1}',
                      })
            });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .update({
      'GroupID': groupID,
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .update({
      'GroupID': groupID,
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .update({
      'GroupID': groupID,
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(previousMemberEmail)
        .update({
      'GroupID': groupID,
    });

    await FirebaseFirestore.instance
        .collection('Groups')
        .doc(dep)
        .collection(batch)
        .add({
      'GroupID': groupID,
      'Member 1': user.email,
      'Member 2': receiverEmail,
      'Member 3': previousMemberEmail
    });
    ///////////////////////////////////
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Group Members')
        .doc(receiverEmail)
        .set({
      'Registeration No': receiverRegNo,
      'Email': receiverEmail,
      'PhotoURL': receiverPhotoURL,
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(previousMemberEmail)
        .collection('Group Members')
        .doc(receiverEmail)
        .set({
      'Registeration No': receiverRegNo,
      'Email': receiverEmail,
      'PhotoURL': receiverPhotoURL,
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Group Members')
        .doc(previousMemberEmail)
        .set({
      'Registeration No': previousMemberEmail.substring(0, 12),
      'Email': previousMemberEmail,
      'PhotoURL': user.photoURL,
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Group Members')
        .doc(user.email)
        .set({
      'Registeration No': user.email.substring(0, 12),
      'Email': user.email,
      'PhotoURL': user.photoURL,
    });

    ///////////////////////////////////////////////////////////////////////////

    await FirebaseFirestore.instance
        .collection('Students')
        .doc(department)
        .collection(batch)
        .doc(receiverEmail)
        .delete();

    await FirebaseFirestore.instance
        .collection('Students')
        .doc(department)
        .collection(batch)
        .doc(previousMemberEmail)
        .delete();

    await FirebaseFirestore.instance
        .collection('Students')
        .doc(department)
        .collection(batch)
        .doc(user.email)
        .delete();

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Invites')
        .doc(receiverEmail)
        .delete()
        .then((value) => {
              Navigator.pop(context),
            });
  }

  Future accept3rdInvite(context,
      {@required receiverEmail,
      @required receiverRegNo,
      @required receiverPhotoURL,
      @required previousMemberEmail,
      @required previousMemberPhoto,
      @required department,
      @required batch}) async {
    String groupID;
    String dep;
    String batch;

    //getting and assigning groupID
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .get()
        .then((value) => {
              dep = value['Department'],
              batch = value['Batch'],
              FirebaseFirestore.instance
                  .collection('Groups')
                  .doc(dep)
                  .collection(batch)
                  .get()
                  .then((value) => {
                        groupID = '$dep-${value.docs.length + 1}',
                      })
            });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .update({
      'GroupID': groupID,
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .update({
      'GroupID': groupID,
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .update({
      'GroupID': groupID,
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(previousMemberEmail)
        .update({
      'GroupID': groupID,
    });

    await FirebaseFirestore.instance
        .collection('Groups')
        .doc(dep)
        .collection(batch)
        .add({
      'GroupID': groupID,
      'Member 1': user.email,
      'Member 2': receiverEmail,
      'Member 3': previousMemberEmail
    });
    ///////////////////////////////////

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Group Members')
        .doc(user.email)
        .set({
      'Registeration No': user.email.substring(0, 12),
      'Email': user.email,
      'PhotoURL': user.photoURL,
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Group Members')
        .doc(receiverEmail)
        .set({
      'Registeration No': receiverRegNo,
      'Email': receiverEmail,
      'PhotoURL': receiverPhotoURL,
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Group Members')
        .doc(previousMemberEmail)
        .set({
      'Registeration No': previousMemberEmail.substring(0, 12),
      'Email': previousMemberEmail,
      'PhotoURL': previousMemberPhoto,
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(previousMemberEmail)
        .collection('Group Members')
        .doc(user.email)
        .set({
      'Registeration No': user.email.substring(0, 12),
      'Email': user.email,
      'PhotoURL': user.photoURL,
    });

    ///////////////////////////////////////////////////////////////////////////

    await FirebaseFirestore.instance
        .collection('Students')
        .doc(department)
        .collection(batch)
        .doc(receiverEmail)
        .delete();

    await FirebaseFirestore.instance
        .collection('Students')
        .doc(department)
        .collection(batch)
        .doc(previousMemberEmail)
        .delete();

    await FirebaseFirestore.instance
        .collection('Students')
        .doc(department)
        .collection(batch)
        .doc(user.email)
        .delete();

    return await FirebaseFirestore.instance
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
