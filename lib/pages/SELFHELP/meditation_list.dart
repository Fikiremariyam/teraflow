import 'package:flutter/material.dart';
import '/util/exercise_card.dart';
import 'breathing_exercise.dart';

class MeditationListPage extends StatelessWidget {
  const MeditationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Meditation',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Breathing Exercise',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ExerciseCard(
            title: 'Breathing Exercise 1',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BreathingExerciseDetailPage(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ExerciseCard(
            title: 'Breathing Exercise Note',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BreathingExerciseDetailPage(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ExerciseCard(
            title: 'Breathing Instruction',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BreathingExerciseDetailPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
