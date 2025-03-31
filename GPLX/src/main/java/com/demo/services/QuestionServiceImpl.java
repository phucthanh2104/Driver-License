package com.demo.services;

import com.demo.dtos.QuestionDTO;
import com.demo.entities.Question;
import com.demo.repositories.QuestionRepository;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class QuestionServiceImpl implements QuestionService {

    @Autowired
    private QuestionRepository questionRepository;
    @Autowired
    private ModelMapper modelMapper;

    @Override
    public List<Question> findAll() {
        return modelMapper.map(questionRepository.findAll(), new TypeToken<List<QuestionDTO>>() {}.getType());
    }

    @Override
    public QuestionDTO findById(int id) {
        return modelMapper.map(questionRepository.findById(id).get(), QuestionDTO.class);
    }

    @Override
    public List<Question> findFailedQuestion() {
        return modelMapper.map(questionRepository.findAllFailedQuestions(), new TypeToken<List<QuestionDTO>>() {}.getType());
    }


}
