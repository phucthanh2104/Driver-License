package com.demo.controllers;

import com.demo.dtos.AnswerDTO;
import com.demo.entities.Answer;
import com.demo.entities.TestDetails;
import com.demo.services.AnswerService;
import com.demo.services.TestDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/testDetails")
public class TestDetailsController {

    @Autowired
    private TestDetailsService testDetailsService;

    @GetMapping("findAll")
    public ResponseEntity<List<TestDetails>> findAll() {
        try{
            return new ResponseEntity<>(testDetailsService.findAll(),HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

}
