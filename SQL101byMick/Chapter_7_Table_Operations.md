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


实例3+4: 使用`UNION`对表进行加减法
- `UNION`等集合运算符通常都会除去重复的记录
```sql
SELECT product_id, product_name
FROM Product
UNION
SELECT product_id, product_name
FROM Product2;

-- 使用ORDER BY
SELECT product_id, product_name
FROM Product
WHERE product_type = '厨房用具'
UNION
SELECT product_id, product_name
FROM Product2
WHERE product_type = '厨房用具'
ORDER BY product_id;
```


#### 集合运算的注意事项 ####

集合运算的注意事项
1. 作为运算对象的记录的列数必须相同
2. 作为运算对象的记录中列的类型必须一致
3. 可以使用任何`SELECT`语句, 但`ORDER BY`子句只能在最后使用一次
   - 对集合结果进行全体排序


#### 包含重复行的集合运算 - ALL选项 ####

`UNION`的结果中保留重复行的语法. 其实非常简单, 只需要在`UNION`后面添加`ALL`关键字就可以了

实例5: 保留重复行
```sql
SELECT product_id, product_name
FROM Product
UNION ALL
SELECT product_id, product_name
FROM Product2;
```


#### 选取表中的公共部分 - INTERSECT ####

选取两个记录集合中公共部分的关键字是`INTERSECT`(交集)
- 与使用`AND`可以选取出一张表中满足多个条件的公共部分不同, `INTERSECT`应用于两张表, 选取出它们当中的公共记录

实例6: 使用`INTERSECT`选取出表中公共部分
```sql
SELECT product_id, product_name
FROM Product
INTERSECT
SELECT product_id, product_name
FROM Product2
ORDER BY product_id;
```


#### 记录的减法 - EXCEPT ####

进行减法运算的`EXCEPT`(差集), 其语法也与`UNION`相同

实例7+8: 使用`EXCEPT`对记录进行减法运算
```sql
SELECT product_id, product_name
FROM Product
EXCEPT
SELECT product_id, product_name
FROM Product2
ORDER BY product_id;

-- 互换两张表的顺序结果也不同
SELECT product_id, product_name
FROM Product2
EXCEPT
SELECT product_id, product_name
FROM Product
ORDER BY product_id;
```

---
### 7-2 联结 (以列为单位对表进行联结) ###

学习重点:
- 联结(JOIN)就是将其他表中的列添加过来, 进行"添加列"的集合运算. UNION是以行(纵向)为单位进行操作, 而联结则是以列(横向)为单位进行的.
- 联结大体上分为内联结和外联结两种. 首先请大家牢牢掌握这两种联结的使用方法.
- 请大家一定要使用标准SQL的语法格式来写联结运算, 对于那些过时的或者特定SQL中的写法, 了解一下即可, 不建议使用.

#### 什么是联结 ####

联结(`JOIN`)运算, 简单来说, 就是将其他表中的列添加过来, 进行"添加列"的运算. 期望得到的数据往往会分散在不同的表之中. 使用联结就可以从多张表(3 张以上的表也没关系)中选取数据了


#### 内联结 - INNER JOIN ####

内联结是应用最广泛的联结运算, 可以暂时忽略这个内字


