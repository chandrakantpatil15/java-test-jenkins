<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.lang.management.*" %>
<%@ page import="com.sun.management.OperatingSystemMXBean" %>
<%
    // Get system information
    OperatingSystemMXBean osBean = ManagementFactory.getPlatformMXBean(OperatingSystemMXBean.class);
    Runtime runtime = Runtime.getRuntime();
    
    double cpuUsage = osBean.getProcessCpuLoad() * 100;
    if (cpuUsage < 0) cpuUsage = 0; // Handle -1 case
    
    long totalMemory = runtime.totalMemory();
    long freeMemory = runtime.freeMemory();
    long usedMemory = totalMemory - freeMemory;
    long maxMemory = runtime.maxMemory();
    
    double memoryUsage = (double) usedMemory / maxMemory * 100;
    
    int availableProcessors = runtime.availableProcessors();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Saksham AI Assistant - System Monitor</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .dashboard {
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .header {
            text-align: center;
            color: white;
            margin-bottom: 30px;
        }
        
        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .system-monitor {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .monitor-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .monitor-icon {
            font-size: 2em;
            margin-right: 15px;
        }
        
        .monitor-title {
            font-size: 1.4em;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .metric-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            position: relative;
            overflow: hidden;
        }
        
        .metric-label {
            font-size: 0.9em;
            color: #6c757d;
            margin-bottom: 8px;
        }
        
        .metric-value {
            font-size: 2.2em;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .progress-bar {
            width: 100%;
            height: 8px;
            background: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
        }
        
        .progress-fill {
            height: 100%;
            border-radius: 4px;
            transition: width 0.3s ease;
        }
        
        .cpu-usage { color: #e74c3c; }
        .cpu-fill { background: linear-gradient(90deg, #e74c3c, #c0392b); }
        
        .memory-usage { color: #3498db; }
        .memory-fill { background: linear-gradient(90deg, #3498db, #2980b9); }
        
        .disk-usage { color: #f39c12; }
        .disk-fill { background: linear-gradient(90deg, #f39c12, #e67e22); }
        
        .network-usage { color: #27ae60; }
        .network-fill { background: linear-gradient(90deg, #27ae60, #229954); }
        
        .chat-container {
            grid-column: 1 / -1;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            height: 500px;
            display: flex;
            flex-direction: column;
        }
        
        .chat-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 15px 15px 0 0;
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
        
        .message.user { justify-content: flex-end; }
        
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
            border-radius: 0 0 15px 15px;
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
        }
        
        .send-btn {
            padding: 12px 20px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
        }
        
        .refresh-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 20px;
            padding: 8px 15px;
            cursor: pointer;
            font-size: 0.8em;
        }
        
        .status-indicator {
            display: inline-block;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 8px;
        }
        
        .status-good { background: #27ae60; }
        .status-warning { background: #f39c12; }
        .status-critical { background: #e74c3c; }
        
        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }
        
        .pulse { animation: pulse 2s infinite; }
    </style>
</head>
<body>
    <div class="dashboard">
        <div class="header">
            <h1>🤖 Saksham AI Assistant</h1>
            <p>AI-Powered System Monitor & Assistant</p>
        </div>
        
        <button class="refresh-btn" onclick="location.reload()">🔄 Refresh</button>
        
        <div class="grid">
            <!-- CPU Monitor -->
            <div class="system-monitor">
                <div class="monitor-header">
                    <div class="monitor-icon">🖥️</div>
                    <div class="monitor-title">CPU Performance</div>
                </div>
                
                <div class="metric-card">
                    <div class="metric-label">
                        <span class="status-indicator <%= cpuUsage > 80 ? "status-critical" : cpuUsage > 60 ? "status-warning" : "status-good" %>"></span>
                        CPU Usage
                    </div>
                    <div class="metric-value cpu-usage"><%= String.format("%.1f", cpuUsage) %>%</div>
                    <div class="progress-bar">
                        <div class="progress-fill cpu-fill" style="width: <%= cpuUsage %>%"></div>
                    </div>
                </div>
                
                <div class="metric-card">
                    <div class="metric-label">Available Processors</div>
                    <div class="metric-value" style="color: #667eea;"><%= availableProcessors %> Cores</div>
                </div>
            </div>
            
            <!-- Memory Monitor -->
            <div class="system-monitor">
                <div class="monitor-header">
                    <div class="monitor-icon">💾</div>
                    <div class="monitor-title">Memory Usage</div>
                </div>
                
                <div class="metric-card">
                    <div class="metric-label">
                        <span class="status-indicator <%= memoryUsage > 85 ? "status-critical" : memoryUsage > 70 ? "status-warning" : "status-good" %>"></span>
                        Memory Usage
                    </div>
                    <div class="metric-value memory-usage"><%= String.format("%.1f", memoryUsage) %>%</div>
                    <div class="progress-bar">
                        <div class="progress-fill memory-fill" style="width: <%= memoryUsage %>%"></div>
                    </div>
                </div>
                
                <div class="metric-card">
                    <div class="metric-label">Memory Details</div>
                    <div style="font-size: 0.9em; color: #6c757d;">
                        Used: <%= String.format("%.1f", usedMemory / (1024.0 * 1024.0)) %> MB<br>
                        Max: <%= String.format("%.1f", maxMemory / (1024.0 * 1024.0)) %> MB
                    </div>
                </div>
            </div>
        </div>
        
        <!-- AI Chat Interface -->
        <div class="chat-container">
            <div class="chat-header">
                <h2>💬 Chat with Saksham AI</h2>
                <p>Ask about system performance, get help, or just chat!</p>
            </div>
            
            <div class="chat-messages" id="chatMessages">
                <div class="message ai">
                    <div class="message-avatar">🤖</div>
                    <div class="message-content">
                        Hello! I'm monitoring your system performance. Current CPU usage is <%= String.format("%.1f", cpuUsage) %>% and memory usage is <%= String.format("%.1f", memoryUsage) %>%. How can I help you today?
                    </div>
                </div>
            </div>
            
            <div class="chat-input">
                <div class="input-container">
                    <input type="text" id="messageInput" placeholder="Ask about system performance or anything else..." onkeypress="handleKeyPress(event)">
                    <button class="send-btn" onclick="sendMessage()">Send</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const chatMessages = document.getElementById('chatMessages');
        const messageInput = document.getElementById('messageInput');
        
        // System-aware AI responses
        const systemResponses = {
            'cpu': 'Current CPU usage is <%= String.format("%.1f", cpuUsage) %>%. <%= cpuUsage > 80 ? "⚠️ High CPU usage detected! Consider closing unnecessary applications." : cpuUsage > 60 ? "⚡ Moderate CPU usage. System is working well." : "✅ CPU usage is optimal!" %>',
            'memory': 'Memory usage is <%= String.format("%.1f", memoryUsage) %>%. <%= memoryUsage > 85 ? "🔴 High memory usage! Consider restarting some applications." : memoryUsage > 70 ? "🟡 Moderate memory usage." : "🟢 Memory usage is healthy!" %>',
            'performance': 'System Performance Report:\n• CPU: <%= String.format("%.1f", cpuUsage) %>% (<%= availableProcessors %> cores)\n• Memory: <%= String.format("%.1f", memoryUsage) %>%\n• Status: <%= (cpuUsage < 60 && memoryUsage < 70) ? "🟢 Excellent" : (cpuUsage < 80 && memoryUsage < 85) ? "🟡 Good" : "🔴 Needs Attention" %>',
            'help': 'I can help you with:\n• 📊 System monitoring and performance\n• 💻 CPU and memory optimization\n• 🔧 Troubleshooting performance issues\n• 📈 Understanding system metrics\n• 🤖 General AI assistance\n\nWhat would you like to know?'
        };
        
        function sendMessage() {
            const message = messageInput.value.trim();
            if (message === '') return;
            
            addMessage(message, 'user');
            messageInput.value = '';
            
            setTimeout(() => {
                const response = getSystemAwareResponse(message);
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
            messageContent.innerHTML = content.replace(/\n/g, '<br>');
            
            if (sender === 'ai') {
                messageDiv.appendChild(avatar);
                messageDiv.appendChild(messageContent);
            } else {
                messageDiv.appendChild(messageContent);
                messageDiv.appendChild(avatar);
            }
            
            chatMessages.appendChild(messageDiv);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
        
        function getSystemAwareResponse(message) {
            const lowerMessage = message.toLowerCase();
            
            for (const key in systemResponses) {
                if (lowerMessage.includes(key)) {
                    return systemResponses[key];
                }
            }
            
            const defaultResponses = [
                "I'm here to help! Try asking about 'cpu', 'memory', or 'performance' to get system insights.",
                "That's interesting! I can also provide real-time system monitoring. What would you like to know?",
                "Great question! I'm monitoring your system performance in real-time. Need any system insights?"
            ];
            
            return defaultResponses[Math.floor(Math.random() * defaultResponses.length)];
        }
        
        function handleKeyPress(event) {
            if (event.key === 'Enter') {
                sendMessage();
            }
        }
        
        // Auto-refresh every 30 seconds
        setInterval(() => {
            const refreshBtn = document.querySelector('.refresh-btn');
            refreshBtn.classList.add('pulse');
            setTimeout(() => refreshBtn.classList.remove('pulse'), 2000);
        }, 30000);
        
        window.onload = function() {
            messageInput.focus();
        };
    </script>
</body>
</html>