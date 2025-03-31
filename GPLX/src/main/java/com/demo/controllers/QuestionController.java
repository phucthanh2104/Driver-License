package com.demo.controllers;

import com.demo.dtos.QuestionDTO;
import com.demo.entities.Question;
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
@RequestMapping("/api/question")
public class QuestionController {

    @Autowired
    private QuestionService questionService;

    @GetMapping("findAll")
    public ResponseEntity<List<Question>> findAll() {
        try{
            return new ResponseEntity<>(questionService.findAll(),HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }
    // Tìm theo id
    @GetMapping("findById/{id}")
    public ResponseEntity<QuestionDTO> findById(@PathVariable("id") int id) {
        try{
            return new ResponseEntity<>(questionService.findById(id),HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    // Tìm ra danh sách các câu hỏi điểm liệt
    @GetMapping("findAllFailed")
    public ResponseEntity<List<Question>> findAllFailed() {
        try{
            return new ResponseEntity<>(questionService.findFailedQuestion(),HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }
}
