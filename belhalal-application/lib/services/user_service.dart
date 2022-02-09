import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/utils.dart';
import 'package:halal/chat/widgets/favorait_contact.dart';
import 'package:halal/controllers/app_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/models/complaint.dart';
import 'package:halal/models/user.dart';
import 'package:halal/models/person.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class UserService {
  UserService._();

  /// singilton onject
  static UserService userService = UserService._();
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final AppController _appController = Get.put(AppController());

  /// create new user by firebase server
  createNewUser(MyUser myUser, String userId) async {
    int count = await getNumberOfUsers();
    var users =
        await FirebaseFirestore.instance.collection('users').doc(userId);
    MyUser newUser = myUser;
    newUser.id = userId;
    newUser.idOrder = count + 1;
    users.set(newUser.toJson()).then((value) async {
      await increaseNumberOfUsersByOne();
    }).catchError((e) {
      Get.snackbar("ناسف", "العمليه لم تتم بالشكل الصحيح");
    });
  }

  /// get user info
  Future<MyUser> getUserInfo(String userId) async {
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      var userMap = documentSnapshot.data() as Map<String, dynamic>;
      return MyUser.fromJson(userMap);
    } catch (e) {
      return MyUser();
    }
  }

  /// get user info
  Future<MyUser> getSpecificUserinfo(String userId) async {
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      var userMap = documentSnapshot.data() as Map<String, dynamic>;
      return MyUser.fromJson(userMap);
    } catch (e) {
      return MyUser();
    }
  }

  getUserImage(String userId) async {
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      var userMap = documentSnapshot.data() as Map<String, dynamic>;
      return MyUser.fromJson(userMap).imageUrl;
    } catch (e) {
      return "";
    }
  }

  /// get user info
  Future<String> getUserEmailByName(String userId) async {
    String email = "";
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: userId)
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        var userMap = querySnapshot.docs.first.data();
        MyUser user = MyUser.fromJson(userMap);
        email = user.email!;
      });
    } catch (e) {
      email = "";
    }
    return email;
  }

  /// update user info
  updateUser(String userId, MyUser myUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update(myUser.toJson())
        .then(
            (value) => Get.snackbar("نجحت العملية ", "تم تحديث بياناتك بنجاح"))
        .catchError((error) {
      Get.snackbar("ناسف", "العمليه لم تتم بالشكل الصحيح");
    });
  }

  deleteUser(String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .delete()
        .then((value) {

    })
        .catchError((error) {
      Get.snackbar("ناسف", "العمليه لم تتم بالشكل الصحيح");
    });
  }

  Future<String> uploadImage(XFile xfile) async {
    String filePath = xfile.path;
    File file = File(filePath);
    String fileName = filePath.split('/').last;
    Reference reference = firebaseStorage.ref('images/$fileName');
    TaskSnapshot taskSnapshot = await reference.putFile(file);
    String url = await reference.getDownloadURL();
    return url;
  }

  ///update user image
  updateUserImage(String userId, XFile file) async {
    String imageUrl = await uploadImage(file);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({"imageUrl": imageUrl});
  }

  ///update user suptype
  updateUserSupType(String userId, Subtype subtype) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({"subtype": "${subtype}"})
        .then((value) {})
        .catchError((e) {
          Get.snackbar("ناسف", "العمليه لم تتم بالشكل الصحيح");
        });
  }

  Future<bool> checkIfthisEmailIsAlreadyExist(String email) async {
    bool isExist = false;
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      value.docs.forEach((element) {});
      isExist = true;
      Get.snackbar("ناسف ", "هذا الايميل مستخدم من قبل");
    }).catchError((e) {
      isExist = false;
    });
    return isExist;
  }

  ///Search about spesific users
  Future<List<MyUser>> searchAgeAndCountryName(
      String uId, int fromAge, int toAge, String countryName) async {
    List<MyUser> users = <MyUser>[];
    await FirebaseFirestore.instance
        .collection('users')
        .where('age',
            isGreaterThanOrEqualTo: fromAge, isLessThanOrEqualTo: toAge)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        MyUser user = MyUser.fromJson(doc.data());
        if (user.country == countryName) {
          if (user.id != uId) {
            users.add(user);
          }
        }
      });
      users.isEmpty
          ? Get.snackbar("نتائج البحث", "لا يوجد أشخاص بهذه المواصفات")
          : null;
    }).catchError((e) {
      Get.snackbar("نتائج البحث", "لا يوجد أشخاص بهذه المواصفات");
    });
    return users;
  }

  Future<List<MyUser>> getUserLooksLikeYou(
      String uId, int age, Subtype subtype) async {
    return subtype == Subtype.goldSubscription
        ? getAllUsersLooksLikeYou(uId, age)
        : getUserLooksLikeYouWithLimit(uId, age);
  }

  Future<List<MyUser>> getAllUsersLooksLikeYou(String uId, int age) async {
    List<MyUser> users = <MyUser>[];
    int less = age + 10;
    int grater = age - 10;
    await FirebaseFirestore.instance
        .collection('users')
        .where('age', isGreaterThanOrEqualTo: grater, isLessThanOrEqualTo: less)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        MyUser user = MyUser.fromJson(doc.data());
        if (user.id != uId) {
          users.add(user);
        }
      });
    }).catchError((e) {
      Get.snackbar("نتائج البحث", "لا يوجد أشخاص بهذه المواصفات");
    });
    return users;
  }

  Future<List<MyUser>> getUserLooksLikeYouWithLimit(String uId, int age) async {
    List<MyUser> users = <MyUser>[];
    int less = age + 10;
    int grater = age - 10;
    await FirebaseFirestore.instance
        .collection('users')
        .where('age', isGreaterThanOrEqualTo: grater, isLessThanOrEqualTo: less)
        .limit(10)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        MyUser user = MyUser.fromJson(doc.data());
        if (user.id != uId) {
          users.add(user);
        }
      });
    }).catchError((e) {
      Get.snackbar("نتائج البحث", "لا يوجد أشخاص بهذه المواصفات");
    });
    return users;
  }

  ///get all people i did like for him
  Future<List<MyPerson>> getPeopleIlike(String userId) async {
    List<MyPerson>? peoples = <MyPerson>[];
    await FirebaseFirestore.instance
        .collection("userStatues")
        .doc(userId)
        .collection("peopleIamLiked")
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        peoples.add(MyPerson.fromJson(doc.data()));
      });
    });

    return peoples;
  }

  /// check if the user in my blocked list or not
  Future<bool> checkIfUserInMyBlockedBeople(
      String myUserId, String personId) async {
    bool isBlocked = false;
    var snap = await FirebaseFirestore.instance
        .collection("userStatues")
        .doc(myUserId)
        .collection("blockedUsers")
        .where('id', isEqualTo: personId)
        .get()
        .then((value) {
      String ss = value.docs.first['id'];
      isBlocked = true;
    }).catchError((e) {
      isBlocked = false;
    });

    return isBlocked;
  }

  /// check if the user in my liked list or not
  checkIfUserInMyLikedBeople(String myUserId, String personId) async {
    MyPerson person = MyPerson();
    var documentSnapshot = await FirebaseFirestore.instance
        .collection("userStatues")
        .doc(myUserId)
        .collection("peopleIamLiked")
        .doc(personId)
        .get()
        .then((value) {
      var userMap = value.data() as Map<String, dynamic>;
      person = MyPerson.fromJson(userMap);
    }).catchError((e) {
      person = MyPerson(id: "");
    });

    return person.id!.length > 3 ? true : false;
  }

  DocumentSnapshot? _lastDocument;
  getAllPeople(String userId, String myGenderValue, List<String> myBlockedUserId) async {
   /// do query on firebase to get all data as Query 
    var pageQuery = FirebaseFirestore.instance
        .collection("users")
        .orderBy('idOrder', descending: true)
        .limit(30);

     /// check if the last Document and stor it
    if (_lastDocument != null) {
      pageQuery = pageQuery.startAfterDocument(_lastDocument!);
    }

//// get pageQuery and get all users and store the lastDocument 
    pageQuery.snapshots().listen((postSnapShot) {
      if (postSnapShot.docs.isNotEmpty) {
        var users = postSnapShot.docs
            .map((snapshot) => MyUser.fromJson(snapshot.data()))
            .toList();
        users.shuffle();
        _lastDocument = postSnapShot.docs.last;

/// filter user accourding to there age and blockedUsers
       var filteredusers = users
            .where((element) => element.gendervalue != myGenderValue)
            .where((element) => myBlockedUserId.contains(element.id) == false)
            .toList();
//// add user after filtering to appController so the showed on the slider            
        _appController.myUsers.value.addAll(filteredusers);
      }
    });
  }

  Future<List<MyUser>> getPeoplewithLimit(String myId) async {
    List<MyUser>? peoples = <MyUser>[];
    await FirebaseFirestore.instance
        .collection("users")
        .where('id', isNotEqualTo: myId)
        .limit(30)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        peoples.add(MyUser.fromJson(doc.data()));
      });
    });
    return peoples;
  }

//Add people to my peopleIamLiked list
  likedPeople(String myId, MyPerson person) async {
    await FirebaseFirestore.instance
        .collection('userStatues')
        .doc(myId)
        .collection("peopleIamLiked")
        .doc(person.id)
        .set(person.toJson())
        .then((value) => {
              Get.snackbar("نجحت العملية", "تمت عملية الإعجاب بنجاح"),
            })
        .catchError((e) {
      Get.snackbar("ناسف", "العمليه لم تتم بالشكل الصحيح");
    });
  }

  doDisLikePeople(String userId, String disLikePersonId) {
    FirebaseFirestore.instance
        .collection('userStatues')
        .doc(userId)
        .collection("peopleIamLiked")
        .doc(disLikePersonId)
        .delete()
        .then((value) {})
        .catchError((e) {
      Get.snackbar("ناسف", "العمليه لم تتم بالشكل الصحيح");
    });
  }

  /// add people to my peopleIamLiked list
  blockPeople(String myId, MyPerson person) async {
    await FirebaseFirestore.instance
        .collection('userStatues')
        .doc(myId)
        .collection("blockedUsers")
        .doc(person.id)
        .set(person.toJson())
        .then((value) => {
              Get.snackbar("نجحت العملية", "تمت عملية الحظر بنجاح"),
            })
        .catchError((e) {
      Get.snackbar("ناسف", "العمليه لم تتم بالشكل الصحيح");
    });
  }

  ///get all people i did like for him
  Future<List<MyPerson>> getPeopleIBlocked(String userId) async {
    List<MyPerson>? peoplesIbloked = <MyPerson>[];

    await FirebaseFirestore.instance
        .collection("userStatues")
        .doc(userId)
        .collection("blockedUsers")
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        peoplesIbloked.add(MyPerson.fromJson(doc.data()));
      });
    });
    return peoplesIbloked;
  }

  doDisBlockedPeople(String userId, String disLikePersonId) {
    FirebaseFirestore.instance
        .collection('userStatues')
        .doc(userId)
        .collection("blockedUsers")
        .doc(disLikePersonId)
        .delete()
        .then((value) => {})
        .catchError((e) {
      Get.snackbar("ناسف", "العمليه لم تتم");
    });
  }

  /// to apply complemets against user
  complaintAginestUserUser(String personId) async {
    Complaint complaint = await getUsercomplaints(personId);
    var qer = FirebaseFirestore.instance.collection('complaints').doc(personId);
    await qer
        .set(Complaint(
                userId: qer.id,
                count: complaint.count! + 1,
                isClosed: complaint.isClosed)
            .toJson())
        .then((value) => {
              Get.snackbar("العمليه ناجحه", "تمت العملية بنجاح"),
            })
        .catchError((e) {
      Get.snackbar("ناسف", "العمليه لم تتم بالشكل الصحيح");
    });
  }

  /// get my complemets
  getUsercomplaints(String userId) async {
    Complaint complaint = Complaint();
    try {
      await FirebaseFirestore.instance
          .collection('complaints')
          .where('userId', isEqualTo: userId)
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        var userMap = querySnapshot.docs.first.data();
        complaint = Complaint.fromJson(userMap);
      });
    } catch (e) {
      print(e);
      return Complaint();
    }
    return complaint;
  }

  getNumberOfUsers() async {
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('account')
          .doc('numberOfUsers')
          .get();
      var numOfUsers = documentSnapshot.data()!['numberOfUsers'];
      return numOfUsers;
    } catch (e) {
      return 0;
    }
  }

  increaseNumberOfUsersByOne() async {
    int count = 0;
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('account')
          .doc('numberOfUsers')
          .get();
      count = documentSnapshot.data()!['numberOfUsers'];
      await FirebaseFirestore.instance
          .collection('account')
          .doc('numberOfUsers')
          .set({'numberOfUsers': count + 1});
    } catch (e) {
      print(e);
    }
  }
}
