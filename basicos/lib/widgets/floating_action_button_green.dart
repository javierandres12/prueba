import 'package:flutter/material.dart';

class FloatingActionButtonGreen extends StatefulWidget {

  final VoidCallback onPressedFav;
  final IconData iconData;

  FloatingActionButtonGreen({Key key,
    @required this.onPressedFav,
    @required this.iconData
});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FloatingActionButtonGreen();
  }

}


class _FloatingActionButtonGreen extends State<FloatingActionButtonGreen> {

  @override
  Widget build(BuildContext context) {


    // TODO: implement build
    return FloatingActionButton(
      backgroundColor: Color(0xFF11DA53),
      mini: true,
      tooltip: "Fav",
      onPressed: widget.onPressedFav,
      child: Icon(
        widget.iconData
      ),
      heroTag: null,
    );
  }

}