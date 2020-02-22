package test;

import org.junit.Before;
import org.junit.Test;


public class CoffeeMakerTest {
    private CoffeeMaker cm;

    @Before
    public void setUp(){
        cm = new CoffeeMaker();
    }

    @Test
    public void testConstructor(){
        assertEquals(cm.getTimeSinceLastBrew(), cm.getCupsRemaining(), 0);
    }

    @Test
    public void testBrewShouldPass(){
        try {
            successfulBrew();
            assertEquals(cm.getTimeSinceLastBrew(), 0);
            cm.brew(2.40, 14.8);
            cm.brew(2.6, 14.9);
        } catch (Exception e) {
            fail();
        }
    }

    @Test (expected = NotEnoughBeansException.class)
    public void testBrewFailNotEnoughBeans() throws BeansAmountException, WaterException {
        cm.brew(2.39, 15);
    }

    @Test (expected = TooManyBeansException.class)
    public void testBrewFailTooManyBeans() throws BeansAmountException, WaterException {
        cm.brew(2.61, 14.9);
    }

    @Test (expected = WaterException.class)
    public void testBrewFailNotEnoughWater() throws BeansAmountException, WaterException {
        cm.brew(2.5, 14.75);
    }

    @Test (expected = WaterException.class)
    public void testBrewFailBothWrongWaterFirst() throws BeansAmountException, WaterException {
        cm.brew(2.1, 14);
    }

    @Test
    public void testPourCoffeePass() throws BeansAmountException, WaterException {
        successfulBrew();
        try {
            cm.pourCoffee();
            cm.pourCoffee();
            cm.pourCoffee();
            cm.pourCoffee();
            cm.pourCoffee();
            cm.setTimeSinceLastBrew(59);
            assertEquals(cm.getCupsRemaining(), 15);
            cm.pourCoffee();
        } catch (Exception e) {
            fail();
        }
    }

    @Test (expected = StaleCoffeeException.class)
    public void testPourCoffeeFailStaleCoffee() throws StaleCoffeeException, NoCupsRemainingException,
            BeansAmountException, WaterException {
        successfulBrew();
        cm.setTimeSinceLastBrew(60);
        cm.pourCoffee();
    }

    @Test (expected = NoCupsRemainingException.class)
    public void testPourCoffeeFailNoCupsRemaining() throws BeansAmountException, WaterException,
            StaleCoffeeException, NoCupsRemainingException {
        successfulBrew();
        pour20Cups();
        cm.pourCoffee();
    }

    @Test (expected = NoCupsRemainingException.class)
    public void testPourCoffeeBothWrongNoCupsFirst() throws StaleCoffeeException, NoCupsRemainingException,
            BeansAmountException, WaterException {
        successfulBrew();
        pour20Cups();
        cm.setTimeSinceLastBrew(60);
        cm.pourCoffee();
    }

    private void successfulBrew() throws BeansAmountException, WaterException {
        cm.brew(2.5, 15);
    }

    private void pour20Cups() throws StaleCoffeeException, NoCupsRemainingException {
        for(int i=0; i<20; i++){
            cm.pourCoffee();
        }
    }
}