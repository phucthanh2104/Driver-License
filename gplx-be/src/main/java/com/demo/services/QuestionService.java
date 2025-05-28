package com.demo.services;

import com.demo.dtos.QuestionDTO;
import com.demo.entities.Question;

import java.util.List;

public interface QuestionService {
    public List<QuestionDTO> findAll();

    public List<QuestionDTO> findFailedQuestion();

    public List<QuestionDTO> findFailedQuestionByRank();
}
