package model;

import java.util.LinkedList;
import java.util.List;

public class BurgerByte {

    private String location;
    private Manager manager;
    private List<Employee> staff;
    private boolean isOpen;

    public BurgerByte(String locn, Manager manager) {
        location = locn;
        this.manager = manager;
        staff = new LinkedList<>();
        isOpen = false;
    }

    // getters
    public String getLocation() { return location; }
    public Manager getManager() { return manager; }
    public List<Employee> getStaff() { return staff; }
    public boolean isOpen() { return isOpen; }

    // EFFECTS: "opens" this restaurant, i.e. set isOpen to true
    public void openRestaurant() {
        isOpen = true;
    }

    // EFFECTS: sets the isOpen field to false, and sends all employees home (off work)
    public void closeRestaurant() {
        isOpen = false;
        staff.forEach(e -> e.leaveWork());
        manager.leaveWork();
    }

    // REQUIRES: e must not be in this employees or this BurgerByte's Manager's employees
    // MODIFIES: this
    // EFFECTS: adds the given employee to this employees and to this Manager's employees
    public void addEmployee(Employee e) {
        staff.add(e);
        manager.getEmployees().add(e);
    }

    // REQUIRES: e must be in this employee and this BurgerByte's Manager's employees
    // MODIFIES: this
    // EFFECTS: removes the given employee from this employees and to this Manager's employees
    public void removeEmployee(Employee e) {
        staff.remove(e);
        manager.getEmployees().remove(e);
    }

    // EFFECTS: computes wages for all employees, prints them out in this format
    //          Name: ______, Salary: _______ for each employee
    public void computeStaffWages() {
        staff.forEach(e -> System.out.println("Name: " + e.getName() + ", Salary: " + e.computeWage()));
        System.out.println("Name: " + manager.getName() +", Salary: " + manager.computeWage());
    }


}