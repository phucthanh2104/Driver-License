package com.demo.services;

import com.demo.dtos.RankDTO;
import com.demo.repositories.RankRepository;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RankSeviceImpl implements RankService{
    @Autowired
    private RankRepository rankRepository;
    @Autowired
    private ModelMapper modelMapper;

    @Override
    public List<RankDTO> findAll() {
        return modelMapper.map(rankRepository.findAll(), new TypeToken<List<RankDTO>>() {}.getType());
    }
}
