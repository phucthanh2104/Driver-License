package com.demo.controllers;

import com.demo.helpers.OllamaClient;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/chatbot/")
public class ChatBotController {

    @PostMapping("ask")
    public String askChatBot(@RequestBody String prompt) {
        try {
            return OllamaClient.callMistralModel(prompt);
        } catch (Exception e) {
            e.printStackTrace();
            return "Đã xảy ra lỗi: " + e.getMessage();
        }
    }
}
