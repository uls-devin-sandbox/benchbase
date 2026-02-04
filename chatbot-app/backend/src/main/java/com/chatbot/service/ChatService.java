package com.chatbot.service;

import com.chatbot.entity.ChatMessage;
import com.chatbot.repository.ChatMessageRepository;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * チャットサービスクラス
 */
@Service
public class ChatService {

    private final ChatMessageRepository chatMessageRepository;

    public ChatService(ChatMessageRepository chatMessageRepository) {
        this.chatMessageRepository = chatMessageRepository;
    }

    /**
     * ユーザーの入力に対してボットの返信を生成し、DBに保存する
     */
    public ChatMessage processMessage(String userInput) {
        String botResponse = "Hello, " + userInput;
        ChatMessage chatMessage = new ChatMessage(userInput, botResponse);
        return chatMessageRepository.save(chatMessage);
    }

    /**
     * チャット履歴を取得する
     */
    public List<ChatMessage> getHistory() {
        return chatMessageRepository.findAllByOrderByCreatedAtAsc();
    }
}
