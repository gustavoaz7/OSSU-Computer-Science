package model;

public class OversizedBook extends Book {

    private double shippingMultiplier;

    private static final double BASE_SHIPPING = 5.00;
    private static final String MIN_SIZE = "large";

    public OversizedBook(String title, double price) {
        super(title, price);

        if (price > 9.50) {
            shippingMultiplier = 2;
        } else {
            shippingMultiplier = 1.5;
        }
    }

    @Override
    public Box packageBook(Box b) {
        if (b.getSize().equals("large")) {
            System.out.println("The large box is big enough for this oversized book.");
        } else {
            System.out.println("This box is way too small for an oversized book!");
            return null;
        }
        this.setBox(b);
        b.setContents(this);
        return b;
    }

    @Override
    public double calculateShipping() {
        return BASE_SHIPPING * shippingMultiplier;
    }

    @Override
    public String getMinBoxSize() {
        System.out.println("An oversized book can only fit in a large box.");
        return MIN_SIZE;
    }

}
