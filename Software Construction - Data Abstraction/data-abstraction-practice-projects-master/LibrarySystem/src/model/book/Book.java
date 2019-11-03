package model.book;

import model.library.Library;

public class Book {

    private String title;
    private String author;
    private BookType type;
    private int year;
    private int edition;
    private Library homeLibrary;
    private boolean isOnLoan;

    public Book(String title, String author, BookType type, int year, int ed) {
        this.title = title;
        this.author = author;
        this.type = type;
        this.year = year;
        this.edition = ed;
        this.homeLibrary = null;
        this.isOnLoan = false;
    }

    // getters
    public String getTitle() {
        return this.title;
    }
    public String getAuthor() {
        return this.author;
    }
    public BookType getType() {
        return this.type;
    }
    public int getYear() {
        return this.year;
    }
    public int getEdition() {
        return this.edition;
    }
    public Library getHomeLibrary() {
        return this.homeLibrary;
    }

    // MODIFIES: this
    // EFFECTS: set the book to be not on loan
    public void notOnLoan() {
        this.isOnLoan = false;
    }

    // EFFECTS: return true if this book is on loan, else return false
    public boolean onLoan() {
        return this.isOnLoan;
    }

    // MODIFIES: this
    // EFFECTS: set the book to be on loan
    public void nowOnLoan() {
        this.isOnLoan = true;
    }

    // REQUIRES: home != null
    // MODIFIES: this
    // EFFECTS: sets this book's home library to the one passed as parameter
    public void setHomeLibrary(Library home) {
        this.homeLibrary = home;
        this.homeLibrary.storeBook(this);
    }


}