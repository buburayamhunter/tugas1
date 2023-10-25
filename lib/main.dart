import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class University {
  final String name;
  final String country;

  University({
    required this.name,
    required this.country,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      country: json['country'],
    );
  }
}

class ApiService {
  Future<List<University>> fetchUniversities() async {
    final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=Indonesia'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<University> universities =
          data.map((e) => University.fromJson(e)).toList();
      return universities;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Universitas Di Indonesia'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService apiService = ApiService();
  List<University> universities = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final result = await apiService.fetchUniversities();
      setState(() {
        universities = result;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return universities.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: universities.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(universities[index].name),
                subtitle: Text('Country: ${universities[index].country}'),
              );
            },
          );
  }
}
