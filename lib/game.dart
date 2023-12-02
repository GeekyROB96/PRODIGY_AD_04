import 'package:flutter/material.dart';

class GameFile extends StatefulWidget {
  const GameFile({Key? key}) : super(key: key);

  @override
  State<GameFile> createState() => _GameFileState();
}

class _GameFileState extends State<GameFile> {
  List<List<String>> gameGrid = [];
  List<List<Color>> cellColors = [];
  String currentPlayer = '';
  List<int> winningIndices = [];

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void highlightWinningCells() {
    setState(() {
      // Change the color of the winning cells to yellow
      winningIndices.forEach((index) {
        int row = index ~/ 3;
        int col = index % 3;
        cellColors[row][col] = Colors.yellow;
      });
    });
  }

  void onCellClick(int row, int col) {
    if (gameGrid[row][col].isEmpty) {
      setState(() {
        gameGrid[row][col] = currentPlayer;
        cellColors[row][col] = Colors.lightGreen;
        currentPlayer = (currentPlayer == 'O') ? 'X' : 'O';
      });

      String winner = checkWinner();
      if (winner.isNotEmpty) {
        Future.delayed(const Duration(seconds: 2), () {
          showWinnerDialog(winner);
        });
      }
    }
  }

  void showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text(
          winner == 'Draw' ? 'It\'s a Draw' : 'Player $winner wins!!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              newGame();
              Navigator.pop(context);
            },
            child: const Text('New Game'),
          ),
        ],
      ),
    );
  }

  String checkWinner() {
    for (int i = 0; i < 3; i++) {
      if (gameGrid[i][0].isNotEmpty &&
          gameGrid[i][0] == gameGrid[i][1] &&
          gameGrid[i][1] == gameGrid[i][2]) {
        winningIndices = [i * 3, i * 3 + 1, i * 3 + 2];
        return gameGrid[i][0];
      }

      if (gameGrid[0][i].isNotEmpty &&
          gameGrid[0][i] == gameGrid[1][i] &&
          gameGrid[2][i] == gameGrid[1][i]) {
        winningIndices = [i, i + 3, i + 6];
        return gameGrid[0][i];
      }
    }

    if (gameGrid[0][0].isNotEmpty &&
        gameGrid[0][0] == gameGrid[1][1] &&
        gameGrid[1][1] == gameGrid[2][2]) {
      winningIndices = [0, 4, 8];
      return gameGrid[0][0];
    }

    if (gameGrid[0][2].isNotEmpty &&
        gameGrid[0][2] == gameGrid[1][1] &&
        gameGrid[1][1] == gameGrid[2][0]) {
      winningIndices = [2, 4, 6];
      return gameGrid[0][2];
    }

    bool isDraw = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (gameGrid[i][j].isEmpty) {
          isDraw = false;
          break;
        }
      }
    }
    if (isDraw) {
      return 'Draw';
    }
    return '';
  }

  void newGame() {
    setState(() {
      startGame();
    });
  }

  void startGame() {
    gameGrid = List.generate(3, (_) => List.filled(3, ''));
    cellColors = List.generate(3, (_) => List.filled(3, Colors.brown));
    currentPlayer = 'O';
    winningIndices = [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          " Tic-Tac-Toe ",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF3B3A3B),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF3B3A3B),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Current Player",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  currentPlayer,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: currentPlayer == 'X' ? Colors.red.shade700 : Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 55,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;

                  bool isWinningCell = winningIndices.contains(index);
                  Color cellColor = isWinningCell ? Colors.yellow : cellColors[row][col];

                  return GestureDetector(
                    onTap: () => onCellClick(row, col),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange, width: 5.0),
                        color: cellColor,
                      ),
                      child: Center(
                        child: Text(
                          gameGrid[row][col],
                          style: TextStyle(
                            fontSize: 48,
                            color: gameGrid[row][col] == 'X' ? Colors.red.shade700 : Colors.blue.shade700,
                            fontWeight: FontWeight.bold,     ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: newGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade300,
              ),
              child: const Text("Reset Game"),
            ),
          ],
        ),
      ),
    );
  }
}
