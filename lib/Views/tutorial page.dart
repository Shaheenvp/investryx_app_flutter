import 'package:flutter/material.dart';
import 'detail page/tutorial_detailpage.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredTutorials = [];

  final List<Map<String, String>> tutorials = [
    {
      'title': 'Business for Sale',
      'image': 'assets/tut1.png',
    },
    {
      'title': 'Find Investor',
      'image': 'assets/tut2.png',
    },
    {
      'title': 'Franchise Options',
      'image': 'assets/tut3.png',
    },
    {
      'title': 'Creating Various Profile',
      'image': 'assets/tut4.png',
    },
    {
      'title': 'Creation Business Profile',
      'image': 'assets/tut5.png',
    },
    {
      'title': 'Add Product Post',
      'image': 'assets/tut6.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    filteredTutorials = tutorials;
    _searchController.addListener(_filterTutorials);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTutorials() {
    final String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredTutorials = tutorials;
      } else {
        filteredTutorials = tutorials
            .where((tutorial) =>
            tutorial['title']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Tutorials', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: const Color(0xffF3F8FE),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: CircleAvatar(
                  backgroundColor: const Color(0xffFFCC00),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: _filterTutorials,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: filteredTutorials.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 4.0,
                  childAspectRatio: 3 / 3.5,
                ),
                itemBuilder: (context, index) {
                  final tutorial = filteredTutorials[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TutorialsDetailScreen(),
                        ),
                      );
                    },
                    child: _buildTutorialCard(
                      tutorial['title']!,
                      tutorial['image']!,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialCard(String title, String imagePath) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}