
package model.exceptions;


public class WaterException extends Exception {
    private double water;

    public WaterException(double water){
        super("Insufficient water: " + water);
    }

    public double getWater() {
        return water;
    }
}