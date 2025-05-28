package com.demo.controllers;

import com.demo.dtos.RankDTO;
import com.demo.dtos.TestDTO;
import com.demo.entities.Test;
import com.demo.repositories.TestRepository;
import com.demo.services.RankService;
import com.demo.services.TestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MimeTypeUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static org.springframework.data.jpa.domain.AbstractPersistable_.id;

@RestController
@RequestMapping("api/test")
public class TestController {
    @Autowired
    private TestService testService;
    @Autowired
    private RankService rankService;



    @GetMapping(value = "findAllTest", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<TestDTO>> findAllTest() {
        try {
            return new ResponseEntity<List<TestDTO>>(testService.findAllTest(), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<List<TestDTO>>(HttpStatus.BAD_REQUEST);
        }
    }
    @GetMapping(value = "findAllSimulator", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<TestDTO>> findAllSimulator() {
        try {
            return new ResponseEntity<List<TestDTO>>(testService.findAllSimulator(), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<List<TestDTO>>(HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(value = "findById/{id}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<TestDTO> findById(@PathVariable Long id) {
        try {
            return new ResponseEntity<TestDTO>(testService.findById(id), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<TestDTO>(HttpStatus.BAD_REQUEST);
        }
    }
    @GetMapping(value = "findAllByTypeAndRankId/{type}/{rankId}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<TestDTO>> findAllByTypeAndRankId(@PathVariable int type, @PathVariable int rankId) {
        try {
            return new ResponseEntity<List<TestDTO>>(testService.findAllByTypeAndRankId(type, rankId), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<List<TestDTO>>(HttpStatus.BAD_REQUEST);
        }
    }
    @GetMapping(value = "findSimulatorByTypeAndRankId/{type}/{rankId}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<TestDTO>> findSimulatorByTypeAndRankId(@PathVariable int type, @PathVariable int rankId) {
        try {
            return new ResponseEntity<List<TestDTO>>(testService.findSimulatorByTypeAndRankId(type, rankId), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<List<TestDTO>>(HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(value = "findAllRank", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<RankDTO>> findAllByType() {
        try {
            return new ResponseEntity<List<RankDTO>>(rankService.findAll(), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<List<RankDTO>>(HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(value = "findAllByRankIsNull", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<TestDTO>> findAllByRankIsNull() {
        try {
            return new ResponseEntity<List<TestDTO>>(testService.findAllTestByRankIsNull(), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<List<TestDTO>>(HttpStatus.BAD_REQUEST);
        }
    }
    @GetMapping(value = "findTestByRankId/{id}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<TestDTO>> findTestByRankId(@PathVariable Integer id) {
        try {
            return new ResponseEntity<List<TestDTO>>(testService.findTestByRankId(id), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<List<TestDTO>>(HttpStatus.BAD_REQUEST);
        }
    }
    @GetMapping(value = "findSimulatorByRankId/{id}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<TestDTO>> findSimulatorByRankId(@PathVariable Integer id) {
        try {
            return new ResponseEntity<List<TestDTO>>(testService.findSimulatorByRankId(id), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<List<TestDTO>>(HttpStatus.BAD_REQUEST);
        }
    }
}
