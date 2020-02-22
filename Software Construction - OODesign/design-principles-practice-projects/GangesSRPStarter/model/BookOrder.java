package model;

/**
 * A book purchase made by a customer of Ganges.com, Inc
 */
public class BookOrder {

    private Book book;

    private Customer customer;
    private int orderNumber;

    public BookOrder(Customer customer, Book book, int orderNumber) {
        this.customer = customer;
        this.book = book;
        this.orderNumber = orderNumber;
    }

    public int getOrderNumber() {
        return orderNumber;
    }

    public Customer getCustomer() {
        return customer;
    }
}
