package model;

/**
 * A customer of Ganges.com, Inc.
 */
public class Customer {

    private String name;
    private String address;
    private int uniqueId;

    public Customer(String name, String address, int uniqueId) {
        this.name = name;
        this.address = address;
        this.uniqueId = uniqueId;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public String getName() {
        return name;
    }

    public String getAddress() {
        return address;
    }
}
