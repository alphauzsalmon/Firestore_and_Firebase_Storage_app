import 'package:app_with_firebase/blocs/bloc/firestore_bloc.dart';
import 'package:app_with_firebase/screens/widgets/home_page_widgets/home_page_widgets.dart';
import 'package:flutter/material.dart';


class GridViewPage extends StatelessWidget {
  final ImagesLoaded state;
  const GridViewPage({Key? key, required this.state}) : super(key: key);

  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarWidget(),
      body: state.images.pictures.isEmpty
          ? const Center(
              child: Text(
                "Please add images",
                style: TextStyle(color: Colors.black),
              ),
            )
          : Column(
              children: [
                const Text("For delete press long on image"),
                SizedBox(
                  height: size.height - 100.0,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: (itemWidth / itemHeight),
                    ),
                    itemBuilder: (context, index) {
                      return ImagePlace(state: state, index: index,);
                    },
                    itemCount: state.images.pictures.length,
                  ),
                ),
              ],
            ),
      floatingActionButton: const FloatingActionButtonWidget(),
    );
  }
}
