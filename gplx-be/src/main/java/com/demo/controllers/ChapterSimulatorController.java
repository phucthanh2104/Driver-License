package com.demo.controllers;

import com.demo.dtos.ChapterSimulatorDTO;
import com.demo.dtos.QuestionDTO;
import com.demo.dtos.SimulatorDTO;
import com.demo.services.ChapterSimulatorService;
import com.demo.services.QuestionService;
import com.demo.services.SimulatorService;
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
@RequestMapping("api/chapter_simulator")
public class ChapterSimulatorController {
    @Autowired
    private ChapterSimulatorService chapterSimulatorService;
    @Autowired
    private SimulatorService simulatorService;

    @GetMapping(value = "findAll", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<ChapterSimulatorDTO>> findAll() {
        try {
            return new ResponseEntity<List<ChapterSimulatorDTO>>(chapterSimulatorService.findAll(), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<List<ChapterSimulatorDTO>>(HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(value = "findByChapterId/{id}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<SimulatorDTO>> findByChapterId(@PathVariable("id") Integer id) {
        try {
            return new ResponseEntity<List<SimulatorDTO>>(simulatorService.findByChapterId(id), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<List<SimulatorDTO>>(HttpStatus.BAD_REQUEST);
        }
    }
    @GetMapping(value = "findBySimulatorId/{id}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<SimulatorDTO> findById(@PathVariable("id") Integer id) {
        try {
            return new ResponseEntity<SimulatorDTO>(simulatorService.findById(id), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<SimulatorDTO>(HttpStatus.BAD_REQUEST);
        }
    }
}
