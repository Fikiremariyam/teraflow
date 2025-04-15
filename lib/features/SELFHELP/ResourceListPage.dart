import 'package:flutter/material.dart';
import 'package:teraflow/features/SELFHELP/resource_service.dart';
import 'resource_detail_page.dart';

class ResourceListPage extends StatefulWidget {
  @override
  _ResourceListPageState createState() => _ResourceListPageState();
}

class _ResourceListPageState extends State<ResourceListPage> {
  List<dynamic> resources = [];

  @override
  void initState() {
    super.initState();
    loadResourcesData();
  }

  Future<void> loadResourcesData() async {
    List<dynamic> loadedResources = await ResourceService.loadResources();
    setState(() {
      resources = loadedResources;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Self Help Resources',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: resources.length,
                itemBuilder: (context, index) {
                  final resource = resources[index];

                  // Ensure imageUrl exists, fallback to a default image
                  String? imageUrl =
                      resource['imageUrl'] ?? resource['thumbnailUrl'];

                  if (imageUrl == null) {
                    print(
                        'Error: Missing image for ${resource['title']}'); // Debugging
                    imageUrl =
                        'lib/images/default.png'; // Use a placeholder image
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResourceDetailPage(
                            resource: resource,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.broken_image,
                                size: 80,
                                color: Colors.grey,
                              ), // Handle broken image
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  resource['title'] ?? 'Untitled',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  resource['description'] ??
                                      'No description available',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      height: 1.3),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
