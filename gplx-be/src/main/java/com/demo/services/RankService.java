package com.demo.services;

import com.demo.dtos.RankDTO;

import java.util.List;

public interface RankService {
    public List<RankDTO> findAll();
    public RankDTO findById(int id);
}
