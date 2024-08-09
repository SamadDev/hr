import 'package:flutter/material.dart';

typedef ListViewBuilder = Widget Function(BuildContext context, int index);

class ListBuilder extends StatelessWidget {
  final ListViewBuilder itemBuilder;

  ListBuilder({
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      reverse: true,
      itemCount: 64,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
      itemBuilder: (context, index) {
        var xIndex = index % 8;
        var yIndex = (index / 8).floor();
        var tileId = '${tileLetter[xIndex]}${yIndex + 1}';
        return Container(
          color: (xIndex + yIndex).isEven ? Colors.black : Colors.white,
          child: Stack(
            children: <Widget>[
              Text(
                tileId,
                style: TextStyle(
                  color: (xIndex + yIndex).isOdd ? Colors.black : Colors.white,
                  fontSize: 12,
                ),
              ),
              itemBuilder(context, index),
            ],
          ),
        );
      },
    );
  }

  final Map<int, String> tileLetter = {
    0: 'A',
    1: 'B',
    2: 'C',
    3: 'D',
    4: 'E',
    5: 'F',
    6: 'G',
    7: 'H',
  };
}
