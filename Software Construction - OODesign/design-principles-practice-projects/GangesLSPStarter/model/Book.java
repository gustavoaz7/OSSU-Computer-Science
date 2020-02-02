package model;

/**
 * A book that's available for purchase.
 */
public class Book {

    private String title;
    private double price;
    private Box box;

    private static final double FLAT_RATE_SHIPPING = 2.00;
    private static final String MIN_BOX_SIZE = "medium";

    public Book(String title, double price) {
        this.title = title;
        this.price = price;
        this.box = null; // book starts off unpackaged
    }

    // REQUIRES: model.Box must be medium or large
    // MODIFIES: this
    // EFFECTS:  If the book fits in the given box, then the two are associated (the book is packaged).
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

    public String getTitle() {
        return title;
    }

    public void setBox(Box box) {
        this.box = box;
    }

    // EFFECTS: Returns the flat rate for shipping a standard sized book
    public double calculateShipping() {
        return FLAT_RATE_SHIPPING;
    }

    // EFFECTS: returns the minimum required size of box for packaging this book
    public String getMinBoxSize() {
        System.out.println("A standard size book can fit in a medium or large box.");
        return MIN_BOX_SIZE;
    }
}
