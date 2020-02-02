package test;

import model.BookOrder;
import model.Customer;
import model.GangesServiceManager;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests for the model.GangesServiceManager. These tests should pass with the starter code, and after successful refactoring.
 */

public class GangesServiceManagerTest {

    private GangesServiceManager sm;
    private Customer customer;
    private static final String NAME = "Crystal Shanda Lear";
    private static final String ADDR = "123 Waltz St";
    private static final int ID = 12345;

    @BeforeEach
    public void setup() {
        sm = new GangesServiceManager();
        customer = new Customer(NAME, ADDR, ID);
    }

    @Test
    public void testNewCustomer() {
        Customer c = sm.signUpNewCustomer(ADDR, NAME);
        assertEquals(c.getName(), NAME);
        assertEquals(c.getAddress(), ADDR);
        assertTrue(c.getUniqueId() > 0);
    }

    @Test
    public void listAvaliableBooks() {
        sm.listAvailableBooks();
    }

    @Test
    public void orderBook() {
        BookOrder order = sm.orderBook(customer, 1);
        assertEquals(order.getCustomer(), customer);
        assertTrue(order.getOrderNumber() > 0);
    }

    @Test
    public void cancelOrder() {
        BookOrder order = sm.orderBook(customer, 1);
        assertTrue(sm.cancelBookOrder(order.getOrderNumber()));
        int fakeOrderNum = 5;
        assertFalse(sm.cancelBookOrder(fakeOrderNum));
    }

    @Test
    public void putAndGetNewData() {
        assertNull(sm.getData(customer));
        String dataString = "I am the very model of a modern major general";
        sm.putData(customer, dataString);
        assertEquals(sm.getData(customer), dataString);
    }

    @Test
    public void putDataOverwrite() {
        assertNull(sm.getData(customer));
        String dataString = "I've information vegetable animal and mineral";
        sm.putData(customer, dataString);
        assertEquals(sm.getData(customer), dataString);

        String newDataString = "I know the kings of England and I quote the fights historical";
        sm.putData(customer, newDataString);
        assertEquals(sm.getData(customer), newDataString);
    }

    @Test
    public void deleteData() {
        String dataString = "From Marathon to Waterloo in order categorical";
        sm.putData(customer, dataString);
        assertEquals(sm.getData(customer), dataString);

        sm.deleteData(customer);
        assertNull(sm.getData(customer));
    }
}
