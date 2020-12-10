import 'package:bcredible/src/blocs/login_bloc.dart';
import 'package:flutter/material.dart';
import '../models/business.dart';
import './business_tile.dart';
import '../blocs/business_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login_screen.dart';

class ListViewScreen extends StatefulWidget {
  final String locationCity;
  ListViewScreen({Key key, @required this.locationCity}) : super(key: key);

  @override
  ListScreenState createState() => ListScreenState(locationCity);
}

class ListScreenState extends State<ListViewScreen> {
  String locationCity;
  ListScreenState(this.locationCity);

  @override
  Widget build(BuildContext context) {
    businessBloc.fetchBusinesses(locationCity);
    // _read();
    return StreamBuilder(
      stream: businessBloc.result,
      builder: (context, AsyncSnapshot<List<Business>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          return _buildListView(snapshot.data);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      });
  }

  MaterialApp _buildListView(List<Business> data) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListViews',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('bCredible'),
          backgroundColor: Color.fromRGBO(0, 209, 189, 100),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
                size: 20.0,
              ),
              onPressed: () {
                _logout();
              },
            ),
          ]
        ),
        body: _buildSearchResults(data),
      ),
    );
  }

  Widget _buildSearchResults(List<Business> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final business = results[index];
        return Card(
          margin: EdgeInsets.all(1.5),
          child: InkWell(
            onTap: () {
              // print('tapped');
            },
            child: Padding(
              padding: const EdgeInsets.all(0.2),
              child: BusinessTile(business: business),
            ),
          ),
        );
      },
    );
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'userID';
    final value = prefs.getString(key) ?? null;
    print('read userID: $value');
  }

  _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userID');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
      builder: (context) => Provider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sign in',
          home: Scaffold(
            appBar: AppBar(
              title: Text('bCredible'),
              backgroundColor: Color.fromRGBO(0, 209, 189, 100)),
            body: LoginScreen(),
          ),
        ),
      ))
    );
  }

}
