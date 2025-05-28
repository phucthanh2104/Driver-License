package com.demo.entities;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "chapter_simulator")
public class ChapterSimulator {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(columnDefinition = "text")
    private String title;

    @Column(columnDefinition = "text")
    private String description;

    @Column(nullable = false)
    private Boolean status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "test_id", nullable = false) // Cột mới bạn vừa thêm
    private Test test;

    @OneToMany(mappedBy = "chapterSimulator", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Simulator> simulators;





    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
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

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public List<Simulator> getSimulators() {
        return simulators;
    }

    public void setSimulators(List<Simulator> simulators) {
        this.simulators = simulators;
    }

    public Test getTest() {
        return test;
    }

    public void setTest(Test test) {
        this.test = test;
    }
}