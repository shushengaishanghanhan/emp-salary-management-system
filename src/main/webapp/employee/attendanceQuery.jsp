<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.emp.util.DBUtil" %>
<%
    // 1. 权限+身份验证：获取当前员工ID
    String username = (String)session.getAttribute("username");
    Integer empId = (Integer)session.getAttribute("empId"); // 从登录Session中获取
    if (username == null || empId == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    String empName = (String)session.getAttribute("empName");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的考勤 - 职工工资管理系统</title>
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
        /* 顶部导航（和员工首页统一） */
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
            width: 700px;
            margin: 40px auto;
            text-align: center;
        }
        .page-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 30px;
        }
        /* 考勤表格 */
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
        .no-data {
            color: #666;
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
        <h2 class="page-title"><%= empName %> - 我的考勤记录</h2>

        <!-- 考勤表格（仅显示当前员工的考勤） -->
        <table class="att-table">
            <tr>
                <<<th>考勤月份</</</th>
                <<<th>出勤天数</</</th>
                <<<th>请假天数</</</th>
                <<<th>迟到次数</</</th>
                <<<th>旷工天数</</</th>
            </tr>
            <%
                // 查询当前员工的考勤数据
                Connection conn = DBUtil.getConnection();
                String sql = "SELECT att_month, work_days, leave_days, late_times, absent_days " +
                             "FROM attendance WHERE emp_id = ? ORDER BY att_month DESC";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, empId);
                ResultSet rs = pstmt.executeQuery();
                boolean hasData = false;

                while (rs.next()) {
                    hasData = true;
            %>
            <tr>
                <td><%= rs.getString("att_month") %></td>
                <td><%= rs.getInt("work_days") %></td>
                <td><%= rs.getInt("leave_days") %></td>
                <td><%= rs.getInt("late_times") %></td>
                <td><%= rs.getInt("absent_days") %></td>
            </tr>
            <%
                }
                // 无数据提示
                if (!hasData) {
            %>
            <tr>
                <td colspan="5" class="no-data">暂无考勤记录</td>
            </tr>
            <%
                }
                // 关闭资源
                rs.close();
                pstmt.close();
                conn.close();
            %>
        </table>
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