package model;

import model.words.WordEntry;
import model.words.WordEntryType;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public class Phrase {

    private List<String> words;
    private boolean needsWord;
    private int wordEntryIndex;
    private WordEntry wordEntry;

    public Phrase(String phrase) {
        words = new ArrayList<>();
        setPhrase(phrase);
    }

    public boolean needsWord() { return needsWord; }

    public void addWordEntry(WordEntryType type, int index) {
        wordEntry = new WordEntry(type, index);
        needsWord = true;
        wordEntryIndex = index;
    }

    public void addWordEntry(WordEntryType type, int index, String description) {
        wordEntry = new WordEntry(type, index);
        wordEntry.setDescription(description);
        needsWord = true;
        wordEntryIndex = index;
    }

    public WordEntry getNeededWordEntry() {
        return wordEntry;
    }

    public void setPhrase(String phrase) {
        Pattern spaceDelimiter = Pattern.compile(" ");
        String exploded[] = spaceDelimiter.split(phrase);
        for (int i=0; i<exploded.length; i++) {
            words.add(exploded[i]);
        }
    }

    public void fillWordEntry(String value) {
        wordEntry.setString(value);
        words.add(wordEntryIndex, wordEntry.toString());
        needsWord = false;
    }

    @Override
    public String toString() {
        StringBuilder str = new StringBuilder();
        for (String s : words) {
            str.append(s).append(" ");
        }
        return str.toString();
    }

}