<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.emp.util.DBUtil, java.util.ArrayList" %>
<%
    // 权限验证：仅管理员可访问
    String role = (String)session.getAttribute("role");
    if (!"admin".equals(role)) {
        response.sendRedirect("../login.jsp");
        return;
    }
    // 接收操作提示（如录入成功/失败）
    String msg = (String)request.getAttribute("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>考勤管理 - 职工工资管理系统</title>
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
        /* 主容器：居中 */
        .main-container {
            width: 800px;
            margin: 40px auto;
            text-align: center;
        }
        .page-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 30px;
        }
        /* 考勤录入表单 */
        .att-form {
            background-color: white;
            padding: 25px;
            border-radius: 6px;
            margin-bottom: 30px;
            text-align: left;
        }
        .form-item {
            margin: 15px 0;
        }
        .form-item label {
            display: inline-block;
            width: 120px;
            font-size: 14px;
            color: #666;
        }
        .form-item select, .form-item input {
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
            margin-left: 124px;
        }
        /* 提示信息 */
        .msg {
            color: #4CAF50;
            margin: 10px 0;
            text-align: center;
        }
        /* 考勤列表表格 */
        .att-table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            border-radius: 6px;
            overflow: hidden;
        }
        .att-table th, .att-table td {
            padding: 12px;
            border: 1px solid #eee;
            font-size: 14px;
        }
        .att-table th {
            background-color: #333;
            color: white;
        }
        .att-table tr:hover {
            background-color: #f9f9f9;
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
        <h2 class="page-title">管理员 - 考勤管理</h2>

        <!-- 考勤录入表单 -->
        <div class="att-form">
            <h3 style="margin-bottom: 20px; color: #333;">录入员工考勤</h3>
            <% if (msg != null) { %>
                <div class="msg"><%= msg %></div>
            <% } %>
            <form action="attendanceServlet" method="post">
                <div class="form-item">
                    <label>选择员工：</label>
                    <select name="empId" required>
                        <%
                            // 加载员工列表（关联employee表）
                            Connection conn = DBUtil.getConnection();
                            String empSql = "SELECT emp_id, emp_name FROM employee";
                            PreparedStatement empPstmt = conn.prepareStatement(empSql);
                            ResultSet empRs = empPstmt.executeQuery();
                            while (empRs.next()) {
                        %>
                        <option value="<%= empRs.getInt("emp_id") %>"><%= empRs.getString("emp_name") %></option>
                        <%
                            }
                            empRs.close();
                            empPstmt.close();
                        %>
                    </select>
                </div>
                <div class="form-item">
                    <label>考勤月份：</label>
                    <input type="month" name="attMonth" required>
                </div>
                <div class="form-item">
                    <label>出勤天数：</label>
                    <input type="number" name="workDays" min="0" max="31" required>
                </div>
                <div class="form-item">
                    <label>请假天数：</label>
                    <input type="number" name="leaveDays" min="0" max="31" value="0">
                </div>
                <div class="form-item">
                    <label>迟到次数：</label>
                    <input type="number" name="lateTimes" min="0" value="0">
                </div>
                <div class="form-item">
                    <label>旷工天数：</label>
                    <input type="number" name="absentDays" min="0" max="31" value="0">
                </div>
                <div class="form-item">
                    <input type="submit" class="submit-btn" value="提交考勤">
                </div>
            </form>
            <% conn.close(); %>
        </div>

        <!-- 考勤列表（查询所有员工考勤） -->
        <div>
            <h3 style="margin-bottom: 15px; color: #333;">员工考勤列表</h3>
            <table class="att-table">
                <tr>
                    <<th>员工姓名</</th>
                    <<th>考勤月份</</th>
                    <<th>出勤天数</</th>
                    <<th>请假天数</</th>
                    <<th>迟到次数</</th>
                    <<th>旷工天数</</th>
                </tr>
                <%
                    // 查询所有考勤数据（关联员工姓名）
                    Connection listConn = DBUtil.getConnection();
                    String listSql = "SELECT e.emp_name, a.att_month, a.work_days, a.leave_days, a.late_times, a.absent_days " +
                                     "FROM attendance a LEFT JOIN employee e ON a.emp_id = e.emp_id " +
                                     "ORDER BY a.att_month DESC";
                    PreparedStatement listPstmt = listConn.prepareStatement(listSql);
                    ResultSet listRs = listPstmt.executeQuery();
                    boolean hasData = false;
                    while (listRs.next()) {
                        hasData = true;
                %>
                <tr>
                    <td><%= listRs.getString("emp_name") %></td>
                    <td><%= listRs.getString("att_month") %></td>
                    <td><%= listRs.getInt("work_days") %></td>
                    <td><%= listRs.getInt("leave_days") %></td>
                    <td><%= listRs.getInt("late_times") %></td>
                    <td><%= listRs.getInt("absent_days") %></td>
                </tr>
                <%
                    }
                    // 无数据时显示提示
                    if (!hasData) {
                %>
                <tr>
                    <td colspan="6" style="color: #666;">暂无考勤数据</td>
                </tr>
                <%
                    }
                    listRs.close();
                    listPstmt.close();
                    listConn.close();
                %>
            </table>
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