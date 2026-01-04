-- 1. 部门表（存储部门信息，员工需关联部门）
CREATE TABLE dept (
  dept_id INT PRIMARY KEY AUTO_INCREMENT,  -- 部门ID（自增主键）
  dept_name VARCHAR(50) NOT NULL UNIQUE    -- 部门名称（唯一，不重复）
);

-- 2. 员工表（存储员工基本信息）
CREATE TABLE employee (
  emp_id INT PRIMARY KEY AUTO_INCREMENT,   -- 员工ID（自增主键）
  emp_name VARCHAR(50) NOT NULL,           -- 员工姓名
  dept_id INT,                             -- 关联部门表的部门ID
  position VARCHAR(50),                    -- 岗位（如“开发工程师”）
  phone VARCHAR(20),                       -- 联系方式
  FOREIGN KEY (dept_id) REFERENCES dept(dept_id)  -- 外键：关联部门表
);

-- 3. 用户表（登录用，区分管理员/员工角色）
CREATE TABLE user (
  user_id INT PRIMARY KEY AUTO_INCREMENT,  -- 用户ID（自增主键）
  username VARCHAR(50) NOT NULL UNIQUE,    -- 登录账号（唯一）
  password VARCHAR(50) NOT NULL,           -- 登录密码（先存明文，后续优化加密）
  role VARCHAR(20) NOT NULL,               -- 角色：'admin'（管理员）/'employee'（员工）
  emp_id INT UNIQUE,                       -- 关联员工表（员工用户需绑定员工ID，管理员可空）
  FOREIGN KEY (emp_id) REFERENCES employee(emp_id)  -- 外键：关联员工表
);

-- 4.考勤表：记录员工每月考勤（员工ID+月份唯一，避免重复录入）
CREATE TABLE attendance (
    att_id INT PRIMARY KEY AUTO_INCREMENT,  -- 考勤ID（主键）
    emp_id INT NOT NULL,                     -- 员工ID（外键，关联employee表）
    att_month VARCHAR(7) NOT NULL,           -- 考勤月份（格式：2025-05）
    work_days INT NOT NULL DEFAULT 0,        -- 出勤天数
    leave_days INT NOT NULL DEFAULT 0,       -- 请假天数
    late_times INT NOT NULL DEFAULT 0,       -- 迟到次数
    absent_days INT NOT NULL DEFAULT 0,      -- 旷工天数
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id),  -- 外键约束
    UNIQUE KEY (emp_id, att_month)           -- 唯一约束：同一员工同一月份只能有一条考勤
);

-- 5. 工资表（核心表，存储每月工资明细）
CREATE TABLE salary (
  sal_id INT PRIMARY KEY AUTO_INCREMENT,   -- 工资ID（自增主键）
  emp_id INT NOT NULL,                     -- 关联员工ID
  sal_month VARCHAR(10) NOT NULL,          -- 工资月份（如“2025-05”）
  base_salary DECIMAL(10,2) NOT NULL,      -- 基本工资
  subsidy DECIMAL(10,2) DEFAULT 0,         -- 补贴（加班补贴+其他）
  deduction DECIMAL(10,2) DEFAULT 0,       -- 扣款（缺勤扣款+其他）
  actual_salary DECIMAL(10,2) NOT NULL,    -- 实发工资（base_salary + subsidy - deduction）
  FOREIGN KEY (emp_id) REFERENCES employee(emp_id),  -- 外键：关联员工表
  UNIQUE KEY (emp_id, sal_month)           -- 同一员工同一月份只能有一条工资记录
);


use emp_salary_conn;

-- 1. 先插入部门表（dept）：员工需关联部门，先初始化3个常见部门
INSERT INTO dept (dept_name) 
VALUES 
('技术部'),
('人事部'),
('财务部');

-- 2. 插入员工表（employee）：5条中文姓名员工数据，关联不同部门
INSERT INTO employee (emp_name, dept_id, position, phone) 
VALUES 
-- 员工1：张三（技术部，开发工程师）
('张三', 1, '开发工程师', '13800138001'),
-- 员工2：李四（技术部，测试工程师）
('李四', 1, '测试工程师', '13800138002'),
-- 员工3：王五（人事部，人事专员）
('王五', 2, '人事专员', '13800138003'),
-- 员工4：赵六（财务部，会计）
('赵六', 3, '会计', '13800138004'),
-- 员工5：钱七（人事部，招聘专员）
('钱七', 2, '招聘专员', '13800138005');

-- 3. 插入用户表（user）：5条员工账号+1条管理员账号（方便测试）
INSERT INTO user (username, password, role, emp_id) 
VALUES 
-- 管理员账号：admin（无关联员工ID）
('admin', '123456', 'admin', NULL),
-- 员工1账号：zhangsan（关联张三，emp_id=1）
('zhangsan', '123456', 'employee', 1),
-- 员工2账号：lisi（关联李四，emp_id=2）
('lisi', '123456', 'employee', 2),
-- 员工3账号：wangwu（关联王五，emp_id=3）
('wangwu', '123456', 'employee', 3),
-- 员工4账号：zhaoliu（关联赵六，emp_id=4）
('zhaoliu', '123456', 'employee', 4),
-- 员工5账号：qianqi（关联钱七，emp_id=5）
('qianqi', '123456', 'employee', 5);

-- 4. 插入考勤表（attendance）：5条员工2025-12月考勤数据
INSERT INTO attendance (emp_id, att_month, work_days, leave_days, late_times, absent_days) 
VALUES 
-- 张三：全勤，无迟到请假
('1', '2025-12', 22, 0, 0, 0),
-- 李四：请假1天，迟到1次
('2', '2025-12', 21, 1, 1, 0),
-- 王五：全勤，迟到2次
('3', '2025-12', 22, 0, 2, 0),
-- 赵六：请假2天，无迟到
('4', '2025-12', 20, 2, 0, 0),
-- 钱七：全勤，无迟到请假
('5', '2025-12', 22, 0, 0, 0);

-- 5. 插入工资表（salary）：5条员工2025-12月工资数据（实发工资=基本工资+补贴-扣款）
INSERT INTO salary (emp_id, sal_month, base_salary, subsidy, deduction, actual_salary) 
VALUES 
-- 张三：基本工资8000+补贴1000-扣款0=实发9000
('1', '2025-12', 8000.00, 1000.00, 0.00, 9000.00),
-- 李四：基本工资7500+补贴800-扣款200（迟到扣款）=实发8100
('2', '2025-12', 7500.00, 800.00, 200.00, 8100.00),
-- 王五：基本工资6500+补贴500-扣款0=实发7000
('3', '2025-12', 6500.00, 500.00, 0.00, 7000.00),
-- 赵六：基本工资7000+补贴600-扣款500（请假扣款）=实发7100
('4', '2025-12', 7000.00, 600.00, 500.00, 7100.00),
-- 钱七：基本工资6000+补贴400-扣款0=实发6400
('5', '2025-12', 6000.00, 400.00, 0.00, 6400.00);


