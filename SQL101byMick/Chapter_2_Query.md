# SQL 101 by Mick #
## Chapter 2 查询基础 ##

---
### 2-1 SELECT 语句基础 ###

学习重点:
- 使用`SELECT`语句从表中选取数据.
- 为列设定显示用的别名.
- `SELECT`语句中可以使用常数或者表达式.
- 通过指定`DISTINCT`可以删除重复的行.
- SQL语句中可以使用注释.
- 可以通过`WHERE`语句从表中选取出符合查询条件的数据.

#### 列的查询 ####
- 从表中选取数据使用`SELECT`语句
- 通过`SELECT`语句查询并选取必要数据的过程叫匹配查询(Qu- ery)
- `SELECT`语句石SQL中使用最多的最基本的语句

语法1: `SELECT`语句
- 两个子句(clause)
    - `SLECT` 列举列的名称
    - `FROM`  指定表的名称
```sql
SELECT <列名>, ...
FROM <表名>;
```


实例1: 从Product表中输出3列
```sql
SELECT product_id, product_name, purchase_price
    FROM Product;
```
> - 用逗号`,`分隔多列
> - 列的顺序和`SELECT`子句中顺序相同(不一定,但可以额外设置)
> - 列中的数据没有固定的顺序

#### 查询所有列 ####

语法2: 查询所有列
> - `*`号代表所有
> - 使用`*`就没没法设定顺序? 此时按照`CREATE TABLE`语句排序
```sql
SELECT *
FROM <表名>
```


实例2: 输出Product表中全部的列
```sql
SELECT *
FROM Product;
```

注意:
- SQL可以随意使用换行
- 但是不要插入空行

实例3: 与代码清单2-2具有相同含义的SELECT语句
```sql
SELECT product_id, product_name, product_type, sale_price,
purchase_price, regist_date
FROM Product;
```

#### 为列设定别名 ####

实例4+5: 为列设定别名
```sql
SELECT product_id     AS id,
       product_name   AS name,
       purchase_price AS "进货价格"
FROM Product;
```
> - 这样在显示出来的table中,列名就被换成了别名
> - 使用中文时注意使用双引号`"中文"`
>    - Jetbrains的IDE貌似不需要


#### 常数的查询 ####

实例6: 查询常数
```sql
SELECT '商品' AS string, 38 AS number, '2009-02-24' AS date,
        product_id, product_name
FROM Product;
```
> - 这样使用常数时, 临时新增了`string`, `number`和`date`三个列
> - 每个列都全部填满了语句中的常数


#### 删除重复行 ####

实例7+8: 使用DISTINCT删除product_type列中重复的数据
```sql
SELECT DISTINCT purchase_price
FROM Product;
```
> - 这样就会显示无重复的列数据
> - `NULL`也会被视为一类数据


实例9: 在多列之前使用DISTINCT
```sql
SELECT DISTINCT product_type, regist_date
FROM product;
```
> - `DISTINCT` 必须用在第一个列名之前
> - 这里`product_type`出现重复, 因为他们`regist_date`不同个
>    - 所以`DISTINCT`多个类, 只要有一列不同, 就算不同
>    - 也就是只有两行中所有列的数据都相同才会被合并


#### WHERE 语句 ####
语法3: 通过使用`WHERE`添加选择条件
```sql
SELECT <列名>, ...
FROM <表名>
WHERE <条件表达式>;
```

实例10: 选取品类为`衣服`的记录
```sql
SELECT product_name, product_type
FROM Product
WHERE product_type = '衣服';
```

实例11: 也可以不选取出作为查询条件的列
```sql
SELECT product_name
FROM Product
WHERE product_type = '衣服';
```

实例12: 随意改变子句的书写顺序会造成错误
```sql
SELECT product_name, product_type
WHERE product_type = '衣服'
FROM Product;
>>> Error Message
```

实例13+14+15+16: 单行与多行注释
```sql
-- 本SELECT语句会从结果中删除重复行.
SELECT DISTINCT product_id, purchase_price
FROM Product; -- really?

SELECT DISTINCT product_id, purchase_price
/* 本SELECT语句, 
会从结果中删除重复行 */
FROM Product;
```
> - 注释可插入在任何地方, 甚至末尾
> - 未必筛选的信息需要被`SELECT`
> - `WHERE`必须在`FROM`之后


---
### 2-2 算术运算符和比较运算符 ###

学习重点:
- 运算符就是对其两边的列或者值进行运算(计算或者比较大小等)的符号.
- 使用算术运算符可以进行四则运算.
- 括号可以提升运算的优先顺序(优先进行运算).
- 包含`NULL`的运算, 其结果也是`NULL`.
- 比较运算符可以用来判断列或者值是否相等, 还可以用来比较大小.
- 判断是否为`NULL`, 需要使用`IS NULL`或者`IS NOT NULL`运算符.

#### 算术运算符 ####

实例17: 在显示数据时,对数据进行运算处理
```sql
SELECT 
    product_name, 
    sale_price AS "original_sale_price",
    sale_price * 2 AS "sale_price_x2"
FROM Product;
```
> - 主要运算符包括`+`, `-`, `*`, `/`
> - 支持使用括号作为运算优先级的法则
> - 只要数据中存在`NULL`, 任何`NULL`参与的运算结果都是`NULL`
>    - 甚至是`NULL / 0`

实例, 直接使用SQL中的`SELECT`进行简单运算
```sql
SELECT (100+200)*3 AS calculation;
```
> - 但是这个操作并不常用
> - 并不是每种数据库都允许省略`FROM`的使用


#### 比较运算符 ####

实例18+19+20: 选出sale_price等于/不等于500 + 大于等于1000的记录
```sql
SELECT product_name, product_type
FROM Product
WHERE sale_price = 500;   -- 等于
WHERE sale_price <> 500;  -- 不等于
WHERE sale_price >= 1000;  -- 如题
```

SQL中的Boolean比较符
- `=` 等于
- `<>` 不等于
- `<` 小于
- `>` 大于
- `<=` 小于等于
- `>=` 大于等于

实例21: 日期的比较
```sql
SELECT product_name, product_type, regist_date 
FROM Product 
WHERE regist_date < '2009-09-27';
```

实例22: WHERE子句的条件表达式中也可以使用计算表达式
```sql
SELECT product_name, sale_price, purchase_price
FROM Product
WHERE sale_price - purchase_price >= 500;
```

实例extra
```sql
'2009-09-01' < regist_date < '2009-09-20';  -- WRONG
regist_date < '2009-09-20' AND regist_date > '2009-09-01'; -- RIGHT
```
> - 连续对比不能连用, 而是要使用`AND`

实例24: 对字符串使用不等号
```sql
SELECT chr
FROM Chars 
WHERE chr > '2';
```
> - 只显示3和222
> - 为什么不显示3,10,11和22?
> - 因为字符按字典顺序排列: 1, 10, 11, 2, 222, 3

实例25: 选取进货单价为2800日元的记录
```sql
SELECT product_name, purchase_price
FROM Product
WHERE purchase_price = 2800;
```

实例26: `NULL`不能被比较
```sql
SELECT product_name, purchase_price
FROM Product
WHERE purchase_price <> 2800;
```
> - 由于`叉子`和`圆珠笔`的`purchase_price`是`NULL`, 所以就算不等于2800也不会被显示

实例27: 选出`NULL`值的行, 仍然失败
```sql
SELECT product_name, purchase_price
FROM Product
WHERE purchase_price = NULL;
```
> - 使得`purchase_price = NULL`同样无法得到`叉子`和`圆珠笔`

实例28: 选出`NULL`值的正确方式:
```sql
SELECT product_name, purchase_price
FROM Product
WHERE purchase_price IS NULL;
```
> - 使用`IS NULL`
> - 反之, 使用`IS NOT NULL`


---
### 2-3 逻辑运算符 ###

学习重点:
- 通过使用逻辑运算符, 可以将多个查询条件进行组合.
- 通过`NOT`运算符可以生成"不是~"这样的查询条件.
- 两边条件都成立时, 使用`AND`运算符的查询条件才成立.
- 只要两边的条件中有一个成立使用`OR`运算符的查询条件就可以成立. 值可以归结为真(`TRUE`)和假(`FALSE`)其中之一的值称为真值. 比较运 算符在比较成立时返回真, 不成立时返回假. 但是, 在SQL中还存在另外一个特定的真值--不确定(`UNKNOWN`).
- 将根据逻辑运算符对真值进行的操作及其结果汇总成的表称为真值表.
- SQL中的逻辑运算是包含对真, 假和不确定进行运算的三值逻辑.

#### NOT 运算符 ####

- 除了<>表示不等于
- 还有NOT, 使用范围更广
- 不能单独使用, 需要和其他条件组合
- 也就是反向的`Boolean`

实例30+31+32: 选取价格小于1000的产品
```sql
SELECT product_name, product_type, sale_price
FROM Product
WHERE sale_price >= 1000;
WHERE NOT sale_price >= 1000;  -- 与上句相反
WHERE sale_price < 1000;  -- 与上句等价
```

#### AND运算符和OR运算符 ####

- 同理于`Boolean`的`and`和`or`
- 短路?

实例33+34: 使用`AND`和`OR`
```sql
SELECT product_name, sale_price
FROM Product
WHERE product_type = '厨房用具' AND sale_price >= 3000;
WHERE product_type = '厨房用具' OR sale_price >= 3000;
```


#### 通过括号强化处理 ####

实例35: 通过括号改变评价顺序
```sql
SELECT product_name, product_type, regist_date
FROM Product
WHERE 
product_type = '办公用品'
  AND 
(regist_date = '2009-09-11' OR regist_date = '2009-09-20');
```

实例36: 通过使用括号让OR运算符先于AND运算符执行
```sql
SELECT product_name, product_type, regist_date
FROM Product
WHERE product_type = '办公用品' AND (regist_date = '2009-09-11' OR regist_date = '2009-09-20');
```

#### 逻辑运算符和真值 ####

- 略

#### 含有NULL时的真值 ####

- `NULL`其实算UNKNOWN, 除了`TRUE`和`FALSE`以外的第三种逻辑
- 一般编程语言都是二值逻辑, 只有SQL使用三值逻辑
- 所以不论`TRUE`还是`NOT TRUE`都不会显示`NULL`的值
