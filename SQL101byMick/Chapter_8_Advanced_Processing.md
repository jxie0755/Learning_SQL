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
> - 核心语法: `窗口函数 OVER (分组方式/排序方式) AS <列名>`
> - `PARTITION BY`和`ORDER BY`分别可以单独使用, 但是如果一起使用必须先`PARTITION BY`
> - `RANK`函数的意义在于排好序后, 可以将每行数据分配序号, 方便任意提取第N大的数据
> - `PARTITION BY`能够设定排序的对象范围 (就是先把商品根据类型分区)
>   - `PARTITION BY`在横向上对表进行分组
> - `ORDER BY`能够指定按照哪一列, 何种顺序进行排序 (也就是在各分区内按照规定排序)
>   - `ORDER BY`决定了纵向排序的规则
> - 通过`PARTITION BY`分组后的记录集合称为窗口.
>   - 此处的窗口并 非"窗户"的意思, 而是代表范围.
>   - 这也是"窗口函数"名称的由来.
>   - 各个窗口在定义上绝对不会包含共通的部分. 就像刀切蛋糕一样, 干净利落.
>   - 这与通过`GROUP BY`子句分割后的集合具有相同的特征
```sql
SELECT product_name, product_type, sale_price,
       RANK() OVER (PARTITION BY product_type
           ORDER BY sale_price) AS ranking     --- 根据排序结果依次分配序号
FROM product;
```

- 窗口函数兼具之前我们学过的`GROUP BY`子句的分组功能以及`ORDER BY`子句的排序功能
- `PARTITION BY`子句并不具备`GROUP BY`子句的汇总功能. 因此, 使用`RANK`函数并不会减少原表中记录的行数, 结果中仍然包含 8 行数据.
  - 解释: `GROUP BY`会把同类GROUP缩减成一行显示不同的GROUP, 而`PARTITION BY`则是把GROUP中每行数据展示出来


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

实例extra 1: 如果使用`GROUP BY`, 应该配合一些统计函数
```sql
SELECT name
from student_exam
GROUP BY name;
-- 可以发现一共有三个人

SELECT subject
from student_exam
GROUP BY subject;
-- 可以发现一共考三科

SELECT name, sum(score), avg(score)
from student_exam
GROUP BY name;
-- 可以看各人三科总分和平均分, 发现Denis总分最高

SELECT subject, sum(score), avg(score)
from student_exam
GROUP BY subject;
-- 可以看各科三人总分和平均分, 发现宏观上来看英语学得比其他两科好
```
>- 无论如何, 这里都是做了一些简单的统计工作, 简化了数据


实例extra 2: 如果使用`OVER (PARTITION BY)` 则是从不同的角度展示整张表, 不简化数据
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
       sum(score) over(partition by name),  -- 增加一个总分列
        avg(score) over(partition by name)  -- 增加一个平均分列
FROM student_exam
-- 每个人只有一个总分/平均分, 但是有三科成绩, 这样同一个总分/平均分要出现三次,分别和三科成绩对比
-- 如此使用窗口函数则方便很多
```
>- 无论如何, 这里都是对原表做了一个分层展示, 数据全部不动


#### 无需指定PARTITION BY ####

- 使用窗口函数时起到关键作用的是`PARTITION BY`和`GROUP BY`.
- 其中, `PARTITION BY`并不是必需的


实例2/语法3: 不指定`PARTITION BY`
```sql
SELECT product_name, product_type, sale_price,
    RANK () OVER (ORDER BY sale_price) AS ranking
FROM Product;
```


#### 专用窗口函数的种类 ####

一些有代表性的窗口函数, 在所有DBMS中可以使用
- `RANK`函数
  - 出现并列的情况, 参考通用体育排名, 并列第一名之后就是排第三名了.
- `DENISE_RANK`函数
  - 与`RANK`的情况相反, 并列第一名之后的仍然是排第二名
- `ROW_NUMBER`函数
  - 无视并列的情况, 强行安排1,2,3,4....


实例3: 比较`RANK`, `DENSE_RANK`, `ROW_NUMBER`的结果
```sql
SELECT product_name, product_type, sale_price,
    -- 同时对sale_price做三列不同的窗口函数:
    RANK () OVER (ORDER BY sale_price) AS ranking,
    DENSE_RANK () OVER (ORDER BY sale_price) AS dense_ranking,
    ROW_NUMBER () OVER (ORDER BY sale_price) AS row_num    
FROM Product;
```
> - 使用`RANK`或`ROW_NUMBER`时无需任何参数, 只需要像`RANK ()`或者`ROW_NUMBER()`这样保持括号中为空就可以了.
> - 这也是专用窗口函数通常的使用方式.


#### 窗口函数的适用范围 ####

使用窗口函数的位置有非常大的限制, 只能书写在一个特定的位置
- 这个位置就是`SELECT`子句之中.
- 反过来说, 就是这类函数不能在`WHERE`子句或者`GROUP BY`子句中使用
- 理由:
  - 在DBMS内部, 窗口函数是对`WHERE`子句或者`GROUP BY`子句处理后的"结果"进行的操作


#### 作为窗口函数使用的聚合函数 ####

把SUM或者AVG等聚合函数作为窗口函数使用的方法 (其实以前之前**Extra: GROUP BY vs PARTITION BY**中讨论过)
- 所有的聚合函数都能用作窗口函数, 其语法和专用窗口函数完全相同

实例4+5: 将`SUM`函数和`AVG`函数作为窗口函数使用
```sql
SELECT product_id, product_name, sale_price,
    SUM (sale_price) OVER (ORDER BY product_id) AS current_sum
FROM Product;

-- 这里的current sum是随着行数往下累积从头相加到该行
    -- 任意一行的sum就是到目前为止的sum
    -- 最后一行的sum显然就是total sum
    
SELECT product_id, product_name, sale_price,
    AVG (sale_price) OVER (ORDER BY product_id) AS current_avg
FROM Product;

-- 理由同上, 每一行的avg都是至此行的avg
```


#### 计算平均移动 ####

- 窗口函数就是将表以窗口为单位进行分割, 并在其中进行排序的函数.
- 其实其中还包含在窗口中指定更加详细的汇总范围的备选功能, 该备选功能中的汇总范围称为**框架**


实例6+7: 指定"最靠近的3行"和"当前的前后"作为汇总对象
```sql
-- 使用PRECEDING
SELECT product_id, product_name, sale_price,
    AVG (sale_price) OVER (ORDER BY product_id 
                            ROWS 2 PRECEDING) AS moving_avg 
FROM Product;
    
-- 使用PRECEDING和FOLLOWING
SELECT product_id, product_name, sale_price,
    AVG (sale_price) OVER (ORDER BY product_id 
                            ROWS BETWEEN 1 PRECEDING AND 
                            1 FOLLOWING) AS moving_avg 
FROM Product;    
```
> - 从第三行开始才是"最近3行"平移
>   - 注意,到达每一行时本身都要被看的
>   - 第一行就是它本身, 第二行就是本身加上一行,从第三行开始都是本身加前两行
> - 这种方法叫做Moving Average
>   - 这里我们使用了`ROWS`("行")和`PRECEDING`("之前")两个关键字, 将框架指定为"截止到之前 ~ 行".
>   - 同理, 之后N行叫做`FOLLOWING`
> - 结合在一起就是有之前就看,没有就不看,有之后就看,没有也不看,至少要看自己
>   - 如果要排除自己就在窗口函数中减去自己即可


#### 两个ORDER BY ####

- `OVER`子句中的`ORDER BY`只是用来决定窗口函数按照什么样的顺序进行计算的, 对结果的排列顺序并没有影响

实例8: 无法保证`SELECT`语句的结果的排序顺序
```sql
-- 不能保证排序ranking
SELECT product_name, product_type, sale_price,
    RANK () OVER (ORDER BY sale_price) AS ranking 
FROM Product;

-- 保证按照ranking来排序
SELECT product_name, product_type, sale_price,
    RANK () OVER (ORDER BY sale_price) AS ranking 
FROM Product
ORDER BY ranking;
```
> - 有时候的确会按照ranking来排序, 但是未必一定
> - 所以这是必须要加一个`ORDER BY`给这个显示出来的view排序


### GROUPING运算符 ###

学习重点
- 只使用`GROUP BY`子句和聚合函数是无法同时得出小计和合计的. 如果想要同时得到, 可以使用GROUPING运算符.
- 理解`GROUPING`运算符中`CUBE`的关键在于形成"积木搭建出的立方体"的印象.
- 虽然`GROUPING`运算符是标准SQL的功能, 但还是有些DBMS尚未支持这一功能.


#### 同时得到合计行 ####

- 使用`GROUP BY`把合计作为一行数据添加到表里

实例10+11: 使用`GROUP BY`只能得到小计,无法得到合计行, 但是可以通过UNION ALL来把小计连接
```sql
SELECT product_type, SUM(sale_price) 
FROM Product 
GROUP BY product_type;

-- 如此可以得到各品类产品的小计(也即是品类总和)
-- 但是无法得到三类物品的全部合计

SELECT '合计' AS product_type, SUM(sale_price) 
FROM Product 
UNION ALL SELECT product_type, SUM(sale_price)
FROM Product GROUP BY product_type;

-- `UNION ALL`和`UNION`的区别:加上`ALL`不会去重(第七章有提到)
```
> - 这相当于对Product表做了两次类似的SUM语句再合并起来, 比较繁琐


#### ROLLUP - 同时得出合计和小计 ####

为了满足用户的需求, 标准SQL引入了`GROUPING`运算符,包含3种:
1. `ROLLUP`
2. `CUBE`
3. `GROUPING SETS`
- *目前不是每个DBMS都支持GROUPING运算符比如MySQL5.7还不行
- pSQL从9.5版之后开始支持(使用语法0查看版本)


`ROLLUP`
- 从语法上来说, 就是将 GROUP BY 子句中的聚合键清单像 ROLLUP ( 列 1>,< 列 2>,... )这样使用
- 该运算符的作用, 一言以蔽之, 就是"一次计算出不同聚合键组合的结果"

实例12: 使用`ROLLUP`同时得出合计和小计
```sql
SELECT product_type, SUM(sale_price) AS sum_price
FROM Product
GROUP BY ROLLUP(product_type);
```
> - 这里使用`ROLLUP`意思就是做两次运算
>   - 第一次, 就当没有`GROUP BY`子句当然也就不需要`SELECT product_type`, 直接得出Sum(sales_price)
>   - 第二次, 就是当做没有`ROLLUP`, 分组后分别计算各组Sum


实例13+14: 在`GROUP BY`中添加"登记日期"(不使用`ROLLUP` vs. 使用`ROLLUP`)
```sql
SELECT product_type, regist_date, SUM(sale_price) AS sum_price 
FROM Product 
GROUP BY product_type, regist_date;

-- 这里意思是按照product_type和regist_date分组,相同的组把售价总和一下, 由于Product表里没有完全相同的product_type和regist_date,所以这里列出来的sum_price就是每个物品的单价

SELECT product_type, regist_date, SUM(sale_price) AS sum_price
FROM Product
GROUP BY ROLLUP(product_type, regist_date);

-- 这里就会对未分组做一个sum, 也就是所有产品的售价的sum
-- 然后对`GROUP BY (product_type)`分组做一个售价的sum,这样就看到了分类产品的售价sum
-- 最后对`GROUP BY (product_type, regist_date)`形成的分组做一个售价的sum,由于这里没有完全重复的分组,所以这里没显示任何售价的sum
-- 注意, 这里不对`GROUP BY (regist_date)`做分组,所以先后顺序是重要的
```


#### GROUPING函数 - 让NULL更加容易分辨 ####

在实例14中, 如果一个条目:
- 比如衣服(售价4000)没有regist_date, 那么regist_date列会显示`NULL`
- 又比如衣服(售价5000), 这个其实是衣服类的合计,regist_date也会显示`NULL`
  - 但是这两个`NULL`意思是不一样的,如何能更好的区分呢?

为了避免混淆, SQL提供了一个用来判断超级分组记录的`NULL`的特定函数 - `GROUPING`函数

实例15: 使用 GROUPING 函数来判断 NULL
```sql
SELECT GROUPING(product_type) AS product_type,
       GROUPING(regist_date) AS regist_date,
       SUM(sale_price) AS sum_price FROM Product
GROUP BY ROLLUP(product_type, regist_date);
```
> - 这样会把product_type和regist_date的数据全部变成`0`和`1`
>   - `0`的意思就是这就是原始数据
>   - `1`的意思就是`ROLLUP`之后的演算值


实例16: 在超级分组记录的键值中插入恰当的字符串
```sql
SELECT CASE WHEN GROUPING(product_type) = 1
            THEN '商品种类 合计' ELSE product_type 
        END AS product_type,

        CASE WHEN GROUPING(regist_date) = 1
             THEN '登记日期 合计' ELSE CAST(regist_date AS VARCHAR(16)) 
         END AS regist_date,

        SUM(sale_price) AS sum_price
FROM Product
GROUP BY ROLLUP(product_type, regist_date);
```
> - 使用case表达式把数据中的0和1作区分对待可以有效的减少`NULL`带来的误解

**注意:** CAST(regist_date AS VARCHAR(16))的原因是为了保证Case表达式所有的输出都是同一类型的数据,因为登记日期合计是字符串,所以日期数据要被转型


#### CUBE - 用数据来搭积木 ####

- CUBE 的语法和`ROLLUP`相同，只需要将`ROLLUP`替换为`CUBE`就可以了

实例17: 使用`CUBE`取得全部组合的结果
```sql
SELECT CASE WHEN GROUPING(product_type) = 1
            THEN '商品种类 合计'
            ELSE product_type END AS product_type,
       CASE WHEN GROUPING(regist_date) = 1
           THEN '登记日期 合计'
            ELSE CAST(regist_date AS VARCHAR(16)) END AS regist_date,
       SUM(sale_price) AS sum_price
FROM Product
GROUP BY CUBE(product_type, regist_date);
```
> - 此例和实例16代码几乎完全相同,只是把`ROLLUP`替换成`CUBE`
> - 结果是包括了实例16的全部内容,然后再多出来了几行内容
>   - 简单的说就是`ROLLUP`对product_type和regist_date有一个先后顺序固定,只取`GROUP BY (product_type)` 然后直接`GROUP BY (product_type, regist_date)`
>   - 而`CUBE`分别对`GROUP BY (product_type)`和`GROUP BY (regist_date)`,然后对两者一起`GROUP BY (product_type, regist_date)`
>   - 效果类似笛卡尔乘积

