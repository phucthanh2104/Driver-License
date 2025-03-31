package com.demo.repositories;

import com.demo.entities.Rank;
import org.springframework.data.repository.CrudRepository;

public interface RankRepository extends CrudRepository<Rank, Integer> {
}
