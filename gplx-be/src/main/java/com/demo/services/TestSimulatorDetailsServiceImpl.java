package com.demo.services;

import com.demo.dtos.SimulatorDTO;
import com.demo.dtos.TestSimulatorDetailDTO;
import com.demo.entities.Test;
import com.demo.entities.TestSimulatorDetails;
import com.demo.repositories.TestSimulatorDetailsRepository;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class TestSimulatorDetailsServiceImpl implements TestSimulatorDetailsService {

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private TestSimulatorDetailsRepository testSimulatorDetailRepository;

    @Override
    public List<TestSimulatorDetailDTO> findByTestId(int testId) {
        List<TestSimulatorDetails> details = testSimulatorDetailRepository.findByTestId(testId);

        return details.stream().map(detail -> {
            TestSimulatorDetailDTO dto = new TestSimulatorDetailDTO();
            dto.setId(detail.getId());
            dto.setStatus(detail.getStatus());

            // Gán simulator
            if (detail.getSimulator() != null) {
                dto.setSimulator(modelMapper.map(detail.getSimulator(), SimulatorDTO.class));
            }

            // Gán thông tin từ bảng Test
            Test test = detail.getTest();
            if (test != null) {
                dto.setTestId((long) test.getId());
                dto.setTestTime(test.getTime());
                dto.setTestType(test.getType());
                dto.setTestPassedScore(test.getPassedScore());
            }

            // Gán chapterSimulatorId
            if (detail.getChapter() != null) {
                dto.setChapterSimulatorId(detail.getChapter().getId());
            }

            return dto;
        }).collect(Collectors.toList());
    }
}
