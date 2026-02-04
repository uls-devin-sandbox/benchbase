package com.chatbot.repository;

import com.chatbot.entity.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * チャットメッセージのリポジトリインターフェース
 */
@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {

    /**
     * 作成日時の降順でメッセージを取得
     */
    List<ChatMessage> findAllByOrderByCreatedAtAsc();
}
