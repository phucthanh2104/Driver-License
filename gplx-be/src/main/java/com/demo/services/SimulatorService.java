package com.demo.services;

import com.demo.dtos.SimulatorDTO;
import com.demo.entities.Simulator;

import java.util.List;

public interface SimulatorService {

    public List<SimulatorDTO> findByChapterId(Integer id);

    public SimulatorDTO findById(Integer id);

    public List<SimulatorDTO> findAll();
}
