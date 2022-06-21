import 'dart:async';

import 'package:bubble_trouble/utilities/ball.dart';
import 'package:bubble_trouble/utilities/button.dart';
import 'package:bubble_trouble/utilities/colors.dart';
import 'package:bubble_trouble/utilities/missile.dart';
import 'package:bubble_trouble/utilities/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum BallDirection { left, right }

class _HomePageState extends State<HomePage> {
//player positional variables
  static double playerX = 0;

//projectile positional variables
  double missileX = playerX;
  double missileY = 1;
  double missileHeight = 10;
  bool isFired = false;

//ball positional variables
  double ballX = 0;
  double ballY = 1;
  var ballDirection = BallDirection.left;

  void moveLeft() {
    setState(() {
      if (playerX >= -1) {
        playerX -= 0.1;
      }
      if (!isFired) {
        missileX = playerX;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (playerX <= 1) {
        playerX += 0.1;
      }
      if (!isFired) {
        missileX = playerX;
      }
    });
  }

  void resetMissile() {
    missileX = playerX;
    missileHeight = 10;
    isFired = false;
  }

  void fireMissile() {
    if (!isFired) {
      Timer.periodic(const Duration(milliseconds: 100), (timer) {
        isFired = true;

        setState(() {
          missileHeight += 50;
        });

        // when missile reches the top it will stop
        if (missileHeight > (MediaQuery.of(context).size.height * 3 / 4)) {
          resetMissile();
          timer.cancel();
        }
        // when missile reaches the ball it will stop
        if (ballY > heightToPosition(missileHeight) &&
            (ballX - missileX).abs() < 0.03) {
          resetMissile();
          ballX = 5;
          timer.cancel();
        }
      });
    }
  }

  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  void startGame() {
    //veriables required to create an parabolic equation
    double time = 0;
    double height = 0;
    double velocity = 50;

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      height = -5 * time * time + velocity * time;
      if (height < 0) {
        time = 0;
      }
      setState(() {
        ballY = heightToPosition(height);
      });

      //when ball hits the left wall it will hange its direction
      if (ballX - 0.005 < -1) {
        ballDirection = BallDirection.right;
      } else if (ballX + 0.005 > 1) {
        ballDirection = BallDirection.left;
      }
      //when ball hits the right wall it will hange its direction
      if (ballDirection == BallDirection.left) {
        setState(() {
          ballX -= 0.005;
        });
      } else if (ballDirection == BallDirection.right) {
        setState(() {
          ballX += 0.005;
        });
      }
      // check if the ball hits the player
      if (playerDies()) {
        timer.cancel();
        print('Game over pal');
        _showDialog();
      }
      //time ticking
      time += 0.1;
    });
  }

  bool playerDies() {
    //if ball position and player position is the same player dies
    if ((ballX - playerX).abs() < 0.05 && (ballY > 0.95)) {
      return true;
    }
    return false;
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[700],
            title: Text(
              'You are done',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        } else if (event.isKeyPressed(LogicalKeyboardKey.space)) {
          fireMissile();
        }
      },
      child: Column(
        children: [
          //Upper part -> Playable field
          Expanded(
            flex: 3,
            child: Container(
              color: AppColors.primary,
              child: Center(
                child: Stack(
                  children: [
                    //Objects of the field
                    Ball(ballX: ballX, ballY: ballY),
                    Missile(
                      missileX: missileX,
                      missileHeight: missileHeight,
                    ),
                    MyPlayer(
                      playerX: playerX,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
            color: AppColors.secondary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyButton(
                  icon: Icons.play_arrow,
                  function: startGame,
                ),
                MyButton(
                  icon: Icons.arrow_back,
                  function: moveLeft,
                ),
                MyButton(
                  icon: Icons.arrow_upward,
                  function: fireMissile,
                ),
                MyButton(
                  icon: Icons.arrow_forward,
                  function: moveRight,
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
