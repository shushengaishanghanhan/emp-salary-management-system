package com.emp.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.emp.util.DBUtil;

// 注解配置Servlet映射（无需手动改web.xml）
@WebServlet("/loginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 1. 设置请求编码（解决中文乱码）
        request.setCharacterEncoding("UTF-8");
        // 2. 接收前端提交的参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); // admin 或 employee

        // 3. 调用数据库验证账号密码，新增：获取empId（员工ID）
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean loginSuccess = false;
        String empName = ""; // 存储员工姓名（登录后显示）
        Integer empId = null; // 新增：存储员工ID（关键，考勤页面需要）

        try {
            // 获取数据库连接
            conn = DBUtil.getConnection();
            // SQL：新增查询 e.emp_id（员工ID），关联employee表
            String sql = "SELECT u.username, u.role, e.emp_name, e.emp_id " + 
                         "FROM user u LEFT JOIN employee e ON u.emp_id = e.emp_id " + 
                         "WHERE u.username = ? AND u.password = ? AND u.role = ?";
            pstmt = conn.prepareStatement(sql);
            // 给SQL参数赋值（？占位符）
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            pstmt.setString(3, role);
            // 执行查询
            rs = pstmt.executeQuery();

            // 4. 判断查询结果：有数据则登录成功，同时获取empId
            if (rs.next()) {
                loginSuccess = true;
                empName = rs.getString("emp_name"); 
                // 处理管理员姓名（管理员emp_name为null，设为“管理员”）
                if (empName == null) empName = "管理员";
                // 新增：获取empId（员工有值，管理员为null）
                try {
                    empId = rs.getInt("emp_id");
                    // 若管理员emp_id为null（数据库中存为NULL），用wasNull()判断并设为0（避免空指针）
                    if (rs.wasNull()) empId = 0;
                } catch (SQLException e) {
                    empId = 0; // 异常时默认设为0，不影响管理员功能
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // 5. 关闭数据库资源（避免泄露）
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // 6. 根据登录结果跳转页面，新增：存储empId到Session
        if (loginSuccess) {
            // 登录成功：创建Session存储用户信息（含empId）
            HttpSession session = request.getSession();
            session.setAttribute("username", username); // 存储账号
            session.setAttribute("role", role); // 存储角色
            session.setAttribute("empName", empName); // 存储姓名
            session.setAttribute("empId", empId); // 新增：存储empId（考勤页面核心依赖）
            // 不同角色跳不同首页
            if ("admin".equals(role)) {
                response.sendRedirect("admin/index.jsp"); // 管理员首页
            } else {
                response.sendRedirect("employee/index.jsp"); // 员工首页
            }
        } else {
            // 登录失败：返回登录页并显示错误信息
            request.setAttribute("errorMsg", "账号、密码或角色错误，请重新输入！");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    // 避免GET请求报错，直接调用doPost
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}