package com.demo.repositories;

import com.demo.entities.Rank;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RankRepository extends CrudRepository<Rank, Integer> {
}
