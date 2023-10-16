import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/constants.dart';

class TicTacToeWidget extends StatefulWidget {
  const TicTacToeWidget({super.key});

  @override
  State<TicTacToeWidget> createState() => _TicTacToeWidgetState();
}

class _TicTacToeWidgetState extends State<TicTacToeWidget> {
  bool playerATurn = true;
  List<String> displayElement = ['', '', '', '', '', '', '', '', ''];
  int playerAScore = 0;
  int playerBScore = 0;
  int filledBoxes = 0;

  void clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayElement[i] = '';
      }
    });
    filledBoxes = 0;
  }

  Widget _buildScoreColumn(String playerName, int score) {
    return Padding(
      padding: const EdgeInsets.all(10.0), // Adjust padding for landscape
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            playerName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            score.toString(),
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCell(String text) {
    return Container(
      width: 50,
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return Scaffold(
      backgroundColor: Colors.black,
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildScoreColumn(AConstants.playerA, playerBScore),
                    _buildScoreColumn(AConstants.playerB, playerAScore),
                  ],
                ),
              ),
              Expanded(
                flex: data.size.shortestSide < 550 ? 3 : 6,
                child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: orientation == Orientation.landscape && data.size.shortestSide < 550
                        ? 4
                        : orientation == Orientation.portrait && data.size.shortestSide > 550
                            ? 1
                            : orientation == Orientation.portrait && data.size.shortestSide < 550
                                ? 1
                                : 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _onTapClick(index);
                      },
                      child: _buildGridCell(displayElement[index]),
                    );
                  },
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: _clearScoreBoard,
                      child: const Text(AConstants.clearScoreBoard),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _clearScoreBoard() {
    setState(() {
      playerBScore = 0;
      playerAScore = 0;
      for (int i = 0; i < 9; i++) {
        displayElement[i] = '';
      }
    });
    filledBoxes = 0;
  }

  void _showWinDialog(String winner) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("\" $winner \" is Winner!!!"),
            actions: [
              TextButton(
                child: const Text(AConstants.playAgain),
                onPressed: () {
                  clearBoard();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });

    if (winner == 'O') {
      playerAScore++;
    } else if (winner == 'X') {
      playerBScore++;
    }
  }

  void _showDrawDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(AConstants.draw),
            actions: [
              TextButton(
                child: const Text(AConstants.playAgain),
                onPressed: () {
                  clearBoard();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _getWinner() {
    final List<List<int>> winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];
    for (final combination in winningCombinations) {
      final firstElement = displayElement[combination[0]];
      final secondElement = displayElement[combination[1]];
      final thirdElement = displayElement[combination[2]];
      if (firstElement == secondElement && secondElement == thirdElement && firstElement != '') {
        _showWinDialog(firstElement);
        break;
      }
    }
    if (filledBoxes == 9) {
      _showDrawDialog();
    }
  }

  void _onTapClick(int index) {
    setState(() {
      if (displayElement[index] == '') {
        displayElement[index] = playerATurn ? 'O' : 'X';
        filledBoxes++;
        playerATurn = !playerATurn;
        _getWinner();
      }
    });
  }
}
