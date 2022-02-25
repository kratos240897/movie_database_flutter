import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:movie_database/screens/person/person_controller.dart';

class Person extends StatefulWidget {
  final String title;
  final String id;
  const Person({Key? key, required this.title, required this.id})
      : super(key: key);

  @override
  State<Person> createState() => _PersonState();
}

class _PersonState extends State<Person> {
  PersonController controller = Get.find<PersonController>();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.getPerson(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(),
      ),
    );
  }
}
