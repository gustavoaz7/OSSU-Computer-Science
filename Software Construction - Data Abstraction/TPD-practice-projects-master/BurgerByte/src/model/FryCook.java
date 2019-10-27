package model;

public class FryCook {

    public static final double FRYCOOK_WAGE = 5.50;
    public static final double BASE_WAGE = 10.00;

    private String name;
    private int age;
    private double hoursWorked;
    private boolean atWork;
    private BurgerByte workBranch;
    private boolean isGrillReady;

    public FryCook(String name, int age, BurgerByte workBranch) {
        this.name = name;
        this.age = age;
        this.workBranch = workBranch;
        isGrillReady = false;
        workBranch.addFryCook(this);
    }

    // getters
    public String getName() { return name; }
    public int getAge() { return age; }
    public boolean isAtWork() { return atWork; }
    public BurgerByte getWorkPlace() { return workBranch; }
    public boolean isGrillReady() { return isGrillReady; }

    // MODIFIES: this
    // EFFECTS: adds hours to the hoursWorked field
    private void logHoursWorked(double hours) {
        hoursWorked += hours;
    }

    // EFFECTS: the grill should be ready to go, hours should be logged, and
    //          the atWork field should be updated to reflect this FryCook's status
    public void startWork(double hours) {
        isGrillReady = true;
        atWork = true;
        logHoursWorked(hours);
        System.out.println("Grill is ready to cook with!");
    }

    // EFFECTS: close the grill for the day, and update this FryCook's work status
    public void leaveWork() {
        isGrillReady = false;
        atWork = false;
        System.out.println("Grill is closed for the day.");
    }

    // EFFECTS: computes wages for the day
    public double computeWage() {
        return (hoursWorked * (FRYCOOK_WAGE + BASE_WAGE));
    }


}