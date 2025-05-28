package com.demo.services;

import com.demo.dtos.TestDetailDTO;

import java.util.List;

public interface TestDetailsService {
    List<TestDetailDTO> findByTestId(int testId);



}
