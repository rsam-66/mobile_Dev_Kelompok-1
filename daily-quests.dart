import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DailyQuestPage(),
      routes: {
        '/home': (context) => HomePage(),
      },
    );
  }
}

class DailyQuestPage extends StatefulWidget {
  const DailyQuestPage({super.key});

  @override
  _DailyQuestPageState createState() => _DailyQuestPageState();
}

class _DailyQuestPageState extends State<DailyQuestPage> {
  int totalProgress = 0;
  Map<String, bool> isClaimed = {
    'Login the app': false,
    'Seasonal Challenges': false,
    'Eco-Friendly Actions': false,
    'Inviting Friends': false,
    'Green Habits Challenges': false,
  };
  Map<String, int> expPoints = {
    'Login the app': 5,
    'Seasonal Challenges': 50,
    'Eco-Friendly Actions': 20,
    'Inviting Friends': 10,
    'Green Habits Challenges': 20,
  };

  void claimTask(String task) {
    if (!isClaimed[task]!) {
      setState(() {
        totalProgress += expPoints[task]!;
        isClaimed[task] = true;
      });
    }
  }

  void claimAllTasks() {
    setState(() {
      isClaimed.forEach((task, claimed) {
        // Hanya klaim tugas yang tidak berisi "Challenges" dan belum diklaim
        if (!claimed && !task.contains("Challenges")) {
          totalProgress += expPoints[task]!;
          isClaimed[task] = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Quest"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...isClaimed.keys.map((task) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        expPoints[task].toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(task),
                    trailing: isClaimed[task]!
                        ? const Icon(Icons.check, color: Colors.green)
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: task.contains("Challenges")
                                  ? Colors.blue
                                  : Colors.green,
                            ),
                            onPressed: () {
                              if (task.contains("Challenges")) {
                                Navigator.pushNamed(context, '/home');
                              } else {
                                claimTask(task);
                              }
                            },
                            child: Text(task.contains("Challenges") ? "Go" : "Claim"),
                          ),
                  ),
                ),
              );
            }),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: totalProgress / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Text("$totalProgress XP"),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: claimAllTasks,
              child: const Text("Claim All"),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: const Center(
        child: Text("Home Page"),
      ),
    );
  }
}
