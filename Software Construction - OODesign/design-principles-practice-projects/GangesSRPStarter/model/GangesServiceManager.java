package model;

public class GangesServiceManager {

    private BookRetailer bookRetailer;
    private CloudStorage cloudStorage;
    private int customerIdCounter;

    public static final int FIRST_CUSTOMER_NUMBER = 100;

    public GangesServiceManager() {
        this.bookRetailer = new BookRetailer();
        this.cloudStorage = new CloudStorage();
        this.customerIdCounter = FIRST_CUSTOMER_NUMBER;
    }

    public Customer signUpNewCustomer(String address, String name) {
        return new Customer(name, address, customerIdCounter++);
    }

    public void listAvailableBooks() {
        bookRetailer.listAvailableBooks();
    }

    public BookOrder orderBook(Customer c, int bookNumber) {
        return bookRetailer.orderBook(c, bookNumber);
    }

    public boolean cancelBookOrder(int orderNumber) {
        return bookRetailer.cancelBookOrder(orderNumber);
    }

    public void putData(Customer c, String data) {
        cloudStorage.putData(c.getUniqueId(), data);
    }

    public String getData(Customer c) {
        return cloudStorage.getData(c.getUniqueId());
    }

    public String deleteData(Customer c) {
        return cloudStorage.deleteData(c.getUniqueId());
    }

}
