package model;

import model.observer_pattern.Observer;
import model.random.BingoNumber;
import model.random.NumberSquare;

import java.util.*;

import static model.Game.CARD_SIZE;

public class PlayerCard implements Observer {

    private List<NumberSquare> numbers;
    private List<Collection<Integer>> colIndices;
    private List<Collection<Integer>> rowIndices;
    private List<Collection<Integer>> diagonalIndices;
    private int numberSquaresStamped;
    private boolean hasBingo;

    public PlayerCard(){
        numbers = new ArrayList<>();
        populateIndices();

        for(int i=0; i < CARD_SIZE; i++){
            numbers.add(new NumberSquare());
        }
    }

    @Override
    public void update(Object o){
        BingoNumber bc = (BingoNumber) o;
        int i = numberSquaresMatch(bc);
        for (int j=0; j < i; j++) {
            int index = getSquareIndexOfNextUnstamped(bc);
            stampSquare(index);
            checkIfBingo(index);
        }
    }

    public boolean hasBingo(){ return hasBingo; }

    public List<NumberSquare> getSquares() { return numbers; }

    public int getNumberOfSquaresStamped() { return numberSquaresStamped; }

    private void checkIfBingo(int i){
        hasBingo =  isBingoSequence(i, rowIndices) ||
                isBingoSequence(i, colIndices) ||
                isBingoSequence(i, diagonalIndices);
    }

    private int numberSquaresMatch(BingoNumber bc){
        int i = 0;
        int match = bc.getNumber();
        for (int j = getColumnFromBC(bc); j < CARD_SIZE; j+=5) {
            if (numbers.get(j).getNumber().equals(match) && !numbers.get(j).isStamped()){
                i++;
            }
        }
        return i;
    }

    private int getSquareIndexOfNextUnstamped(BingoNumber bc) {
        int column = getColumnFromBC(bc);
        int match = bc.getNumber();
        for (int i=column; i < CARD_SIZE; i += 5){
            NumberSquare sqr = numbers.get(i);
            if ((!sqr.isStamped()) && sqr.getNumber().equals(match)){
                return i;
            }
        }
        throw new NoSuchElementException("Number of matching squares exceeded unstamped squares.");
    }

    private void stampSquare(int index) {
        numbers.get(index).stamp();
        numberSquaresStamped++;
    }

    private int getColumnFromBC(BingoNumber bc){
        switch(bc.getLetter()) {
            case 'B':
                return 0;
            case 'I':
                return 1;
            case 'N':
                return 2;
            case 'G':
                return 3;
            default:
                return 4;
        }
    }

    private boolean isBingoSequence(int index, List<Collection<Integer>> allIndices) {
        Collection<Integer> coll = getIndicesForIndex(index, allIndices);
        if (coll == null)
            return false;
        boolean bingo = true;
        for (Integer i : coll) {
            if (!numbers.get(i).isStamped()) {
                bingo = false;
                break;
            }
        }
        return bingo;
    }

    private Collection<Integer> getIndicesForIndex(int index, List<Collection<Integer>> allIndices) {
        for (Collection<Integer> c: allIndices) {
            if (c.contains(index))
                return c;
        }
        return null;
    }

    private void populateIndices() {
        rowIndices = new ArrayList<>();
        colIndices = new ArrayList<>();
        diagonalIndices = new ArrayList<>();
        populateRows();
        populateCols();
        populateDiagonals();
    }


    /*   NOTE: Why are we hard-coding this?
     *   We could make an effort to generalize to a board of arbitrary size,
     *   but since B-I-N-G-O has 5 letters, it's probably safe to leave these numbers here.
     */
    private void populateRows() {
        Integer[] row0 = {0, 1, 2, 3, 4};
        Integer[] row1 = {5, 6, 7, 8, 9};
        Integer[] row2 = {10, 11, 12, 13, 14};
        Integer[] row3 = {15, 16, 17, 18, 19};
        Integer[] row4 = {20, 21, 22, 23, 24};
        addToCollection(rowIndices, row0);
        addToCollection(rowIndices, row1);
        addToCollection(rowIndices, row2);
        addToCollection(rowIndices, row3);
        addToCollection(rowIndices, row4);
    }

    private void populateCols() {
        Integer[] col0 = {0, 5, 10, 15, 20};
        Integer[] col1 = {1, 6, 11, 16, 21};
        Integer[] col2 = {2, 7, 12, 17, 22};
        Integer[] col3 = {3, 8, 13, 18, 23};
        Integer[] col4 = {4, 9, 14, 19, 24};
        addToCollection(colIndices, col0);
        addToCollection(colIndices, col1);
        addToCollection(colIndices, col2);
        addToCollection(colIndices, col3);
        addToCollection(colIndices, col4);
    }

    private void populateDiagonals() {
        Integer[] diag0 = {0, 6, 12, 18, 24};
        Integer[] diag1 = {4, 8, 12, 16, 20};
        addToCollection(diagonalIndices, diag0);
        addToCollection(diagonalIndices, diag1);
    }

    private void addToCollection(List<Collection<Integer>> coll, Integer[] arr) {
        HashSet<Integer> indices = new HashSet<>(Arrays.asList(arr));
        coll.add(indices);
    }

}