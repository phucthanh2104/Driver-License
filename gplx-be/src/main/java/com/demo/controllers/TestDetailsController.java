package com.demo.controllers;

import com.demo.dtos.QuestionDTO;
import com.demo.dtos.TestDetailDTO;
import com.demo.services.QuestionService;
import com.demo.services.TestDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MimeTypeUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("api/testDetails")
public class TestDetailsController {
    @Autowired
    private TestDetailsService testDetailsService;

    @GetMapping(value = "findByTestId/{testId}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<TestDetailDTO>> findAll(@PathVariable int testId) {
        try {
            return new ResponseEntity<List<TestDetailDTO>>(testDetailsService.findByTestId(testId), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<List<TestDetailDTO>>(HttpStatus.BAD_REQUEST);
        }
    }
}
