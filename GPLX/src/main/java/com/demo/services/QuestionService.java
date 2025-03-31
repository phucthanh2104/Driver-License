package com.demo.services;

import com.demo.dtos.QuestionDTO;
import com.demo.entities.Question;

import java.util.List;

public interface QuestionService {

        public List<Question> findAll();

        public QuestionDTO findById(int id);

        //tìm câu hỏi theo điểm liệt => tìm bằng is_failed = true

        public List<Question> findFailedQuestion();
}
