<template>
  <div class="app-container">
    <el-card class="chat-card">
      <template #header>
        <div class="card-header">
          <span>チャットボット</span>
        </div>
      </template>
      <ChatBot />
    </el-card>
  </div>
</template>

<script setup lang="ts">
import ChatBot from './components/ChatBot.vue'
</script>

<style>
body {
  margin: 0;
  padding: 0;
  background-color: #f5f5f5;
}

.app-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  padding: 20px;
  box-sizing: border-box;
}

.chat-card {
  width: 100%;
  max-width: 600px;
}

.card-header {
  font-size: 18px;
  font-weight: bold;
}
</style>
