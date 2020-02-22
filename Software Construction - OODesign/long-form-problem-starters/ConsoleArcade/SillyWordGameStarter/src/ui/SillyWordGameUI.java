package ui;

import model.SillyWordGame;
import model.Phrase;
import model.words.WordEntry;

import java.util.Scanner;

public class SillyWordGameUI {

    private SillyWordGame wordGame;
    private Scanner s;

    public static void main(String[] args) {
        new SillyWordGameUI(new PhraseResource());
    }

    public SillyWordGameUI(PhraseResource pr) {
        s = new Scanner(System.in);
        wordGame = new SillyWordGame(pr.generatePhraseList());
        userInteraction();
        printSillyGame();
    }

    private void userInteraction(){
        for (Phrase p : wordGame) {
            WordEntry w = p.getNeededWordEntry();

            printWordInputDescription(w);

            String input = "";
            while (input.length() == 0) {
                if (s.hasNext())
                    input = s.nextLine();
            }
            input = input.trim();
            p.fillWordEntry(input);
        }
    }

    private void printSillyGame() {
        for(Phrase p : wordGame.getAllPhrases())
            System.out.println(p.toString());
    }

    private void printWordInputDescription(WordEntry w) {
        StringBuilder str = new StringBuilder(w.getType().getInstructions());
        String desc = w.getDescription();
        if (desc.length() > 0) {
            str.append(" (" ).append(desc).append( ")");
        }
        str.append(": ");
        System.out.println(str.toString());
    }
}