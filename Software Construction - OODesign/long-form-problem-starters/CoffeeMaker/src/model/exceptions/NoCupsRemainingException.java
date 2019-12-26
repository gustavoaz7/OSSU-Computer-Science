package model.exceptions;


public class NoCupsRemainingException extends Exception {
    public NoCupsRemainingException(){
        super("No cups remaining. Cannot pour coffee anymore.");
    }
}