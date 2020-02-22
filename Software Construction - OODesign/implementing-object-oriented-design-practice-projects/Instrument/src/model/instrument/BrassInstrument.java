package model.instrument;

import model.Orchestra;

public abstract class BrassInstrument implements Instrument {

    private Orchestra orchestra;

    public BrassInstrument(Orchestra orchestra) {
        this.orchestra = orchestra;
    }

    public void setOrchestra(Orchestra orchestra) {
        if (!this.orchestra.equals(orchestra)) {
            this.orchestra = orchestra;
            orchestra.addBrassInstrument(this);
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof BrassInstrument)) return false;

        BrassInstrument that = (BrassInstrument) o;

        return orchestra != null ? orchestra.equals(that.orchestra) : that.orchestra == null;
    }

    @Override
    public int hashCode() {
        return orchestra != null ? orchestra.hashCode() : 0;
    }
}
