import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_app/components/body_builder.dart';
import 'package:flutter_ebook_app/components/book_card.dart';
import 'package:flutter_ebook_app/components/book_list_item.dart';
import 'package:flutter_ebook_app/models/category.dart';
import 'package:flutter_ebook_app/util/consts.dart';
import 'package:flutter_ebook_app/util/router.dart';
import 'package:flutter_ebook_app/views/genre/genre.dart';

import '../../bloc/home_bloc/home_cubit.dart';
import '../../bloc/home_bloc/home_state.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => BlocProvider.of<HomeBloc>(context, listen: false).getFeeds(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              '${Constants.appName}',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          body: _buildBody(context),
        );
      
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return BodyBuilder(
      homeApiRequestStatus: context.read<HomeBloc>().state,
      child: _buildBodyList(context),
      reload: () => context.read<HomeBloc>().getFeeds(),
    );
  }

  Widget _buildBodyList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<HomeBloc>().getFeeds(),
      child: ListView(
        children: <Widget>[
          _buildFeaturedSection(context),
          SizedBox(height: 20.0),
          _buildSectionTitle('Categories'),
          SizedBox(height: 10.0),
          _buildGenreSection(context),
          SizedBox(height: 20.0),
          _buildSectionTitle('Recently Added'),
          SizedBox(height: 20.0),
          _buildNewSection(context),
        ],
      ),
    );
  }

  _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$title',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  _buildFeaturedSection(BuildContext context) {
    return Container(
      height: 200.0,
      child: Center(
        child: ListView.builder(
          primary: false,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: context.read<HomeBloc>().top.feed?.entry?.length ?? 0,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            Entry entry = context.read<HomeBloc>().top.feed!.entry![index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: BookCard(
                img: entry.link![1].href!,
                entry: entry,
              ),
            );
          },
        ),
      ),
    );
  }

  _buildGenreSection(BuildContext context) {
    return Container(
      height: 50.0,
      child: Center(
        child: ListView.builder(
          primary: false,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: context.read<HomeBloc>().top.feed?.link?.length ?? 0,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            Link link = context.read<HomeBloc>().top.feed!.link![index];

            // We don't need the tags from 0-9 because
            // they are not categories
            if (index < 10) {
              return SizedBox();
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  onTap: () {
                    MyRouter.pushPage(
                      context,
                      Genre(
                        title: '${link.title}',
                        url: link.href!,
                      ),
                    );
                  },
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '${link.title}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _buildNewSection(BuildContext contextr) {
    return ListView.builder(
      primary: false,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: context.read<HomeBloc>().recent.feed?.entry?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        Entry entry = context.read<HomeBloc>().recent.feed!.entry![index];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: BookListItem(
            entry: entry,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
