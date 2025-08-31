<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Java Web App</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f4f4f4; }
        .container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h1 { color: #333; }
        .info { background: #e7f3ff; padding: 15px; border-radius: 5px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Welcome to My Updated Java Web Application!</h1>
        <p style="color: green; font-weight: bold;">✨ This change was deployed automatically! ✨</p>
        <div class="info">
            <p><strong>Version:</strong> 1.0.0</p>
            <p><strong>Build Time:</strong> <%= new java.util.Date() %></p>
            <p><strong>Status:</strong> Successfully Deployed via Jenkins CI/CD</p>
        </div>
        <h2>Features:</h2>
        <ul>
            <li>✅ Automated CI/CD Pipeline</li>
            <li>✅ Maven Build Process</li>
            <li>✅ Docker Containerization</li>
            <li>✅ Tomcat Deployment</li>
        </ul>
        <p><em>Edit this file and push to GitHub to see automatic deployment!</em></p>
    </div>
</body>
</html>