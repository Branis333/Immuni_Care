import 'package:flutter/material.dart';
import '../data/news.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunicare/theme/bloc.dart';

class NewsDetails extends StatefulWidget {
  final Article article;

  const NewsDetails(this.article, {super.key});

  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  static const String defaultImage =
      "https://www.healthcareitnews.com/sites/hitn/files/Global%20healthcare_2.jpg";

  @override
  Widget build(BuildContext context) {
    // Using BLoC instead of Provider for theme
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Health News'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Image with error handling
            SizedBox(
              height: 250,
              child: widget.article.urlToImage != null
                  ? Image.network(
                      widget.article.urlToImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.network(defaultImage, fit: BoxFit.cover),
                    )
                  : Image.network(defaultImage, fit: BoxFit.cover),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.article.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 20.0,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ),

            // Description
            if (widget.article.description != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  widget.article.description!,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),

            // Content
            if (widget.article.content != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.article.content!,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),

            // Source and date
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isDarkMode 
                    ? Theme.of(context).cardColor 
                    : Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Source: ${widget.article.source.name}",
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Published: ${_formatDate(widget.article.publishedAt)}",
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // Read more button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // You can implement URL launching here if needed
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Link opening is not implemented'),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                },
                icon: Icon(Icons.open_in_new),
                label: Text('Read Full Article'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<List<Article>> getData() async {
    List<Article> list = [];
    // Replace the old API key with your new one
    String link =
        "https://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=24af34a799b243f4b8ab48b8e3887b63";
    try {
      print("Fetching news from API...");
      var res = await http
          .get(Uri.parse(link), headers: {"Accept": "application/json"});

      print("API Response status: ${res.statusCode}");
      print(
          "API Response body preview: ${res.body.substring(0, min(100, res.body.length))}...");

      if (res.statusCode == 200) {
        var data = json.decode(res.body);

        // Check if the status is "ok" from the API
        if (data["status"] != "ok") {
          print("API returned non-OK status: ${data["status"]}");
          if (data["code"] != null) {
            print("Error code: ${data["code"]}");
          }
          if (data["message"] != null) {
            print("Error message: ${data["message"]}");
          }
          return [];
        }

        var rest = data["articles"] as List;
        list = rest.map<Article>((json) => Article.fromJson(json)).toList();
        print("Successfully parsed ${list.length} news articles");
      } else {
        print("API Error: Status code ${res.statusCode}");
        print("Response body: ${res.body}");
      }
    } catch (e) {
      print("Error fetching news: $e");
    }
    return list;
  }
}