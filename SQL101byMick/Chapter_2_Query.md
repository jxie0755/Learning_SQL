# SQL 101 by Mick #
## Chapter 2 查询基础 ##


### SELECT 语句基础 ###

#### 列的查询 ####
- 从表中选取数据使用`SELECT`语句
- 通过`SELECT`语句查询并选取必要数据的过程叫匹配查询(Query)
- `SELECT`语句石SQL中使用最多的最基本的语句

`SELECT`基本用法:
```sql
SELECT <列名>, ...
FROM <表名>;
```
- 两个子句(clause)
    - `SLECT` 列举列的名称
    - `FROM`  指定表的名称

实例:
```
SELECT product_id, product_name, purchase_price
    FROM Product;
```
- 用逗号`,`分隔多列
- 列的顺序和`SELECT`子句中顺序相同(不一定,但可以额外设置)
- 列中的数据没有固定的顺序

#### 查询所有列 ####

```sql
SELECT *
FROM <表名>
```
- `*`号代表所有
- 使用`*`就没没法设定顺序? 此时按照`CREATE TABLE`语句排序


**注意:**
- SQL可以随意使用换行
- 但是不要插入空行

#### 为列设定别名 ####
```
SELECT product_id     AS id,
       product_name   AS name,
       purchase_price AS "进货价格"
FROM Product;
```
- 这样在显示出来的table中,列名就被换成了别名
- 使用中文时注意使用双引号`"中文"`
    - Jetbrains的IDE貌似不需要


#### 常数的查询 ####

```
SELECT '商品' AS string, 38 AS number, '2009-02-24' AS date,
        product_id, product_name
FROM Product;
```
- 这样使用常数时, 新增了`string`, `number`和`date`三个列
- 每个列都全部填满了语句中的常数


#### 删除重复行 ####
```
SELECT DISTINCT purchase_price
FROM Product;
```
- 这样就会显示无重复的列数据
- `NULL`也会被视为一类数据

如果出现多个列
```
SELECT DISTINCT product_type, regist_date
FROM product;
```
- `DISTINCT` 必须用在第一个列名之前
- 这里`product_type`出现重复, 因为他们`regist_date`不同个
    - 所以`DISTINCT`多个类, 只要有一列不同, 就算不同
    - 也就是只有两行中所有列的数据都相同才会被合并


#### WHERE 语句 ####
通过使用`WHERE`添加选择条件
```sql
SELECT <列名>, ...
FROM <表名>
WHERE <条件表达式>;
```

实例: 选取品类为`衣服`的记录
```
SELECT product_name, product_type
FROM Product
WHERE product_type = '衣服';
```

```
SELECT product_name
FROM Product
WHERE product_type = '衣服';
```

实例2: 选取价格<=1000的商品
```
SELECT product_name, product_type, sale_price
FROM Product
WHERE sale_price = 1000;
```
- 未必筛选的信息需要被`SELECT`
- `WHERE`必须在`FROM`之后



### 算术运算符和比较运算符 ###

#### 算术运算符 ####

实例: 在显示数据时,对数据进行运算处理
```
SELECT 
    product_name, 
    sale_price AS "original_sale_price",
    sale_price * 2 AS "sale_price_x2"
FROM Product;
```

- 主要运算符包括`+`, `-`, `*`, `/`
- 支持使用括号作为运算优先级的法则
- 只要数据中存在`NULL`, 任何`NULL`参与的运算结果都是`NULL`
    - 甚至是`NULL / 0`

实例, 直接使用SQL中的`SELECT`进行简单运算
```
SELECT (100+200)*3 AS calculation;
```
- 但是这个操作并不常用
- 并不是每种数据库都允许省略`FROM`的使用


#### 比较运算符 ####

实例: 选出sale_price不等于500的记录
```
SELECT product_name, product_type, sale_price
FROM Product
WHERE sale_price <> 1000;
```
- `=` 等于
- `<>` 不等于
- `<` 小于
- `>` 大于
- `<=` 小于等于
- `>=` 大于等于

实例: 日期的比较
```
SELECT product_name, product_type, regist_date 
FROM Product 
WHERE regist_date < '2009-09-27';
```

连续对比不能连用
```
'2009-09-01' < regist_date < '2009-09-20';  -- WRONG
regist_date < '2009-09-20' AND regist_date > '2009-09-01'; -- RIGHT
```

**注意: 对字符串使用不等号**
```
SELECT chr
FROM Chars 
WHERE chr > '2';
-- 只显示3和222
-- 为什么不显示3,10,11和22?
-- 因为字符按字典顺序排列: 1, 10, 11, 2, 222, 3
```

**注意: `NULL`不能被比较**
```
SELECT product_name, purchase_price
FROM Product
WHERE purchase_price <> 2800;
```
- 由于`叉子`和`圆珠笔`的`purchase_price`是`NULL`, 所以就算不等于2800也不会被显示

```
SELECT product_name, purchase_price
FROM Product
WHERE purchase_price = NULL;
```
- 使得`purchase_price = NULL`同样无法得到`叉子`和`圆珠笔`

正确的方式:
```
SELECT product_name, purchase_price
FROM Product
WHERE purchase_price IS NULL;
```
- 使用`IS NULL`
- 反之, 使用`IS NOT NULL`



### 逻辑运算符 ###


#### NOT 运算符 ####

- 除了<>表示不等于
- 还有NOT, 使用范围更广
- 不能单独使用, 需要和其他条件组合
- 也就是反向的`Boolean`

实例: 选取价格小于1000的产品
```
SELECT product_name, product_type, sale_price
FROM Product
WHERE NOT sale_price >= 1000;
```

#### AND运算符和OR运算符 ####

- 同理于`Boolean`的`and`和`or`
- 短路?

实例:
```
SELECT product_name, sale_price
FROM Product
WHERE product_type = '厨房用具' OR sale_price >= 3000;
```


#### 通过括号强化处理 ####

实例: 通过括号改变评价顺序
```
SELECT product_name, product_type, regist_date
FROM Product
WHERE 
product_type = '办公用品'
AND 
(regist_date = '2009-09-11' OR regist_date = '2009-09-20');
```

#### 逻辑运算符和真值 ####

- 略

#### 含有NULL时的真值 ####

- `NULL`其实算UNKNOWN, 除了`TRUE`和`FALSE`以外的第三种逻辑
- 一般编程语言都是二值逻辑, 只有SQL使用三值逻辑
- 所以不论`TRUE`还是`NOT TRUE`都不会显示`NULL`的值
