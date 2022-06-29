import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model/person_model.dart';

class UpdateScreen extends StatefulWidget {
  final String docId, name, address;
  final num age;

  const UpdateScreen(
      {Key? key,
      required this.docId,
      required this.name,
      required this.address,
      required this.age})
      : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
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

  @override
  void initState() {
    _name.text = widget.name;
    _age.text = widget.age.toString();
    _address.text = widget.address;
    super.initState();
  }

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
          'Update Contact to FireStore',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),
                onPressed: _updateContact,
                child: const Text('Update Contact'),
              ),
            ),
            (_loading) ? const CircularProgressIndicator() : Container(),
            (_success) ? const Text('Success') : Container(),
            (_error) ? const Text('Error') : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> _updateContact() async {
    setState(() {
      _loading = true;
      _success = false;
      _error = false;
    });
    _contact.doc(widget.docId).update({
      'name': _name.text,
      'age': num.tryParse(_age.text),
      'address': _address.text,
    }).then((value) {
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
