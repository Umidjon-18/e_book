import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_app/bloc/app_bloc/app_cubit.dart';
import 'package:flutter_ebook_app/bloc/detail_bloc/detail_cubit.dart';
import 'package:flutter_ebook_app/bloc/home_bloc/home_cubit.dart';
import 'package:flutter_ebook_app/util/consts.dart';
import 'package:flutter_ebook_app/theme/theme_config.dart';
import 'package:flutter_ebook_app/views/splash/splash.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/app_bloc/app_state.dart';
import 'bloc/favorites_bloc/favorites_cubit.dart';
import 'bloc/genre_bloc/genre_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(providers: [
        BlocProvider(create: (_) => AppBloc()),
        BlocProvider(create: (_) => DetailsBloc()),
        BlocProvider(create: (_) => HomeBloc()),
        BlocProvider(create: (_) => FavoritesBloc()),
        BlocProvider(create: (_) => GenreBloc()),
        
      ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        AppBloc().checkTheme();
        return MaterialApp(
          key: context.read<AppBloc>().key,
          debugShowCheckedModeBanner: false,
          navigatorKey: context.read<AppBloc>().navigatorKey,
          title: Constants.appName,
          theme: themeData(context.read<AppBloc>().theme),
          darkTheme: themeData(ThemeConfig.darkTheme),
          home: Splash(),
        );
      },
    );
  }

  // Apply font to our app's theme
  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
      colorScheme: theme.colorScheme.copyWith(
        secondary: ThemeConfig.lightAccent,
      ),
    );
  }
}
