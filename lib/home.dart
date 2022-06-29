import 'package:firebase_auth/firebase_auth.dart';
import '/model/person_model.dart';
import '/update_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<QuerySnapshot<PersonModel>> _contactDoc({required bool orderValue}) =>
      FirebaseFirestore.instance
          .collection('contacts')
          .withConverter<PersonModel>(
              fromFirestore: (snapshot, _) =>
                  PersonModel.fromJson(snapshot.data() ?? {}),
              toFirestore: (person, _) => person.toJson())
          .orderBy('timestamp', descending: orderValue)
          .snapshots();
  late bool _orderValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<bool>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (value) {
              if (value) {
                setState(() {
                  _orderValue = value;
                  _contactDoc(orderValue: _orderValue);
                });
              } else {
                setState(() {
                  _orderValue = value;
                  _contactDoc(orderValue: _orderValue);
                });
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: false,
                  child: Text('Timestamp by Ascending'),
                ),
                const PopupMenuItem(
                  value: true,
                  child: Text('Timestamp by Descending'),
                ),
              ];
            },
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Firebase Example',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<PersonModel>>(
        stream: _contactDoc(orderValue: _orderValue),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<PersonModel>>? contactsDocList =
                snapshot.data?.docs;
            if (contactsDocList != null) {
              return ListView.builder(
                padding: const EdgeInsets.only(top: 10, bottom: 100),
                itemCount: contactsDocList.length,
                itemBuilder: (BuildContext context, position) {
                  QueryDocumentSnapshot<PersonModel> contactsDoc =
                      contactsDocList[position];

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                    child: ListTile(
                      leading: (contactsDoc.data().profileUrl != null)
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                contactsDoc.data().profileUrl!,
                              ),
                            )
                          : const CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.person,
                                size: 40,
                              ),
                            ),
                      title: Text(contactsDoc.data().name ?? ''),
                      subtitle: Text(contactsDoc.data().address ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                var docUser = FirebaseFirestore.instance
                                    .collection('contacts')
                                    .withConverter<PersonModel>(
                                        fromFirestore: (snapshot, _) =>
                                            PersonModel.fromJson(
                                                snapshot.data() ?? {}),
                                        toFirestore: (person, _) =>
                                            person.toJson());
                                docUser.doc(contactsDoc.id).delete();
                              },
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              )),
                          Text(contactsDoc.data().age.toString()),
                        ],
                      ),
                      onTap: () {
                        // debugPrint(contactsDoc.id);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => UpdateScreen(
                                      docId: contactsDoc.id,
                                      name: contactsDoc.data().name ?? '',
                                      address: contactsDoc.data().address ?? '',
                                      age: contactsDoc.data().age ?? 0,
                                    )));
                      },
                    ),
                  );
                },
              );
            } else {
              const Center(child: Text('Empty data'));
            }
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
