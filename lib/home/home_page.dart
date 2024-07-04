import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/news_detail/news_detail.dart';
import 'bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeNews()),
      child: const HomePageView(),
    );
  }
}

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "TeamMekanik Malam",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeSuccess) {
            final articles = state.articles;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(LoadHomeNews());
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: articles!.length > 10 ? 10 : articles.length,
                itemBuilder: (BuildContext context, int index) {
                  final article = articles[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetail(
                            newsUrl: article.url ?? "",
                          ),
                        ),
                      );
                    },
                    leading: SizedBox(
                      height: 50,
                      width: 65,
                      child: Image.network(article.urlToImage ?? ""),
                    ),
                    title: Text(
                      article.title ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      article.description ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 20),
                  Text(
                    "Loading...",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
