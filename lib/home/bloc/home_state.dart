part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final List<Article>? articles;

  HomeSuccess({required this.articles});
}

final class HomeFailure extends HomeState {
  final List<Article>? articles;

  HomeFailure({required this.articles});
}
