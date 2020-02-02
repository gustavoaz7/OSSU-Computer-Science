package model.words;

public class WordEntry {

    private String word;
    private String description;
    private WordEntryType type;

    public WordEntry(WordEntryType type, int index) {
        this.word = "";
        this.description = "";
        this.type = type;
    }

    @Override
    public String toString(){
        return word;
    }

    public String getDescription() {
        return description;
    }

    public void setString(String word){
        this.word = word;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public WordEntryType getType(){
        return type;
    }
}