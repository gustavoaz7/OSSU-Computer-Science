package model;

public class Monster extends Choice {

    private Treasure treasure;

    public Monster() {
        super("Fight a monster.");
        treasure = null;
    }

    public void setTreasure(Treasure t) {
        this.treasure = t;
    }

    public void printOutcome() {
        if (treasure == null) {
            System.out.println("Ha! I killed you!");
        } else {
            System.out.println("Ahh! You killed me!");
            treasure.printOutcome();
        }
    }

}