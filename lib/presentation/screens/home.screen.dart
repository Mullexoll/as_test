import 'package:anti_school_test/presentation/widgets/home_screen_widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/app_bloc/app_bloc.dart';
import '../../domain/models/card.model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  disableStyle() {
    return BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: Colors.blueAccent, width: 2),
      borderRadius: BorderRadius.circular(10),
    );
  }

  activeStyle() {
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
          if (state is AppLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is AppLoaded) {
            List<CardModel> orderedCards =
                state.remoteConfigCardsOrder.map((id) {
              return state.cardsList.firstWhere((card) {
                if (card.cardId == 'сard_4') {
                  return 'card_4' == id;
                }
                return card.cardId == id;
              });
            }).toList();

            return Column(
              children: [
                const Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: PageView.builder(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderedCards.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CardWidget(
                        cardData: orderedCards[index],
                      );
                    },
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => setState(() {
                          if (currentPage > 0) {
                            currentPage--;
                          }
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.linear,
                          );
                        }),
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration:
                              currentPage == 0 ? disableStyle() : activeStyle(),
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
                        onTap: () => setState(() {
                          if (currentPage < state.cardsList.length - 1) {
                            currentPage++;
                          }
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.linear,
                          );
                        }),
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: currentPage >= state.cardsList.length - 1
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
                )
              ],
            );
          }

          return const SizedBox.shrink();
        }),
      ),
    );
  }
}
