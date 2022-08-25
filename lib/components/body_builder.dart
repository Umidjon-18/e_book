import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/bloc/home_bloc/home_state.dart';
import 'package:flutter_ebook_app/components/error_widget.dart';
import 'package:flutter_ebook_app/components/loading_widget.dart';

import '../bloc/genre_bloc/genre_state.dart';

class BodyBuilder extends StatelessWidget {
  final HomeState? homeApiRequestStatus;
  final GenreState? genreApiRequestStatus;
  final Widget child;
  final Function reload;

  BodyBuilder(
      {Key? key, this.homeApiRequestStatus, this.genreApiRequestStatus, required this.child, required this.reload})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    if (homeApiRequestStatus != null) {
      if (homeApiRequestStatus is HomeStateIsLoading) return LoadingWidget();
      if (homeApiRequestStatus is HomeStateIsUnInitialized) return LoadingWidget();
      if (homeApiRequestStatus is HomeStateIsConnectionError)
        return MyErrorWidget(
          refreshCallBack: reload,
          isConnection: true,
        );
      if (homeApiRequestStatus is HomeStateIsError)
        return MyErrorWidget(
          refreshCallBack: reload,
          isConnection: true,
        );
      if (homeApiRequestStatus is HomeStateIsLoaded)
        return child;
      else
        return LoadingWidget();
    }
    if (genreApiRequestStatus != null) {
      if (genreApiRequestStatus is GenreStateIsLoading) return LoadingWidget();
      if (genreApiRequestStatus is GenreStateIsUnInitialized) return LoadingWidget();
      if (genreApiRequestStatus is GenreStateIsConnectionError)
        return MyErrorWidget(
          refreshCallBack: reload,
          isConnection: true,
        );
      if (genreApiRequestStatus is GenreStateIsError)
        return MyErrorWidget(
          refreshCallBack: reload,
          isConnection: true,
        );
      if (genreApiRequestStatus is GenreStateIsLoaded)
        return child;
      else
        return LoadingWidget();
    }
    return LoadingWidget();
  }
}


// explore, home, genre 