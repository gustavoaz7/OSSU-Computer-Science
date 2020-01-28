package model;

import model.instrument.BrassInstrument;
import model.instrument.StringInstrument;
import java.util.ArrayList;


public class Orchestra {

    private ArrayList<BrassInstrument> brassInstruments = new ArrayList<>();
    private ArrayList<StringInstrument> stringInstruments = new ArrayList<>();

    public Orchestra(ArrayList<BrassInstrument> brassInstruments, ArrayList<StringInstrument> stringInstruments) {
        this.brassInstruments = brassInstruments;
        this.stringInstruments = stringInstruments;
    }

    public void addBrassInstrument(BrassInstrument b) {
        if(!brassInstruments.contains(b)) {
            brassInstruments.add(b);
            b.setOrchestra(this);
        }
    }

    public void addStringInstrument(StringInstrument s) {
        if(!stringInstruments.contains(s)) {
            stringInstruments.add(s);
            s.setOrchestra(this);
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Orchestra)) return false;

        Orchestra orchestra = (Orchestra) o;

        if (
            brassInstruments != null
            ? !brassInstruments.equals(orchestra.brassInstruments)
            : orchestra.brassInstruments != null
        ) return false;
        
        return stringInstruments != null ? stringInstruments.equals(orchestra.stringInstruments) : orchestra.stringInstruments == null;
    }

    @Override
    public int hashCode() {
        int result = brassInstruments != null ? brassInstruments.hashCode() : 0;
        result = 31 * result + (stringInstruments != null ? stringInstruments.hashCode() : 0);
        return result;
    }
}
