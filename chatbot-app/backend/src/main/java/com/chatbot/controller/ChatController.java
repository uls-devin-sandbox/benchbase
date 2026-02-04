package com.chatbot.controller;

import com.chatbot.entity.ChatMessage;
import com.chatbot.service.ChatService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;
import java.util.Map;

/**
 * チャットコントローラークラス
 */
@RestController
@RequestMapping("/api/chat")
@CrossOrigin(origins = "*")
public class ChatController {

    private final ChatService chatService;

    public ChatController(ChatService chatService) {
        this.chatService = chatService;
    }

    /**
     * チャットメッセージを送信する
     */
    @PostMapping
    public ResponseEntity<ChatMessage> sendMessage(@RequestBody Map<String, String> request) {
        String message = request.get("message");
        if (message == null || message.trim().isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        ChatMessage chatMessage = chatService.processMessage(message.trim());
        return ResponseEntity.ok(chatMessage);
    }

    /**
     * チャット履歴を取得する
     */
    @GetMapping("/history")
    public ResponseEntity<List<ChatMessage>> getHistory() {
        List<ChatMessage> history = chatService.getHistory();
        return ResponseEntity.ok(history);
    }
}
