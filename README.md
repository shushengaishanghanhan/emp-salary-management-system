# emp-salary-management-system
基于 Servlet+JSP+MySQL 的职工工资管理系统

## 项目介绍
本项目为《软件工程学》课程作业，采用 B/S 架构，支持管理员和员工双角色权限管理，核心实现员工信息管理、工资录入与查询、考勤录入与查询、密码修改等功能，旨在规范企业工资与考勤管理流程。

## 技术栈
- 前端：JSP + CSS3 + JavaScript
- 后端：Java Servlet + JDBC
- 数据库：MySQL 8.0
- 部署环境：JDK 1.8、Apache Tomcat 9.0.73
- 依赖：mysql-connector-j-8.0.33.jar（MySQL驱动）

## 核心功能
- 管理员：登录/退出、员工管理（新增/列表）、工资录入、考勤录入
- 员工：登录/退出、个人工资查询、个人考勤查询、密码修改

## 部署步骤
1.  克隆仓库：git clone https://github.com/shushengaishanghanhan/emp-salary-management-system.git
2.  数据库初始化：启动MySQL，创建emp_salary_conn数据库，执行createTable/Table.sql脚本
3.  导入项目：用Eclipse导入项目，关联Tomcat 9.0.73服务器
4.  启动访问：启动Tomcat和MySQL，访问http://localhost:8080/webexp7/login.jsp

## 测试账号
- 管理员：username=admin，password=123456
- 员工：username=zhangsan，password=213238

## 备注
- 项目编码请设置为UTF-8，避免中文乱码
- Tomcat默认端口8080，若被占用可修改配置文件
- 作者：鲁东润 | 学号：2305110257 | 班级：软工2303