package model;

public class Elephant {

    private String name;
    private String country;
    private int age;
    private Zookeeper careTaker;
    private double weight;

    public Elephant(String nm, String ct, int age, Zookeeper zk, double wgt) {
        name = nm;
        country = ct;
        this.age = age;
        careTaker = zk;
        weight = wgt;
    }

    // getters
    public String getName() { return name; }
    public String getCountry() { return country; }
    public int getAge() { return age; }
    public Zookeeper getCareTaker() { return careTaker; }
    public double getWeight() { return weight; }


}