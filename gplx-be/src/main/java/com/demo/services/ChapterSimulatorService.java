package com.demo.services;

import com.demo.dtos.ChapterSimulatorDTO;
import com.demo.entities.ChapterSimulator;

import java.util.List;

public interface ChapterSimulatorService {

    public List<ChapterSimulatorDTO> findAll();

}
