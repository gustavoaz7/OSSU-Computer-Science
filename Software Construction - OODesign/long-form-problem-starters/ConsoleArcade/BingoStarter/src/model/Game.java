package model;

import model.observer_pattern.Observer;
import model.observer_pattern.Subject;
import model.random.BingoNumber;

import java.util.ArrayList;
import java.util.List;

public class Game extends Subject {

    public static final int CARD_SIZE = 25;
    public static final int SIDE_LENGTH = (int) Math.sqrt(CARD_SIZE);

    private BingoNumber currentCall;
    private boolean gameOver;

    public Game() {
        callNext();
    }

    public BingoNumber getCurrentCall(){
        return currentCall;
    }

    public boolean isGameOver(){
        return gameOver;
    }

    public List<PlayerCard> getCards() {
        List<PlayerCard> playerCards = new ArrayList<>();
        for (Observer o : getObservers()) {
            if (o.getClass().getSimpleName().equals("PlayerCard"))
                playerCards.add((PlayerCard) o);
        }
        return playerCards;
    }

    public void callNext() {
        currentCall = new BingoNumber();
        notifyObservers(currentCall);
        checkGameOver();
    }

    public void addPlayerCard(PlayerCard pc) {
        addObserver(pc);
    }


    private void checkGameOver(){
        for (Observer o : getObservers()) {
            PlayerCard p = (PlayerCard) o;
            if (p.hasBingo()) {
                gameOver = true;
                break;
            }
        }
    }
}