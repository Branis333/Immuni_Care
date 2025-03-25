import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class News {
  final String status;
  final int totalResults;
  final List<Article> articles;

  News({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
        status: json["status"] as String,
        totalResults: json["totalResults"] as int,
        articles: (json["articles"] as List)
            .map((x) => Article.fromJson(x as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": articles.map((x) => x.toJson()).toList(),
      };

  // Add this static method to fetch news
  static Future<List<Article>> getNewsArticles() async {
    List<Article> list = [];
    String link =
        "https://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=25cc2a2feaae431cba2a6150e0cee0a5";
    try {
      print("Fetching news from API...");
      var res = await http
          .get(Uri.parse(link), headers: {"Accept": "application/json"});

      print("API Response status: ${res.statusCode}");
      if (res.body.isNotEmpty) {
        print(
            "API Response preview: ${res.body.substring(0, min(100, res.body.length))}...");
      }

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
          return getSampleNewsData(); // Fall back to sample data
        }

        var rest = data["articles"] as List;
        list = rest.map<Article>((json) => Article.fromJson(json)).toList();
        print("Successfully parsed ${list.length} news articles");
      } else {
        print("API Error: Status code ${res.statusCode}");
        print("Response body: ${res.body}");
        return getSampleNewsData(); // Fall back to sample data
      }
    } catch (e) {
      print("Error fetching news: $e");
      return getSampleNewsData(); // Fall back to sample data
    }
    return list.isEmpty ? getSampleNewsData() : list;
  }

  // Fallback data in case API fails
  static List<Article> getSampleNewsData() {
    return [
      Article(
          source: Source(id: "sample-1", name: "Health News"),
          title: "Childhood Vaccination: Important Facts Parents Should Know",
          description:
              "Vaccinations help protect your children against serious diseases. Learn about vaccination schedules and benefits.",
          url: "https://example.com/vaccination",
          publishedAt: DateTime.now().subtract(Duration(days: 2)),
          content:
              "Vaccination is one of the best ways to protect your children from potentially deadly diseases."),
      Article(
          source: Source(id: "sample-2", name: "Medical Journal"),
          title: "How to Keep Your Child Healthy During Flu Season",
          description:
              "Practical tips to protect your family during the winter months.",
          url: "https://example.com/flu-season",
          publishedAt: DateTime.now().subtract(Duration(days: 5)),
          content:
              "Regular handwashing and avoiding contact with sick individuals can help prevent flu."),
      Article(
          source: Source(id: "sample-3", name: "Pediatrics Today"),
          title: "New Research on Child Development Milestones",
          description:
              "Recent studies reveal important insights about developmental markers.",
          url: "https://example.com/development",
          publishedAt: DateTime.now().subtract(Duration(days: 7)),
          content:
              "Understanding developmental milestones can help parents identify potential issues earlier."),
    ];
  }
}

class Article {
  final Source source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String? content;

  Article({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: Source.fromJson(json["source"] as Map<String, dynamic>),
        author: json["author"] as String?,
        title: json["title"] as String,
        description: json["description"] as String?,
        url: json["url"] as String,
        urlToImage: json["urlToImage"] as String?,
        publishedAt: DateTime.parse(json["publishedAt"] as String),
        content: json["content"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "source": source.toJson(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt.toIso8601String(),
        "content": content,
      };
}

class Source {
  final String? id;
  final String name;

  Source({
    this.id,
    required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"] as String?,
        name: json["name"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
