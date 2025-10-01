#include "game.hpp"
#include <cmath>
#include <string>
#include <iostream>

// MUTATORS
void Game::pause(){
    std::cout << "Hit enter to continue" << std::endl;
    std::cin.ignore(1000, '\n');
    std::cin.get();
}
bool Game::firstTurn() {
    (rand() % 2) ? playerTurn = true: playerTurn = false;
    return playerTurn;
}
bool Game::switchTurn() {
    (playerTurn) ? playerTurn = false : playerTurn = true;
    roll = 0;
    return playerTurn;
}
int Game::rollDice() {
    roll = rand() % 6 + 1;
    return roll;
}
int Game::putDice(int choice) {
    if(playerTurn) {
        // Player turn
        if (choice == 1){
            choice = insert(choice, roll, p1col1);
            remove(roll, p2col1);
        } else if (choice == 2){
            choice = insert(choice, roll, p1col2);
            remove(roll, p2col2);
        } else if (choice == 3){
            choice = insert(choice, roll, p1col3);
            remove(roll, p2col3);
        } else {
            return 0;
        }
    } else {
        // Computer turn
        if (choice == 1){
            choice = insert(choice, roll, p2col1);
            remove(roll, p1col1);
        } else if (choice == 2){
            choice = insert(choice, roll, p2col2);
            remove(roll, p1col2);
        } else if (choice == 3){
            choice = insert(choice, roll, p2col3);
            remove(roll, p1col3);
        } else {
            return 0;
        }
    }
    return choice;
}
int Game::computerChoice(){
    // Scores per column
    int col1Score = 0;
    int col2Score = 0;
    int col3Score = 0;
    
    int match = 10;
    int opponent = 4;
    int empty = 1;

    // Set score for least full columns
    for(int i = 0; i < 3; i++){
        if(p2col1[i] == 0){
            col1Score += empty;
        }
        if(p2col2[i] == 0){
            col2Score += empty;
        }
        if(p2col3[i] == 0){
            col3Score += empty;
        }
    }

    // Set score for matching dice
    for(int i = 0; i < 3;i++){
        if(p2col1[i] == roll && p2col1[2] == 0){
            col1Score += match;
        }
        if(p2col2[i] == roll && p2col2[2] == 0){
            col2Score += match;
        }
        if(p2col3[i] == roll && p2col3[2] == 0){
            col3Score += match;
        }
    }

    // Set score for opponent deletes
    for(int i = 0; i < 3;i++){
        if(p1col1[i] == roll && p2col1[2] == 0){
            col1Score += opponent;
        }
        if(p1col2[i] == roll && p2col2[2] == 0){
            col2Score += opponent;
        }
        if(p1col3[i] == roll && p2col3[2] == 0){
            col3Score += opponent;
        }
    }

    // Return Result
    if(rand() % 2){
        if(col1Score > col2Score && col1Score > col3Score){
            return 1;
        } else if(col2Score > col1Score && col2Score > col3Score){
            return 2;
        } else if(col3Score > col1Score && col3Score > col2Score){
            return 3;
        } else if(col1Score == col2Score){
            return rand() % 2+1;
        } else if(col2Score == col3Score){
            return rand() % 2+2;
        } else if(col1Score == col3Score){
            if(rand() % 2){ 
                return 1;
            } else {
                return 3;
            }
        }
    }
    return rand() % 3+1;
}

// ACCESSORS
bool Game::checkGameover() {
    bool gameover = false;
    ((p1col1[2] == 0 || p1col2[2] == 0 || p1col3[2] == 0) 
    && (p2col1[2] == 0 || p2col2[2] == 0 || p2col3[2] == 0)) 
    ? gameover = false : gameover = true;
    return gameover;
}
int Game::columnScore(int column[3]) {
    int score = 0;
    for (int i = 0; i < 3; i++){
        for (int j = 0; j < 3; j++){
            if(column[i] == column[j]) {
                score += column[i];
            }
        }
    }
    return score;
}
int Game::playerScore(){
    return columnScore(p1col1) + columnScore(p1col2) + columnScore(p1col3);
}
int Game::computerScore(){
    return columnScore(p2col1) + columnScore(p2col2) + columnScore(p2col3);
}
void Game::printGame(){
    // Visual Blocks
    std::string empty = "          ";
    
    // PRINT GAME
    system("cls");
    // Computer Side
    std::cout << std::endl << empty << empty << empty <<"|||||||||||||||||||||||||||||||||||||||||" << std::endl;
    for(int i = 1; i < 6; i++){
            std::cout << empty << empty << empty << "||"
            << dicePrint(p2col1[2], i) << " ||" 
            << dicePrint(p2col2[2], i) << " ||"
            << dicePrint(p2col3[2], i) << " ||" << std::endl;
    }
    for(int i = 6; i < 11; i++){
            std::cout << empty;
            (!playerTurn) ? std::cout << dicePrint(roll, i) : std::cout << empty; 
            std::cout << empty << "||"
            << dicePrint(p2col1[1], i) << " ||"
            << dicePrint(p2col2[1], i) << " ||"
            << dicePrint(p2col3[1], i) << " ||"<< std::endl;
    }
    for(int i = 11; i < 16; i++){
            std::cout << empty << empty << empty << "||"
            << dicePrint(p2col1[0], i) << " ||"
            << dicePrint(p2col2[0], i) << " ||"
            << dicePrint(p2col3[0], i) << " ||" << std::endl;
    }

    // GAP
    std::cout << empty << empty << empty << "|||||||||||||||||||||||||||||||||||||||||" << std::endl; 

    // Computer scores
    std::cout << empty << empty << empty << "      "; 
    if (columnScore(p2col1) < 10){
        std::cout << " ";
    }
    std::cout << columnScore(p2col1) << empty << " "; 

    if (columnScore(p2col2) < 10){
        std::cout << " ";
    }
    std::cout << columnScore(p2col2) << empty << " ";
    
    if (columnScore(p2col3) < 10){
        std::cout << " ";
    }
    std::cout << columnScore(p2col3) << std::endl << std::endl;
    
    // Gameover
    std::cout << empty << empty << empty << empty << "      "; 
    if(!checkGameover()){
        std::cout << "P1  -  P2"  << std::endl;
    } else if(playerScore() == computerScore()){
        std::cout << " A Draw!";
        std::cout << std::endl;
    } else if (playerScore() > computerScore()){
        std::cout << "P1  Wins!";
        std::cout << std::endl;
    } else {
        std::cout << "P2  Wins!";
        std::cout << std::endl;
    } 
    
    // Game Score
    std::cout << empty << empty << empty << empty << "      "; 
    if(playerScore() < 10){
        std::cout << " ";
    }
    std::cout << playerScore() << "  - "; 
    if (computerScore() > 9){
        std::cout << " ";
    }
    if(computerScore() < 10){
        std::cout << " ";
    }
    std::cout << computerScore() << std::endl << std::endl;


    // Player Scores
    std::cout << empty << empty << empty << "      "; 
    if (columnScore(p1col1) < 10){
        std::cout << " ";
    }
    std::cout << columnScore(p1col1) << empty << " "; 

    if (columnScore(p1col2) < 10){
        std::cout << " ";
    }
    std::cout << columnScore(p1col2) << empty << " ";
    
    if (columnScore(p1col3) < 10){
        std::cout << " ";
    }
    std::cout << columnScore(p1col3) << std::endl;

    std::cout << empty << empty << empty 
    <<"|||||||||||||||||||||||||||||||||||||||||"
    << std::endl;
    
    // Player side
    for(int i = 1; i < 6; i++){
            std::cout << empty << empty << empty << "||" 
            << dicePrint(p1col1[0], i) << " ||"
            << dicePrint(p1col2[0], i) << " ||"
            << dicePrint(p1col3[0], i) << " ||" << std::endl;
    }
    for(int i = 6; i < 11; i++){
            std::cout << empty;
            (playerTurn) ? std::cout << dicePrint(roll, i) : std::cout << empty; 
            std::cout << empty << "||" 
            << dicePrint(p1col1[1], i) << " ||"
            << dicePrint(p1col2[1], i) << " ||"
            << dicePrint(p1col3[1], i) << " ||" << std::endl;
    }
    for(int i = 11; i < 16; i++){
            std::cout << empty << empty << empty << "||"
            << dicePrint(p1col1[2], i) << " ||"
            << dicePrint(p1col2[2], i) << " ||"
            << dicePrint(p1col3[2], i) << " ||" << std::endl;
    }
    std::cout << empty << empty << empty <<"|||||||||||||||||||||||||||||||||||||||||" << std::endl;
    std::cout << empty << empty << empty << "    Column 1 " << "    Column 2 " << "    Column 3 " << std::endl;
}
bool Game::get_playerTurn(){
    return playerTurn;
}

// HELPERS
std::string Game::dicePrint(int columnValue, int i){
    // Visual Blocks
    std::string empty = "          ";
    std::string edge =  "  ------- ";
    std::string zero =  " |       |";
    std::string one =   " |   O   |";  
    std::string two =   " | O   O |";
    std::string right = " |     O |";
    std::string left =  " | O     |";

    // Empty
    if(columnValue == 0) {
        return empty;
    } else if(columnValue != 0 && i == 1 || i == 5 || i == 6 || i == 10 || i == 11 || i == 15){
        // Edges
        return edge;
    } else if (columnValue == 1) {
        // One
        if(i == 2 || i == 7 || i == 12 || i == 4 || i == 9 || i == 14){
            return zero;
        } else if (i == 3 || i == 8 || i == 13){
            return one;
        }
    } else if (columnValue == 2){
        // Two
        if(i == 2 || i == 4 || i == 7 || i == 9 || i == 12 || i == 14){
            return zero;
        } else if ( i == 3 || i == 8 || i == 13) {
            return two;
        } 
    } else if (columnValue == 3){
        // Three
        if(i == 2 || i == 7 || i == 12){
            return left;
        } else if (i == 4 || i == 9 || i == 14){
            return right;
        } else if (i == 3 || i == 8 || i == 13){
            return one;
        }
    } else if (columnValue == 4){
        // Four
        if(i == 2 || i == 4 || i == 7 || i == 9 || i == 12 || i == 14){
            return two;
        } else if(i == 3 || i == 8 || i == 13){
            return zero;
        }
    } else if (columnValue == 5){
        //Five
        if(i == 2 || i == 4 || i == 7 || i == 9 || i == 12 || i == 14){
            return two;
        } else if(i == 3 || i == 8 || i == 13){
            return one;
        }
    } else if (columnValue == 6){
        // Six
        return two;
    } 
    return empty;
}
int Game::insert(int choice, int roll, int column[2]){
    if (column[0] == 0) {
        column[0] = roll;
    } else if (column[1] == 0) {
        column[1] = roll;
    } else if (column[2] == 0) {
        column[2] = roll;
    } else {
        return 0;
    }
    return choice;  
}
void Game::remove(int roll, int column[2]){
    for(int i = 0; i < 3; i++){
        if(column[i] == roll){
            if(i == 0){
                column[i] = column[i+1];
                column[i+1] = column[i+2];
                column[i+2] = 0;
                i--;
            } else if (i == 1){
                column[i] = column[i+1];
                column[i+1] = 0;
                i -= 2;
            } else if (i == 2){
                column[i] = 0;
            }
        }
    }
}
