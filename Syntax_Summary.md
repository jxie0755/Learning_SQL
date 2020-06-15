#Postgre SQL 语法总结#

---
## Chapter 0 搭建SQL和连接SQL##

---
## Chapter 1 数据库和SQL ##

语法0:查看pSQL版本
```sql
SELECT version();
```

语法1: 创建`DATABASE`数据库
```sql
CREATE DATABASE <数据库名称>;
```

语法2: 创建`TABLE`
```sql
CREATE TABLE  <表名> (
<列名 1> <数据类型> <该列所需约束>, 
<列名 2> <数据类型> <该列所需约束>, 
<列名 3> <数据类型> <该列所需约束>, 
<列名 4> <数据类型> <该列所需约束>, 
    .
    .
    .
<该表的约束 1>, <该表的约束 2>, ...): 
```

语法3: 删除表用`DROP TABLE`
- 一旦删除则无法恢复
- 执行前务必确认!
```sql
DROP TABLE <表名>;
```

语法6: 修改表名
```sql
-- only for psql and Oracle
ALTER TABLE Poduct RENAME TO Product;

-- MySQL
ALTER TABLE Poduct RENAME TO Product;
```

语法7: Extra材料, 给列改名
```sql
ALTER TABLE <表名>
  RENAME COLUMN <列名> TO <新列名>;
```

---
## Chapter 2 查询基础 ##

语法1: `SELECT`语句
- 两个子句(clause)
    - `SLECT` 列举列的名称
    - `FROM`  指定表的名称
```sql
SELECT <列名>, ...
FROM <表名>;
```

语法2: 查询所有列
> - `*`号代表所有
> - 使用`*`就没没法设定顺序? 此时按照`CREATE TABLE`语句排序
```sql
SELECT *
FROM <表名>
```

语法3: 通过使用`WHERE`添加选择条件
```sql
SELECT <列名>, ...
FROM <表名>
WHERE <条件表达式>;
```

---
## Chapter 3 聚合与查询 ##

语法1: `GROUP BY`语句
```sql
SELECT <列名1>, <列名2>, <列名3>...
FROM <表名>
WHERE
GROUP BY <列名1>, <列名2>, <列名3>...;
```

语法2: 使用WHERE子句和GROUP BY子句进行汇总处理
```sql
SELECT <列名1>, <列名2>, <列名3>,...
FROM <表名>
WHERE
GROUP BY <列名1>, <列名2>, <列名3>,...;
```

语法3: `HAVING`语句
> - `HAVING` 子句**必须**写在 `GROUP BY` 子句之后, 其在 DBMS 内部的
> - 执行顺序也排在 `GROUP BY` 子句之后
```sql
SELECT <列名1>, <列名2>, <列名3>, ......
FROM <表名>
GROUP BY <列名1>, <列名2>, <列名3>, ......
HAVING <分组结果对应的条件>
```

语法4: `ORDER BY`语句
```sql
SELECT <列名1>, <列名2>, <列名3>, ...
FROM <表名>
ORDER BY <排序基准列1>, <排序基准列2>, ... (DESC | ASC)
```

语法extra: 至此SQL语句顺序
- 最终书写顺序:
  - `SELECT` -> `FROM` -> `WHERE` -> `GROUP BY` -> `HAVING` -> `ORDER BY`
- 真实执行顺序:
  - `FROM` -> `WHERE` -> `GROUP BY` -> `HAVING` -> `SELECT` -> `ORDER BY`
```sql
SELECT * 
FROM <表名>
WHERE <条件>
GROUP BY <分组条件>
HAVING <条件> 
ORDER BY <条件>
```

---
## Chapter 4 数据更新 ##

语法1: `INSERT`的使用
```sql
INSERT INTO <表名> (列1, 列2, 列3, ...) 
VALUES 
    (值1, 值2, 值3, ...);
```

语法2: 保留数据表, 仅删除全部数据行的`DELETE`
- 如果语句中忘了写 FROM, 而是写成了`DELETE <表名>`或者写了多余的列名, 都会出错, 无法正常执行, 请大家特别注意
    - `DELETE <表名>`无法正常执行的原因是删除对象不是表, 而是表中的数据行
    - `DELETE * FROM <表名>;`无法正常执行因为`DELETE`语句的对象是行而不是列, 所以`DELETE`语句无法只删除部分列的数据
        - 若要删除列, 参见Chapter 1-5中使用`ALTER` + `ADD COLUMN`/`DROP COLUMN`
```sql
DROP TABLE <表名>;
-- 将表完全删除

DELETE FROM <表名>;
-- 只是删除表中的内容, 但是保留表本体, 不适用于psql, 见本节专栏

TRUNCATE <表名>;  -- 对等于: DELETE FROM <表名>, 参见章末专栏;
```

语法3: 删除部分数据行的搜索型`DELETE`
- `WHERE`子句的书写方式与此前介绍的`SELECT`语句完全一样
```sql
DELETE FROM <表名>
WHERE <条件>;
```

语法4: 改变表中数据的`UPDATE`语句
- 将更新对象的列和更新后的值都记述在`SET`子句中
```sql
UPDATE <表名>
    SET <列名> = <表达式>;
```

语法5: 更新部分数据行的搜索型`UPDATE`
```sql
UPDATE <表名>
    SET <列名> = <表达式>
WHERE <条件>;
```

语法6: 事务的语法
- 这时需要特别注意的是事务的开始语句.
- 实际上, 在标准SQL中并没有定义事务的开始语句
```sql
事务开始语句;

    DML语句1;
    DML语句2;
    DML语句3;
       .
       .
       .
事务结束语句(COMMIT或者ROLLBACK);

-- 事务开始句:
BEGIN TRANSACTION -- psql, SQL server
START TRANSACTION -- MySQL
```

---
## Chapter 5 复杂查询 ##

语法1: 创建视图的CREATE VIEW语句
- `SELECT`语句需要书写在`AS`关键字之后.
- `SELECT`语句中列的排列顺序和视图中列的排列顺序相同, `SELECT`语句中的第1列就是视图中的第1列, `SELECT`语句中的第2列就是视图中的第2列
- 定义视图时可以使用任何`SELECT`语句, 既可以使用`WHERE`, `GROUP BY`, `HAVING`, 也可以通过`SELECT *`来指定全部列
```sql
CREATE VIEW 视图名称(<视图列名1>, <视图列名2>, ......)
AS
<SELECT语句>
```

语法2: 删除视图需要使用`DROP VIEW`语句
- 可以一次删除多个`VIEW`
- psql不支持删除`VIEW`中的`COLUMN`
```sql
DROP VIEW 视图名称(<视图1>, <视图2>, ......)
```

语法extra: 关联子查询
- 这里起到关键作用的就是在子查询中添加的`WHERE`子句的条件
    - 这次由于作为比较对象的都是同一张Product表, 因此为了进行区别, 分别使用了`P1`和`P2`两个别名.
    - 在使用关联子查询时, 需要在表所对应的列名之前加上表的别名, 以`<表名>.<列名>`的形式记述
```sql
SELECT product_type, product_name, sale_price
    FROM Product AS P1
WHERE sale_price > (SELECT AVG(sale_price)
                        FROM Product AS P2
                    WHERE P1.product_type = P2.product_type   --- 调用P1和P2的关联性来形成每个类别的单独子查询对比
                        GROUP BY product_type);
```

---
## Chapter 6 函数, 谓词, CASE表达式 ##

语法1: `ABS`函数
- 就是求
```sql
ABC(数值)
```

语法2: `MOD`函数
- `MOD`是计算除法余数(求余)的函数, 是modulo的缩写
```sql
MOD(被除数, 除数)
```

语法3: `ROUND`四舍五入
- `ROUND`函数用来进行四舍五入操作. 四舍五入在英语中称为 round.
- 如果指定四舍五入的位数为1, 那么就会对小数点第2位进行四舍五入处理
```sql
ROUND(对象数值, 保留小数的位数)
```

语法4: `||`拼接
- 在实际业务中, 我们经常会碰到abc + de = abcde这样希望将字符串进行拼接的情况.
- 在SQL中, 可以通过由两条并列的竖线变换而成的`||`函数来实现
- 只要存在`NULL`, 则输出`NULL`, SQL不会拼接任何`str+NULL`
- `||`函数在SQL Server(`+`)和MySQL(`CONCAT`)中无法使用
```sql
字符串1||字符串2
```

语法5: `LENGTH`函数计算字符串长度
```sql
LENGTH(字符串)
```

语法6: `LOWER`函数小写转换
- 只能针对英文字母使用, 它会将参数中的字符串全都转换为小写
- 混合型字符串只变化大写字符部分
- 并不影响原本就是小写的字符
```sql
LOWER(字符串)
```

语法7: `REPLACE`函数字符串的替换
- 这里有一个要求就b必须存在于a里面, 才会把a中的b部分替换成c
    - 不然的话, 不存在替换动作, 返回的还是a本身
    - 如果a中存在多个b部分, 则所有b都会被替换成c
```sql
REPLACE(对象字符串, 替换前的字符串, 替换后的字符串)
--          a         b           c
```

语法8: `SUBSTRING`函数(PostgreSQL/MySQL专用语法)
- 截取的起始位置从字符串最左侧开始计算
- 注意index从1开始, 不为0
```sql
SUBSTRING(对象字符串 FROM 截取的起始位置 FOR 截取的字符数)
--           str          index           长度
```

语法9: `UPPER`函数大写转换
- 只能针对英文字母使用, 它会将参数中的字符串全都转换为大写
- 混合型字符串只变化小写字符部分
- 并不影响原本就是大写的字符
```sql
UPPER(字符串)
```

语法10: `CURRENT_DATE`函数
- `CURRENT_DATE`函数能够返回SQL执行的日期, 也就是该函数执行时的日期.
- 由于没有参数, 因此无需使用括号行时的时间
```sql
CURRENT_DATE
```

语法11: `CURRENT_TIME`函数
- `CURRENT_TIME`函数能够取得SQL执行的时间, 也就是该函数执行时的时间
```sql
CURRENT_TIME;
```

语法12: `CURRENT_TIMESTAMP`函数
- `CURRENT_TIMESTAMP`函数具有`CURRENT_DATE` + `CURRENT_TIME`的功能.
- 使用该函数可以同时得到当前的日期和时间
- 当然也可以从结果中截取日期或者时间
```sql
CURRENT_TIMESTAMP
```

语法13: `EXTRACT`函数
- 使用`EXTRACT`函数可以截取出日期数据中的一部分,  例如"年" "月", 或者"小时""秒"等
- 该函数的返回值并不是日 期类型而是数值类型
- `EXTRACT`函数不能独立使用, 必须用在一条SELECT命令之后
- `EXTRACT`函数不能提取出时区信息, 因为在psql中所有时区信息都会被转换成UTC时间记录下来, 所以没有独立的时区信息被保留
```sql
-- 批量
SELECT 列名 as D
    EXTRACT(日期元素 FROM D)

-- 单独
SELECT EXTRACT(日期元素 FROM TIMESTAMP 'YYYY-MM-DD HH-MM-SS.123456')
```

语法extra: 查询和修改时区
```sql
-- 查询所有时区
SELECT *
FROM pg_timezone_names; -- 位于pg_catalog/views中

-- 查询所在时区有哪些地方
SELECT *
FROM pg_timezone_names
WHERE utc_offset = '+08:00:00';  -- 中国的GMT+8时区

SELECT *
FROM pg_timezone_names
WHERE utc_offset = '-05:00:00';  -- 美国东岸GMT-5时区

-- 调整时区
-- 设置时可以使用pg_timezone_names表中的name或者abbrev作为字符串
-- 注意: 每次在新的Console中都需要设置,设置不是永久在database中保存
SET TIMEZONE = 'UTC';  -- GMT标准时间
SET TIMEZONE = 'EST';  -- 美国东岸时间
SET TIMEZONE = 'CST';  -- 美国中部时间
SET TIMEZONE = 'PST';  -- 美国西岸时间

-- 由于该表中直接有对每个ETC时区的name 例如:
-- name: ETc/GMT-8, abbrev: +08
-- 所以可以直接SET TIMEZONE = '+08'; 或者 SET TIMEZONE = '-05';等等
```

语法14: `CAST`函数实现类型转换
- 之所以需要进行类型转换, 是因为可能会插入与表中数据类型不匹配的数据
- 或者在进行运算时由于数据类型不一致发生了错误
- 又或者是进行自动类型转换会造成处理速度低下. 这些时候都需要事前进行数据类型转换
- 将字符串转换为日期 类型时, 从结果上并不能看出数据发生了什么变化, 理解起来也比较困难.
  - 从这一点我们也可以看出, 类型转换其实并不是为了方便用户使用而开发的功能, 而是为了方便DBMS内部处理而开发的功能
```sql
CAST (转换前的值 AS 想要转换的数据类型)
```

语法15: `COALSECE`函数
- `COALESCE`是SQL特有的函数.
- 该函数会返回可变参数A中左侧开始第1个不是`NULL`的值.
- 参数个数是可变的, 因此可以根据需要无限增加.
- 在 SQL 语句中将`NULL`转换 为其他值时就会用到转换函数.
    - 运算或者函数中含有`NULL`时, 结果全都会变为`NULL`.
    - 能够避免这种结果的函数就是 COALESCE
```sql
COALESCE( 数据1, 数据2, 数据3 ...... )
```

语法16: 搜索CASE表达式
- WHEN 子句中的"<求值表达式>"就是类似"`列 = 值`"这样, 返回值为真值(`TRUE`/`FALSE`/`UNKNOWN`)的表达式
- CASE 表达式会从对最初的`WHEN`子句中的"< 求值表达式 >"进行求值开始执行.
  - 所谓求值, 就是要调查该表达式的真值是什么
  - 如果结果为真(`TRUE`), 那么就返回`THEN`子句中的表达式
  - CASE 表达式的执行到此为止 (相当于if...elif, 而不是if...if...)
```sql
CASE WHEN <求值表达式> THEN <表达式>
     WHEN <求值表达式> THEN <表达式>
     WHEN <求值表达式> THEN <表达式>
       .
       .
       .
    ELSE <表达式>
END AS <COLUMN_NAME> 
```

语法extra: 简单CASE表达式
- 与搜索CASE表达式一样, 简单CASE表达式也是从最初的`WHEN`子句开始进行
- 逐一判断每个 WHEN 子句直到返回真值为止
- 没有能够返回真值的`WHEN`子句时, 也会返回`ELSE`子句指定的表达式
- 两者的不同之处在于, 简单CASE表达式最初的`CASE< 表达式 >`也会作为求值的对象
```sql
CASE <表达式>
    WHEN <表达式> THEN <表达式>
    WHEN <表达式> THEN <表达式>
    WHEN <表达式> THEN <表达式>
     .
     .
     .
    ELSE <表达式>
END AS <COLUMN_NAME>
```

---
## Chapter 7 表的加减法 ##

语法1: 使用`UNION`对表进行加减法
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

语法2: `UNION ALL`保留重复行
```sql
SELECT product_id, product_name
FROM Product
UNION ALL
SELECT product_id, product_name
FROM Product2;
```

语法3: 使用`INTERSECT`选取出表中公共部分
```sql
SELECT product_id, product_name
FROM Product
INTERSECT
SELECT product_id, product_name
FROM Product2
ORDER BY product_id;
```

语法4: 使用`EXCEPT`对记录进行减法运算
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

语法5: 将Product表和ShopProduct表内联
```sql
SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price
FROM ShopProduct AS SP INNER JOIN Product AS P
ON SP.product_id = P.product_id;
```

语法7: 对3张表进行内联结
```sql
-- 针对原代码做了小改动, 增加了IP.inventory_id列, 确定了只筛选出P001仓库的货品
SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price, IP.inventory_id, IP.inventory_quantity
FROM ShopProduct AS SP INNER JOIN Product AS P
ON SP.product_id = P.product_id    -- 以上和第一次内联结两张表完全相同
INNER JOIN InventoryProduct AS IP  -- 第二次内联结开始
ON SP.product_id = IP.product_id
WHERE IP.inventory_id = 'P001';
```

语法8: 将两张表进行交叉联结
```sql
SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name
FROM ShopProduct AS SP CROSS JOIN Product AS P;
```

---
## Chapter 8 SQL高阶处理 ##

语法1: 窗口函数
> - 窗口函数大体可以分为以下两种:
>   1. 能够作为窗口函数的聚合函数(`SUM`, `AVG`, `COUNT`, `MAX`, `MIN`)
>      - 将聚合函数书写 在`<窗口函数>`中, 就能够当作窗口函数来使用了
>   2. `RANK`, `DENSE_RANK`, `ROW_NUMBER`等专用窗口函数
```sql
<窗口函数> OVER ([PARTITION BY <列清单>]
                        ORDER BY <排序用列清单>)   
```

语法2: 根据不同的商品种类, 按照销售单价从低到高顺序创建排序表
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

语法3: 不指定`PARTITION BY`
```sql
SELECT product_name, product_type, sale_price,
    RANK () OVER (ORDER BY sale_price) AS ranking
FROM Product;
```

---
## Chapter 9 通过应用程序连接数据库 ##

