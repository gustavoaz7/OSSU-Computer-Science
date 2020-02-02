package model.observer_pattern;

import java.util.ArrayList;
import java.util.List;

public abstract class Subject {

    private List<Observer> observers;

    public Subject(){
        observers = new ArrayList<>();
    }

    public List<Observer> getObservers() {
        return observers;
    }

    public void addObserver(Observer o) {
        observers.add(o);
    }

    @Override
    public void notifyObservers(BingoNumber currentCall){
        for (Observer o : getObservers()){
            o.update(currentCall);
        }
    }

}