// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top earnings bar
              Container(
                padding: EdgeInsets.all(16),
                color: Color(0xFF7AC36A),
                child: Row(
                  children: [
                    Text(
                      'Earnings Available',
                      style: TextStyle(color: Colors.white),
                    ),
                    Spacer(),
                    Text(
                      '\$3,289',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Profile section
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage('https://hebbkx1anhila5yf.public.blob.vercel-storage.com/upwork-app-redesign-feQnAPzPpxoQTpxfa77mNm6SRdqgQB.png'),
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Color(0xFF7AC36A),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tony Stark',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ],
                    ),
                    Text(
                      'Kyiv, Ukraine',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    
                    // Stats row
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(Icons.bar_chart, 'STATS'),
                          _buildStatItem(Icons.pie_chart, 'HOURS'),
                          _buildStatItem(Icons.description, 'PORTFOLIO'),
                          _buildStatItem(Icons.help_outline, 'SUPPORT'),
                          _buildStatItem(Icons.settings, 'SETTINGS'),
                        ],
                      ),
                    ),

                    // Tags
                    Row(
                      children: [
                        _buildTag('General', isSelected: true),
                        SizedBox(width: 8),
                        _buildTag('Product Design'),
                        SizedBox(width: 8),
                        _buildTag('Mobile UX Design'),
                      ],
                    ),

                    // Profile description
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product UI/UX Designer',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Hi, My name is Tony Stark! I\'m from California, USA. I\'m seasoned professional with 12+ years of experience in web and mobile UI/UX design. 5 years of Product Design. 25+ years team management in both international and California, USA companies...',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('More'),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Play video button
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.play_circle_outline),
                      label: Text('Play Video'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7AC36A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    // Bottom stats
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildBottomStat('\$45.00', 'RATE'),
                          _buildBottomStat('\$200k+', 'EARNED'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Proposals'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 4,
        selectedItemColor: Color(0xFF7AC36A),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String label, {bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF7AC36A) : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildBottomStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}