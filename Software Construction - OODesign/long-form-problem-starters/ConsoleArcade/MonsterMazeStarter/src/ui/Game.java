package ui;

import model.Choice;
import model.Monster;
import model.Room;
import model.Treasure;

import java.util.Scanner;

public class Game {

    private static final String INVALID_CHOICE = "You have entered an invalid choice. Please try again.";
    private static final String ANOTHER_ROUND = "Y";
    private static final String STOP = "N";
    private static final String QUIT = "Q";

    private Choice current;
    private Choice start;
    private Scanner scanner;
    private boolean gameOver;

    public Game(Choice c) {
        start = c;
        current = start;
        scanner = new Scanner(System.in);
        gameOver = false;
        playGame();
    }

    private void playGame() {
        printInstructions();

        while(!gameOver) {
            parsePlayerNextInstruction();
            if (gameOver) break;
            current.printOutcome();
            if (roundOver())
                offerAnotherRound();
        }

        System.out.println("You have escaped...");
        scanner.close();
    }

    private void offerAnotherRound() {
        System.out.println("\nThere are no more choices; you have reached the end of the maze.");
        System.out.println("Would you like to play again? enter Y (Yes) or N (No): ");
    }

    private void parsePlayerNextInstruction() {
        String str = "";
        while (str.length() == 0)  {
            if (scanner.hasNext())
                str += scanner.nextLine();
        }
        str = str.trim();
        handleInput(str);
    }

    private void handleInput(String s) {
        if (s.length() > 0) {
            try {
                int input = Integer.parseInt(s);
                choose(input);
            } catch (NumberFormatException e){
                updateGameState(s.toUpperCase());
            }
        }
    }

    private void choose(int input) {
        if (current instanceof Room) {
            Room r = (Room) current;
            try {
                if (input <= 0) throw new Exception();
                current = r.getChoice(input);
            } catch (Exception e) {
                System.out.println(INVALID_CHOICE);
            }
        }
    }

    private void updateGameState(String command) {
        switch(command) {
            case QUIT:
            case STOP:
                gameOver = true;
                break;
            case ANOTHER_ROUND:
                current = start;
                break;
            default:
                System.out.println(INVALID_CHOICE);
                break;
        }
    }

    private void printInstructions() {
        System.out.println("Welcome to Monster Maze, a dangerous 'choose your own path' game.");
        System.out.println("You will travel through the maze by selecting a choice out of every set of options.");
        System.out.println("Once you make a choice, you cannot go backwards.");
        System.out.println("Enter q (Quit) at any time to escape the maze.");
        System.out.println("Good luck!\n");

        System.out.println("For each set of options, enter the number corresponding to your choice.\n");

        current.printOutcome();
    }

    private boolean roundOver() {
        return (current instanceof Monster) || (current instanceof Treasure);
    }

}