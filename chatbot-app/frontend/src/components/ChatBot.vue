<template>
  <div class="chatbot-container">
    <div class="message-area" ref="messageArea">
      <div v-for="message in messages" :key="message.id" class="message-wrapper">
        <div class="user-message">
          <el-tag type="info">あなた</el-tag>
          <span class="message-text">{{ message.userInput }}</span>
        </div>
        <div class="bot-message">
          <el-tag type="success">ボット</el-tag>
          <span class="message-text">{{ message.botResponse }}</span>
        </div>
      </div>
      <div v-if="messages.length === 0" class="empty-message">
        名前を入力してください
      </div>
    </div>
    <div class="input-area">
      <el-input
        v-model="inputMessage"
        placeholder="名前を入力してください"
        @keyup.enter="sendMessage"
        :disabled="loading"
      />
      <el-button
        type="primary"
        @click="sendMessage"
        :loading="loading"
        style="background-color: #000000; border-color: #000000; color: #ffffff;"
      >
        送信
      </el-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue'
import axios from 'axios'

interface ChatMessage {
  id: number
  userInput: string
  botResponse: string
  createdAt: string
}

const messages = ref<ChatMessage[]>([])
const inputMessage = ref('')
const loading = ref(false)
const messageArea = ref<HTMLElement | null>(null)

const scrollToBottom = () => {
  nextTick(() => {
    if (messageArea.value) {
      messageArea.value.scrollTop = messageArea.value.scrollHeight
    }
  })
}

const sendMessage = async () => {
  if (!inputMessage.value.trim() || loading.value) {
    return
  }

  loading.value = true
  try {
    const response = await axios.post<ChatMessage>('/api/chat', {
      message: inputMessage.value.trim()
    })
    messages.value.push(response.data)
    inputMessage.value = ''
    scrollToBottom()
  } catch (error) {
    console.error('メッセージの送信に失敗しました:', error)
  } finally {
    loading.value = false
  }
}

const loadHistory = async () => {
  try {
    const response = await axios.get<ChatMessage[]>('/api/chat/history')
    messages.value = response.data
    scrollToBottom()
  } catch (error) {
    console.error('履歴の取得に失敗しました:', error)
  }
}

onMounted(() => {
  loadHistory()
})
</script>

<style scoped>
.chatbot-container {
  display: flex;
  flex-direction: column;
  height: 500px;
}

.message-area {
  flex: 1;
  overflow-y: auto;
  padding: 10px;
  border: 1px solid #e4e7ed;
  border-radius: 4px;
  margin-bottom: 10px;
  background-color: #fafafa;
}

.message-wrapper {
  margin-bottom: 15px;
}

.user-message,
.bot-message {
  display: flex;
  align-items: center;
  margin-bottom: 5px;
}

.message-text {
  margin-left: 10px;
}

.empty-message {
  text-align: center;
  color: #909399;
  padding: 20px;
}

.input-area {
  display: flex;
  gap: 10px;
}

.input-area .el-input {
  flex: 1;
}
</style>
