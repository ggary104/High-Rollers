#ifndef GAME_H
#define GAME_H

#include <iostream>
#include <string>
    using std::string;

class Game {

    public:
        // MUTATORS
        void pause(); 
        bool firstTurn();
        bool switchTurn();
        int rollDice();
        int putDice(int choice); 
        int computerChoice();
        

        // ACCESSORS
        bool checkGameover();
        int columnScore(int column[3]);
        int playerScore();
        int computerScore();
        void printGame();
        bool get_playerTurn();

    private:
        // ATTRIBUTES
        bool playerTurn;
        int roll = 0;
        int p1col1[3] = {0, 0, 0};
        int p1col2[3] = {0, 0, 0};
        int p1col3[3] = {0, 0, 0};
        int p2col1[3] = {0, 0, 0};
        int p2col2[3] = {0, 0, 0};
        int p2col3[3] = {0, 0, 0};

        // HELPERS
        string dicePrint(int columnValue, int i); 
        int insert(int choice, int roll, int column[2]);
        void remove(int roll, int column[2]);
};

#endif
