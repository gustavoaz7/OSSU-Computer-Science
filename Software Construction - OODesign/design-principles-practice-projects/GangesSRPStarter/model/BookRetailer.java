package model;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class BookRetailer {

    private List<Book> books;
    private List<BookOrder> customerBookOrders;
    private int orderNumberCounter;

    private static final int FIRST_ORDER_NUMBER = 1000;


    public BookRetailer() {
        this.books = new ArrayList<>();
        books.add(new Book ("A Tale of Two Gentlemen of Verona", 5.99));
        books.add(new Book("Harry Potter and a Series of Unfortunate Events", 12.49));
        books.add(new Book("Fifty Shades of The Color Purple", 22.36));

        this.customerBookOrders = new ArrayList<>();

        orderNumberCounter = FIRST_ORDER_NUMBER;
    }

    public void listAvailableBooks() {
        System.out.println("Books available through Ganges:");
        for (int i = 0; i < books.size(); i++) {
            Book thisBook = books.get(i);
            System.out.println((i+1) + ". " + thisBook.getTitle() + " - " + thisBook.getPrice());
        }
    }

    public BookOrder orderBook(Customer c, int bookNumber) {
        bookNumber--;
        
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

}
