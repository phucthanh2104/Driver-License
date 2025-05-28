package com.demo.entities;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "question")
public class Question {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(columnDefinition = "text")
    private String content;

    @Column(name = "is_failed")
    private boolean isFailed;

    @Column(columnDefinition = "text")
    private String image;

    @Column(name = "explain")
    private String explain;

    private boolean status;

    @Column(name = "is_rankA")
    private boolean isRankA;

    @OneToMany(mappedBy = "question")
    private List<Answer> answers;

    @OneToMany(mappedBy = "question")
    private List<TestDetails> testDetails;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean getIsFailed() {
        return isFailed;
    }

    public void setIsFailed(boolean isFailed) {
        this.isFailed = isFailed;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public List<Answer> getAnswers() {
        return answers;
    }

    public void setAnswers(List<Answer> answers) {
        this.answers = answers;
    }

    public List<TestDetails> getTestDetails() {
        return testDetails;
    }

    public void setTestDetails(List<TestDetails> testDetails) {
        this.testDetails = testDetails;
    }

    public boolean getIsRankA() {
        return isRankA;
    }

    public void setRankA(boolean rankA) {
        isRankA = rankA;
    }

    public String getExplain() {
        return explain;
    }

    public void setExplain(String explain) {
        this.explain = explain;
    }
}
