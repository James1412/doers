import 'package:flutter/material.dart';

class InstructionsScreen extends StatefulWidget {
  const InstructionsScreen({super.key});

  @override
  State<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          surfaceTintColor: Colors.grey.shade100,
          shadowColor: Colors.grey.shade100,
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add a new event or task quickly!",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Press the plus button on a date to add a new event or a task",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/instructions/0.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add a new date",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Press the add button to add a new date or task",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/instructions/1.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add a new date",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Press the add button to add a new date or task",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Container(
                      height: 350,
                      width: 350,
                      decoration: const BoxDecoration(),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/instructions/2.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Change the date",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Long press on a tile to move to a different date",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Container(
                      height: 400,
                      width: 350,
                      decoration: const BoxDecoration(),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/instructions/3.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Move the tile up and down",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Press and slide to move the tile within the same date",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Container(
                      height: 400,
                      width: 350,
                      decoration: const BoxDecoration(),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/instructions/4.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Edit an event or a task",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Slide the tile to the left to delete or edit the event",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Container(
                      height: 300,
                      width: 350,
                      decoration: const BoxDecoration(),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/instructions/5.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.grey.shade100,
          shadowColor: Colors.grey.shade100,
          surfaceTintColor: Colors.grey.shade100,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TabPageSelector(),
            ],
          ),
        ),
      ),
    );
  }
}
