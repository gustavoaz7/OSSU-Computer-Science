package model;

import java.util.LinkedList;
import java.util.List;

public class Manager extends Employee {

    public static final double MANAGER_WAGE = 9.50;

    private BurgerByte managingBranch;
    private List<Employee> team;
    public Manager(String name, int age) {
        super(name, age);
        team = new LinkedList<>();
    }

    // getters
    public BurgerByte getManagingBranch() { return managingBranch; }
    public List<Employee> getTeam() { return team; }

    // REQUIRES: hours >= 0
    // MODIFIES: this
    // EFFECTS: opens this Manager's BurgerByte, sets atWork to true, and logs
    //          hours worked
    public void startWork(double hours) {
        managingBranch.openRestaurant();
        atWork = true;
        logHoursWorked(hours);
        System.out.println("We are open for the day!");
    }

    // MODIFIES: this
    // EFFECTS: closes this Manager's BurgerByte, set atWork to false
    public void leaveWork() {
        managingBranch.closeRestaurant();
        atWork = false;
        System.out.println("We are closed for the day!");
    }

    // EFFECTS: returns the total amount of wages this Manager made
    public double computeWage() {
        return (hoursWorked * (MANAGER_WAGE + BASE_WAGE));
    }

    // EFFECTS: set this managingBranch to managingBranch
    public void setManagingBranch(BurgerByte managingBranch) {
        this.managingBranch = managingBranch;
    }

    // REQUIRES: e must not be in already in team and this Manager's restaurant
    // MODIFIES: this
    // EFFECTS: adds given Employee to team and this Manager's restaurant
    public void hire(Employee e) {
        managingBranch.getStaff().add(e);
        team.add(e);
        System.out.println("Welcome aboard, " + e.getName() + "!");
    }

    // REQUIRES: e must be in this team and and this Manager's restaurant
    // MODIFIES: this
    // EFFECTS: removes given Employee from team and this Manager's restaurant
    public void fire(Employee e) {
        managingBranch.removeStaff(e);
        team.remove(e);
        System.out.println("Sorry to let you go, " + e.getName() + ".");
    }

}