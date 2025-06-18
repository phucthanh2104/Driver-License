package com.demo.helpers;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpRequest.BodyPublishers;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class OllamaClient {
    private static final String OLLAMA_API_URL = "http://localhost:11434/api/generate";

    public static String callMistralModel(String prompt) throws Exception {
        HttpClient client = HttpClient.newHttpClient();

        String jsonPayload = "{"
                + "\"model\": \"mistral\","
                + "\"prompt\": \"" + escapeJson(prompt) + "\","
                + "\"stream\": true"
                + "}";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(OLLAMA_API_URL))
                .header("Content-Type", "application/json")
                .POST(BodyPublishers.ofString(jsonPayload))
                .build();

        HttpResponse<java.io.InputStream> response = client.send(request, HttpResponse.BodyHandlers.ofInputStream());

        BufferedReader reader = new BufferedReader(new InputStreamReader(response.body()));

        String line;
        StringBuilder fullResponse = new StringBuilder();

        while ((line = reader.readLine()) != null) {
            if (line.trim().isEmpty()) continue;

            JsonObject json = JsonParser.parseString(line).getAsJsonObject();

            if (json.has("response")) {
                fullResponse.append(json.get("response").getAsString());
            }

            if (json.has("done") && json.get("done").getAsBoolean()) {
                break;
            }
        }

        return fullResponse.toString();
    }

    private static String escapeJson(String str) {
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    public static void main(String[] args) {
        try {
            System.out.println("aaa");
            String prompt = "Bạn là trợ lý pháp luật giao thông Việt Nam. Hãy trả lời chi tiết và cụ thể câu hỏi sau: Tốc độ tối đa cho phép khi đi xe máy trong khu dân cư là bao nhiêu km/h?";
            String response = callMistralModel(prompt);
            System.out.println("Full Response from Mistral model:\n" + response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
