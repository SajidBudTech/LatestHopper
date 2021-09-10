import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerControllButtons extends StatefulWidget {

  PlayerControllButtons({Key key,}):super(key: key);

  @override
  _PlayerControllButtonsState createState() => _PlayerControllButtonsState();

}

class _PlayerControllButtonsState extends State<PlayerControllButtons> {

  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
            child:IconButton(
                alignment: Alignment.center,
                iconSize: 36,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(
                  Icons.skip_previous_sharp,
                  color: Colors.black,
                  //size: 48,
                ),
                onPressed: () {

                }
            )),
        InkWell(
          onTap: (){

          },
          child: Image.asset("assets/images/back15.png",
            width: 65,
            height: 65,

          ),
        ),
        InkWell(
          onTap: (){
             setState(() {
               isPlaying=!isPlaying;
             });
          },
          child: isPlaying?
          Image.asset("assets/images/pause.png",
            width: 65,
            height: 65,
          )
          :Image.asset("assets/images/paly.png",
            width: 65,
            height: 65,
          ),
        ),
        InkWell(
          onTap: (){

          },
          child: Image.asset("assets/images/forward15.png",
            width: 65,
            height: 65,
          ),
        ),
        Container(
            child:IconButton(
                alignment: Alignment.center,
                iconSize: 36,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(
                  Icons.skip_next_sharp,
                  color: Colors.black,
                ),
                onPressed: () {

                }
            )),
      ],
    );
  }
}