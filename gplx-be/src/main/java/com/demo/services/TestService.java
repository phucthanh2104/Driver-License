package com.demo.services;

import com.demo.dtos.TestDTO;
import com.demo.entities.Test;

import java.util.List;

public interface TestService {
    public TestDTO findById(Long id);
    public List<TestDTO> findAllByTypeAndRankId(int type, int rankId);

   public List<TestDTO> findAllTestByRankIsNull();


    public List<TestDTO> findSimulatorByTypeAndRankId(int type, int rankId);

    public List<TestDTO> findAllTest();
    public List<TestDTO> findAllSimulator();

    public List<TestDTO> findTestByRankId(int rankId);
    public List<TestDTO> findSimulatorByRankId(int rankId);
}
