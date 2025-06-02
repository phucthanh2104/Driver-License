package com.demo.services;

import com.demo.dtos.SimulatorDTO;
import com.demo.dtos.TestDTO;
import com.demo.repositories.SimulatorRepository;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.modelmapper.internal.bytebuddy.description.method.MethodDescription;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class SimulatorServiceImpl implements SimulatorService {

    @Autowired
    private SimulatorRepository simulatorRepository;
    @Autowired
    private ModelMapper modelMapper;

    @Override
    public List<SimulatorDTO> findByChapterId(Integer id) {
//        return simulatorRepository.findByChapterSimulatorId(id)
//                .stream()
//                .map(simulator -> modelMapper.map(simulator, SimulatorDTO.class))
//                .collect(Collectors.toList());
        return modelMapper.map(simulatorRepository.findByChapterSimulatorId(id) , new TypeToken<List<SimulatorDTO>>(){}.getType());
    }

    @Override
    public SimulatorDTO findById(Integer id) {
        return modelMapper.map(simulatorRepository.findById(id).get() , SimulatorDTO.class );
    }

    @Override
    public List<SimulatorDTO> findAll() {
        return modelMapper.map(simulatorRepository.findAll() , new TypeToken<List<SimulatorDTO>>(){}.getType());
    }

}
