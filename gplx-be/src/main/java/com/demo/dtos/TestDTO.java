package com.demo.dtos;

import com.demo.entities.Rank;
import jakarta.persistence.Column;
import jakarta.persistence.Id;


public class TestDTO {
    private Long id;
    private String title;
    private String description;
    private Integer type;
    private Integer time;
    private int passedScore;
    private boolean status;
    private Integer rank;
    private boolean isTest;
    private Integer numberOfQuestions;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public Integer getTime() {
        return time;
    }

    public void setTime(Integer time) {
        this.time = time;
    }

    public int getPassedScore() {
        return passedScore;
    }

    public void setPassedScore(int passedScore) {
        this.passedScore = passedScore;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Integer getRank() {
        return rank;
    }

    public void setRank(Integer rank) {
        this.rank = rank;
    }

    public boolean isTest() {
        return isTest;
    }

    public void setTest(boolean test) {
        isTest = test;
    }

    public Integer getNumberOfQuestions() {
        return numberOfQuestions;
    }

    public void setNumberOfQuestions(Integer numberOfQuestions) {
        this.numberOfQuestions = numberOfQuestions;
    }
}
