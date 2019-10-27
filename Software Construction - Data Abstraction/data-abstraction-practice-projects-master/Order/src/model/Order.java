package model;

public class Order {
    private int ticketN;
    private char combo;
    private String name;
    private double price;
    private String instructions;
    private boolean completed;

    public Order(int ticketN, char combo, String name) {
        this.ticketN = ticketN;
        this.combo = combo;
        this.name = name;
        this.completed = false;
        this.calculatePrice();
    }

    public int getTicketN() {
        return this.ticketN;
    }
    public char getCombo() {
        return this.combo;
    }
    public String getName() {
        return this.name;
    }
    public double getPrice() {
        return this.price;
    }
    public String getInstructions() {
        return this.instructions;
    }
    public boolean getCompleted() {
        return this.completed;
    }

    public void completed() {
        this.completed = true;
    }

    public void setInstructions(String instructions) {
        this.instructions = instructions;
    }

    public boolean isCompleted() {
        return getCompleted();
    }

    public String comboType() {
        switch (getCombo()) {
            case 'A': return "Pizza";
            case 'B': return "Hamburger";
            case 'C': return "Omelet";
            case 'D': return "Noodles";
            case 'E': return "Barbecue";
            default: return "Salad";
        }
    }

    public String orderInstructions() {
        return "Ticket " + getTicketN()
                + "\nCOMBO " + getCombo()
                + "\nINSTRUCTIONS: " + getInstructions();
    }

    public String receipt(){
        return getName()
                + "\nTicket " + getTicketN()
                + "\nCombo " + getCombo() + " = " + comboType()
                + "\nPrice: $" + getPrice();
    }


    private void calculatePrice() {
        switch (getCombo()) {
            case 'A':
                this.price = 10;
                break;
            case 'B':
                this.price = 8;
                break;
            case 'C':
                this.price = 5;
                break;
            case 'D':
                this.price = 6;
                break;
            case 'E':
                this.price = 12;
                break;
        }
    }
}
