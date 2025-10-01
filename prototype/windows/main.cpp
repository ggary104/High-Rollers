#include "game.hpp"
#include <iostream>
#include <ctime>
#include <cmath>
#include <string>
    using std::string;
    using std::cout;
    using std::cin;

int main() {
    
    // Initiate Game
    int playAgain = 0;
    do{
        // Initializations
        srand (time(NULL));
        Game Game1;
        playAgain = 0;
        Game1.firstTurn();
        
        // Start 
        Game1.printGame();
        std::cout << "Press enter to start!" << std::endl;
        std::cin.get();
        int players = 0;
        while (players != 1 && players != 2){
            Game1.printGame();
            std::cout << "Pick 1 or 2 players: " << std::endl;
            std::cin >> players;
        }

        // Indiviudual Game Loop
        while(!Game1.checkGameover()){
            Game1.rollDice();
            Game1.printGame();
            int choice = 0;
            if(Game1.get_playerTurn()){
                // Player 1 Turn 
                std::cout << "Player 1 (Bottom board): Place dice in column 1, 2, or 3." << std::endl;
                while (choice == 0) {
                    std::cin >> choice;
                    choice = Game1.putDice(choice);
                }
            } else {
                if(players == 2){
                    // Player 2 Turn 
                    std::cout << "Player 2 (Top Board): Place dice in column 1, 2, or 3." << std::endl;
                    while (choice == 0) {
                        std::cin >> choice;
                        choice = Game1.putDice(choice);
                    }
                } else if (players == 1) {
                    // Computer 2 Turn
                    Game1.pause();
                    while (choice == 0) {
                        choice = Game1.computerChoice();
                        Game1.printGame();
                        choice = Game1.putDice(choice);
                    }
                }
            }
            Game1.switchTurn();
        }
        // End of Game Print
        Game1.printGame();
        Game1.pause();
        while (playAgain != 1 && playAgain != 2){
            Game1.printGame();
            std::cout << "Enter 1 to play again or 2 to quit!: " << std::endl;
            std::cin >> playAgain;
        }
    } while (playAgain == 1);

    return 0;
}
