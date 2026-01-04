package com.emp.entity;

public class User {
    private String username;
    private String role;
    private String empName;
    private Integer empId; // 新增：员工ID属性

    // 新增getter/setter
    public Integer getEmpId() { return empId; }
    public void setEmpId(Integer empId) { this.empId = empId; }

    // 原有getter/setter（username/role/empName）保持不变
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getEmpName() { return empName; }
    public void setEmpName(String empName) { this.empName = empName; }
}