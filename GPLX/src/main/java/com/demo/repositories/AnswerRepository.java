package com.demo.repositories;

import com.demo.entities.Answer;
import com.demo.entities.Question;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AnswerRepository extends CrudRepository<Answer, Integer> {


}
