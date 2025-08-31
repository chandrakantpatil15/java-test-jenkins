<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Saksham AI Assistant</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .chat-container {
            width: 90%;
            max-width: 800px;
            height: 600px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        
        .chat-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            text-align: center;
        }
        
        .chat-header h1 {
            font-size: 1.8em;
            margin-bottom: 5px;
        }
        
        .chat-header p {
            opacity: 0.9;
            font-size: 0.9em;
        }
        
        .chat-messages {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background: #f8f9fa;
        }
        
        .message {
            margin-bottom: 15px;
            display: flex;
            align-items: flex-start;
        }
        
        .message.user {
            justify-content: flex-end;
        }
        
        .message-content {
            max-width: 70%;
            padding: 12px 18px;
            border-radius: 18px;
            font-size: 0.95em;
            line-height: 1.4;
        }
        
        .message.ai .message-content {
            background: #e3f2fd;
            color: #1565c0;
            border-bottom-left-radius: 5px;
        }
        
        .message.user .message-content {
            background: #667eea;
            color: white;
            border-bottom-right-radius: 5px;
        }
        
        .message-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2em;
            margin: 0 10px;
        }
        
        .message.ai .message-avatar {
            background: #2196f3;
            color: white;
        }
        
        .message.user .message-avatar {
            background: #667eea;
            color: white;
        }
        
        .chat-input {
            padding: 20px;
            background: white;
            border-top: 1px solid #e0e0e0;
        }
        
        .input-container {
            display: flex;
            gap: 10px;
        }
        
        .chat-input input {
            flex: 1;
            padding: 12px 18px;
            border: 2px solid #e0e0e0;
            border-radius: 25px;
            font-size: 0.95em;
            outline: none;
            transition: border-color 0.3s ease;
        }
        
        .chat-input input:focus {
            border-color: #667eea;
        }
        
        .send-btn {
            padding: 12px 20px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 0.95em;
            transition: background 0.3s ease;
        }
        
        .send-btn:hover {
            background: #5a6fd8;
        }
        
        .typing-indicator {
            display: none;
            padding: 10px 18px;
            background: #e3f2fd;
            border-radius: 18px;
            border-bottom-left-radius: 5px;
            color: #1565c0;
            font-style: italic;
        }
        
        .quick-actions {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }
        
        .quick-btn {
            padding: 8px 15px;
            background: #f0f0f0;
            border: 1px solid #ddd;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.85em;
            transition: all 0.3s ease;
        }
        
        .quick-btn:hover {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
    </style>
</head>
<body>
    <div class="chat-container">
        <div class="chat-header">
            <h1>🤖 Saksham AI Assistant</h1>
            <p>Your intelligent companion for learning and problem-solving</p>
        </div>
        
        <div class="chat-messages" id="chatMessages">
            <div class="message ai">
                <div class="message-avatar">🤖</div>
                <div class="message-content">
                    Hello! I'm Saksham, your AI assistant. I'm here to help you with questions, learning, and problem-solving. How can I assist you today?
                </div>
            </div>
            
            <div class="quick-actions">
                <div class="quick-btn" onclick="sendQuickMessage('What can you help me with?')">What can you do?</div>
                <div class="quick-btn" onclick="sendQuickMessage('Tell me about AI')">About AI</div>
                <div class="quick-btn" onclick="sendQuickMessage('Help with coding')">Coding Help</div>
                <div class="quick-btn" onclick="sendQuickMessage('Explain DevOps')">DevOps</div>
            </div>
            
            <div class="typing-indicator" id="typingIndicator">
                Saksham is thinking...
            </div>
        </div>
        
        <div class="chat-input">
            <div class="input-container">
                <input type="text" id="messageInput" placeholder="Type your message here..." onkeypress="handleKeyPress(event)">
                <button class="send-btn" onclick="sendMessage()">Send</button>
            </div>
        </div>
    </div>

    <script>
        const chatMessages = document.getElementById('chatMessages');
        const messageInput = document.getElementById('messageInput');
        const typingIndicator = document.getElementById('typingIndicator');
        
        // Simple AI responses
        const aiResponses = {
            'what can you help me with?': 'I can help you with:\n• Programming and coding questions\n• DevOps and CI/CD concepts\n• Learning new technologies\n• Problem-solving and debugging\n• General knowledge questions\n\nJust ask me anything!',
            'tell me about ai': 'Artificial Intelligence (AI) is the simulation of human intelligence in machines. It includes:\n• Machine Learning\n• Natural Language Processing\n• Computer Vision\n• Robotics\n\nAI is transforming industries and making our lives easier!',
            'help with coding': 'I can help you with:\n• Java, JavaScript, Python, and more\n• Debugging code issues\n• Best practices and design patterns\n• Code reviews and optimization\n• Learning new frameworks\n\nWhat programming challenge are you facing?',
            'explain devops': 'DevOps combines Development and Operations:\n• Continuous Integration (CI)\n• Continuous Deployment (CD)\n• Infrastructure as Code\n• Monitoring and Logging\n• Collaboration between teams\n\nIt helps deliver software faster and more reliably!',
            'hello': 'Hello! Great to meet you! How can I help you today?',
            'hi': 'Hi there! I\'m excited to help you. What would you like to know?',
            'thanks': 'You\'re welcome! I\'m always here to help. Is there anything else you\'d like to know?'
        };
        
        function sendMessage() {
            const message = messageInput.value.trim();
            if (message === '') return;
            
            addMessage(message, 'user');
            messageInput.value = '';
            
            // Show typing indicator
            showTyping();
            
            // Simulate AI response delay
            setTimeout(() => {
                hideTyping();
                const response = getAIResponse(message);
                addMessage(response, 'ai');
            }, 1500);
        }
        
        function sendQuickMessage(message) {
            addMessage(message, 'user');
            showTyping();
            
            setTimeout(() => {
                hideTyping();
                const response = getAIResponse(message);
                addMessage(response, 'ai');
            }, 1000);
        }
        
        function addMessage(content, sender) {
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${sender}`;
            
            const avatar = document.createElement('div');
            avatar.className = 'message-avatar';
            avatar.textContent = sender === 'ai' ? '🤖' : '👤';
            
            const messageContent = document.createElement('div');
            messageContent.className = 'message-content';
            messageContent.textContent = content;
            
            if (sender === 'ai') {
                messageDiv.appendChild(avatar);
                messageDiv.appendChild(messageContent);
            } else {
                messageDiv.appendChild(messageContent);
                messageDiv.appendChild(avatar);
            }
            
            chatMessages.insertBefore(messageDiv, typingIndicator);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
        
        function getAIResponse(message) {
            const lowerMessage = message.toLowerCase();
            
            // Check for exact matches first
            if (aiResponses[lowerMessage]) {
                return aiResponses[lowerMessage];
            }
            
            // Check for partial matches
            for (const key in aiResponses) {
                if (lowerMessage.includes(key.split(' ')[0])) {
                    return aiResponses[key];
                }
            }
            
            // Default responses
            const defaultResponses = [
                "That's an interesting question! While I'm still learning, I'd be happy to help you explore this topic further.",
                "I understand you're asking about that. Let me think... Could you provide a bit more context?",
                "Great question! I'm continuously learning and improving. Is there a specific aspect you'd like me to focus on?",
                "I appreciate your question! While I may not have all the answers, I'm here to help you think through problems.",
                "That's a thoughtful inquiry! Could you tell me more about what you're trying to achieve?"
            ];
            
            return defaultResponses[Math.floor(Math.random() * defaultResponses.length)];
        }
        
        function showTyping() {
            typingIndicator.style.display = 'block';
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
        
        function hideTyping() {
            typingIndicator.style.display = 'none';
        }
        
        function handleKeyPress(event) {
            if (event.key === 'Enter') {
                sendMessage();
            }
        }
        
        // Focus on input when page loads
        window.onload = function() {
            messageInput.focus();
        };
    </script>
</body>
</html>