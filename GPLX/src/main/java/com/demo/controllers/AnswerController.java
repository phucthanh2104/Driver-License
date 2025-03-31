package com.demo.controllers;

import com.demo.dtos.AnswerDTO;
import com.demo.entities.Answer;
import com.demo.entities.Question;
import com.demo.services.AnswerService;
import com.demo.services.QuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/answer")
public class AnswerController {

    @Autowired
    private AnswerService answerService;

    @GetMapping("findAll")
    public ResponseEntity<List<Answer>> findAll() {
        try{
            return new ResponseEntity<>(answerService.findAll(),HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }
    @GetMapping("findById/{id}")
    public ResponseEntity<AnswerDTO> findById(@PathVariable int id) {
        try{
            return new ResponseEntity<>(answerService.findById(id),HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }
}
