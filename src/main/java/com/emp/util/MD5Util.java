package com.emp.util; // 包名必须是com.emp.util，与导入路径对应

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * 密码MD5加密工具类（带盐值，避免明文存储）
 */
public class MD5Util {
    // 盐值：自定义（建议用班级号/学号，如"2023Web01"，增强安全性）
    private static final String SALT = "2023Web01";

    /**
     * 密码加密：明文密码 + 盐值 → MD5加密（32位小写）
     * @param password 明文密码
     * @return 加密后的MD5字符串
     */
    public static String encrypt(String password) {
        if (password == null || password.trim().isEmpty()) {
            return null;
        }
        // 拼接明文和盐值（防止简单密码被暴力破解）
        String content = password + SALT;
        try {
            // 1. 获取MD5加密实例
            MessageDigest md = MessageDigest.getInstance("MD5");
            // 2. 对内容进行加密，得到字节数组
            byte[] digestBytes = md.digest(content.getBytes());
            // 3. 将字节数组转为32位十六进制字符串（避免乱码）
            StringBuilder sb = new StringBuilder();
            for (byte b : digestBytes) {
                String hex = Integer.toHexString(b & 0xFF); // 转为十六进制
                if (hex.length() == 1) { // 单个字符补0（确保32位）
                    sb.append("0");
                }
                sb.append(hex);
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }

    // 测试：运行main方法，确认加密正常（控制台会输出123456加密后的结果）
    public static void main(String[] args) {
        System.out.println(encrypt("123456")); // 输出示例：e10adc3949ba59abbe56e057f20f883e（带盐值后会不同）
    }
}