package model;

public class Horse {

    private String name;
    private String country;
    private int age;
    private Zookeeper careTaker;
    private Double weight;
    private double topSpeed;

    public Horse(String nm, String ct, int age, Zookeeper zk, double wgt, double ts) {
        name = nm;
        this.age = age;
        careTaker = zk;
        country = ct;
        weight = wgt;
        topSpeed = ts;
    }

    // getters
    public String getName() { return name; }
    public String getCountry() { return country; }
    public int getAge() { return age; }
    public Zookeeper getCareTaker() { return careTaker; }
    public Double getWeight() { return weight; }
    public double getTopSpeed() { return topSpeed; }


}