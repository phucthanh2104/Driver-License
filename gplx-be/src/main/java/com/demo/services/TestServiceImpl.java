package com.demo.services;

import com.demo.dtos.*;
import com.demo.entities.*;
import com.demo.repositories.QuestionRepository;
import com.demo.repositories.TestRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class TestServiceImpl implements TestService {
    @Autowired
    private TestRepository testRepository;
    @Autowired
    private QuestionRepository questionRepository;
    @Autowired
    private RankService rankService;
    @Autowired
    private ModelMapper modelMapper;

    @PersistenceContext
    private EntityManager entityManager;


    @Override
    public TestDTO findById(Long id) {
        try {
            Test test = testRepository.findById(id).orElseThrow();
            test.getTestDetails().size(); // ép Hibernate load list
            return modelMapper.map(test, TestDTO.class);
        } catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<TestDTO> findAllByTypeAndRankId(int type, int rankId) {
        try {
            return modelMapper.map(testRepository.findByTypeAndRankId(type, rankId), new TypeToken<List<TestDTO>>() {}.getType());
        }
        catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<TestDTO> findAllTestByRankIsNull() {
        return modelMapper.map(testRepository.findAllWithNullRankId(), new TypeToken<List<TestDTO>>() {}.getType());
    }

    @Override
    public List<TestDTO> findSimulatorByTypeAndRankId(int type, int rankId) {
        try {
            return modelMapper.map(testRepository.findSimulatorByTypeAndRankId(type, rankId), new TypeToken<List<TestDTO>>() {}.getType());
        }
        catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<TestDTO> findAllTest() {
        return modelMapper.map(testRepository.findAllTest(), new TypeToken<List<TestDTO>>() {}.getType());
    }
    @Override
    public List<TestDTO> findAllSimulator() {
        return modelMapper.map(testRepository.findAllSimulator(), new TypeToken<List<TestDTO>>() {}.getType());
    }

    @Override
    public List<TestDTO> findTestByRankId(int rankId) {
        try {
            return modelMapper.map(testRepository.findTestByRankId( rankId), new TypeToken<List<TestDTO>>() {}.getType());
        }
        catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<TestDTO> findSimulatorByRankId(int rankId) {
        try {
            return modelMapper.map(testRepository.findSimulatorByRankId( rankId), new TypeToken<List<TestDTO>>() {}.getType());
        }
        catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    @Transactional
    public TestDTO save(TestDTO testDTO) {
        // Ánh xạ TestDTO sang Test entity (chỉ ánh xạ các thuộc tính cơ bản)
        Test test = new Test();
        test.setTitle(testDTO.getTitle());
        test.setDescription(testDTO.getDescription());
        test.setType(testDTO.getType());
        test.setTime(testDTO.getTime());
        test.setPassedScore(testDTO.getPassedScore());
        test.setStatus(testDTO.isStatus());
        test.setTest(true); // Sử dụng giá trị isTest từ testDTO
        test.setNumberOfQuestions(testDTO.getNumberOfQuestions());

        // Xử lý rank
        if (testDTO.getRank() != null) {
            RankDTO rankDTO = rankService.findById(testDTO.getRank());
            Rank rank = modelMapper.map(rankDTO, Rank.class);
            test.setRank(rank);
        }

        // Lấy danh sách TestDetailDTO từ testDTO
        List<TestDetailDTO> testDetailDTOs = testDTO.getTestDetails();
        if (testDetailDTOs == null || testDetailDTOs.isEmpty()) {
            throw new IllegalArgumentException("Danh sách câu hỏi không được để trống");
        }

        List<TestDetails> testDetails = new ArrayList<>();
        for (TestDetailDTO detailDTO : testDetailDTOs) {
            if (detailDTO.getQuestion() == null || detailDTO.getQuestion().getId() == null) {
                throw new IllegalArgumentException("questionId không được để trống trong testDetails");
            }

            Question question = questionRepository.findByIdWithAnswers(detailDTO.getQuestion().getId());

            TestDetails testDetail = new TestDetails();
            testDetail.setTest(test);
            testDetail.setQuestion(question);
            testDetail.setChapter(null); // Giả định chapterId là tùy chọn, có thể null
            testDetail.setStatus( true);
            testDetails.add(testDetail);
        }

        test.setTestDetails(testDetails);

        // Lưu Test (và các TestDetails liên quan do cascade)
        Test savedTest = testRepository.save(test);

        // Tải lại Test từ cơ sở dữ liệu với tất cả TestDetails
        Test loadedTest = entityManager.find(Test.class, savedTest.getId());

        // Ánh xạ lại sang TestDTO để trả về
        TestDTO resultDTO = modelMapper.map(loadedTest, TestDTO.class);

        // Ánh xạ testDetails với đầy đủ thông tin Question, không bao gồm time và passedScore
        List<TestDetailDTO> resultTestDetails = loadedTest.getTestDetails().stream().map(testDetail -> {
            TestDetailDTO dto = new TestDetailDTO();
            dto.setTestId((int) testDetail.getTest().getId());
            dto.setChapterId(testDetail.getChapter() != null ? testDetail.getChapter().getId() : null);
            Question question = testDetail.getQuestion();
            QuestionDTO questionDTO = modelMapper.map(question, QuestionDTO.class);
            // Ánh xạ danh sách answers
            if (question.getAnswers() != null) {
                List<AnswerDTO> answerDTOs = question.getAnswers().stream()
                        .map(answer -> modelMapper.map(answer, AnswerDTO.class))
                        .collect(Collectors.toList());
                questionDTO.setAnswers(answerDTOs);
            }

            // Tính correctAnswer
            questionDTO.setCorrectAnswer(question.getAnswers().stream()
                    .filter(Answer::isCorrect)
                    .findFirst()
                    .map(Answer::getId)
                    .orElse(null));

            dto.setQuestion(questionDTO);
            dto.setStatus(testDetail.isStatus());
            return dto;
        }).collect(Collectors.toList());

        resultDTO.setTestDetails(resultTestDetails);

        // Chuẩn bị phản hồi theo định dạng yêu cầu
        Map<String, Object> response = new HashMap<>();
        response.put("test", resultDTO);
        response.put("status", "success");
        return resultDTO; // Trả về resultDTO để khớp với signature, nhưng response được cấu trúc theo yêu cầu
    }
}
