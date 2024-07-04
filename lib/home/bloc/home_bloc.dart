import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../model/news_model.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeNews>(_onLoadHomeNews);
  }
  Future<void> _onLoadHomeNews(
    LoadHomeNews event,
    Emitter<HomeState> emit,
  ) async {
    const String apiKey = '2a64b8778cf64afbbff558b7d84bb0e5';
    const String query = 'mobil';
    const String url =
        'https://newsapi.org/v2/everything?q=$query&language=id&apiKey=$apiKey';
    emit(HomeLoading());
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final NewsModel news = NewsModel.fromJson(data);
        emit(HomeSuccess(articles: news.articles));
      } else {
        emit(HomeFailure(articles: const []));
      }
    } catch (e) {
      emit(HomeFailure(articles: const []));
    }
  }
}
