import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teraflow/features/blog/firestore_service.dart';
import 'package:teraflow/features/blog/blog.dart';

class AddBlogPage extends StatefulWidget {
  @override
  _AddBlogPageState createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  String? _selectedCategory; // For category selection

  // For loading state
  bool _isLoading = false;

  final FirestoreService _firestoreService = FirestoreService();

  final List<String> _categories = [
    'Lifestyle',
    'Health',
    'Education'
  ]; // Categories

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Blog')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              SizedBox(height: 12),

              // Content Field
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
                validator: (value) => value!.isEmpty ? 'Enter content' : null,
                maxLines: 4,
              ),
              SizedBox(height: 12),

              // Author Field
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Author'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter author name' : null,
              ),
              SizedBox(height: 12),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Select a category' : null,
              ),
              SizedBox(height: 20),

              // Add Blog Button
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitBlog,
                      child: Text('Add Blog'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitBlog() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Blog newBlog = Blog(
        id: '', // Firestore will auto-generate the ID
        title: _titleController.text,
        content: _contentController.text,
        author: _authorController.text,
        authorId: '123', // Replace with actual user ID if available
        category: _selectedCategory ??
            'Lifestyle', // Default category if none selected
        likes: 0,
        timestamp: DateTime.now(),
      );

      try {
        await _firestoreService.addBlog(newBlog);
        setState(() {
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Blog added successfully!')),
        );

        Navigator.pop(context); // Close the Add Blog Page
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add blog: $e')),
        );
      }
    }
  }
}
