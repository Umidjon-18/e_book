import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_app/bloc/genre_bloc/genre_state.dart';
import 'package:flutter_ebook_app/util/api.dart';
import 'package:flutter_ebook_app/util/functions.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/category.dart';

class GenreBloc extends Cubit<GenreState> {
  GenreBloc() : super(GenreState());
  ScrollController controller = ScrollController();
  List items = [];
  int page = 1;
  bool loadingMore = false;
  bool loadMore = true;
  GenreState apiRequestStatus = GenreStateIsLoading();
  Api api = Api();

  listener(url) {
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if (!loadingMore) {
          paginate(url);
          // Animate to bottom of list
          Timer(Duration(milliseconds: 100), () {
            controller.animateTo(
              controller.position.maxScrollExtent,
              duration: Duration(milliseconds: 100),
              curve: Curves.easeIn,
            );
          });
        }
      }
    });
  }

  getFeed(String url) async {
    setApiRequestStatus(GenreStateIsLoading());
    print(url);
    try {
      CategoryFeed feed = await api.getCategory(url);
      items = feed.feed!.entry!;
      setApiRequestStatus(GenreStateIsLoaded());
      listener(url);
    } catch (e) {
      checkError(e);
      throw (e);
    }
  }

  paginate(String url) async {
    if (apiRequestStatus != GenreStateIsLoading() && !loadingMore && loadMore) {
      Timer(Duration(milliseconds: 100), () {
        controller.jumpTo(controller.position.maxScrollExtent);
      });
      loadingMore = true;
      page = page + 1;
      emit(apiRequestStatus);
      try {
        CategoryFeed feed = await api.getCategory(url + '&page=$page');
        items.addAll(feed.feed!.entry!);
        loadingMore = false;

        emit(apiRequestStatus);
      } catch (e) {
        loadMore = false;
        loadingMore = false;

        emit(apiRequestStatus);
        throw (e);
      }
    }
  }

  void checkError(e) {
    if (Functions.checkConnectionError(e)) {
      setApiRequestStatus(GenreStateIsConnectionError());
      showToast('Connection error');
    } else {
      setApiRequestStatus(GenreStateIsError());
      showToast('Something went wrong, please try again');
    }
  }

  showToast(msg) {
    Fluttertoast.showToast(
      msg: '$msg',
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
  }

  void setApiRequestStatus(GenreState value) {
    apiRequestStatus = value;
    emit(value);
  }
}
