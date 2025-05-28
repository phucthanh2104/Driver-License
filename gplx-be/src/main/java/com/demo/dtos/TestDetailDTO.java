package com.demo.dtos;

public class TestDetailDTO {
    private Integer testId;
    private Integer chapterId;
    private QuestionDTO question;
    private int time;
    private int passedScore;
    public TestDetailDTO() {
    }

    public TestDetailDTO(Integer testId, Integer chapterId, QuestionDTO question) {
        this.testId = testId;
        this.chapterId = chapterId;
        this.question = question;
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

    public TestDetailDTO(Integer testId, Integer chapterId, QuestionDTO question, int time, int passedScore) {
        this.testId = testId;
        this.chapterId = chapterId;
        this.question = question;
        this.time = time;
        this.passedScore = passedScore;
    }
}
