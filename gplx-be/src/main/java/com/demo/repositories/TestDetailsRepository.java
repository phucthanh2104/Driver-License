package com.demo.repositories;

import com.demo.entities.TestDetails;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TestDetailsRepository extends CrudRepository<TestDetails, Integer> {

    @Query("SELECT td FROM TestDetails td WHERE td.test.id = :testId")
    List<TestDetails> findByTestId(@Param("testId") Integer testId);
}
