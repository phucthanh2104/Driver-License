package com.demo.repositories;

import com.demo.entities.Answer;
import com.demo.entities.Test;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TestRepository extends CrudRepository<Test, Integer> {


}
