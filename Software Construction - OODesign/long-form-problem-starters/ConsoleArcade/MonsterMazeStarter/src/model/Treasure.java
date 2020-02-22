package model;

public class Treasure extends Choice {

    private int prize;

    public Treasure(int prize) {
        super("Claim your treasure!");
        this.prize = prize;
    }

    public void printOutcome() {
        System.out.println("Your prize is " + prize + " spendibees.");
    }

}