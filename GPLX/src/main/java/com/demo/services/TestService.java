package com.demo.services;

import com.demo.dtos.QuestionDTO;
import com.demo.entities.Test;

import java.util.List;

public interface TestService {

    public List<Test> findAll();
}
