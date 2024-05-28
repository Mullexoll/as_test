import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/app_bloc/app_bloc.dart';

class HomeScreenButtons extends StatelessWidget {
  final int currentPage;
  final Function moveToPreviousPage;
  final Function moveToNextPage;

  const HomeScreenButtons({
    super.key,
    required this.currentPage,
    required this.moveToPreviousPage,
    required this.moveToNextPage,
  });

  BoxDecoration disableStyle() {
    return BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: Colors.blueAccent, width: 2),
      borderRadius: BorderRadius.circular(10),
    );
  }

  BoxDecoration activeStyle() {
    return BoxDecoration(
      border: Border.all(color: Colors.blueAccent, width: 2),
      borderRadius: BorderRadius.circular(10),
      gradient: const LinearGradient(
        colors: [
          Colors.indigo,
          Colors.blue,
          Colors.lightBlueAccent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => moveToPreviousPage(),
            child: Container(
              width: 150,
              height: 50,
              decoration: currentPage == 0 ? disableStyle() : activeStyle(),
              child: const Center(
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => moveToNextPage(),
            child: Container(
              width: 150,
              height: 50,
              decoration: currentPage >=
                      (context.read<AppBloc>().state as AppLoaded)
                              .cardsList
                              .length -
                          1
                  ? disableStyle()
                  : activeStyle(),
              child: const Center(
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
