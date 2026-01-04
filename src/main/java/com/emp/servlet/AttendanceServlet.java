package com.emp.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.emp.util.DBUtil;

@WebServlet("/admin/attendanceServlet")
public class AttendanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        // 1. 接收前端考勤数据
        int empId = Integer.parseInt(request.getParameter("empId"));
        String attMonth = request.getParameter("attMonth");
        int workDays = Integer.parseInt(request.getParameter("workDays"));
        int leaveDays = Integer.parseInt(request.getParameter("leaveDays"));
        int lateTimes = Integer.parseInt(request.getParameter("lateTimes"));
        int absentDays = Integer.parseInt(request.getParameter("absentDays"));

        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            // 2. 插入考勤数据（避免同一员工同一月份重复录入）
            String sql = "INSERT INTO attendance (emp_id, att_month, work_days, leave_days, late_times, absent_days) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, empId);
            pstmt.setString(2, attMonth);
            pstmt.setInt(3, workDays);
            pstmt.setInt(4, leaveDays);
            pstmt.setInt(5, lateTimes);
            pstmt.setInt(6, absentDays);

            // 3. 执行插入并返回提示
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                request.setAttribute("msg", "考勤录入成功！");
            } else {
                request.setAttribute("msg", "考勤录入失败，请重试！");
            }
        } catch (SQLException e) {
            // 捕获“重复录入”异常（唯一约束）
            if (e.getMessage().contains("Duplicate entry")) {
                request.setAttribute("msg", "该员工此月份考勤已录入！");
            } else {
                request.setAttribute("msg", "系统错误：" + e.getMessage());
            }
            e.printStackTrace();
        } finally {
            // 4. 关闭资源
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        // 5. 跳回考勤管理页显示提示
        request.getRequestDispatcher("attendanceManage.jsp").forward(request, response);
    }
}