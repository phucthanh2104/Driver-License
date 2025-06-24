package com.demo.entities;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "test_simulator_details")

public class TestSimulatorDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "simulator_id", nullable = false)
    private Simulator simulator;

    @ManyToOne
    @JoinColumn(name = "test_id", nullable = false)
    private Test test;

    @ManyToOne
    @JoinColumn(name = "chapter_simulator_id", nullable = true)
    private ChapterSimulator chapter;

    @Column(name = "status")
    private boolean status;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Simulator getSimulator() {
        return simulator;
    }

    public void setSimulator(Simulator simulator) {
        this.simulator = simulator;
    }

    public Test getTest() {
        return test;
    }

    public void setTest(Test test) {
        this.test = test;
    }

    public ChapterSimulator getChapter() {
        return chapter;
    }

    public void setChapter(ChapterSimulator chapter) {
        this.chapter = chapter;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public boolean getStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}