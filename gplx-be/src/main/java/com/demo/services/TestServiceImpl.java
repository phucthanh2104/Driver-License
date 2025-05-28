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
public class TestServiceImpl implements TestService {
    @Autowired
    private TestRepository testRepository;
    @Autowired
    private ModelMapper modelMapper;
    @Override
    public TestDTO findById(Long id) {
        try {
            Test test = testRepository.findById(id).orElseThrow();
            test.getTestDetails().size(); // ép Hibernate load list
            return modelMapper.map(test, TestDTO.class);
        } catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<TestDTO> findAllByTypeAndRankId(int type, int rankId) {
        try {
            return modelMapper.map(testRepository.findByTypeAndRankId(type, rankId), new TypeToken<List<TestDTO>>() {}.getType());
        }
        catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<TestDTO> findAllTestByRankIsNull() {
        return modelMapper.map(testRepository.findAllWithNullRankId(), new TypeToken<List<TestDTO>>() {}.getType());
    }

    @Override
    public List<TestDTO> findSimulatorByTypeAndRankId(int type, int rankId) {
        try {
            return modelMapper.map(testRepository.findSimulatorByTypeAndRankId(type, rankId), new TypeToken<List<TestDTO>>() {}.getType());
        }
        catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<TestDTO> findAllTest() {
        return modelMapper.map(testRepository.findAllTest(), new TypeToken<List<TestDTO>>() {}.getType());
    }
    @Override
    public List<TestDTO> findAllSimulator() {
        return modelMapper.map(testRepository.findAllSimulator(), new TypeToken<List<TestDTO>>() {}.getType());
    }

    @Override
    public List<TestDTO> findTestByRankId(int rankId) {
        try {
            return modelMapper.map(testRepository.findTestByRankId( rankId), new TypeToken<List<TestDTO>>() {}.getType());
        }
        catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<TestDTO> findSimulatorByRankId(int rankId) {
        try {
            return modelMapper.map(testRepository.findSimulatorByRankId( rankId), new TypeToken<List<TestDTO>>() {}.getType());
        }
        catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }


}
