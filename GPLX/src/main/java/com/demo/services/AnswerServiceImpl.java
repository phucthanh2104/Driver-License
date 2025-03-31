package com.demo.services;

import com.demo.dtos.AnswerDTO;
import com.demo.entities.Answer;
import com.demo.repositories.AnswerRepository;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class AnswerServiceImpl implements AnswerService {

    @Autowired
    private AnswerRepository answerRepository;
    @Autowired
    private ModelMapper modelMapper;
    @Override
    public List<Answer> findAll() {

        return modelMapper.map(answerRepository.findAll(), new TypeToken<List<AnswerDTO>>(){}.getType());
    }

    @Override
    public AnswerDTO findById(int id) {
        return modelMapper.map(answerRepository.findById(id).get(), AnswerDTO.class);
    }
}
