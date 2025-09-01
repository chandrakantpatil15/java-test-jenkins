<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.lang.management.*" %>
<%@ page import="com.sun.management.OperatingSystemMXBean" %>
<%@ page import="java.io.File" %>
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
    
    // Get disk usage
    File root = new File("/");
    long totalDiskSpace = root.getTotalSpace();
    long freeDiskSpace = root.getFreeSpace();
    long usedDiskSpace = totalDiskSpace - freeDiskSpace;
    double diskUsage = (double) usedDiskSpace / totalDiskSpace * 100;
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
        
        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 20px;">
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
            
            <!-- Disk Monitor -->
            <div class="system-monitor">
                <div class="monitor-header">
                    <div class="monitor-icon">💽</div>
                    <div class="monitor-title">Disk Usage</div>
                </div>
                
                <div class="metric-card">
                    <div class="metric-label">
                        <span class="status-indicator <%= diskUsage > 90 ? "status-critical" : diskUsage > 75 ? "status-warning" : "status-good" %>"></span>
                        Disk Usage
                    </div>
                    <div class="metric-value disk-usage"><%= String.format("%.1f", diskUsage) %>%</div>
                    <div class="progress-bar">
                        <div class="progress-fill disk-fill" style="width: <%= diskUsage %>%"></div>
                    </div>
                </div>
                
                <div class="metric-card">
                    <div class="metric-label">Disk Details</div>
                    <div style="font-size: 0.9em; color: #6c757d;">
                        Used: <%= String.format("%.1f", usedDiskSpace / (1024.0 * 1024.0 * 1024.0)) %> GB<br>
                        Total: <%= String.format("%.1f", totalDiskSpace / (1024.0 * 1024.0 * 1024.0)) %> GB
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
                        Hello! I'm monitoring your system performance. Current status:<br>
                        • CPU: <%= String.format("%.1f", cpuUsage) %>%<br>
                        • Memory: <%= String.format("%.1f", memoryUsage) %>%<br>
                        • Disk: <%= String.format("%.1f", diskUsage) %>%<br><br>
                        How can I help you today?
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
        
        // Get system data from server
        const systemData = {
            cpu: <%= String.format("%.1f", cpuUsage) %>,
            memory: <%= String.format("%.1f", memoryUsage) %>,
            disk: <%= String.format("%.1f", diskUsage) %>,
            cores: <%= availableProcessors %>,
            usedDiskGB: <%= String.format("%.1f", usedDiskSpace / (1024.0 * 1024.0 * 1024.0)) %>,
            totalDiskGB: <%= String.format("%.1f", totalDiskSpace / (1024.0 * 1024.0 * 1024.0)) %>
        };
        
        // Dynamic AI responses using live data
        function getSystemResponse(type) {
            switch(type) {
                case 'cpu':
                    const cpuStatus = systemData.cpu > 80 ? '⚠️ High CPU usage detected! Consider closing unnecessary applications.' : 
                                     systemData.cpu > 60 ? '⚡ Moderate CPU usage. System is working well.' : 
                                     '✅ CPU usage is optimal!';
                    return `Current CPU usage is ${systemData.cpu}%. ${cpuStatus}`;
                    
                case 'memory':
                    const memStatus = systemData.memory > 85 ? '🔴 High memory usage! Consider restarting some applications.' : 
                                     systemData.memory > 70 ? '🟡 Moderate memory usage.' : 
                                     '🟢 Memory usage is healthy!';
                    return `Memory usage is ${systemData.memory}%. ${memStatus}`;
                    
                case 'disk':
                case 'storage':
                    const diskStatus = systemData.disk > 90 ? '🔴 Critical! Disk almost full. Clean up files immediately.' : 
                                      systemData.disk > 75 ? '🟡 Warning: Disk getting full. Consider cleanup.' : 
                                      '🟢 Disk usage is healthy!';
                    return `Disk usage is ${systemData.disk}%. ${diskStatus}\nUsed: ${systemData.usedDiskGB} GB / ${systemData.totalDiskGB} GB`;
                    
                case 'performance':
                    const overallStatus = (systemData.cpu < 60 && systemData.memory < 70 && systemData.disk < 75) ? '🟢 Excellent' : 
                                         (systemData.cpu < 80 && systemData.memory < 85 && systemData.disk < 90) ? '🟡 Good' : 
                                         '🔴 Needs Attention';
                    return `System Performance Report:\n• CPU: ${systemData.cpu}% (${systemData.cores} cores)\n• Memory: ${systemData.memory}%\n• Disk: ${systemData.disk}%\n• Status: ${overallStatus}`;
                    
                case 'help':
                    return `I can help you with:\n• 📊 System monitoring (CPU, Memory, Disk)\n• 💻 Performance optimization\n• 🔧 Troubleshooting issues\n• 📈 Understanding metrics\n• 🤖 General AI assistance\n\nTry asking: "cpu", "memory", "disk", or "performance"`;
                    
                default:
                    return null;
            }
        }
        
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
            
            // Check for system keywords
            if (lowerMessage.includes('cpu')) {
                return getSystemResponse('cpu');
            }
            if (lowerMessage.includes('memory') || lowerMessage.includes('ram')) {
                return getSystemResponse('memory');
            }
            if (lowerMessage.includes('disk') || lowerMessage.includes('storage') || lowerMessage.includes('space')) {
                return getSystemResponse('disk');
            }
            if (lowerMessage.includes('performance') || lowerMessage.includes('status') || lowerMessage.includes('report')) {
                return getSystemResponse('performance');
            }
            if (lowerMessage.includes('help') || lowerMessage.includes('what can you')) {
                return getSystemResponse('help');
            }
            
            // Greetings
            if (lowerMessage.includes('hello') || lowerMessage.includes('hi')) {
                return `Hello! I'm monitoring your system in real-time. Current status: CPU ${systemData.cpu}%, Memory ${systemData.memory}%, Disk ${systemData.disk}%. How can I help?`;
            }
            
            // Default responses
            const defaultResponses = [
                "I'm here to help! Try asking about 'cpu', 'memory', 'disk', or 'performance' to get system insights.",
                "That's interesting! I can provide real-time monitoring. Ask about CPU, memory, or disk usage!",
                "Great question! I'm monitoring your system in real-time. Try 'performance' for a full report!"
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