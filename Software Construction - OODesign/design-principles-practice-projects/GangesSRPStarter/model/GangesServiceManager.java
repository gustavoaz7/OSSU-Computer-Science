package model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

/**
 * model.Customer interface for making requests of various Ganges.com, Inc. services.
 */
public class GangesServiceManager {

    private HashMap<Integer, String> dataStorage;
    private List<Book> books;
    private List<BookOrder> customerBookOrders;
    private int orderNumberCounter;
    private int customerIdCounter;

    public static final int FIRST_CUSTOMER_NUMBER = 100;
    private static final int FIRST_ORDER_NUMBER = 1000;

    public GangesServiceManager() {
        this.dataStorage = new HashMap<>();

        this.books = new ArrayList<>();
        books.add(new Book ("A Tale of Two Gentlemen of Verona", 5.99));
        books.add(new Book("Harry Potter and a Series of Unfortunate Events", 12.49));
        books.add(new Book("Fifty Shades of The Color Purple", 22.36));

        this.customerBookOrders = new ArrayList<>();

        this.customerIdCounter = FIRST_CUSTOMER_NUMBER;
        this.orderNumberCounter = FIRST_ORDER_NUMBER;
    }

    // EFFECTS: Create a new customer with the given address and name
    public Customer signUpNewCustomer(String address, String name) {
        return new Customer(name, address, customerIdCounter++);
    }


    // EFFECTS: Print all books for sale to the console, along with the index number + 1.
    public void listAvailableBooks() {
        System.out.println("Books available through Ganges:");
        for (int i = 0; i < books.size(); i++) {
            Book thisBook = books.get(i);
            System.out.println((i+1) + ". " + thisBook.getTitle() + " - " + thisBook.getPrice());
        }
    }

    // REQUIRES: bookNumber is >= 1
    // MODIFIES: this
    // EFFECTS: If the book number corresponds to a book in stock (i.e., is a valid index+1 of the list books),
    //          then create a new model.BookOrder and return the order number; otherwise, do not create an order and return -1.
    public BookOrder orderBook(Customer c, int bookNumber) {
        bookNumber--; // change book number to zero-point indexing

        if (bookNumber < books.size()) {
            Book thisBook = books.get(bookNumber);
            int thisOrderNum = orderNumberCounter++;

            BookOrder order = new BookOrder(c, thisBook, thisOrderNum);
            customerBookOrders.add(order);

            System.out.println("Your order for " + thisBook.getTitle() + " is on the way!");
            return order;
        }
        else {
            System.out.println("Sorry, that isn't a book we have in stock.");
            return null;
        }
    }

    // MODIFIES: this
    // EFFECTS: if this order number matches a current order, then the order is cancelled (removed from the orders list)
    public boolean cancelBookOrder(int orderNumber) {
        Iterator<BookOrder> iterator = customerBookOrders.iterator();
        BookOrder currOrder;

        while (iterator.hasNext()) {
            currOrder = iterator.next();

            if (currOrder.getOrderNumber() == orderNumber) {
                iterator.remove();
                return true;
            }
        }
        return false;
    }

    // MODIFIES: this
    // EFFECTS: Stores the given data in the cloud under this customer's account
    public void putData(Customer c, String data) {
        dataStorage.put(c.getUniqueId(), data);
    }

    // Returns the given customer's data from the cloud
    public String getData(Customer c) {
        return dataStorage.get(c.getUniqueId());
    }

    // MODIFIES: this
    // EFFECTS: Deletes this customer's data from the cloud
    public String deleteData(Customer c) {
        return dataStorage.remove(c.getUniqueId());
    }
}
