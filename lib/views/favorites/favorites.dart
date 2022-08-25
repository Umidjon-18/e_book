import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_app/components/book.dart';
import 'package:flutter_ebook_app/models/category.dart';

import '../../bloc/favorites_bloc/favorites_cubit.dart';
import '../../bloc/favorites_bloc/favorites_state.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  @override
  void deactivate() {
    super.deactivate();
    getFavorites();
  }

  getFavorites() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          BlocProvider.of<FavoritesBloc>(context, listen: false).getFavorites();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Favorites',
            ),
          ),
          body: context.read<FavoritesBloc>().posts.isEmpty
              ? _buildEmptyListView()
              : _buildGridView(context),
        );
      
      },
    );
  }

  _buildEmptyListView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/images/empty.png',
            height: 300.0,
            width: 300.0,
          ),
          Text(
            'Nothing is here',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _buildGridView(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      shrinkWrap: true,
      itemCount: context.read<FavoritesBloc>().posts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 200 / 340,
      ),
      itemBuilder: (BuildContext context, int index) {
        Entry entry = Entry.fromJson(context.read<FavoritesBloc>().posts[index]['item']);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: BookItem(
            img: entry.link![1].href!,
            title: entry.title!.t!,
            entry: entry,
          ),
        );
      },
    );
  }
}
