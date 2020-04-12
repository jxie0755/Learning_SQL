# SQL 101 by Mick #
## Chapter 8 SQL高阶处理 ##


---
### 8-1 窗口函数 ###

学习重点:
- 口函数可以进行排序, 生成序列号等一般的 操作.
- 理解 PARTITION BY 和 ORDER BY 这两个关键字的含义十分重要.


#### 什么是窗口函数 ####

窗口函数也称为OLAP函数, 全称是Online Analytical Processing, 意思是对数据库进行实时分析处理. 窗口函数就是为了实现OLAP而添加的SQL标准功能.


#### 窗口函数的语法 ####

语法1: 窗口函数
> - 窗口函数大体可以分为以下两种:
>   1. 能够作为窗口函数的聚合函数(`SUM`, `AVG`, `COUNT`, `MAX`, `MIN`)
>      - 将聚合函数书写 在`<窗口函数>`中, 就能够当作窗口函数来使用了
>   2. `RANK`, `DENSE_RANK`, `ROW_NUMBER`等专用窗口函数
```sql
<窗口函数> OVER ([PARTITION BY <列清单>]
                        ORDER BY <排序用列清单>)   
```

#### 语法的基本使用方法 - 使用RANK函数 ####

RANK 是用来计算记录排序的函数
≥
实例1/语法2: 根据不同的商品种类, 按照销售单价从低到高顺序创建排序表
> - `RANK`函数的意义在于排好序后, 可以将每行数据分配序号, 方便任意提取第N大的数据
> - `PARTITION BY`能够设定排序的对象范围 (就是先把商品根据类型分区)
>   - `PARTITION BY`在横向上对表进行分组
> - `ORDER BY`能够指定按照哪一列, 何种顺序进行排序 (也就是在各分区内按照规定排序)
>   - `ORDER BY`决定了纵向排序的规则
> - 通过`PARTITION BY`分组后的记录集合称为窗口.
>   - 此处的窗口并 非"窗户"的意思, 而是代表范围.
>   - 这也是"窗口函数"名称的由来.
>   - 各个窗口在定义上绝对不会包含共通的部分。就像刀切蛋糕一 样，干净利落。
>   - 这与通过 GROUP BY 子句分割后的集合具有相同的特征
```sql
SELECT product_name, product_type, sale_price,
       RANK() OVER (PARTITION BY product_type
           ORDER BY sale_price) AS ranking     --- 根据排序结果依次分配序号
FROM product;
```

- 窗口函数兼具之前我们学过的`GROUP BY`子句的分组功能以及`ORDER BY`子句的排序功能
- `PARTITION BY`子句并不具备`GROUP BY`子句的汇总功能。因此，使用`RANK`函数并不会减少原表中记录的行数，结果中仍然包含 8 行数据.
  - 解释: GROUP BY会把同类GROUP缩减成一行显示不同的GROUP, 而PARTITION BY则是把GROUP中每行数据展示出来


#### Extra: GROUP BY vs PARTITION BY ####

首先创立一个简单的TABLE展示三位学生的语数英考试成绩
```sql
CREATE TABLE student_exam
(name    varchar(32) NOT NULL,
subject varchar(32) NOT NULL,
score   INTEGER
);

BEGIN TRANSACTION;
INSERT INTO student_exam VALUES ('Denis', 'Chinese', 77);
INSERT INTO student_exam VALUES ('Denis', 'Math', 99);
INSERT INTO student_exam VALUES ('Denis', 'English', 95);
INSERT INTO student_exam VALUES ('Cindy', 'Chinese', 90);
INSERT INTO student_exam VALUES ('Cindy', 'Math', 81);
INSERT INTO student_exam VALUES ('Cindy', 'English', 98);
INSERT INTO student_exam VALUES ('Adrienne', 'Chinese', 73);
INSERT INTO student_exam VALUES ('Adrienne', 'Math', 75);
INSERT INTO student_exam VALUES ('Adrienne', 'English', 99);
END TRANSACTION;
```

实例extra 1: 如果使用GROUP BY, 应该配合一些统计函数
```sql
SELECT name
from student_exam
GROUP BY name;
-- 可以发现一共有三个人

SELECT subject
from student_exam
GROUP BY subject;
-- 可以发现一共考三科

SELECT name, sum(score)
from student_exam
GROUP BY name;
-- 可以看各人三科总分, 发现Denis总分最高

SELECT subject, sum(score)
from student_exam
GROUP BY subject;
-- 可以看各科三人总分, 发现宏观上来看英语学得比其他两科好
```
>- 无论如何, 这里都是做了一些简单的统计工作, 简化了数据


实例extra 2: 如果使用OVER (PARTITION BY) 则是从不同的角度展示整张表, 不简化数据
```sql
Select name, subject, score,
       Rank () over (PARTITION BY subject ORDER BY score)
from student_exam;
-- 展示整张表, 按照三科分组, 每组包含三个人成绩, 从低到高

Select name, subject, score,
       Rank () over (PARTITION BY name ORDER BY score)
from student_exam;
-- 展示整张表, 按照三人分组, 每组包含一个人的三科成绩, 从低到高

-- 从本质上来说,上组查询和使用ORDER BY对多列先后排序比较类似
Select name, subject, score
from student_exam
ORDER BY name, score;

那么如何展示窗口函数特别之处?
SELECT name, subject, score,
    avg(score) over(partition by name) -- 增加一个平均分列
FROM student_exam
-- 每个人只有一个平均分, 但是有三科成绩, 这样同一个平均分要出现三次,分别和三科成绩对比
-- 如此使用窗口函数则方便很多
```
>- 无论如何, 这里都是对原表做了一个分层展示, 数据全部不动


#### 无需指定PARTITION BY ####

- 使用窗口函数时起到关键作用的是`PARTITION BY`和`GROUP BY`。
- 其中，`PARTITION BY`并不是必需的


实例2/语法3: 不指定`PARTITION BY`
```sql
SELECT product_name, product_type, sale_price,
    RANK () OVER (ORDER BY sale_price) AS ranking
FROM Product;
```

