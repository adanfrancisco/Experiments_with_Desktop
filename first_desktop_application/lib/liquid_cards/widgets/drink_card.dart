import 'package:first_desktop_application/liquid_cards/data/demo_data.dart';
import 'package:first_desktop_application/liquid_cards/styles/styles.dart';
import 'package:first_desktop_application/liquid_cards/widgets/rounded_shadow.dart';

import 'dart:math';

import 'package:flutter/material.dart';

class DrinkListCard extends StatefulWidget {
  static double nominalHeightClosed = 96;
  static double nominalHeightOpen = 290;

  final Function(DrinkData) onTap;

  final bool isOpen;
  final DrinkData drinkData;
  final int earnedPoints;

  const DrinkListCard({
    Key key,
    this.onTap,
    this.isOpen,
    this.drinkData,
    this.earnedPoints,
  }) : super(key: key);

  @override
  _DrinkListCardState createState() => _DrinkListCardState();
}

class _DrinkListCardState extends State<DrinkListCard>
    with SingleTickerProviderStateMixin {
  bool _wasOpen;
  Animation<double> _fillTween;
  Animation<double> _pointsTween;

  AnimationController _liquidSimController;

  //TODO: Create Simulation...

  @override
  void initState() {
    super.initState();
    _liquidSimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );

    _liquidSimController.addListener(_rebuildIfOpen);

    // Raises the fill level of the card
    _fillTween = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _liquidSimController,
        curve: Interval(.12, .45, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _liquidSimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Determine the points required text value, using the _pointsTween
    var pointsRequired = widget.drinkData.requiredPoints;

    // print('IS OPEN >>>> ${widget.isOpen}');

    // widget.earnedPoints -> always same 150.0
    // Value is taken min. b/w 1 and the division...(as animation max value is 1.0)
    double _maxFillLevel = min(
      1,
      widget.earnedPoints / widget.drinkData.requiredPoints,
    );

    double fillLevel = _maxFillLevel;

    double cardHeight = widget.isOpen
        ? DrinkListCard.nominalHeightOpen
        : DrinkListCard.nominalHeightClosed;

    return GestureDetector(
      onTap: _handleTap,
      child: RoundedShadow.fromRadius(
        12.0,
        child: Container(
          color: Color(0xff303238),
          child: Stack(
            children: <Widget>[
              //Card Content
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 24),
                      _buildTopContent(),
                      //Spacer
                      const SizedBox(height: 12.0),
                      _buildBottomContent(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildTopContent() => Row(
        children: <Widget>[
          //Icon
          Image.asset(
            "assets/images/" + widget.drinkData.iconImage,
            fit: BoxFit.fitWidth,
            width: 50.0,
          ),
          SizedBox(width: 24),
          //Label
          Expanded(
            child: Text(
              widget.drinkData.title.toUpperCase(),
              style: Styles.text(18, Colors.white, true),
            ),
          ),
          //Star Icon
          Icon(Icons.star, size: 20, color: AppColors.orangeAccent),
          SizedBox(width: 4),
          //Points Text
          Text(
            "${widget.drinkData.requiredPoints}",
            style: Styles.text(20, Colors.white, true),
          )
        ],
      );

  // TODO Add param
  Column _buildBottomContent() {
    return Column(
      children: <Widget>[
        SizedBox(height: 16),
        Text(
          "Redeem your points for a cup of happiness! Our signature espresso is blanced with steamed milk and topped with a light layer of foam. ",
          textAlign: TextAlign.center,
          style: Styles.text(14, Colors.white, false, height: 1.5),
        ),
        const SizedBox(height: 16.0),
        //Main Button
        //Main Button
        ButtonTheme(
          minWidth: 200,
          height: 40,
          child: FlatButton(
            onPressed: () {},
            color: AppColors.orangeAccent,
            disabledColor: AppColors.orangeAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text("REDEEM", style: Styles.text(16, Colors.white, true)),
          ),
        )
      ],
    );
  }

  /// Override the handle tap...
  /// Pass the drinkData back to the callee.
  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap(widget.drinkData);
    }
  }

  void _rebuildIfOpen() {
    if (widget.isOpen) {
      setState(() {});
    }
  }
}
