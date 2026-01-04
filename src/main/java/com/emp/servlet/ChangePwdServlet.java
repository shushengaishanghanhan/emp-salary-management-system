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

// 路径不变，和页面表单提交对应
@WebServlet("/employee/changePwdServlet")
public class ChangePwdServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        // 1. 获取页面输入的密码
        String oldPwd = request.getParameter("oldPwd");
        String newPwd = request.getParameter("newPwd");
        String confirmPwd = request.getParameter("confirmPwd");
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username"); // 当前登录账号

        // 2. 先判断新密码和确认密码是否一致（前端也有校验，后端再防一层）
        if (!newPwd.equals(confirmPwd)) {
            request.setAttribute("errorMsg", "新密码和确认密码不一样！");
            request.getRequestDispatcher("changePwd.jsp").forward(request, response);
            return;
        }
        // 简单校验新密码长度（避免太简单）
        if (newPwd.length() < 3) {
            request.setAttribute("errorMsg", "新密码至少3位！");
            request.getRequestDispatcher("changePwd.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            // 3. 查数据库里的原密码（明文对比）
            String checkSql = "SELECT password FROM user WHERE username = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setString(1, username); // 用当前登录账号查
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String dbOldPwd = rs.getString("password"); // 数据库里的明文原密码
                // 4. 对比输入的原密码和数据库原密码
                if (!dbOldPwd.equals(oldPwd)) {
                    request.setAttribute("errorMsg", "原密码输错了！");
                    request.getRequestDispatcher("changePwd.jsp").forward(request, response);
                    return;
                }
            }

            // 5. 原密码正确，更新新密码（明文存数据库）
            String updateSql = "UPDATE user SET password = ? WHERE username = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, newPwd); // 新密码明文存
            pstmt.setString(2, username);
            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                request.setAttribute("msg", "密码修改成功！下次登录用新密码");
                // 可选：修改后不强制退出，方便测试
                // session.invalidate(); 
            } else {
                request.setAttribute("errorMsg", "修改失败，再试一次！");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "系统出错：" + e.getMessage());
        } finally {
            // 关闭资源
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        // 跳回修改密码页显示结果
        request.getRequestDispatcher("changePwd.jsp").forward(request, response);
    }
}