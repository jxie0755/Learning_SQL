# SQL 101 by Mick #
## Chapter 7 表的加减法 ##


---
### 7-1 表的加减法 ###

学习重点:
- 集合运算就是对满足同一规则的记录进行的加减等四则运算.
- 使用`UNION`(并集), `INTERSECT`(交集), `EXCEPT`(差集)等集合运算符来进行集合运算.
- 集合运算符可以去除重复行.
- 如果希望集合运算符保留重复行, 就需要使用ALL选项.


#### 什么是集合运算 ####

集合在数学领域表示"(各种各样的)事物的总和"
- 在数据库领域表示记录的集合.
- 具体来说, 表, 视图和查询的执行结果都是记录的集
- 通过集合运算, 可以得到两张表中记录的集合或者公共记录的集合, 又或者其中某张表中的记录的集合. 像这样用来进行集合运算的运算符称为集合运算符


#### 表的加法 - UNION ####

`UNION`就是集合中的并集

实例1+2: 创建表Product2
```sql
-- 注意, Product2表的结构和Product完全相同, 包括product_id作为KEY
CREATE TABLE Product2
(product_id CHAR(4) NOT NULL,
product_name VARCHAR(100) NOT NULL,
product_type VARCHAR(32) NOT NULL,
sale_price INTEGER ,
purchase_price INTEGER ,
regist_date DATE ,
PRIMARY KEY (product_id));

-- 插入数据
BEGIN TRANSACTION;
INSERT INTO Product2 VALUES ('0001', 'T恤衫', '衣服', 1000, 500, '2008-09-20');
INSERT INTO Product2 VALUES ('0002', '打孔器', '办公用品', 500, 320, '2009-09-11');
INSERT INTO Product2 VALUES ('0003', '运动T恤', '衣服', 4000, 2800, NULL);
INSERT INTO Product2 VALUES ('0009', '手套', '衣服', 800, 500, NULL);
INSERT INTO Product2 VALUES ('0010', '水壶', '厨房用具', 2000, 1700, '2009-09-20');
COMMIT;
```


实例3: 使用`UNION`对表进行加减法
- `UNION`等集合运算符通常都会除去重复的记录
```sql
SELECT product_id, product_name
FROM Product
UNION
SELECT product_id, product_name
FROM Product2;
```


#### 集合运算的注意事项 ####

集合运算的注意事项
1. 作为运算对象的记录的列数必须相同
2. 作为运算对象的记录中列的类型必须一致
3. 可以使用任何`SELECT`语句，但`ORDER BY`子句只能在最后使用一次
   - 对集合结果进行全体排序


#### 包含重复行的集合运算 — ALL选项 ####
