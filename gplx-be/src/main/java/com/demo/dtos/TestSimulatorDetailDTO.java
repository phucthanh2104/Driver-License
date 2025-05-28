package com.demo.dtos;

public class TestSimulatorDetailDTO {

    private int id;
    private Byte status;
    private SimulatorDTO simulator;

    private Long testId;
    private Integer testTime;
    private Integer testType;
    private Integer testPassedScore;

    private Integer chapterSimulatorId;
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Byte getStatus() {
        return status;
    }

    public void setStatus(Byte status) {
        this.status = status;
    }

    public SimulatorDTO getSimulator() {
        return simulator;
    }

    public void setSimulator(SimulatorDTO simulator) {
        this.simulator = simulator;
    }

    public Long getTestId() {
        return testId;
    }

    public void setTestId(Long testId) {
        this.testId = testId;
    }

    public Integer getTestTime() {
        return testTime;
    }

    public void setTestTime(Integer testTime) {
        this.testTime = testTime;
    }

    public Integer getTestType() {
        return testType;
    }

    public void setTestType(Integer testType) {
        this.testType = testType;
    }

    public Integer getTestPassedScore() {
        return testPassedScore;
    }

    public void setTestPassedScore(Integer testPassedScore) {
        this.testPassedScore = testPassedScore;
    }

    public Integer getChapterSimulatorId() {
        return chapterSimulatorId;
    }

    public void setChapterSimulatorId(Integer chapterSimulatorId) {
        this.chapterSimulatorId = chapterSimulatorId;
    }
}
