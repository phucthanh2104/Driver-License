package com.demo.services.impl;

import com.demo.dtos.*;
import com.demo.entities.*;
import com.demo.repositories.QuestionRepository;
import com.demo.repositories.SimulatorRepository;
import com.demo.repositories.TestRepository;
import com.demo.services.RankService;
import com.demo.services.TestService;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class TestServiceImpl implements TestService {
    @Autowired
    private TestRepository testRepository;
    @Autowired
    private QuestionRepository questionRepository;
    @Autowired
    private SimulatorRepository simulatorRepository;
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
    public TestDTO saveTesTSimulator(TestDTO testDTO) {
        // Ánh xạ TestDTO sang Test entity
        Test test = new Test();
        test.setTitle(testDTO.getTitle());
        test.setDescription(testDTO.getDescription());
        test.setType(testDTO.getType());
        test.setTime(testDTO.getTime());
        test.setPassedScore(testDTO.getPassedScore());
        test.setStatus(testDTO.isStatus());
        test.setTest(false);
        test.setNumberOfQuestions(testDTO.getNumberOfQuestions());

        // Xử lý rank
        if (testDTO.getRank() != null) {
            RankDTO rankDTO = rankService.findById(testDTO.getRank());
            if (rankDTO == null) {
                throw new IllegalArgumentException("Rank với ID " + testDTO.getRank() + " không tồn tại");
            }
            Rank rank = modelMapper.map(rankDTO, Rank.class);
            test.setRank(rank);
        }

        // Lấy danh sách TestDetailDTO từ testDTO
        List<TestSimulatorDetailDTO> testSimulatorDetailDTOS = testDTO.getTestSimulatorDetails();
        if (testSimulatorDetailDTOS == null || testSimulatorDetailDTOS.isEmpty()) {
            throw new IllegalArgumentException("Danh sách câu hỏi không được để trống");
        }

        // Tạo danh sách TestDetails
        List<TestSimulatorDetails> testSimulatorDetails = new ArrayList<>();
        for (TestSimulatorDetailDTO detailDTO : testSimulatorDetailDTOS) {
            if (detailDTO.getSimulator() == null || detailDTO.getSimulator().getId() == null) {
                throw new IllegalArgumentException("simulator không được để trống trong testSimulatorDetails");
            }

            // Tìm câu hỏi từ repository
            Simulator simulator = simulatorRepository.findById(detailDTO.getSimulator().getId()).orElseThrow();
            if (simulator == null) {
                throw new IllegalArgumentException("Câu hỏi với ID " + detailDTO.getSimulator().getId() + " không tồn tại");
            }

            // Tạo TestDetails
            TestSimulatorDetails testSimulatorDetail = new TestSimulatorDetails();
            testSimulatorDetail.setTest(test); // Liên kết với Test (ID sẽ được gán sau khi lưu Test)
            testSimulatorDetail.setSimulator(simulator); // Gán câu hỏi
            testSimulatorDetail.setChapter(null); // chapter_id = null theo yêu cầu
            testSimulatorDetail.setStatus(true); // status = true theo yêu cầu

            testSimulatorDetails.add(testSimulatorDetail);
        }

        // Gán danh sách testSimulatorDetails vào Test
        test.setTestSimulatorDetails(testSimulatorDetails);

        // Lưu Test (tự động lưu TestDetails do cascade = CascadeType.ALL)
        Test savedTest = testRepository.save(test);

        // Tải lại Test từ cơ sở dữ liệu để đảm bảo dữ liệu đầy đủ
        Test loadedTest = entityManager.find(Test.class, savedTest.getId());
        if (loadedTest.getTestSimulatorDetails() == null || loadedTest.getTestSimulatorDetails().isEmpty()) {
            throw new IllegalStateException("Không thể lưu testSimulatorDetails vào cơ sở dữ liệu");
        }

        // Ánh xạ Test sang TestDTO để trả về
        TestDTO resultDTO = modelMapper.map(loadedTest, TestDTO.class);

        // Ánh xạ danh sách TestDetails sang TestDetailDTO
        List<TestSimulatorDetailDTO> resultTestSimulatorDetails = loadedTest.getTestSimulatorDetails().stream().map(testSimulatorDetail -> {
            TestSimulatorDetailDTO dto = new TestSimulatorDetailDTO();
            dto.setTestId(testSimulatorDetail.getTest().getId());
            dto.setChapterSimulatorId(null); // chapter_id = null
            Simulator simulator = testSimulatorDetail.getSimulator();
            SimulatorDTO simulatorDTO = modelMapper.map(simulator, SimulatorDTO.class);
            dto.setTestTime(testSimulatorDetail.getTest().getTime());
            dto.setTestType(testSimulatorDetail.getTest().getType());
            dto.setTestPassedScore(testSimulatorDetail.getTest().getPassedScore());

            dto.setSimulator(simulatorDTO);
            dto.setStatus(testSimulatorDetail.getStatus());
            return dto;
        }).collect(Collectors.toList());

        resultDTO.setTestSimulatorDetails(resultTestSimulatorDetails);

        return resultDTO;
    }

    @Override
    @Transactional
    public TestDTO updateTest(TestDTO testDTO) {
        // Kiểm tra TestDTO đầu vào
        if (testDTO.getId() == null) {
            throw new IllegalArgumentException("ID của Test là bắt buộc để cập nhật");
        }

        // Tìm Test hiện có
        Test existingTest = testRepository.findById(testDTO.getId())
                .orElseThrow(() -> new IllegalArgumentException("Test với ID " + testDTO.getId() + " không tồn tại"));

        // Cập nhật các trường của Test
        existingTest.setTitle(testDTO.getTitle());
        existingTest.setDescription(testDTO.getDescription());
        existingTest.setType(testDTO.getType());
        existingTest.setTime(testDTO.getTime());
        existingTest.setPassedScore(testDTO.getPassedScore());
        existingTest.setStatus(testDTO.isStatus());
        existingTest.setNumberOfQuestions(testDTO.getNumberOfQuestions());

        // Xử lý rank
        if (testDTO.getRank() != null) {
            RankDTO rankDTO = rankService.findById(testDTO.getRank());
            if (rankDTO == null) {
                throw new IllegalArgumentException("Rank với ID " + testDTO.getRank() + " không tồn tại");
            }
            Rank rank = modelMapper.map(rankDTO, Rank.class);
            existingTest.setRank(rank);
        } else {
            existingTest.setRank(null);
        }

        // Lấy danh sách TestDetailDTO từ testDTO
        List<TestDetailDTO> testDetailDTOs = testDTO.getTestDetails();
        if (testDetailDTOs == null || testDetailDTOs.isEmpty()) {
            throw new IllegalArgumentException("Danh sách câu hỏi không được để trống");
        }

        // Tạo danh sách TestDetails mới
        List<TestDetails> updatedTestDetails = new ArrayList<>();
        for (TestDetailDTO detailDTO : testDetailDTOs) {
            if (detailDTO.getQuestion() == null || detailDTO.getQuestion().getId() == null) {
                throw new IllegalArgumentException("questionId không được để trống trong testDetails");
            }

            // Tìm câu hỏi từ repository
            Question question = questionRepository.findByIdWithAnswers(detailDTO.getQuestion().getId());
            if (question == null) {
                throw new IllegalArgumentException("Câu hỏi với ID " + detailDTO.getQuestion().getId() + " không tồn tại");
            }

            // Tạo TestDetails mới
            TestDetails testDetail = new TestDetails();
            testDetail.setTest(existingTest);
            testDetail.setQuestion(question);
            testDetail.setChapter(null); // chapter_id = null theo yêu cầu
            testDetail.setStatus(true); // status = true theo yêu cầu

            updatedTestDetails.add(testDetail);
        }

        // Xóa danh sách TestDetails hiện có và thay bằng danh sách mới
        existingTest.getTestDetails().clear();
        existingTest.getTestDetails().addAll(updatedTestDetails);

        // Lưu Test đã cập nhật
        Test savedTest = testRepository.save(existingTest);

        // Tải lại Test để đảm bảo dữ liệu nhất quán
        Test loadedTest = testRepository.findById(savedTest.getId())
                .orElseThrow(() -> new IllegalStateException("Không thể tải lại Test sau khi lưu"));
        if (loadedTest.getTestDetails() == null || loadedTest.getTestDetails().size() != testDetailDTOs.size()) {
            throw new IllegalStateException("Danh sách TestDetails không khớp sau khi lưu. Dự kiến: " + testDetailDTOs.size() + ", Thực tế: " + (loadedTest.getTestDetails() != null ? loadedTest.getTestDetails().size() : 0));
        }

        // Ánh xạ Test sang TestDTO
        TestDTO resultDTO = modelMapper.map(loadedTest, TestDTO.class);
        if (resultDTO == null) {
            throw new IllegalStateException("Không thể ánh xạ Test sang TestDTO");
        }

        // Ánh xạ danh sách TestDetails sang TestDetailDTO
        List<TestDetailDTO> resultTestDetails = loadedTest.getTestDetails().stream().map(testDetail -> {
            TestDetailDTO dto = new TestDetailDTO();
            dto.setTestId((int) testDetail.getTest().getId());
            dto.setChapterId(null); // chapter_id = null
            Question question = testDetail.getQuestion();
            QuestionDTO questionDTO = modelMapper.map(question, QuestionDTO.class);

            // Ánh xạ danh sách Answer
            if (question.getAnswers() != null) {
                List<AnswerDTO> answerDTOs = question.getAnswers().stream()
                        .map(answer -> modelMapper.map(answer, AnswerDTO.class))
                        .collect(Collectors.toList());
                questionDTO.setAnswers(answerDTOs);
            }

            // Gán correctAnswer
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

        return resultDTO;
    }

    @Override
    @Transactional
    public TestDTO updateTestSimulator(TestDTO testDTO) {
        // Kiểm tra TestDTO đầu vào
        if (testDTO.getId() == null) {
            throw new IllegalArgumentException("ID của Test là bắt buộc để cập nhật");
        }

        // Tìm Test hiện có
        Test existingTest = testRepository.findById(testDTO.getId())
                .orElseThrow(() -> new IllegalArgumentException("Test với ID " + testDTO.getId() + " không tồn tại"));

        // Cập nhật các trường của Test
        existingTest.setTitle(testDTO.getTitle());
        existingTest.setDescription(testDTO.getDescription());
        existingTest.setType(testDTO.getType());
        existingTest.setTime(testDTO.getTime());
        existingTest.setPassedScore(testDTO.getPassedScore());
        existingTest.setStatus(testDTO.isStatus());
        existingTest.setTest(false);
        existingTest.setNumberOfQuestions(testDTO.getNumberOfQuestions());

        // Xử lý rank
        if (testDTO.getRank() != null) {
            RankDTO rankDTO = rankService.findById(testDTO.getRank());
            if (rankDTO == null) {
                throw new IllegalArgumentException("Rank với ID " + testDTO.getRank() + " không tồn tại");
            }
            Rank rank = modelMapper.map(rankDTO, Rank.class);
            existingTest.setRank(rank);
        } else {
            existingTest.setRank(null);
        }

        // Lấy danh sách TestSimulatorDetailDTO từ testDTO
        List<TestSimulatorDetailDTO> testSimulatorDetailDTOs = testDTO.getTestSimulatorDetails();
        if (testSimulatorDetailDTOs == null || testSimulatorDetailDTOs.isEmpty()) {
            throw new IllegalArgumentException("Danh sách câu hỏi không được để trống");
        }

        // Tạo danh sách TestSimulatorDetails mới
        List<TestSimulatorDetails> updatedTestSimulatorDetails = new ArrayList<>();
        for (TestSimulatorDetailDTO detailDTO : testSimulatorDetailDTOs) {
            if (detailDTO.getSimulator() == null || detailDTO.getSimulator().getId() == null) {
                throw new IllegalArgumentException("simulatorId không được để trống trong testSimulatorDetails");
            }

            // Tìm simulator từ repository
            Simulator simulator = simulatorRepository.findById(detailDTO.getSimulator().getId())
                    .orElseThrow(() -> new IllegalArgumentException("Simulator với ID " + detailDTO.getSimulator().getId() + " không tồn tại"));

            // Tạo TestSimulatorDetails mới
            TestSimulatorDetails testSimulatorDetail = new TestSimulatorDetails();
            testSimulatorDetail.setTest(existingTest);
            testSimulatorDetail.setSimulator(simulator);
            testSimulatorDetail.setChapter(null); // chapter_id = null theo yêu cầu
            testSimulatorDetail.setStatus(true); // status = true theo yêu cầu

            updatedTestSimulatorDetails.add(testSimulatorDetail);
        }

        // Xóa danh sách TestSimulatorDetails hiện có và thay bằng danh sách mới
        existingTest.getTestSimulatorDetails().clear();
        existingTest.getTestSimulatorDetails().addAll(updatedTestSimulatorDetails);

        // Lưu Test đã cập nhật
        Test savedTest = testRepository.save(existingTest);

        // Tải lại Test để đảm bảo dữ liệu nhất quán
        Test loadedTest = testRepository.findById(savedTest.getId())
                .orElseThrow(() -> new IllegalStateException("Không thể tải lại Test sau khi lưu"));
        if (loadedTest.getTestSimulatorDetails() == null || loadedTest.getTestSimulatorDetails().size() != testSimulatorDetailDTOs.size()) {
            throw new IllegalStateException("Danh sách TestSimulatorDetails không khớp sau khi lưu. Dự kiến: " + testSimulatorDetailDTOs.size() + ", Thực tế: " + (loadedTest.getTestSimulatorDetails() != null ? loadedTest.getTestSimulatorDetails().size() : 0));
        }

        // Ánh xạ Test sang TestDTO
        TestDTO resultDTO = modelMapper.map(loadedTest, TestDTO.class);
        if (resultDTO == null) {
            throw new IllegalStateException("Không thể ánh xạ Test sang TestDTO");
        }

        // Ánh xạ danh sách TestSimulatorDetails sang TestSimulatorDetailDTO
        List<TestSimulatorDetailDTO> resultTestSimulatorDetails = loadedTest.getTestSimulatorDetails().stream().map(testSimulatorDetail -> {
            TestSimulatorDetailDTO dto = new TestSimulatorDetailDTO();
            dto.setTestId(testSimulatorDetail.getTest().getId());
            dto.setChapterSimulatorId(null); // chapter_id = null
            Simulator simulator = testSimulatorDetail.getSimulator();
            SimulatorDTO simulatorDTO = modelMapper.map(simulator, SimulatorDTO.class);
            dto.setTestTime(testSimulatorDetail.getTest().getTime());
            dto.setTestType(testSimulatorDetail.getTest().getType());
            dto.setTestPassedScore(testSimulatorDetail.getTest().getPassedScore());

            dto.setSimulator(simulatorDTO);
            dto.setStatus(testSimulatorDetail.getStatus());
            return dto;
        }).collect(Collectors.toList());

        resultDTO.setTestSimulatorDetails(resultTestSimulatorDetails);

        return resultDTO;
    }

    @Override
    @Transactional
    public TestDTO saveTest(TestDTO testDTO) {
        // Ánh xạ TestDTO sang Test entity
        Test test = new Test();
        test.setTitle(testDTO.getTitle());
        test.setDescription(testDTO.getDescription());
        test.setType(testDTO.getType());
        test.setTime(testDTO.getTime());
        test.setPassedScore(testDTO.getPassedScore());
        test.setStatus(testDTO.isStatus());
        test.setTest(true);
        test.setNumberOfQuestions(testDTO.getNumberOfQuestions());

        // Xử lý rank
        if (testDTO.getRank() != null) {
            RankDTO rankDTO = rankService.findById(testDTO.getRank());
            if (rankDTO == null) {
                throw new IllegalArgumentException("Rank với ID " + testDTO.getRank() + " không tồn tại");
            }
            Rank rank = modelMapper.map(rankDTO, Rank.class);
            test.setRank(rank);
        }

        // Lấy danh sách TestDetailDTO từ testDTO
        List<TestDetailDTO> testDetailDTOs = testDTO.getTestDetails();
        if (testDetailDTOs == null || testDetailDTOs.isEmpty()) {
            throw new IllegalArgumentException("Danh sách câu hỏi không được để trống");
        }

        // Tạo danh sách TestDetails
        List<TestDetails> testDetails = new ArrayList<>();
        for (TestDetailDTO detailDTO : testDetailDTOs) {
            if (detailDTO.getQuestion() == null || detailDTO.getQuestion().getId() == null) {
                throw new IllegalArgumentException("questionId không được để trống trong testDetails");
            }

            // Tìm câu hỏi từ repository
            Question question = questionRepository.findByIdWithAnswers(detailDTO.getQuestion().getId());
            if (question == null) {
                throw new IllegalArgumentException("Câu hỏi với ID " + detailDTO.getQuestion().getId() + " không tồn tại");
            }

            // Tạo TestDetails
            TestDetails testDetail = new TestDetails();
            testDetail.setTest(test); // Liên kết với Test (ID sẽ được gán sau khi lưu Test)
            testDetail.setQuestion(question); // Gán câu hỏi
            testDetail.setChapter(null); // chapter_id = null theo yêu cầu
            testDetail.setStatus(true); // status = true theo yêu cầu

            testDetails.add(testDetail);
        }

        // Gán danh sách TestDetails vào Test
        test.setTestDetails(testDetails);

        // Lưu Test (tự động lưu TestDetails do cascade = CascadeType.ALL)
        Test savedTest = testRepository.save(test);

        // Tải lại Test từ cơ sở dữ liệu để đảm bảo dữ liệu đầy đủ
        Test loadedTest = entityManager.find(Test.class, savedTest.getId());
        if (loadedTest.getTestDetails() == null || loadedTest.getTestDetails().isEmpty()) {
            throw new IllegalStateException("Không thể lưu testDetails vào cơ sở dữ liệu");
        }

        // Ánh xạ Test sang TestDTO để trả về
        TestDTO resultDTO = modelMapper.map(loadedTest, TestDTO.class);

        // Ánh xạ danh sách TestDetails sang TestDetailDTO
        List<TestDetailDTO> resultTestDetails = loadedTest.getTestDetails().stream().map(testDetail -> {
            TestDetailDTO dto = new TestDetailDTO();
            dto.setTestId((int) testDetail.getTest().getId());
            dto.setChapterId(null); // chapter_id = null
            Question question = testDetail.getQuestion();
            QuestionDTO questionDTO = modelMapper.map(question, QuestionDTO.class);

            // Ánh xạ danh sách Answer
            if (question.getAnswers() != null) {
                List<AnswerDTO> answerDTOs = question.getAnswers().stream()
                        .map(answer -> modelMapper.map(answer, AnswerDTO.class))
                        .collect(Collectors.toList());
                questionDTO.setAnswers(answerDTOs);
            }

            // Gán correctAnswer
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

        return resultDTO;
    }

    @Transactional
    @Override
    public TestDTO deleteTest(TestDTO testDTO) {
        // Kiểm tra nếu testDTO có id
        if (testDTO == null || testDTO.getId() == null) {
            return null; // Trả về null nếu không có id hợp lệ
        }

        // Tìm bản ghi trong cơ sở dữ liệu dựa trên id
        Test test = testRepository.findById(testDTO.getId())
                .orElse(null);

        if (test == null) {
            return null; // Trả về null nếu không tìm thấy bản ghi
        }

        // Thực hiện xóa mềm bằng cách đặt status thành false
        test.setStatus(false);

        // Lưu lại thay đổi vào cơ sở dữ liệu
        test = testRepository.save(test);

        // Chuyển đổi thực thể thành DTO để trả về
        return convertToDTO(test);
    }



    // Phương thức hỗ trợ để chuyển đổi từ Test sang TestDTO
    private TestDTO convertToDTO(Test test) {
        TestDTO testDTO = new TestDTO();
        testDTO.setId((long) test.getId()); // Chuyển int sang Long
        testDTO.setTitle(test.getTitle());
        testDTO.setDescription(test.getDescription());
        testDTO.setType(test.getType());
        testDTO.setTime(test.getTime());
        if (test.getPassedScore() != null) {
            testDTO.setPassedScore(test.getPassedScore().intValue());
        } else {
            testDTO.setPassedScore(0); // Giá trị mặc định
        }
        testDTO.setStatus(test.isStatus());
        testDTO.setTest(test.isTest());
        testDTO.setNumberOfQuestions(test.getNumberOfQuestions());

        // Xử lý rank (nếu cần ánh xạ từ Rank entity)
        if (test.getRank() != null) {
            testDTO.setRank(test.getRank().getId()); // Giả định Rank có phương thức getId()
        }

        // Xử lý testDetails (nếu cần)
        if (test.getTestDetails() != null) {
            // Cần ánh xạ TestDetails sang TestDetailDTO (giả định có phương thức ánh xạ)
            // testDTO.setTestDetails(test.getTestDetails().stream().map(this::convertTestDetailToDTO).collect(Collectors.toList()));
            // Bạn cần triển khai convertTestDetailToDTO nếu sử dụng
        }

        return testDTO;
    }
}
