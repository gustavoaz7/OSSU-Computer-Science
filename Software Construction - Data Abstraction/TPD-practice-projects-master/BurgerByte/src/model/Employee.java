package model;

public abstract class Employee {
    public static final double BASE_WAGE = 10.00;

    protected String name;
    protected int age;
    protected double workedHours;
    protected boolean atWork;

    protected Employee(String name, int age) {
        this.name = name;
        this.age = age;
        this.atWork = false;
        this.workedHours = 0;
    }

    public String getName() {
        return this.name;
    }
    public int getAge() {
        return this.age;
    }
    public boolean isAtWork() {
        return this.atWork;
    }
    public double getWorkedHours() {
        return this.workedHours;
    }

    protected void addWorkedHours(double hours) {
        workedHours += hours;
    }

    public abstract void startWork(double hours);

    public abstract void leaveWork();

    public abstract double computeWage();
}