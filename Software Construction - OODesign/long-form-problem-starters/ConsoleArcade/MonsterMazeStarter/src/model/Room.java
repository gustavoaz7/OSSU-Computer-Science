package model;

import java.util.ArrayList;
import java.util.List;

public class Room extends Choice {

    private List<Choice> nextChoices;
    private int id;

    public Room(int id) {
        super("Enter Room " + id + ".");
        this.id = id;
        nextChoices = new ArrayList<>();
        nextChoices.add(0, null);
    }

    public void addChoice(Choice c) {
        nextChoices.add(c);
    }

    public Choice getChoice(int index) {
        return nextChoices.get(index);
    }

    public void printOutcome() {
        System.out.println("You are now in Room " + id + ".\n");
        System.out.println("You have the following options: ");

        for (int i=1; i < nextChoices.size(); i++) {
            System.out.print("\tOption " + i + ": ");
            nextChoices.get(i).printOption();
        }
    }

}