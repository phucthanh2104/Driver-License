package com.demo.services;

import com.demo.dtos.TestDTO;
import com.demo.entities.Test;
import com.demo.repositories.TestRepository;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TestServiceImpl implements TestService{

    @Autowired
    private TestRepository testRepository;
    @Autowired
    private ModelMapper modelMapper;
    @Override
    public List<Test> findAll() {
        return modelMapper.map(testRepository.findAll(), new TypeToken<List<TestDTO>>() {}.getType());
    }
}
