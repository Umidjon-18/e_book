import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_app/bloc/favorites_bloc/favorites_state.dart';
import 'package:flutter_ebook_app/database/favorite_helper.dart';

class FavoritesBloc extends Cubit<FavoritesState> {
  FavoritesBloc() : super(FavoritesState());
  List posts = [];
  bool loading = true;
  var db = FavoriteDB();

  getFavorites() async {
    setLoading(true);
    posts.clear();
    List all = await db.listAll();
    posts.addAll(all);
    setLoading(false);
  }

  void setLoading(value) {
    loading = value;
    emit(FavoritesState());
  }

  void setPosts(value) {
    posts = value;
    emit(FavoritesState());
  }

  List getPosts() {
    return posts;
  }
}
