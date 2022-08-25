import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_app/components/body_builder.dart';
import 'package:flutter_ebook_app/components/book_list_item.dart';
import 'package:flutter_ebook_app/components/loading_widget.dart';
import 'package:flutter_ebook_app/models/category.dart';

import '../../bloc/genre_bloc/genre_cubit.dart';
import '../../bloc/genre_bloc/genre_state.dart';

class Genre extends StatefulWidget {
  final String title;
  final String url;

  Genre({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  _GenreState createState() => _GenreState();
}

class _GenreState extends State<Genre> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => BlocProvider.of<GenreBloc>(context, listen: false)
          .getFeed(widget.url),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenreBloc, GenreState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('${widget.title}'),
          ),
          body: _buildBody(context),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return BodyBuilder(
      genreApiRequestStatus: context.read<GenreBloc>().apiRequestStatus,
      child: _buildBodyList(context),
      reload: () => context.read<GenreBloc>().getFeed(widget.url),
    );
  }

  _buildBodyList(BuildContext context) {
    return ListView(
      controller: context.read<GenreBloc>().controller,
      children: <Widget>[
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          shrinkWrap: true,
          itemCount: context.read<GenreBloc>().items.length,
          itemBuilder: (BuildContext context, int index) {
            Entry entry = context.read<GenreBloc>().items[index];
            return Padding(
              padding: EdgeInsets.all(5.0),
              child: BookListItem(
                entry: entry,
              ),
            );
          },
        ),
        SizedBox(height: 10.0),
        context.read<GenreBloc>().loadingMore
            ? Container(
                height: 80.0,
                child: _buildProgressIndicator(),
              )
            : SizedBox(),
      ],
    );
  }

  _buildProgressIndicator() {
    return LoadingWidget();
  }
}
