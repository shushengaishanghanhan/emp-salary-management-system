package com.emp.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    // MySQL 8.0的驱动类名
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    // 数据库连接URL（emp_salary_db是数据库名，需与你创建的一致）
    private static final String URL = "jdbc:mysql://localhost:3306/emp_salary_conn?useSSL=false&serverTimezone=UTC&characterEncoding=utf8";
    private static final String USER = "root";
    private static final String PASSWORD = "123456"; // 替换为你的MySQL密码

    // 加载驱动（静态代码块，程序启动时执行一次）
    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("MySQL驱动加载失败");
        }
    }

    // 获取数据库连接
    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("数据库连接失败");
        }
    }

    // 关闭连接（后续操作完数据库需调用）
    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 测试连接（可暂时保留，验证后删除）
    public static void main(String[] args) {
        Connection conn = DBUtil.getConnection();
        System.out.println("数据库连接成功：" + conn);
        DBUtil.close(conn);
    }
}