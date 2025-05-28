package com.demo.repositories;

import com.demo.entities.Test;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface TestRepository extends CrudRepository<Test, Long> {

    @Query("SELECT t FROM Test t WHERE t.type = :type AND t.rank.id = :rankId and t.status = true and t.isTest = true")
    List<Test> findByTypeAndRankId(@Param("type") int type, @Param("rankId") int rankId);


    @Query("SELECT t FROM Test t WHERE t.rank.id IS NULL")
    List<Test> findAllWithNullRankId();

    @Query("SELECT t FROM Test t WHERE t.type = :type AND t.rank.id = :rankId and t.status = true and t.isTest = false")
    List<Test> findSimulatorByTypeAndRankId(@Param("type") int type, @Param("rankId") int rankId);


    @Query("SELECT t FROM Test t WHERE t.rank.id = :rankId and t.status = true and t.isTest = true")
    List<Test> findTestByRankId( @Param("rankId") int rankId);

    @Query("SELECT t FROM Test t WHERE t.rank.id = :rankId and t.status = true and t.isTest = false")
    List<Test> findSimulatorByRankId( @Param("rankId") int rankId);

    @Query("SELECT t FROM Test t WHERE t.status = true and t.isTest = true")
    List<Test> findAllTest( );

    @Query("SELECT t FROM Test t WHERE t.status = true and t.isTest = false")
    List<Test> findAllSimulator( );
}
