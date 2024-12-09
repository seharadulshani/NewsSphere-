import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/news_controller.dart';
import '../db_helper/db_connection.dart';
import '../models/news.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final NewsController newsController = Get.put(NewsController());
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _animationController;

  final List<List<Color>> gradients = [
    [Colors.blueAccent, Colors.purpleAccent],
    [Colors.teal, Colors.greenAccent],
    [Colors.orangeAccent, Colors.redAccent],
  ];

  int _currentGradientIndex = 0;

  @override
  void initState() {
    super.initState();
    newsController.fetchGeneralNews('apple');

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), _changeGradient);
  }

  void _changeGradient() {
    setState(() {
      _currentGradientIndex = (_currentGradientIndex + 1) % gradients.length;
    });

    Future.delayed(const Duration(seconds: 3), _changeGradient);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradients[_currentGradientIndex],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            children: [
              _buildAnimatedHeading(),
              _buildSearchBar(),
              Expanded(
                child: Obx(() {
                  if (newsController.newsArticlesEverything.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: newsController.newsArticlesEverything.length,
                    itemBuilder: (context, index) {
                      return NewsCard(
                        article: newsController.newsArticlesEverything[index],
                        animationController: _animationController,
                        animationDelay: index * 0.2,
                        parentContext: context,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedHeading() {
    return Padding(
      padding: const EdgeInsets.only(top: 86.0),
      child: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Text(
              "🔥 NewsSphere 🔥",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.8 + 0.2 * _animationController.value),
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for news...',
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (value) {
          newsController.fetchGeneralNews('apple', q: value);
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final Map<String, dynamic> article;
  final AnimationController animationController;
  final double animationDelay;
  final BuildContext parentContext;

  const NewsCard({
    Key? key,
    required this.article,
    required this.animationController,
    required this.animationDelay,
    required this.parentContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Animation<Offset> slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Slide from bottom
      end: Offset.zero,          // End at original position
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        animationDelay.clamp(0.0, 1.0),                     // Clamp begin value
        (animationDelay + 0.5).clamp(0.0, 1.0),             // Clamp end value
        curve: Curves.easeOut,
      ),
    ));

    return SlideTransition(
      position: slideAnimation,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () {
              // Navigate to ViewNewsPage
            },
            child: Column(
              children: [
                if (article['urlToImage'] != null) _buildImage(),
                _buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      child: Image.network(
        article['urlToImage'] ?? '',
        height: 140,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article['title'] ?? 'No Title',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            article['description'] ?? 'No Description',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 10),
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
                        : 'No Date',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border, color: Colors.blue),
                onPressed: () async {
                  var newsArticle = NewsArticle(
                    id: article['title'],
                    title: article['title'] ?? '',
                    description: article['description'] ?? '',
                    urlToImage: article['urlToImage'] ?? '',
                    publishedAt: article['publishedAt'] ?? '',
                  );
                  await DatabaseHelper.instance.insertBookmark(newsArticle);

                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    const SnackBar(
                      content: Text('Bookmark added successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
