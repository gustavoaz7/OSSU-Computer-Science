package test;

import model.Order;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

public class OrderTest {

    private Order testOrder;

    @Before
    public void setUp(){
        testOrder = new Order(04, 'C', "Beth");
    }

    @Test
    public void testConstructor(){
        assertEquals(testOrder.getName(), "Beth");
        assertEquals(testOrder.getTicketN(), 04);
        assertEquals(testOrder.getCombo(), 'C');
        assertEquals(testOrder.getPrice(), 5, 0.1);
        assertFalse(testOrder.isCompleted());
    }

    @Test
    public void testCompletedOrder(){
        testOrder.completed();
        assertEquals("Beth"
                + "\nTicket 4"
                + "\nCombo C = Omelet"
                + "\nPrice: $5.0",
                testOrder.receipt()
        );
    }

    @Test
    public void testOrderNotComplete(){
        assertFalse(testOrder.isCompleted());
        testOrder.setInstructions("Take away");
        assertEquals("Ticket 4"
                + "\nCOMBO C"
                + "\nINSTRUCTIONS: Take away",
                testOrder.orderInstructions()
        );
    }


}