package com.demo.services;

import com.demo.dtos.QuestionDTO;
import com.demo.entities.Question;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface QuestionService {
    public List<QuestionDTO> findAll();

    public List<QuestionDTO> findFailedQuestion();

    public List<QuestionDTO> findFailedQuestionByRank();

    public QuestionDTO addQuestion(QuestionDTO questionDTO) throws IOException;

    public QuestionDTO findById(int questionId) throws IOException;

    public QuestionDTO deleteQuestion(int questionId) throws IOException;

    public QuestionDTO updateQuestion(QuestionDTO questionDTO) throws IOException;
}
