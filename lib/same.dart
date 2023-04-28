import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';



final _credentials = ServiceAccountCredentials.fromJson(r'''
{
  "type": "service_account",
  "project_id": "gsheet-384920",
  "private_key_id": "f289d37a745a002d64b6f4f3e3ac4e9d19a02a02",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDTv9OwnLZYt5Iz\nY9T7IkNSbazB/JoUe+IvH0aI3aX7TZToD0MOdaejS81ScbA81KJHzjNK8oPREr9g\nzPnNjmQGILkTizS/HrH63vNf7Jl+j/3yriuKAcaMxCMhvfxx4uJkpQwx4VcPbgdy\nlPZp9xJs7j2mM4SFaSu2d+ilfyq4CR9letzM6zLvyrXGnYthTt6bt6ZuKnc+nQoE\nIXU0rZ5Mlou8xfWYwFDtLIuq/XSYbNBObtu4/RAJ3yoTQq5m6QCzbUypu2yH3ofF\nBTtuxLv8xaUm3D+2Q9Ziy5H//VHQ1PZ8KLzzHSEtmaCQY7kJy224V21eAdMrgop4\npJehUQ2TAgMBAAECggEAHDVJQ5VU21O1F8B8Xmotkr0Gjx8R/ZmVQ5bEhDYWxvgK\nVrG1yqbUyrWt6AY6Jphi9/LZtWnCMqdvNDuKKZ6G56QTU62vPKifqB5sSIKR3iDb\ngSk/ppZe92Cnl3aiOx+w7hxol/p/aRBM0LBUdUBTRYylTM8/H7CngJrPtMBQlgxu\nyDY0oi4SbhLtcdQSkvoOUKF5UmcvjcS1MWaaN/lIHcwag/dcFBcJmbZJtx3RlJu1\naOuWfKiDmof4Vqunj0esqegu5veZ+NnWZSoXT9uXu+w0rECvnc+b5iD3yoaKVHiQ\nF/+kpu4Lg+6UmtBB6NwQFK6Awk1cXBSm+qxSUar7LQKBgQD+uqX6AvRLZi43EeF5\nRbksiOUM4GDRZjV+NiGUItCTl28BbXbWJ1yDFifZwANd7qga156hnaqrIBG+g1GQ\nlcWDazXNld9k+tE74WHPE4S6aH8k/2g3sg9gjsNboPCoy3KjczjSba3+fBb6ngxd\nGFfNJSqLkdZQGyymnOGs+3/S1QKBgQDUzkhoCJ7gBtZRf3SG1tHXlg/IV2xu0rGO\npVIRDcXf2bpRyeU5LMWWx5VUjtC5L2ltajvuY4sJncvesWJlrHMHPfVZt2BR10XS\nr0TQoE6qKxyvFgKwZqJIEEOuRWlw2n0JBey3LOdb/X8sJOWy2gJXb/xiZaPvR7mv\n+jf44lSCxwKBgBFfva5dwTfbUk+jQpO487Zb5/OG4lOl+wQOwR+PeFZ4v7ODOdXF\nfYPbYQBzHker3X9nMYSoclmVqGAsKMYJ0RzzlQnerQwAJ4FEEB3FoQnt0q49VWhn\nFrFpS13WjlOU/M61Lyz7GiD/abnSSdmXrXVqkYpPeiSgld0PWj0oMkG5AoGAbF9M\n8mYJeq8gr8pHrm9x1+dczDrxRpLXx3wbigHIllIMF6DIslBBo6KqQrCkTNp/RzBF\nqwZYhSIt84/EO2ESB0sfSnwfei42KbAGTHSG+xQPfH6qCemKlUZrITHKG6W47UJu\nJW6ht/AltnZn36g0bxDhp755ON7/CkZUANRKE3sCgYEAyTZg5wK1lzqwj5g19zHt\nDddwbnm69KEv3SE5hLE03qijzU4bvG9TSvvaCpRz0s3gX9zTakehUf0BSuEm5vav\nP8u+IBvhGR3YkvCnIB5Kd3V5MztXfwRPzIUw/fgugHVNjHecVgMujtNIZuWxHnB3\nf7cJqxEiat9d4cvAVhe+FwY=\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheet@gsheet-384920.iam.gserviceaccount.com",
  "client_id": "100810567459987202357",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheet%40gsheet-384920.iam.gserviceaccount.com"
}
''');

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Attendance App',
      home: AttendanceScreen(),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _spreadsheetId = '1UR4fyNtd-vvvRQPDDBIJzMYquNp7H4NcU11T6qwh1gc';
  List<String> _studentNames = [];

  @override
  void initState() {
    super.initState();
    _getStudentNames();
  }

  Future<void> _addAttendance(String name, bool present) async {
    final client = await clientViaServiceAccount(_credentials, ['https://www.googleapis.com/auth/spreadsheets']);
    final sheetsApi = SheetsApi(client);
    final range = 'Users!A2:B';
    final values = [[name, present ? 'Present' : 'Absent']];
    final body = ValueRange(values: values);
    await sheetsApi.spreadsheets.values.append(body, _spreadsheetId, range, valueInputOption: 'USER_ENTERED');
  }

  Future<void> _getStudentNames() async {
    final studentNames = await FirebaseFirestore.instance.collection('students').get().then((QuerySnapshot querySnapshot) {
      final List<String> names = [];
      querySnapshot.docs.forEach((doc) {
        final name = (doc.data() as Map<String, dynamic>)['name'];
        if (name != null) {
          names.add(name);
        }


      });
      return names;
    });
    setState(() {
      _studentNames = studentNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: ListView(
        children: [
          for (var name in _studentNames)
            AttendanceCard(name: name, onPresent: () => _addAttendance(name, true), onAbsent: () => _addAttendance(name, false)),
        ],
      ),
    );
  }
}

class AttendanceCard extends StatelessWidget {
  final String name;
  final VoidCallback onPresent;
  final VoidCallback onAbsent;

  AttendanceCard({required this.name, required this.onPresent, required this.onAbsent});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: onPresent,
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: onAbsent,
            ),
          ],
        ),
      ),
    );
  }
}
