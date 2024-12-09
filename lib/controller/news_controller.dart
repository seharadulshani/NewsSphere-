import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsController extends GetxController {
  static const apiKey = '5327333f66f14d9eb8a55f02de389aec';
  static const _baseUrl = 'https://newsapi.org/v2';
  RxList<dynamic> newsArticles = <dynamic>[].obs;
  RxList<dynamic> newsArticlesEverything = <dynamic>[].obs;
  RxList<dynamic> newsSource = <dynamic>[].obs;
  RxList<dynamic> likedArticles = <dynamic>[].obs;  // Store liked articles


  Future<void> fetchNews(String country) async {
    const url = '$_baseUrl/top-headlines?country=us&apiKey=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Fetched data: $data');  // Debugging line
        newsArticles.value = data['articles'];
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  // Fetch general news from everything endpoint (with optional query)
  Future<void> fetchGeneralNews(String s, {String? q}) async {
    final searchQuery = q ?? s;
    final url = '$_baseUrl/everything?q=$searchQuery&apiKey=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Fetched data: $data');  // Debugging line
        newsArticlesEverything.value = data['articles'];
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Fetch news based on date range
  Future<void> fetchNewsByDate(String s, {String? q, required String from, required String to}) async {
    final searchQuery = q ?? s;
    final url = '$_baseUrl/everything?q=$searchQuery&from=$from&to=$to&sortBy=popularity&apiKey=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        newsArticlesEverything.value = data['articles'];
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Toggle "like" status for articles
  void toggleLike(Map<String, dynamic> article) {
    if (likedArticles.contains(article)) {
      likedArticles.remove(article);  // Remove if already liked
    } else {
      likedArticles.add(article);  // Add to liked articles
    }
    update();  // Update UI
  }

  // Fetch sources of news
  Future<void> fetchSource() async {
    const url = '$_baseUrl/top-headlines/sources?apiKey=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        newsSource.value = data['sources'];
      } else {
        throw Exception('Failed to load sources');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

