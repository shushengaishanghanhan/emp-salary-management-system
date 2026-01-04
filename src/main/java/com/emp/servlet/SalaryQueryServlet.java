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

@WebServlet("/employee/salaryQueryServlet")
public class SalaryQueryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. 获取当前登录的用户名（从Session中取）
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        if (username == null) {
            // 未登录，跳登录页
            response.sendRedirect("../login.jsp");
            return;
        }

        // 2. 从user表查询当前用户关联的emp_id（员工ID）
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Integer empId = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT emp_id FROM user WHERE username = ? AND role = 'employee'";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                empId = rs.getInt("emp_id"); // 获取员工ID
                session.setAttribute("empId", empId); // 存到Session，供JSP复用
            } else {
                // 异常情况：员工账号未关联emp_id
                request.setAttribute("errorMsg", "账号未绑定员工信息，请联系管理员！");
                request.getRequestDispatcher("../login.jsp").forward(request, response);
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "系统错误：" + e.getMessage());
            request.getRequestDispatcher("../login.jsp").forward(request, response);
            return;
        } finally {
            // 3. 关闭数据库资源
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // 4. 携带查询条件（月份）跳回工资查询页面
        String salMonth = request.getParameter("salMonth");
        request.setAttribute("salMonth", salMonth);
        request.getRequestDispatcher("salaryQuery.jsp").forward(request, response);
    }

    // 兼容POST请求
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}