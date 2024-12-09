import 'package:flutter/material.dart';
import 'package:pavani/models/news_article.dart';
import 'package:pavani/service/new_api_service.dart';

class SourceScreen extends StatefulWidget {
  const SourceScreen({super.key});

  @override
  State<SourceScreen> createState() => _SourceScreenState();

}



class _SourceScreenState extends State<SourceScreen> {
  late Future<List<NewsModel>> _headLines;

  @override
  void initState() {
    super.initState();
    _headLines = NewsApiService().fetchTopHeadlines(country: 'us');

  }
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    Colors.black,
                    Colors.black,
                    Color(0xFF1A1A2E),
                    Colors.white,
                  ]
                : [
                    Colors.white,
                    Color(0xFF1A1A0E),
                    Color(0xFF1A1A1E),
                    Color(0xFA1A1A3F),
                  ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.4, 0.4, 0.7, 8],
          ),
        ),
        child: FutureBuilder<List<NewsModel>>(
          future: _headLines,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No articles found.'));
            } else {
              final articles = snapshot.data!;
              print("Heloooooooooooooooooooooooooooooooooooo$articles");
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 50.0, left: 16.0, right: 16.0),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // Image.asset('assets/images/newspaper.png',
                              //     width: 44, height: 44),
                              Text(
                                'News App',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(height: 0),
                        ],
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'All News',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        )),
                    Column(
                      children: [
                        FutureBuilder<List<NewsModel>>(
                          future: _headLines,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No articles found.'));
                            } else {
                              final articles = snapshot.data!;
                              print("Heloooooooooooooooooooooooooooooooooooo$articles");
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: articles.length,
                                    itemBuilder: (context, index) {
                                      final article = articles[index];
                                      return GestureDetector(
                                        onTap: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         ViewNewsPage(
                                          //             article: article),
                                          //   ),
                                          // );
                                        },
                                        child: Container(
                                          height: 120,
                                          width: 100,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 20.0),
                                          child: Card(
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (article.urlToImage !=
                                                        null)
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.network(
                                                          article.urlToImage!,
                                                          height: 100,
                                                          width: 100,
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Container(
                                                              height: 100,
                                                              width: 100,
                                                              color: Colors
                                                                  .grey[300],
                                                              child: const Icon(
                                                                Icons.image,
                                                                size: 40,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    else
                                                      Container(
                                                        height: 200,
                                                        width: 100,
                                                        color: Colors.grey[300],
                                                        child: const Icon(
                                                          Icons.image,
                                                          size: 40,
                                                        ),
                                                      ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            article.title ?? '',
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: 80,
                                                                height: 40,
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            Colors.black),
                                                                    shape:
                                                                        MaterialStateProperty
                                                                            .all(
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    article
                                                                        .source
                                                                        .name,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          8,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              IconButton(
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 30,
                                                                ),
                                                                onPressed: () {
                                                                  // _addFavorite(
                                                                  //     article);
                                                                },
                                                              ),
                                                              Container(
                                                                height: 35,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child:
                                                                    IconButton(
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .download,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 20,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    // _saveArticle(
                                                                    //     article);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
