package model;

import java.util.HashMap;

public class CloudStorage {

    private HashMap<Integer, String> dataStorage;


    public CloudStorage() {
        this.dataStorage = new HashMap<>();
    }

    public void putData(int customerId, String data) {
        dataStorage.put(customerId, data);
    }

    public String getData(int customerId) {
        return dataStorage.get(customerId);
    }

    public String deleteData(int customerId) {
        return dataStorage.remove(customerId);
    }
}
