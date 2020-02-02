package model;

public abstract class Book {

    private String title;
    private double price;
    private Box box;

    public Book(String title, double price) {
        this.title = title;
        this.price = price;
        this.box = null;
    }

    public String getTitle() {
        return title;
    }

    public void setBox(Box box) {
        this.box = box;
    }

    public abstract Box packageBook(Box b);

    public abstract double calculateShipping();

    public abstract String getMinBoxSize();
}
