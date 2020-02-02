package model;

public abstract class Choice {

    private String optionMessage;

    public Choice(String optionMessage) {
        this.optionMessage = optionMessage;
    }

    public void printOption() {
        System.out.println(optionMessage);
    }

    public abstract void printOutcome();

}