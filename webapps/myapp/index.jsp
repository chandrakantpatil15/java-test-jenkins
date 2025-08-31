<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DevOps Dashboard - CI/CD Pipeline</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }
        
        .header {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            padding: 20px 0;
            text-align: center;
            color: white;
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
        }
        
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }
        
        .card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        .card-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .card-icon {
            font-size: 2.5em;
            margin-right: 15px;
        }
        
        .card-title {
            font-size: 1.5em;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .status-badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 600;
            margin: 10px 5px;
        }
        
        .success { background: #d4edda; color: #155724; }
        .info { background: #d1ecf1; color: #0c5460; }
        .warning { background: #fff3cd; color: #856404; }
        
        .metrics {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-top: 20px;
        }
        
        .metric {
            text-align: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        
        .metric-value {
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
        }
        
        .metric-label {
            font-size: 0.9em;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .tech-stack {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
        }
        
        .tech-item {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            padding: 8px 15px;
            border-radius: 25px;
            font-size: 0.9em;
            font-weight: 500;
        }
        
        .footer {
            text-align: center;
            margin-top: 50px;
            color: white;
            opacity: 0.8;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .pulse { animation: pulse 2s infinite; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🚀 DevOps CI/CD Dashboard</h1>
        <p>Automated Build & Deployment Pipeline</p>
    </div>

    <div class="container">
        <div class="dashboard">
            <!-- Application Status Card -->
            <div class="card">
                <div class="card-header">
                    <div class="card-icon">📊</div>
                    <div class="card-title">Application Status</div>
                </div>
                <div class="status-badge success pulse">🟢 RUNNING</div>
                <div class="status-badge info">📦 v1.0.0</div>
                <div class="status-badge warning">⚡ Auto-Deploy</div>
                
                <div class="metrics">
                    <div class="metric">
                        <div class="metric-value"><%=java.time.LocalTime.now().getHour()%></div>
                        <div class="metric-label">Current Hour</div>
                    </div>
                    <div class="metric">
                        <div class="metric-value">100%</div>
                        <div class="metric-label">Uptime</div>
                    </div>
                </div>
            </div>

            <!-- Build Information Card -->
            <div class="card">
                <div class="card-header">
                    <div class="card-icon">🔧</div>
                    <div class="card-title">Build Information</div>
                </div>
                <p><strong>Last Build:</strong> <%= new java.util.Date() %></p>
                <p><strong>Build Tool:</strong> Apache Maven</p>
                <p><strong>Java Version:</strong> <%= System.getProperty("java.version") %></p>
                <p><strong>Server:</strong> Apache Tomcat</p>
                
                <div class="tech-stack">
                    <div class="tech-item">☕ Java</div>
                    <div class="tech-item">🐳 Docker</div>
                    <div class="tech-item">⚙️ Jenkins</div>
                    <div class="tech-item">🐱 Git</div>
                </div>
            </div>

            <!-- Pipeline Status Card -->
            <div class="card">
                <div class="card-header">
                    <div class="card-icon">🔄</div>
                    <div class="card-title">CI/CD Pipeline</div>
                </div>
                <div style="margin: 20px 0;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin: 10px 0;">
                        <span>✅ Source Code Checkout</span>
                        <span style="color: #28a745;">SUCCESS</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin: 10px 0;">
                        <span>✅ Maven Build</span>
                        <span style="color: #28a745;">SUCCESS</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin: 10px 0;">
                        <span>✅ WAR Packaging</span>
                        <span style="color: #28a745;">SUCCESS</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin: 10px 0;">
                        <span>✅ Tomcat Deployment</span>
                        <span style="color: #28a745;">SUCCESS</span>
                    </div>
                </div>
            </div>

            <!-- Environment Details Card -->
            <div class="card">
                <div class="card-header">
                    <div class="card-icon">🌐</div>
                    <div class="card-title">Environment Details</div>
                </div>
                <p><strong>Environment:</strong> Development</p>
                <p><strong>Container:</strong> Docker Compose</p>
                <p><strong>Network:</strong> ci-cd-network</p>
                <p><strong>Port:</strong> 8081</p>
                
                <div style="margin-top: 20px; padding: 15px; background: #e8f5e8; border-radius: 8px;">
                    <strong>🎯 Ready for Production!</strong><br>
                    <small>All systems operational and ready for deployment.</small>
                </div>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>🚀 Powered by Jenkins CI/CD Pipeline | Built with ❤️ for DevOps</p>
        <p><em>Last updated: <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %></em></p>
    </div>
</body>
</html>