
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_app/bloc/home_bloc/home_state.dart';
import 'package:flutter_ebook_app/models/category.dart';
import 'package:flutter_ebook_app/util/api.dart';
import 'package:flutter_ebook_app/util/functions.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(HomeState());
  CategoryFeed top = CategoryFeed();
  CategoryFeed recent = CategoryFeed();
  HomeState apiRequestStatus = HomeStateIsLoading();
  Api api = Api();

  getFeeds() async {
    setApiRequestStatus(HomeStateIsLoading());
    try {
      CategoryFeed popular = await api.getCategory(Api.popular);
      setTop(popular);
      CategoryFeed newReleases = await api.getCategory(Api.recent);
      setRecent(newReleases);
      setApiRequestStatus(HomeStateIsLoaded());
    } catch (e) {
      checkError(e);
    }
  }

  void checkError(e) {
    if (Functions.checkConnectionError(e)) {
      setApiRequestStatus(HomeStateIsConnectionError());
    } else {
      setApiRequestStatus(HomeStateIsError());
    }
  }

  void setApiRequestStatus(HomeState value) {
    apiRequestStatus = value;
    emit(apiRequestStatus);
  }

  void setTop(value) {
    top = value;
    emit(apiRequestStatus);
  }

  CategoryFeed getTop() {
    return top;
  }

  void setRecent(value) {
    recent = value;
    emit(apiRequestStatus);
  }

  CategoryFeed getRecent() {
    return recent;
  }
}
