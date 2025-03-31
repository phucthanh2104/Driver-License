package com.demo.services;

import com.demo.dtos.TestDetailsDTO;
import com.demo.entities.TestDetails;
import com.demo.repositories.TestDetailsRepository;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TestDetailsServiceImpl implements TestDetailsService {

    @Autowired
    private TestDetailsRepository testDetailsRepository;
    @Autowired
    private ModelMapper modelMapper;
    @Override
    public Iterable<TestDetails> findAll() {
        return modelMapper.map(testDetailsRepository.findAll(), new TypeToken<Iterable<TestDetailsDTO>>() {}.getType()) ;
    }
}
