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
    <title>员工列表</title>
    <style>
        table { width: 800px; margin: 50px auto; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background: #f5f5f5; }
    </style>
</head>
<body>
    <h2 style="text-align: center;">员工信息列表</h2>
    <table>
        <tr>
            <<th>员工ID</</th>
            <<th>员工姓名</</th>
            <<th>所属部门</</th>
            <<th>岗位</</th>
            <<th>联系方式</</th>
        </tr>
        <%
            // 查询employee表+关联dept表获取部门名称
            Connection conn = DBUtil.getConnection();
            String sql = "SELECT e.emp_id, e.emp_name, d.dept_name, e.position, e.phone " +
                         "FROM employee e LEFT JOIN dept d ON e.dept_id = d.dept_id";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("emp_id") %></td>
            <td><%= rs.getString("emp_name") %></td>
            <td><%= rs.getString("dept_name") %></td>
            <td><%= rs.getString("position") %></td>
            <td><%= rs.getString("phone") %></td>
        </tr>
        <%
            }
            rs.close(); pstmt.close(); conn.close();
        %>
    </table>
    <div style="text-align: center; margin-top: 20px;">
        <a href="addEmp.jsp">新增员工</a>
    </div>
</body>
</html>