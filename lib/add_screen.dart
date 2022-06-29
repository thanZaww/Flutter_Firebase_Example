import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/model/person_model.dart';
import 'package:flutter/material.dart';
import 'image/image_service.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _address = TextEditingController();

  final CollectionReference<PersonModel> _contact = FirebaseFirestore.instance
      .collection('contacts')
      .withConverter<PersonModel>(
          fromFirestore: (snapshot, _) =>
              PersonModel.fromJson(snapshot.data() ?? {}),
          toFirestore: (person, _) => person.toJson());

  bool _loading = false;
  bool _success = false;
  bool _error = false;

  File? _profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Add Contact to FireStore',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TextField(
                controller: _name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _age,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Age',
                  hintText: 'Age',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _address,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                  hintText: 'Address',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () async {
                  File? image = await chooseImage();
                  if (image != null) {
                    setState(() {
                      _profileImage = image;
                    });
                  }
                },
                icon: const Icon(Icons.image),
                label: const Text('Gallery'),
              ),
              const SizedBox(height: 10),
              (_profileImage != null)
                  ? Image.file(
                      _profileImage!,
                      height: 100,
                    )
                  : Container(),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
                  onPressed: _addContact,
                  child: const Text('Save Contact'),
                ),
              ),
              (_loading) ? const CircularProgressIndicator() : Container(),
              (_success) ? const Text('Success') : Container(),
              (_error) ? const Text('Error') : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addContact() async {
    setState(() {
      _loading = true;
      _success = false;
      _error = false;
    });
    String? profileUrl;
    if (_profileImage != null) {
      profileUrl = await uploadImage(_profileImage!);
    }
    _contact
        .add(PersonModel(
      name: _name.text,
      address: _address.text,
      age: num.tryParse(_age.text),
      timestamp: DateTime.now().microsecondsSinceEpoch,
      profileUrl: profileUrl,
    ))
        .then((value) {
      setState(() {
        _loading = false;
        _success = true;
        Navigator.pop(context);
      });
    }).catchError((e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }).whenComplete(() {
      _age.clear();
      _name.clear();
      _address.clear();
    });
  }
}
