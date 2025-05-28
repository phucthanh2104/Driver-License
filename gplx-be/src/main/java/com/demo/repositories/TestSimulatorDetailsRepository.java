package com.demo.repositories;


import com.demo.entities.TestSimulatorDetails;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface TestSimulatorDetailsRepository  extends CrudRepository<TestSimulatorDetails, Integer> {

    @Query("SELECT tsd FROM TestSimulatorDetails tsd WHERE tsd.test.id = :testId")
    List<TestSimulatorDetails> findByTestId(@Param("testId") int testId);


}
