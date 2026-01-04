package com.emp.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.math.BigDecimal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.emp.util.DBUtil;

@WebServlet("/admin/salaryAddServlet")
public class SalaryAddServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        // 接收前端参数
        int empId = Integer.parseInt(request.getParameter("empId"));
        String salMonth = request.getParameter("salMonth");
        BigDecimal baseSalary = new BigDecimal(request.getParameter("baseSalary"));
        BigDecimal subsidy = new BigDecimal(request.getParameter("subsidy"));
        BigDecimal deduction = new BigDecimal(request.getParameter("deduction"));
        // 计算实发工资：基本工资+补贴-扣款
        BigDecimal actualSalary = baseSalary.add(subsidy).subtract(deduction);

        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            // 插入salary表的SQL（避免同一员工同一月份重复录入）
            String sql = "INSERT INTO salary (emp_id, sal_month, base_salary, subsidy, deduction, actual_salary) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, empId);
            pstmt.setString(2, salMonth);
            pstmt.setBigDecimal(3, baseSalary);
            pstmt.setBigDecimal(4, subsidy);
            pstmt.setBigDecimal(5, deduction);
            pstmt.setBigDecimal(6, actualSalary);
            // 执行插入
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                request.setAttribute("msg", "工资录入成功！");
            } else {
                request.setAttribute("msg", "工资录入失败，请重试！");
            }
        } catch (SQLException e) {
            // 捕获“同一员工同一月份重复录入”的异常
            if (e.getMessage().contains("Duplicate entry")) {
                request.setAttribute("msg", "该员工此月份的工资已录入！");
            } else {
                request.setAttribute("msg", "系统错误：" + e.getMessage());
            }
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        // 跳回工资录入页面显示提示
        request.getRequestDispatcher("salaryAdd.jsp").forward(request, response);
    }
}