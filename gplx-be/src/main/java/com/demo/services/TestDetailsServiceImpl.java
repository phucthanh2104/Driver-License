package com.demo.services;

import com.demo.dtos.AnswerDTO;
import com.demo.dtos.QuestionDTO;
import com.demo.dtos.TestDetailDTO;
import com.demo.entities.*;
import com.demo.repositories.SimulatorRepository;
import com.demo.repositories.TestDetailsRepository;
import com.demo.repositories.TestRepository;
import com.demo.repositories.TestSimulatorDetailsRepository;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class TestDetailsServiceImpl implements TestDetailsService {
    @Autowired
    private TestDetailsRepository testDetailsRepository;
    @Autowired
    private TestSimulatorDetailsRepository testSimulatorDetailsRepository;
    @Autowired
    private TestRepository testRepository;
    @Autowired
    private SimulatorRepository simulatorRepository;
    @Autowired
    private ModelMapper modelMapper;
    @Override
    public List<TestDetailDTO> findByTestId(int testId) {
        List<TestDetails> details = testDetailsRepository.findByTestId(testId);

        return details.stream().map(detail -> {
            Question question = detail.getQuestion();

            // Map Question -> QuestionDTO
            QuestionDTO questionDTO = modelMapper.map(question, QuestionDTO.class);

            // Map danh sách Answer -> AnswerDTO
            List<AnswerDTO> answerDTOs = question.getAnswers().stream().map(answer -> {
                AnswerDTO aDto = new AnswerDTO();
                aDto.setId(answer.getId());
                aDto.setContent(answer.getContent());
                aDto.setCorrect(answer.isCorrect());
                aDto.setStatus(answer.isStatus());
                return aDto;
            }).collect(Collectors.toList());

            questionDTO.setAnswers(answerDTOs);

            // Tìm đáp án đúng
            question.getAnswers().stream()
                    .filter(Answer::isCorrect)
                    .findFirst()
                    .ifPresent(correct -> questionDTO.setCorrectAnswer(correct.getId()));

            return new TestDetailDTO(
                    (int) detail.getTest().getId(),
                    detail.getChapter() != null ? detail.getChapter().getId() : null,
                    questionDTO,
                    detail.getTest().getTime() != null ? detail.getTest().getTime() : 0,
                    detail.getTest().getPassedScore() != null ? detail.getTest().getPassedScore() : 0

                    );
        }).collect(Collectors.toList());
    }



}
