package ui;

import model.Order;

import java.util.ArrayList;
import java.util.List;

public class Main {

    public static void main(String[] args) {
        Order order1 = new Order(01, 'B', "Gus");
        order1.setInstructions("Take away");
        Order order2 = new Order(02, 'A', "Ana");
        order2.setInstructions("Double pepperoni");
        Order order3 = new Order(03, 'E', "David");

        List<Order> orders = new ArrayList<>();
        orders.add(order1);
        orders.add(order2);
        orders.add(order3);

        order1.completed();

        orders.forEach(order -> {
            if (order.isCompleted()) {
                System.out.println(order.receipt());
            } else {
                System.out.println(order.orderInstructions());
            }
        });
    }


}
