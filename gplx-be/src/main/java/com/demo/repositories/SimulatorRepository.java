package com.demo.repositories;

import com.demo.dtos.SimulatorDTO;
import com.demo.entities.ChapterSimulator;
import com.demo.entities.Simulator;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SimulatorRepository extends CrudRepository<Simulator, Integer> {


    @Query("FROM Simulator s WHERE s.chapterSimulator.id = :id")
    public List<Simulator> findByChapterSimulatorId(@Param("id") int id);

}
