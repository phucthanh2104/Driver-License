package com.demo.controllers;

import com.demo.dtos.QuestionDTO;
import com.demo.entities.Question;
import com.demo.services.QuestionService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MimeTypeUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("api/question")
public class QuestionController {
    @Autowired
    private QuestionService questionService;
    @Autowired
    private ObjectMapper objectMapper;

    @GetMapping(value = "findAll", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<QuestionDTO>> findAll() {
        try {
            return new ResponseEntity<List<QuestionDTO>>(questionService.findAll(), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<List<QuestionDTO>>(HttpStatus.BAD_REQUEST);
        }
    }
    @GetMapping(value = "findById/{id}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<QuestionDTO> findById(@PathVariable int id) {
        try {
            return new ResponseEntity<QuestionDTO>(questionService.findById(id), HttpStatus.OK);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<QuestionDTO>(HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("findAllFailed")
    public ResponseEntity<List<QuestionDTO>> findAllFailed() {
        try{
            return new ResponseEntity<List<QuestionDTO>>(questionService.findFailedQuestion(),HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("findAllFailedOfRankA")
    public ResponseEntity<List<QuestionDTO>> findAllFailedOfRankA() {
        try{
            return new ResponseEntity<List<QuestionDTO>>(questionService.findFailedQuestionByRank(),HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping(value = "addQuestion", consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Object> addQuestion(
            @RequestPart("question") String questionDTOJson,
            @RequestPart(value = "image", required = false) MultipartFile image) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Chuyển đổi JSON string thành QuestionDTO
            QuestionDTO questionDTO = objectMapper.readValue(questionDTOJson, QuestionDTO.class);

            // Xử lý ảnh nếu có
            if (image != null && !image.isEmpty()) {
                // Định nghĩa hai thư mục lưu ảnh
                String resourceDir = new File("src/main/resources/static/assets/images/").getAbsolutePath(); // Thư mục resources
                String targetDir = new File("target/classes/static/assets/images/").getAbsolutePath(); // Thư mục target

                // Tạo thư mục resources nếu chưa tồn tại
                File resourceDirFile = new File(resourceDir);
                if (!resourceDirFile.exists()) {
                    resourceDirFile.mkdirs();
                    System.out.println("Tạo thư mục resources: " + resourceDir);
                }

                // Tạo thư mục target nếu chưa tồn tại
                File targetDirFile = new File(targetDir);
                if (!targetDirFile.exists()) {
                    targetDirFile.mkdirs();
                    System.out.println("Tạo thư mục target: " + targetDir);
                }

                // Lấy tên file gốc
                String fileName = System.currentTimeMillis() + "_" + image.getOriginalFilename();

                // Lưu file vào thư mục resources
                Path resourceFilePath = Paths.get(resourceDir, fileName);
                Files.write(resourceFilePath, image.getBytes());
                System.out.println("Lưu ảnh thành công vào resources tại: " + resourceFilePath.toString());

                // Lưu file vào thư mục target
                Path targetFilePath = Paths.get(targetDir, fileName);
                Files.write(targetFilePath, image.getBytes());
                System.out.println("Lưu ảnh thành công vào target tại: " + targetFilePath.toString());

                // Gán tên file vào QuestionDTO
                questionDTO.setImage(fileName);
            } else {
                questionDTO.setImage(null);
            }

            // Gọi service để lưu câu hỏi
            QuestionDTO savedQuestionDTO = questionService.addQuestion(questionDTO);
            response.put("status", "success");
            response.put("question", savedQuestionDTO);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (IllegalArgumentException e) {
            response.put("status", "error");
            response.put("question", null);
            response.put("message", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("question", null);
            response.put("message", "Có lỗi xảy ra khi thêm câu hỏi: " + e.getMessage());
            System.out.println("Lỗi khi lưu câu hỏi: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


    @PostMapping(value = "deleteQuestion/{id}", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Object> deleteQuestion(@PathVariable("id") int id) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Gọi service để "xóa" câu hỏi (cập nhật status = false)
            QuestionDTO updatedQuestionDTO = questionService.deleteQuestion(id);

            response.put("status", "success");
            response.put("message", "Câu hỏi đã được đánh dấu không khả dụng.");
            response.put("question", updatedQuestionDTO);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (IllegalArgumentException e) {
            response.put("status", "error");
            response.put("message", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Có lỗi xảy ra khi cập nhật trạng thái câu hỏi: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping(value = "updateQuestion/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<Object> updateQuestion(
            @PathVariable("id") int id,
            @RequestPart("question") String questionDTOJson,
            @RequestPart(value = "image", required = false) MultipartFile image) {
        Map<String, Object> response = new HashMap<>();
        try {
            // Chuyển đổi JSON string thành QuestionDTO
            QuestionDTO questionDTO = objectMapper.readValue(questionDTOJson, QuestionDTO.class);

            // Đảm bảo ID từ DTO khớp với ID trong URL
            if (questionDTO.getId() != null && questionDTO.getId() != id) {
                throw new IllegalArgumentException("ID trong URL không khớp với ID trong DTO");
            }
            questionDTO.setId(id);

            // Tìm câu hỏi hiện có để kiểm tra tồn tại
            QuestionDTO existingQuestion = questionService.findById(id);
            if (existingQuestion == null) {
                throw new IllegalArgumentException("Không tìm thấy câu hỏi với ID: " + id);
            }

            // Xử lý ảnh nếu có
            if (image != null && !image.isEmpty()) {
                // Định nghĩa hai thư mục lưu ảnh
                String resourceDir = new File("src/main/resources/static/assets/images/").getAbsolutePath();
                String targetDir = new File("target/classes/static/assets/images/").getAbsolutePath();

                // Tạo thư mục resources nếu chưa tồn tại
                File resourceDirFile = new File(resourceDir);
                if (!resourceDirFile.exists()) {
                    resourceDirFile.mkdirs();
                    System.out.println("Tạo thư mục resources: " + resourceDir);
                }

                // Tạo thư mục target nếu chưa tồn tại
                File targetDirFile = new File(targetDir);
                if (!targetDirFile.exists()) {
                    targetDirFile.mkdirs();
                    System.out.println("Tạo thư mục target: " + targetDir);
                }

                // Lấy tên file gốc
                String fileName = System.currentTimeMillis() + "_" + image.getOriginalFilename();

                // Lưu file vào thư mục resources
                Path resourceFilePath = Paths.get(resourceDir, fileName);
                Files.write(resourceFilePath, image.getBytes());
                System.out.println("Lưu ảnh thành công vào resources tại: " + resourceFilePath.toString());

                // Lưu file vào thư mục target
                Path targetFilePath = Paths.get(targetDir, fileName);
                Files.write(targetFilePath, image.getBytes());
                System.out.println("Lưu ảnh thành công vào target tại: " + targetFilePath.toString());

                // Gán tên file mới vào QuestionDTO
                questionDTO.setImage(fileName);
            } else {
                // Nếu không có hình ảnh mới, giữ nguyên hình ảnh cũ
                questionDTO.setImage(existingQuestion.getImage());
            }

            // Gọi service để cập nhật câu hỏi
            QuestionDTO updatedQuestionDTO = questionService.updateQuestion(questionDTO);
            response.put("status", "success");
            response.put("question", updatedQuestionDTO);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (IllegalArgumentException e) {
            response.put("status", "error");
            response.put("question", null);
            response.put("message", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("question", null);
            response.put("message", "Có lỗi xảy ra khi cập nhật câu hỏi: " + e.getMessage());
            System.out.println("Lỗi khi cập nhật câu hỏi: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
