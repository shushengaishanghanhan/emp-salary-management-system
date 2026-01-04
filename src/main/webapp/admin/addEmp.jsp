<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet" %>
<%@ page import="com.emp.util.DBUtil" %>
<%
    // 验证管理员登录状态
    String role = (String)session.getAttribute("role");
    if (!"admin".equals(role)) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>新增员工 - 职工工资管理系统</title>
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

        /* 顶部统一导航栏 */
        .top-bar {
            background-color: #333;
            color: white;
            padding: 12px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .system-title {
            font-size: 16px;
        }
        .nav-btn {
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
            width: 500px;
            margin: 40px auto;
            text-align: center;
        }
        .page-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 25px;
        }

        /* 表单样式 */
        .form-box {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            text-align: left;
        }
        .form-item {
            margin: 18px 0;
            display: flex;
            align-items: center;
        }
        .form-item label {
            display: inline-block;
            width: 110px;
            text-align: right;
            margin-right: 15px;
            font-size: 14px;
            color: #666;
        }
        .form-item input, .form-item select {
            padding: 9px;
            width: 250px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        /* 提交按钮区域 */
        .submit-area {
            margin-left: 125px;
            margin-top: 25px;
        }
        #submit {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 25px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 15px;
            transition: background-color 0.3s;
        }
        #submit:hover {
            background-color: #45a049;
        }

        /* 提示信息 */
        .msg {
            color: #4CAF50;
            text-align: center;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .error-msg {
            color: #e74c3c;
            text-align: center;
            margin-bottom: 20px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <!-- 顶部导航栏（与管理员首页统一） -->
    <div class="top-bar">
        <div class="system-title">职工工资管理系统</div>
        <div>
            <a href="index.jsp" class="nav-btn back-btn">返回首页</a>
            <a href="javascript:;" onclick="confirmLogout()" class="nav-btn logout-btn">退出登录</a>
        </div>
    </div>

    <!-- 居中主容器 -->
    <div class="main-container">
        <h2 class="page-title">新增员工信息</h2>

        <div class="form-box">
            <!-- 成功/错误提示 -->
            <%
                String msg = (String)request.getAttribute("msg");
                String errorMsg = (String)request.getAttribute("errorMsg");
                if (msg != null) {
            %>
                <div class="msg"><%= msg %></div>
            <% } else if (errorMsg != null) { %>
                <div class="error-msg"><%= errorMsg %></div>
            <% } %>

            <!-- 表单提交 -->
            <form action="${pageContext.request.contextPath}/admin/addEmpServlet" method="post">
                <div class="form-item">
                    <label>员工姓名：</label>
                    <input type="text" name="empName" required placeholder="请输入中文姓名">
                </div>
                <div class="form-item">
                    <label>所属部门：</label>
                    <select name="deptId" required>
                        <%
                            // 动态加载部门列表（保留原逻辑）
                            Connection conn = DBUtil.getConnection();
                            String sql = "SELECT dept_id, dept_name FROM dept";
                            PreparedStatement pstmt = conn.prepareStatement(sql);
                            ResultSet rs = pstmt.executeQuery();
                            while (rs.next()) {
                        %>
                        <option value="<%= rs.getInt("dept_id") %>"><%= rs.getString("dept_name") %></option>
                        <%
                            }
                            rs.close(); 
                            pstmt.close(); 
                            conn.close();
                        %>
                    </select>
                </div>
                <div class="form-item">
                    <label>岗位：</label>
                    <input type="text" name="position" required placeholder="如：开发工程师">
                </div>
                <div class="form-item">
                    <label>联系方式：</label>
                    <input type="text" name="phone" placeholder="如：13800138001">
                </div>
                <div class="submit-area">
                    <input type="submit" id="submit" value="新增员工">
                </div>
            </form>
        </div>
    </div>

    <!-- 退出登录脚本（与其他页面统一） -->
    <script>
        function confirmLogout() {
            if (confirm('确定要退出登录吗？')) {
                window.location.replace('../loginOutServlet');
            }
        }
    </script>
</body>
</html>