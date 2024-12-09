import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pavani/controller/news_controller.dart';
import 'package:pavani/models/news.dart';
import 'package:pavani/screens/view_news.dart';
import 'package:share_plus/share_plus.dart';

import '../db_helper/db_connection.dart';

class SearchNews extends StatelessWidget {
  final NewsController newsController = Get.put(NewsController());

  @override
  Widget build(BuildContext context) {
    newsController.fetchNews('us'); // Fetch news on initialization

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue, Colors.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text(
                  "NewsSphere",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
              ),
              Expanded(
                child: Obx(() {
                  if (newsController.newsArticles.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: newsController.newsArticles.length,
                      itemBuilder: (context, index) {
                        var article = newsController.newsArticles[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewNewsPage(
                                      article: NewsArticle(
                                        id: article['title'],
                                        title: article['title'],
                                        description: article['description'],
                                        urlToImage: article['urlToImage'] ?? '',
                                        publishedAt: article['publishedAt'] ?? '',
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (article['urlToImage'] != null)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                      child: Image.network(
                                        article['urlToImage']!,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article['title'] ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          article['description'] ?? '',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                                const SizedBox(width: 5),
                                                Text(
                                                  article['publishedAt'] != null
                                                      ? DateFormat('yMMMd').format(DateTime.parse(article['publishedAt']))
                                                      : '',
                                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.share, color: Colors.blueAccent),
                                              onPressed: () {
                                                final String shareContent = "${article['title']} - ${article['url']}";
                                                Share.share(shareContent);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
