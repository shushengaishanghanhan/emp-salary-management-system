<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.emp.util.DBUtil" %>
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
    <title>工资录入</title>
    <style>
        .form-box { width: 400px; margin: 50px auto; }
        .form-item { margin: 10px 0; }
        label { display: inline-block; width: 100px; text-align: right; margin-right: 10px; }
        input, select { padding: 5px; width: 200px; }
        #submit { background: #4CAF50; color: white; border: none; padding: 8px 20px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="form-box">
        <h2>员工工资录入</h2>
        <%
            // 显示操作提示
            String msg = (String)request.getAttribute("msg");
            if (msg != null) {
        %>
        <div style="color: green; text-align: center; margin-bottom: 10px;"><%= msg %></div>
        <%
            }
        %>
        <form action="salaryAddServlet" method="post">
            <div class="form-item">
                <label>选择员工：</label>
                <select name="empId" required>
                    <%
                        // 查询employee表，生成员工下拉选项
                        Connection conn = DBUtil.getConnection();
                        String sql = "SELECT emp_id, emp_name FROM employee";
                        PreparedStatement pstmt = conn.prepareStatement(sql);
                        ResultSet rs = pstmt.executeQuery();
                        while (rs.next()) {
                    %>
                    <option value="<%= rs.getInt("emp_id") %>"><%= rs.getString("emp_name") %></option>
                    <%
                        }
                        rs.close(); pstmt.close(); conn.close();
                    %>
                </select>
            </div>
            <div class="form-item">
                <label>工资月份：</label>
                <input type="month" name="salMonth" required>
            </div>
            <div class="form-item">
                <label>基本工资：</label>
                <input type="number" step="0.01" name="baseSalary" required>
            </div>
            <div class="form-item">
                <label>补贴：</label>
                <input type="number" step="0.01" name="subsidy" value="0.00">
            </div>
            <div class="form-item">
                <label>扣款：</label>
                <input type="number" step="0.01" name="deduction" value="0.00">
            </div>
            <div class="form-item" style="margin-left: 110px;">
                <input type="submit" id="submit" value="录入工资">
            </div>
        </form>
    </div>
</body>
</html>