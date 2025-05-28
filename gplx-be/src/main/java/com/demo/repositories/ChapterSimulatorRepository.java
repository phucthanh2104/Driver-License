package com.demo.repositories;

import com.demo.entities.ChapterSimulator;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChapterSimulatorRepository extends CrudRepository<ChapterSimulator, Integer> {
}
