package model;

public class StandardSizeBook extends Book {

    private static final double FLAT_RATE_SHIPPING = 2.00;
    private static final String MIN_BOX_SIZE = "medium";

    public StandardSizeBook(String title, double price) {
        super(title, price);
    }

    @Override
    public Box packageBook(Box b) {
        if (b.getSize().equals("medium")) {
            System.out.println("The book fits snugly into this box.");
        } else {
            System.out.println("This box is a little big for the book, but it fits.");
        }
        this.setBox(b);
        b.setContents(this);
        return b;
    }

    @Override
    public double calculateShipping() {
        return FLAT_RATE_SHIPPING;
    }

    @Override
    public String getMinBoxSize() {
        System.out.println("A standard size book can fit in a medium or large box.");
        return MIN_BOX_SIZE;
    }
}
