package model;

import java.util.Iterator;
import java.util.List;

public class SillyWordGame implements Iterable<Phrase> {

    private List<Phrase> phrases;

    public SillyWordGame(List<Phrase> phrases) {
        this.phrases = phrases;
    }

    public List<Phrase> getAllPhrases() {
        return phrases;
    }

    public Iterator<Phrase> iterator() {
        return new PhrasesNeedingWordsIterator();
    }


    private class PhrasesNeedingWordsIterator implements Iterator<Phrase> {
        private int numWordsNeeded;
        private Iterator<Phrase> phraseIterator;

        private PhrasesNeedingWordsIterator() {
            phraseIterator = phrases.iterator();
            calculateNumWordsNeeded();
        }

        public boolean hasNext() {
            return (numWordsNeeded > 0);
        }

        public Phrase next() {
            Phrase p = phraseIterator.next();
            while (!p.needsWord()) { p = phraseIterator.next(); }
            numWordsNeeded--;
            return p;
        }

        public void remove(){}

        private void calculateNumWordsNeeded() {
            Iterator<Phrase> it = phrases.iterator();
            while(it.hasNext()) {
                if (it.next().needsWord())
                    numWordsNeeded++;
            }
        }
    }
}