package model;

public class Box {

    private int size;
    private Book contents;

    private static final String[] SIZES = {"none", "small", "medium", "large"};
    private static final double BASE_SHIPPING = 5.50;

    public Box(String size) {
        if (size.equals("small")) {
            this.size = 1;
        } else if (size.equals("medium")) {
            this.size = 2;
        } else {
            this.size = 3;
        }

        contents = null;
    }

    public void setContents(Book contents) {
        this.contents = contents;
    }

    public String getSize() {
        return SIZES[size];
    }

    public double calculateShipping() {
        double price = BASE_SHIPPING * size;
        if (contents != null) {
            price = price + contents.calculateShipping();
        }
        return price;
    }
}
