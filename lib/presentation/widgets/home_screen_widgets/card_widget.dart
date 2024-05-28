import 'package:anti_school_test/domain/models/card.model.dart';
import 'package:anti_school_test/presentation/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CardWidget extends StatelessWidget {
  final CardModel cardData;

  const CardWidget({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Uri.tryParse(cardData.imageUrl) != null
              ? Image.network(
                  cardData.imageUrl,
                  width: 200,
                  height: 200,
                  errorBuilder: (e, s, o) => SizedBox(
                    child: Text('Error url -> ${cardData.imageUrl}'),
                  ),
                )
              : Image.asset(
                  '${cardData.imageUrl}.png',
                  width: 200,
                  height: 200,
                ),
          const Gap(20),
          Text(
            cardData.word,
            style: mainTextStyle(),
          ),
          const Gap(20),
          Text(
            cardData.translation,
            style: mainTextStyle(),
          ),
        ],
      ),
    );
  }
}
