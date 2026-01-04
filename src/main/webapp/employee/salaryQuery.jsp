<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.emp.util.DBUtil, java.math.BigDecimal" %>
<%
    // 1. 权限验证：仅员工可访问，未登录跳登录页
    String role = (String)session.getAttribute("role");
    Integer empId = (Integer)session.getAttribute("empId"); // 后续Servlet会存员工ID
    if (!"employee".equals(role) || empId == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    // 2. 获取查询条件（默认查询当前月，格式：YYYY-MM）
    String salMonth = request.getParameter("salMonth");
    if (salMonth == null || salMonth.trim().isEmpty()) {
        // 自动填充当前年月（如2025-12）
        java.util.Calendar cal = java.util.Calendar.getInstance();
        int year = cal.get(java.util.Calendar.YEAR);
        int month = cal.get(java.util.Calendar.MONTH) + 1; // 月份从0开始，需+1
        salMonth = year + "-" + (month < 10 ? "0" + month : month);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的工资查询</title>
    <style>
        .query-box { width: 600px; margin: 30px auto; text-align: center; }
        table { width: 600px; margin: 20px auto; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background: #f5f5f5; }
        .btn { padding: 6px 15px; background: #4CAF50; color: white; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <h2 style="text-align: center;">我的工资明细</h2>
    <div class="query-box">
        <!-- 月份查询表单 -->
        <form action="salaryQueryServlet" method="get">
            <label>选择月份：</label>
            <input type="month" name="salMonth" value="<%= salMonth %>" required>
            <button type="submit" class="btn">查询</button>
        </form>
    </div>

    <%
        // 3. 从salary表查询当前员工指定月份的工资
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean hasData = false; // 标记是否有工资数据
    %>
    <table>
        <tr>
            <<th>工资月份</</th>
            <<th>基本工资</</th>
            <<th>补贴</</th>
            <<th>扣款</</th>
            <<th>实发工资</</th>
        </tr>
        <%
            try {
                conn = DBUtil.getConnection();
                // SQL：仅查询当前员工（empId）指定月份的工资
                String sql = "SELECT sal_month, base_salary, subsidy, deduction, actual_salary " +
                             "FROM salary WHERE emp_id = ? AND sal_month = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, empId);
                pstmt.setString(2, salMonth);
                rs = pstmt.executeQuery();

                // 4. 回显查询结果
                if (rs.next()) {
                    hasData = true;
        %>
        <tr>
            <td><%= rs.getString("sal_month") %></td>
            <td><%= rs.getBigDecimal("base_salary") %></td>
            <td><%= rs.getBigDecimal("subsidy") %></td>
            <td><%= rs.getBigDecimal("deduction") %></td>
            <td style="color: #e63946;"><%= rs.getBigDecimal("actual_salary") %></td>
        </tr>
        <%
                }
                // 无数据时显示提示行
                if (!hasData) {
        %>
        <tr>
            <td colspan="5" style="color: #666;">暂无该月份工资数据</td>
        </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
        %>
        <tr>
            <td colspan="5" style="color: red;">查询错误：<%= e.getMessage() %></td>
        </tr>
        <%
            } finally {
                // 5. 关闭数据库资源
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
    </table>
</body>
</html>