package com.demo.dtos;

import com.demo.entities.Answer;
import com.demo.entities.TestDetails;
import jakarta.persistence.*;

import java.util.List;

public class QuestionDTO {

    private Integer id;
    private String content;
    private boolean isFailed;
    private String image;
    private String explain;
    private boolean status;
    private boolean isRankA;
    private List<AnswerDTO> answers;
    private Integer correctAnswer;

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

    public boolean isFailed() {
        return isFailed;
    }

    public void setFailed(boolean failed) {
        isFailed = failed;
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

    public List<AnswerDTO> getAnswers() {
        return answers;
    }

    public void setAnswers(List<AnswerDTO> answers) {
        this.answers = answers;
    }

    public Integer getCorrectAnswer() {
        return correctAnswer;
    }

    public void setCorrectAnswer(Integer correctAnswer) {
        this.correctAnswer = correctAnswer;
    }

    public boolean isRankA() {
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
