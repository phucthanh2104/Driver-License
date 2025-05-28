package com.demo.controllers;

import com.demo.dtos.TestSimulatorDetailDTO;
import com.demo.services.TestSimulatorDetailsService;
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
@RequestMapping("api/testSimulatorDetails")
public class TestSimulatorDetailsController {
    @Autowired
    private TestSimulatorDetailsService testSimulatorDetailsService;

    @GetMapping(value = "findByTestId/{testId}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<TestSimulatorDetailDTO>> findAll(@PathVariable int testId) {
        try {
            return new ResponseEntity<List<TestSimulatorDetailDTO>>(testSimulatorDetailsService.findByTestId(testId), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<List<TestSimulatorDetailDTO>>(HttpStatus.BAD_REQUEST);
        }
    }
}
