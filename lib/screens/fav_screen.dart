import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/news_controller.dart';
import '../db_helper/db_connection.dart';

class FavScreen extends StatefulWidget {
  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  final NewsController newsController = Get.put(NewsController());
  final TextEditingController _searchController = TextEditingController();

  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    newsController.fetchGeneralNews('apple');
  }

  // Date picker for From date
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  // Date picker for To date
  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildSearchBar(),
              _buildDateSelectors(context),
              Expanded(
                child: Obx(() {
                  if (newsController.newsArticlesEverything.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: newsController.newsArticlesEverything.length,
                    itemBuilder: (context, index) {
                      var article = newsController.newsArticlesEverything[index];
                      return NewsCard(
                        article: article,
                        onLikePressed: () {
                          newsController.toggleLike(article);
                        },
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for news...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          hintStyle: const TextStyle(color: Colors.black),
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

  Widget _buildDateSelectors(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          TextButton(
            onPressed: () => _selectFromDate(context),
            child: Text(_fromDate == null
                ? 'Select From Date'
                : DateFormat.yMMMd().format(_fromDate!)),
          ),
          const Text('to'),
          TextButton(
            onPressed: () => _selectToDate(context),
            child: Text(_toDate == null
                ? 'Select To Date'
                : DateFormat.yMMMd().format(_toDate!)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_fromDate != null && _toDate != null) {
                newsController.fetchNewsByDate('apple',
                    from: DateFormat('yyyy-MM-dd').format(_fromDate!),
                    to: DateFormat('yyyy-MM-dd').format(_toDate!));
              }
            },
            child: const Text('Fetch News by Date'),
          ),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final Map<String, dynamic> article;
  final VoidCallback onLikePressed;

  const NewsCard({
    Key? key,
    required this.article,
    required this.onLikePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          if (article['urlToImage'] != null)
            Image.network(article['urlToImage']),
          _buildContent(),
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: onLikePressed,
          ),
        ],
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            article['description'] ?? 'No Description',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    article['publishedAt'] ?? 'No Date',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
