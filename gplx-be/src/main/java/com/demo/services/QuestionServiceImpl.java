package com.demo.services;

import com.demo.dtos.AnswerDTO;
import com.demo.dtos.QuestionDTO;
import com.demo.entities.Answer;
import com.demo.entities.Question;
import com.demo.repositories.QuestionRepository;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class QuestionServiceImpl implements QuestionService {
    @Autowired
    private QuestionRepository questionRepository;
    @Autowired
    private ModelMapper modelMapper;
    @Override
    public List<QuestionDTO> findAll() {
        List<Question> questions = (List<Question>) questionRepository.findAll();

        return questions.stream().map(question -> {
            QuestionDTO dto = modelMapper.map(question, QuestionDTO.class);

            // Map danh sách Answer → AnswerDTO
            List<AnswerDTO> answerDTOs = question.getAnswers().stream().map(answer -> {
                AnswerDTO aDto = new AnswerDTO();
                aDto.setId(answer.getId());
                aDto.setContent(answer.getContent());
                aDto.setCorrect(answer.isCorrect());
                aDto.setStatus(answer.isStatus());
                return aDto;
            }).collect(Collectors.toList());

            dto.setAnswers(answerDTOs);

            // ✅ Lấy ra id của đáp án đúng (nếu có)
            question.getAnswers().stream()
                    .filter(Answer::isCorrect)
                    .findFirst()
                    .ifPresent(correct -> dto.setCorrectAnswer(correct.getId()));

            return dto;
        }).collect(Collectors.toList());
    }

    @Override
    public List<QuestionDTO> findFailedQuestion() {
        List<Question> failedQuestions = questionRepository.findAllFailedQuestions();

        return failedQuestions.stream().map(question -> {
            QuestionDTO dto = modelMapper.map(question, QuestionDTO.class);

            // Map danh sách Answer → AnswerDTO
            List<AnswerDTO> answerDTOs = question.getAnswers().stream().map(answer -> {
                AnswerDTO aDto = new AnswerDTO();
                aDto.setId(answer.getId());
                aDto.setContent(answer.getContent());
                aDto.setCorrect(answer.isCorrect());
                aDto.setStatus(answer.isStatus());
                return aDto;
            }).collect(Collectors.toList());

            dto.setAnswers(answerDTOs);

            // ✅ Lấy ra id của đáp án đúng (nếu có)
            question.getAnswers().stream()
                    .filter(Answer::isCorrect)
                    .findFirst()
                    .ifPresent(correct -> dto.setCorrectAnswer(correct.getId()));

            return dto;
        }).collect(Collectors.toList());
    }

    @Override
    public List<QuestionDTO> findFailedQuestionByRank() {
        List<Question> failedQuestions = questionRepository.findAllFailedQuestionsByRank();

        return failedQuestions.stream().map(question -> {
            QuestionDTO dto = modelMapper.map(question, QuestionDTO.class);

            // Map danh sách Answer → AnswerDTO
            List<AnswerDTO> answerDTOs = question.getAnswers().stream().map(answer -> {
                AnswerDTO aDto = new AnswerDTO();
                aDto.setId(answer.getId());
                aDto.setContent(answer.getContent());
                aDto.setCorrect(answer.isCorrect());
                aDto.setStatus(answer.isStatus());
                return aDto;
            }).collect(Collectors.toList());

            dto.setAnswers(answerDTOs);

            // ✅ Lấy ra id của đáp án đúng (nếu có)
            question.getAnswers().stream()
                    .filter(Answer::isCorrect)
                    .findFirst()
                    .ifPresent(correct -> dto.setCorrectAnswer(correct.getId()));

            return dto;
        }).collect(Collectors.toList());
    }
}
