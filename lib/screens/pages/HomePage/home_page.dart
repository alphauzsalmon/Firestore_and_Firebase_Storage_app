import 'package:app_with_firebase/blocs/bloc/firestore_bloc.dart';
import 'package:app_with_firebase/repositories/images_repository.dart';
import 'package:app_with_firebase/screens/widgets/home_page_widgets/grid_view.dart';
import 'package:app_with_firebase/screens/widgets/home_page_widgets/home_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImagesBloc(
        imagesRepository: ImagesRepository(),
      )..add(
          LoadImages(),
        ),
      child: BlocBuilder<ImagesBloc, ImagesState>(builder: (context, state) {
        if (state is ImagesLoading) {
          return const Loading();
        } else if (state is ImagesLoaded) {
          return GridViewPage(
            state: state,
          );
        } else {
          return const WrongText(text: "Something went wrong...");
        }
      }),
    );
  }
}
