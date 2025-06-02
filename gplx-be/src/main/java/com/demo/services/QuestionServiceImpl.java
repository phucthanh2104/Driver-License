package com.demo.services;

import com.demo.dtos.AnswerDTO;
import com.demo.dtos.QuestionDTO;
import com.demo.entities.Answer;
import com.demo.entities.Question;
import com.demo.repositories.QuestionRepository;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.ArrayList;
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
        // Sử dụng findByStatusTrue() để chỉ lấy các câu hỏi có status = true
        List<Question> questions = (List<Question>) questionRepository.findByStatusTrue();

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

            // Lấy ra id của đáp án đúng (nếu có)
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

            // Lấy ra id của đáp án đúng (nếu có)
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

            // Lấy ra id của đáp án đúng (nếu có)
            question.getAnswers().stream()
                    .filter(Answer::isCorrect)
                    .findFirst()
                    .ifPresent(correct -> dto.setCorrectAnswer(correct.getId()));

            return dto;
        }).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public QuestionDTO addQuestion(QuestionDTO questionDTO) throws IOException {
        // Validate that there are at least 2 answers
        if (questionDTO.getAnswers() == null || questionDTO.getAnswers().size() < 2) {
            throw new IllegalArgumentException("Câu hỏi phải có ít nhất 2 câu trả lời");
        }

        // Validate that exactly one answer is marked as correct
        long correctAnswerCount = questionDTO.getAnswers().stream()
                .filter(AnswerDTO::isCorrect)
                .count();
        if (correctAnswerCount != 1) {
            throw new IllegalArgumentException("Câu hỏi phải có chính xác một câu trả lời đúng");
        }

        // Map QuestionDTO to Question entity
        Question question = new Question();
        question.setContent(questionDTO.getContent());
        question.setImage(questionDTO.getImage());
        question.setExplain(questionDTO.getExplain());
        question.setStatus(questionDTO.isStatus());
        question.setRankA(questionDTO.isRankA());
        question.setIsFailed(questionDTO.isFailed());

        // Map AnswerDTOs to Answer entities
        List<Answer> answers = new ArrayList<>();
        for (AnswerDTO answerDTO : questionDTO.getAnswers()) {
            Answer answer = new Answer();
            answer.setContent(answerDTO.getContent());
            answer.setCorrect(answerDTO.isCorrect());
            answer.setStatus(answerDTO.isStatus());
            answer.setQuestion(question); // Thiết lập mối quan hệ
            answers.add(answer);
        }

        question.setAnswers(answers);

        // Save the question (and its answers due to cascading)
        Question savedQuestion = questionRepository.save(question);

        // Tải lại Question từ cơ sở dữ liệu cùng với answers để đảm bảo có ID
        savedQuestion = questionRepository.findByIdWithAnswers(savedQuestion.getId());
        if (savedQuestion == null) {
            throw new IllegalStateException("Không tìm thấy câu hỏi sau khi lưu");
        }

        // Map saved Question to QuestionDTO
        QuestionDTO savedQuestionDTO = modelMapper.map(savedQuestion, QuestionDTO.class);

        // Map danh sách Answer → AnswerDTO, đảm bảo lấy ID đã được sinh tự động
        List<AnswerDTO> answerDTOs = savedQuestion.getAnswers().stream().map(answer -> {
            AnswerDTO aDto = new AnswerDTO();
            aDto.setId(answer.getId());
            aDto.setContent(answer.getContent());
            aDto.setCorrect(answer.isCorrect());
            aDto.setStatus(answer.isStatus());
            return aDto;
        }).collect(Collectors.toList());

        savedQuestionDTO.setAnswers(answerDTOs);

        // Lấy ra id của đáp án đúng (nếu có)
        savedQuestion.getAnswers().stream()
                .filter(Answer::isCorrect)
                .findFirst()
                .ifPresent(correct -> savedQuestionDTO.setCorrectAnswer(correct.getId()));

        return savedQuestionDTO;
    }

    @Override
    public QuestionDTO findById(int questionId) throws IOException {
        // Tìm Question theo ID, đồng thời tải danh sách answers
        Question question = questionRepository.findByIdWithAnswers(questionId);
        if (question == null) {
            throw new IllegalArgumentException("Không tìm thấy câu hỏi với ID: " + questionId);
        }

        // Map Question sang QuestionDTO
        QuestionDTO questionDTO = modelMapper.map(question, QuestionDTO.class);

        // Map danh sách Answer → AnswerDTO
        List<AnswerDTO> answerDTOs = question.getAnswers().stream().map(answer -> {
            AnswerDTO aDto = new AnswerDTO();
            aDto.setId(answer.getId());
            aDto.setContent(answer.getContent());
            aDto.setCorrect(answer.isCorrect());
            aDto.setStatus(answer.isStatus());
            return aDto;
        }).collect(Collectors.toList());

        questionDTO.setAnswers(answerDTOs);

        // Lấy ra id của đáp án đúng (nếu có)
        question.getAnswers().stream()
                .filter(Answer::isCorrect)
                .findFirst()
                .ifPresent(correct -> questionDTO.setCorrectAnswer(correct.getId()));

        return questionDTO;
    }

    @Override
    @Transactional
    public QuestionDTO deleteQuestion(int questionId) throws IOException {
        // Tìm câu hỏi theo ID, đồng thời tải danh sách answers
        Question question = questionRepository.findByIdWithAnswers(questionId);
        if (question == null) {
            throw new IllegalArgumentException("Không tìm thấy câu hỏi với ID: " + questionId);
        }

        // Cập nhật trạng thái thành false (soft delete)
        question.setStatus(false);

        // Lưu câu hỏi đã cập nhật
        Question updatedQuestion = questionRepository.save(question);

        // Map Question sang QuestionDTO
        QuestionDTO questionDTO = modelMapper.map(updatedQuestion, QuestionDTO.class);

        // Map danh sách Answer → AnswerDTO
        List<AnswerDTO> answerDTOs = updatedQuestion.getAnswers().stream().map(answer -> {
            AnswerDTO aDto = new AnswerDTO();
            aDto.setId(answer.getId());
            aDto.setContent(answer.getContent());
            aDto.setCorrect(answer.isCorrect());
            aDto.setStatus(answer.isStatus());
            return aDto;
        }).collect(Collectors.toList());

        questionDTO.setAnswers(answerDTOs);

        // Lấy ra id của đáp án đúng (nếu có)
        updatedQuestion.getAnswers().stream()
                .filter(Answer::isCorrect)
                .findFirst()
                .ifPresent(correct -> questionDTO.setCorrectAnswer(correct.getId()));

        return questionDTO;
    }

    @Override
    @Transactional
    public QuestionDTO updateQuestion(QuestionDTO questionDTO) throws IOException {
        // Tìm câu hỏi hiện có
        Question question = questionRepository.findByIdWithAnswers(questionDTO.getId());
        if (question == null) {
            throw new IllegalArgumentException("Không tìm thấy câu hỏi với ID: " + questionDTO.getId());
        }

        // Cập nhật các field của câu hỏi
        question.setContent(questionDTO.getContent());
        question.setImage(questionDTO.getImage());
        question.setExplain(questionDTO.getExplain());
        question.setStatus(questionDTO.isStatus());
        question.setRankA(questionDTO.isRankA());
        question.setIsFailed(questionDTO.isFailed());

        // Lấy danh sách câu trả lời hiện có
        List<Answer> existingAnswers = question.getAnswers();
        List<AnswerDTO> updatedAnswers = questionDTO.getAnswers();

        // Tạo danh sách để lưu các câu trả lời sau khi cập nhật
        List<Answer> newAnswerList = new ArrayList<>();

        // Duyệt qua danh sách câu trả lời từ DTO
        for (AnswerDTO answerDTO : updatedAnswers) {
            // Kiểm tra content không được null hoặc rỗng
            if (answerDTO.getContent() == null || answerDTO.getContent().trim().isEmpty()) {
                throw new IllegalArgumentException("Nội dung câu trả lời không được để trống (ID: " + (answerDTO.getId() != null ? answerDTO.getId() : "mới") + ")");
            }

            if (answerDTO.getId() != null) {
                // Nếu câu trả lời có ID, tìm và cập nhật
                Answer existingAnswer = existingAnswers.stream()
                        .filter(answer -> answer.getId() == answerDTO.getId())
                        .findFirst()
                        .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy câu trả lời với ID: " + answerDTO.getId()));

                // Cập nhật các field của câu trả lời
                existingAnswer.setContent(answerDTO.getContent());
                existingAnswer.setCorrect(answerDTO.isCorrect());
                existingAnswer.setStatus(answerDTO.isStatus());
                newAnswerList.add(existingAnswer);
            } else {
                // Tạo mới câu trả lời
                Answer newAnswer = new Answer();
                newAnswer.setContent(answerDTO.getContent());
                newAnswer.setCorrect(answerDTO.isCorrect());
                newAnswer.setStatus(answerDTO.isStatus());
                newAnswer.setQuestion(question);
                newAnswerList.add(newAnswer);
            }
        }

        // Xóa các câu trả lời không còn trong danh sách gửi lên
        existingAnswers.removeIf(answer -> newAnswerList.stream().noneMatch(newAnswer -> newAnswer.getId() != null && newAnswer.getId() == answer.getId()));
        // Thêm các câu trả lời mới vào danh sách hiện có
        existingAnswers.addAll(newAnswerList.stream()
                .filter(answer -> answer.getId() == null)
                .collect(Collectors.toList()));

        // Lưu câu hỏi đã cập nhật
        Question updatedQuestion = questionRepository.save(question);

        // Map sang QuestionDTO để trả về
        QuestionDTO updatedQuestionDTO = modelMapper.map(updatedQuestion, QuestionDTO.class);
        List<AnswerDTO> answerDTOs = updatedQuestion.getAnswers().stream().map(answer -> {
            AnswerDTO aDto = new AnswerDTO();
            aDto.setId(answer.getId());
            aDto.setContent(answer.getContent());
            aDto.setCorrect(answer.isCorrect());
            aDto.setStatus(answer.isStatus());
            return aDto;
        }).collect(Collectors.toList());

        updatedQuestionDTO.setAnswers(answerDTOs);

        // Lấy ra id của đáp án đúng (nếu có)
        updatedQuestion.getAnswers().stream()
                .filter(Answer::isCorrect)
                .findFirst()
                .ifPresent(correct -> updatedQuestionDTO.setCorrectAnswer(correct.getId()));

        return updatedQuestionDTO;
    }
}