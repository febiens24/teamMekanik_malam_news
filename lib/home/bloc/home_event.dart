part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class LoadHomeNews extends HomeEvent {}

class SearchNews extends HomeEvent {}
