package com.demo.controllers;

import com.demo.entities.Answer;
import com.demo.entities.Rank;
import com.demo.services.AnswerService;
import com.demo.services.RankService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/rank")
public class RankController {

    @Autowired
    private RankService rankService;

    @GetMapping("findAll")
    public ResponseEntity<List<Rank>> findAll() {
        try{
            return new ResponseEntity<>(rankService.findAll(),HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }
}
