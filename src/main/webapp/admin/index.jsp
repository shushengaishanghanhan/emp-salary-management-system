<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String)session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    String empName = (String)session.getAttribute("empName");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理员首页 - 职工工资管理系统</title>
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

        /* 顶部简化导航 */
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
        .logout-btn {
            color: white;
            text-decoration: none;
            padding: 6px 12px;
            background-color: #e74c3c;
            border-radius: 4px;
            font-size: 14px;
        }

        /* 主容器：完全居中 */
        .main-container {
            width: 600px;
            margin: 60px auto;
            text-align: center;
        }

        /* 欢迎区域 */
        .welcome {
            margin-bottom: 40px;
        }
        .welcome h1 {
            font-size: 24px;
            color: #333;
            margin-bottom: 10px;
        }
        .welcome p {
            color: #666;
            font-size: 14px;
        }

        /* 功能按钮组：居中排列 */
        .func-buttons {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        .func-btn {
            display: block;
            padding: 15px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 16px;
        }
        .func-btn:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <!-- 简化顶部栏 -->
    <div class="top-bar">
        <div class="system-title">职工工资管理系统</div>
        <a href="javascript:;" onclick="confirmLogout()" class="logout-btn">退出登录</a>
    </div>

    <!-- 居中主容器 -->
    <div class="main-container">
        <!-- 居中欢迎语 -->
        <div class="welcome">
            <h1>欢迎您，<%= empName %>！</h1>
            <p>请选择功能操作</p>
        </div>

        <!-- 居中功能按钮组 -->
        <div class="func-buttons">
            <a href="empList.jsp" class="func-btn">员工列表</a>
            <a href="addEmp.jsp" class="func-btn">新增员工</a>
            <a href="salaryAdd.jsp" class="func-btn">工资管理</a>
            <a href="attendanceManage.jsp" class="func-btn">考勤管理</a>
        </div>
    </div>

    <script>
        function confirmLogout() {
            if (confirm('确定退出吗？')) {
                window.location.replace('../loginOutServlet');
            }
        }
    </script>
</body>
</html>