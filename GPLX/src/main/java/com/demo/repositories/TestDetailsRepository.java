package com.demo.repositories;

import com.demo.entities.Test;
import com.demo.entities.TestDetails;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TestDetailsRepository extends CrudRepository<TestDetails, Integer> {


}
