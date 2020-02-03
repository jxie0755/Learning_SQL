# SQL 101 by Mick #
## Chapter 5 复杂查询 ##

---
### 5-1 视图 ###

学习重点:
- 从SQL的角度来看, 视图和表是相同的, 两者的区别在于表中保存的是实际的数据, 而视图中保存的是`SELECT`语句(视图本身并不存储数据).
- 使用视图, 可以轻松完成跨多表查询数据等复杂操作.
- 可以将常用的`SELECT`语句做成视图来使用.
- 创建视图需要使用`CREATE VIEW`语句.
- 视图包含"不能使用`ORDER BY`"和"可对其进行有限制的更新"两项限制.
- 删除视图需要使用`DROP VIEW`语句.


#### 视图和表 ####

一个新的工具-视图
- 视图究竟是什么呢?
    - 如果用一句话概述的话, 就是"从SQL的角度来看视图就是一张表"
    - 实际上, 在SQL语句中并不需要区分哪些是表, 哪些是视图, 只需要知道在更新时它们之间存在一些不同就可以了
- 那么视图和表的区别只有一个
    - 就是"是否保存了实际的数据", 使用视图时并不会将数据保存到存储设备之中, 而且也不会将数据保存到其他任何地方
    - 实际上视图保存的是`SELECT`语句, 我们从视图中读取数据时, 视图会在内部执行该`SELECT`语句并创建出一张临时表
- 视图的两个优点:
    1. 由于视图无需保存数据, 因此可以节省存储设备的容量
    2. 可以将频繁使用的`SELECT`语句保存成视图, 这样就不用每次都重新书写了

实例1:
```sql
SELECT product_type, SUM(sale_price), SUM(purchase_price)
FROM Product
GROUP BY product_type;
-- 一个SELECT语句把各类商品的总售价和进货价显示出来
```

#### 创建视图的方法 ####

语法1: 创建视图的CREATE VIEW语句
```sql
CREATE VIEW 视图名称(<视图列名1>, <视图列名2>, ......)
AS
<SELECT语句>
```
>- `SELECT`语句需要书写在`AS`关键字之后.
>- `SELECT`语句中列的排列顺序和视图中列的排列顺序相同, `SELECT`语句中的第1列就是视图中的第1列, `SELECT`语句中的第2列就是视图中的第2列
>- 定义视图时可以使用任何`SELECT`语句, 既可以使用`WHERE`, `GROUP BY`, `HAVING`, 也可以通过`SELECT *`来指定全部列


实例1+2: 通过视图等SELECT语句保存数据
```sql
-- 实例1, 一个SELECT语句把各类商品的总售价和进货价显示出来
SELECT product_type, SUM(sale_price), SUM(purchase_price)
FROM Product
GROUP BY product_type;

-- 把实例1的语句变成一个VIEW
CREATE VIEW Product_Price_Summary (product_type, sale_sum, purchase_sum)
AS
SELECT product_type, SUM(sale_price), SUM(purchase_price)
FROM Product
GROUP BY product_type;

-- 实例2, ProductSum视图
CREATE VIEW ProductSum (product_type, cnt_product)
AS
SELECT product_type, COUNT(*)
FROM Product
GROUP BY product_type;
```

实例3: 使用视图(和查询表一样的)
```sql
SELECT product_type, cnt_product
FROM ProductSum;
```
>- 需要频繁进行汇总时, 就不用每次都使用`GROUP BY`和`COUNT`函数写`SELECT`语句来从`Product`表中取得数据了.
>- 创建出视图之后, 就可以通过非常简单的`SELECT`语句, 随时得到想要的汇总结果.
>- Product表中的数据更新之后, 视图也会自动更新, 非常灵活方便

**注: 在Jetbrains IDE中, table和view会被区分在两个子路径内**

使用视图的查询
1. 首先执行定义视图的`SELECT`语句(从原表获得)
2. 根据得到的结果, 再执行在`FROM`子句中使用视图的`SELECT`语句(从本视图中获得)
    - 也就是说, 使用视图的查询通常需要执行至少2条以上的`SELECT`语句
    - 因为可以在视图中再创建子视图, 从而得到多重视图
        - 虽然语法上没有错误, 但是我们还是应该尽量避免在视图的基础上创建视图.
        - 对多数DBMS来说, 多重视图会降低SQL的性能


实例4: 视图ProductSumJim (从ProductSum视图中再分离一个纯办公用品的视图)
```sql
CREATE VIEW ProductSumJim (product_type, cnt_product)
AS
SELECT product_type, cnt_product
FROM ProductSum
WHERE product_type = '办公用品';
```

#### 视图的限制1 - 定义视图时不能使用ORDER BY子句 ####
