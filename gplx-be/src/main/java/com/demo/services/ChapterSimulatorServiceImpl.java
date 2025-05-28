package com.demo.services;

import com.demo.dtos.ChapterSimulatorDTO;
import com.demo.repositories.ChapterSimulatorRepository;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ChapterSimulatorServiceImpl implements ChapterSimulatorService {

    @Autowired
    private ModelMapper modelMapper;
    @Autowired
    private ChapterSimulatorRepository chapterSimulatorRepository;
    @Override
    public List<ChapterSimulatorDTO> findAll() {
        return modelMapper.map(chapterSimulatorRepository.findAll(), new TypeToken<List<ChapterSimulatorDTO>>() {}.getType());
    }


}
