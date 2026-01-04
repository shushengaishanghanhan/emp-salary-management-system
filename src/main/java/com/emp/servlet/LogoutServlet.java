package com.emp.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// 映射路径需与前端退出链接一致（之前页面用的是"../loginOutServlet"）
@WebServlet("/loginOutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 新增：打印日志，确认Servlet是否执行
        System.out.println("=== LogoutServlet开始执行 ===");

        // 1. 销毁当前用户Session
        HttpSession session = request.getSession(false);
        if (session != null) {
            System.out.println("Session存在，正在销毁...");
            session.invalidate(); // 强制销毁Session
        } else {
            System.out.println("Session不存在，无需销毁");
        }

        // 2. 清除JSESSIONID Cookie（重点：精准匹配登录时的Cookie属性）
        String contextPath = request.getContextPath(); // 自动获取项目上下文路径（如/webexp7）
        Cookie jsessionidCookie = new Cookie("JSESSIONID", "");
        jsessionidCookie.setMaxAge(0); // 立即失效
        jsessionidCookie.setPath(contextPath); // 自动匹配项目路径，避免手动写死
        jsessionidCookie.setHttpOnly(true); // 匹配登录时JSESSIONID的HttpOnly属性
        response.addCookie(jsessionidCookie);
        System.out.println("已设置JSESSIONID Cookie失效，Path=" + contextPath);
     // 在清除JSESSIONID之后，添加：
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("JSESSIONID".equals(cookie.getName())) {
                    cookie.setValue("");
                    cookie.setMaxAge(0);
                    cookie.setPath(contextPath);
                    response.addCookie(cookie);
                    System.out.println("已强制删除JSESSIONID Cookie");
                    break;
                }
            }
        }
        // 3. 重定向到登录页
        response.sendRedirect(contextPath + "/login.jsp"); // 带项目路径，避免404
        System.out.println("=== LogoutServlet执行完成 ===");
    }

    // 兼容POST请求（若后续有需要）
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}