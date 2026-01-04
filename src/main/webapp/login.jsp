<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 从请求中获取错误信息（如账号密码错误时显示）
    String errorMsg = (String)request.getAttribute("errorMsg");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>职工工资管理系统-登录</title>
    <style>
        /* 简单美化页面 */
        body {
            font-family: "微软雅黑", sans-serif; /* 统一字体，更美观 */
            background-color: #f5f5f5;
        }
        .login-box { 
            width: 380px; 
            margin: 80px auto; 
            padding: 30px; 
            border: 1px solid #eee; 
            border-radius: 8px; 
            background-color: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); /* 增加阴影，更有层次感 */
        }
        /* 系统标题样式 */
        .system-title {
            text-align: center;
            font-size: 22px;
            color: #333;
            margin: 0 0 20px 0;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        .login-title {
            text-align: center;
            font-size: 18px;
            color: #666;
            margin: 0 0 25px 0;
        }
        .input-item { 
            margin: 20px 0; 
        }
        /* 仅给文本输入框设置宽度（修复单选按钮排版问题） */
        .input-text { 
            width: 100%; 
            padding: 10px; 
            box-sizing: border-box; 
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .input-text:focus {
            outline: none;
            border-color: #4CAF50; /* 聚焦时高亮边框 */
        }
        /* 单选按钮样式（确保和文字在同一行） */
        .radio-item {
            display: flex;
            align-items: center; /* 垂直居中对齐 */
            margin-right: 25px;
        }
        .radio-btn {
            width: auto; /* 取消100%宽度限制 */
            margin-right: 8px; /* 按钮和文字之间留间距 */
        }
        .radio-group {
            display: flex; /* 横向排列两个单选按钮 */
            justify-content: center; /* 居中显示 */
        }
        #sub_btn { 
            width: 100%; /* 登录按钮占满宽度 */
            background: #4CAF50; 
            color: white; 
            border: none; 
            cursor: pointer; 
            padding: 12px;
            border-radius: 4px;
            font-size: 16px;
        }
        #sub_btn:hover {
            background: #45a049; /*  hover时加深颜色 */
        }
        #error { 
            color: #f44336; 
            text-align: center; 
            padding: 10px;
            background-color: #fff3f3;
            border-radius: 4px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <!-- 新增：系统标题 -->
        <h1 class="system-title">职工工资管理系统</h1>
        <h2 class="login-title">用户登录</h2>
        
        <!-- 错误信息显示 -->
        <% if(errorMsg != null) { %>
            <div id="error"><%= errorMsg %></div>
        <% } %>
        
        <!-- 表单提交到LoginServlet -->
        <form action="loginServlet" method="post" name="loginForm">
            <div class="input-item">
                <input type="text" class="input-text" name="username" placeholder="请输入账号" required>
            </div>
            <div class="input-item">
                <input type="password" class="input-text" name="password" placeholder="请输入密码" required>
            </div>
            <!-- 优化：单选按钮排版 -->
            <div class="input-item radio-group">
                <div class="radio-item">
                    <input type="radio" class="radio-btn" name="role" value="admin" checked> 管理员
                </div>
                <div class="radio-item">
                    <input type="radio" class="radio-btn" name="role" value="employee"> 员工
                </div>
            </div>
            <div class="input-item">
                <input type="submit" id="sub_btn" value="登录">
            </div>
        </form>
    </div>
    
    <!-- JS验证：确保账号密码不为空（增强体验） -->
    <script>
        document.loginForm.onsubmit = function() {
            let username = document.loginForm.username.value;
            let password = document.loginForm.password.value;
            if (username.trim() === "") {
                alert("请输入账号！");
                return false;
            }
            if (password.trim() === "") {
                alert("请输入密码！");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>