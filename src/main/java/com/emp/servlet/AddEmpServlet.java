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
import javax.servlet.http.HttpSession;

import com.emp.util.DBUtil;

// 映射路径：与addEmp.jsp的form action对应
@WebServlet("/admin/addEmpServlet")
public class AddEmpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. 设置请求编码，解决中文姓名乱码
        request.setCharacterEncoding("UTF-8");
        
        // 2. 接收前端表单参数（对应addEmp.jsp的输入框name）
        String empName = request.getParameter("empName");
        int deptId = Integer.parseInt(request.getParameter("deptId")); // 关联部门表dept_id
        String position = request.getParameter("position");
        String phone = request.getParameter("phone");

        // 3. 验证参数非空（后端二次校验，避免空数据插入）
        if (empName == null || empName.trim().isEmpty() || position == null || phone == null) {
            request.setAttribute("errorMsg", "员工姓名、岗位、电话不能为空！");
            request.getRequestDispatcher("addEmp.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            // 4. 连接数据库，插入员工数据
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO employee (emp_name, dept_id, position, phone) " +
                         "VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, empName);
            pstmt.setInt(2, deptId);
            pstmt.setString(3, position);
            pstmt.setString(4, phone);

            // 5. 执行插入，判断是否成功
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                request.setAttribute("msg", "员工【" + empName + "】新增成功！");
            } else {
                request.setAttribute("errorMsg", "员工新增失败，请重试！");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "系统错误：" + e.getMessage());
        } finally {
            // 6. 关闭数据库资源
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // 7. 跳回员工列表页，显示提示信息
        request.getRequestDispatcher("empList.jsp").forward(request, response);
    }

    // 兼容GET请求（避免直接访问Servlet报错）
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}