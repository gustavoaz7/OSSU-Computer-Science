package model;

public class Kitchen {

    private final static int INGREDIENT_PER_TACO = 3;
    private final static int DOLLAR_PER_INGREDIENT = 2;
    private int ingredient;
    private int tacoCount;
    private int balance;
    private boolean cookReady;

    public Kitchen(int initialIngredient, int initialTaco, int balance, boolean cookStatus) {
        ingredient = initialIngredient;
        tacoCount = initialTaco;
        cookReady = cookStatus;
        this.balance = balance;
    }

    // getters
    public int getIngredientCount() { return ingredient; }
    public int getTacoCount() { return tacoCount; }
    public boolean getCookState() { return cookReady; }
    public int getBalance() { return balance; }

    public void setCookStatus(boolean b) {
        cookReady = b;
    }

    public void makeTaco(int amount) throws NoIngredientException, NoCookException {
        if (!cookReady) {
            throw new NoCookException("No cook!");
        } else {
            if (ingredient - (INGREDIENT_PER_TACO * amount) < 0) {
                throw new NoIngredientException("Not enough ingredients!");
            } else {
                ingredient -= (INGREDIENT_PER_TACO * amount);
                tacoCount += amount;
            }
        }
    }

    public void buyIngredients(int amount) throws NotEnoughMoneyException {
        if (balance - (DOLLAR_PER_INGREDIENT * amount) < 0) {
            throw new NotEnoughMoneyException("Not enough money to buy ingredients!");
        } else {
            ingredient += amount;
            balance -= (DOLLAR_PER_INGREDIENT * amount);
        }
    }
}
