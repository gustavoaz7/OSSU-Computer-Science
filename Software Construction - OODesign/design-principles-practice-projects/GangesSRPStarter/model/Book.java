package model;

/**
 * A book sold by Ganges.com, Inc.
 */
public class Book {

    private String title;
    private double price;

    public Book(String title, double price) {
        this.title = title;
        this.price = price;
    }

    public String getTitle() {
        return title;
    }

    public double getPrice() {
        return price;
    }

}
