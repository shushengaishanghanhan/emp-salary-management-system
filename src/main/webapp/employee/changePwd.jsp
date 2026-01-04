<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 权限验证
    String username = (String)session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    // 接收提示信息
    String msg = (String)request.getAttribute("msg");
    String errorMsg = (String)request.getAttribute("errorMsg");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>修改密码 - 职工工资管理系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "微软雅黑", sans-serif;
        }
        body {
            background-color: #f5f5f5;
        }
        /* 顶部导航 */
        .top-bar {
            background-color: #333;
            color: white;
            padding: 12px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .system-title {
            font-size: 16px;
        }
        .back-btn, .logout-btn {
            color: white;
            text-decoration: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 14px;
            margin-left: 10px;
        }
        .back-btn {
            background-color: #4CAF50;
        }
        .logout-btn {
            background-color: #e74c3c;
        }
        /* 居中主容器 */
        .main-container {
            width: 400px;
            margin: 60px auto;
            text-align: center;
        }
        .page-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 30px;
        }
        /* 密码表单 */
        .pwd-form {
            background-color: white;
            padding: 25px;
            border-radius: 6px;
            text-align: left;
        }
        .form-item {
            margin: 15px 0;
        }
        .form-item label {
            display: inline-block;
            width: 100px;
            font-size: 14px;
            color: #666;
        }
        .form-item input {
            padding: 8px;
            width: 200px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .submit-btn {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 104px;
        }
        /* 提示信息 */
        .msg {
            color: #4CAF50;
            margin: 10px 0;
            text-align: center;
        }
        .error-msg {
            color: #e74c3c;
            margin: 10px 0;
            text-align: center;
        }
    </style>
</head>
<body>
    <!-- 顶部导航 -->
    <div class="top-bar">
        <div class="system-title">职工工资管理系统</div>
        <div>
            <a href="index.jsp" class="back-btn">返回首页</a>
            <a href="javascript:;" onclick="confirmLogout()" class="logout-btn">退出登录</a>
        </div>
    </div>

    <!-- 居中主容器 -->
    <div class="main-container">
        <h2 class="page-title">修改密码</h2>

        <!-- 密码表单 -->
        <div class="pwd-form">
            <% if (msg != null) { %>
                <div class="msg"><%= msg %></div>
            <% } %>
            <% if (errorMsg != null) { %>
                <div class="error-msg"><%= errorMsg %></div>
            <% } %>
            <form action="changePwdServlet" method="post">
                <div class="form-item">
                    <label>原密码：</label>
                    <input type="password" name="oldPwd" required>
                </div>
                <div class="form-item">
                    <label>新密码：</label>
                    <input type="password" name="newPwd" required>
                </div>
                <div class="form-item">
                    <label>确认新密码：</label>
                    <input type="password" name="confirmPwd" required>
                </div>
                <div class="form-item">
                    <input type="submit" class="submit-btn" value="确认修改">
                </div>
            </form>
        </div>
    </div>

    <!-- 退出脚本 -->
    <script>
        function confirmLogout() {
            if (confirm('确定退出吗？')) {
                window.location.replace('../loginOutServlet');
            }
        }
    </script>
</body>
</html>