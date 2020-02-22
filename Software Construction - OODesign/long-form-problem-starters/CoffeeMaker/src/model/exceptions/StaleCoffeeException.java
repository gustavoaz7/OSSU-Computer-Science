package model.exceptions;

public class StaleCoffeeException extends Exception {
    private int time;

    public StaleCoffeeException(int time){
        super("After " + time + " the coffee is stale!");
        this.time = time;
    }

    public int getTime(){
        return time;
    }
}