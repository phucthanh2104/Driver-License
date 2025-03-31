package com.demo.services;

import com.demo.dtos.AnswerDTO;
import com.demo.dtos.QuestionDTO;
import com.demo.entities.Answer;

import java.util.List;

public interface AnswerService {
    public List<Answer> findAll();

    public AnswerDTO findById(int id);
}
