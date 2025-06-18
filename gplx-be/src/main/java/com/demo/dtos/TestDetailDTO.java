package com.demo.dtos;

public class TestDetailDTO {
    private Integer testId;
    private Integer chapterId;
    private QuestionDTO question;
    private int time;
    private int passedScore;
    private boolean status;
    public TestDetailDTO() {
    }

    public TestDetailDTO(Integer testId, Integer chapterId, QuestionDTO question, boolean status) {
        this.testId = testId;
        this.chapterId = chapterId;
        this.question = question;
        this.status = status;
    }

    public Integer getTestId() {
        return testId;
    }

    public void setTestId(Integer testId) {
        this.testId = testId;
    }

    public Integer getChapterId() {
        return chapterId;
    }

    public void setChapterId(Integer chapterId) {
        this.chapterId = chapterId;
    }

    public QuestionDTO getQuestion() {
        return question;
    }

    public void setQuestion(QuestionDTO question) {
        this.question = question;
    }
    public int getTime() {
        return time;
    }
    public void setTime(int time) {
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

    public TestDetailDTO(Integer testId, Integer chapterId, QuestionDTO question, int time, int passedScore) {
        this.testId = testId;
        this.chapterId = chapterId;
        this.question = question;
        this.time = time;
        this.passedScore = passedScore;
    }

    public TestDetailDTO(Integer testId, Integer chapterId, QuestionDTO question, int time, int passedScore, boolean status) {
        this.testId = testId;
        this.chapterId = chapterId;
        this.question = question;
        this.time = time;
        this.passedScore = passedScore;
        this.status = status;
    }
}
