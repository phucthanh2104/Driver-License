package com.demo.services;

import com.demo.dtos.TestSimulatorDetailDTO;

import java.util.List;

public interface TestSimulatorDetailsService {
    List<TestSimulatorDetailDTO> findByTestId(int testId);
}
