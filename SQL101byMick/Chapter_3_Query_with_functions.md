# SQL 101 by Mick #
## Chapter 3 聚合与查询 ##

---
### 3-1 对表进行聚合查询 ###

学习重点:
- 使用聚合函数对表中的列进行计算合计值或者平均值等的汇总操作.
- 通常, 聚合函数会对`NULL`以外的对象进行汇总.
- 但是只有`COUNT`函数例外, 使用`COUNT(*)`可以查出包含`NULL`在内的全部数据的行数.
- 使用`DISTINCT`关键字删除重复值.


- 用于汇总的函数成为聚合函数或者聚集函数
- 5个常用函数
    - `COUNT`: 计算行数
    - `SUM`: 求和
    - `AVG`: 求平均值
    - `MAX`: 最大值
    - `MIN`: 最小值

#### 计算表中数据的行数 ####

实例1: 统计Product列表的行数
```sql
SELECT COUNT(*)
FROM Product;
>>> 8
```
> - `COUNT(*)`统计所有行数
>   - `*`作为参数是`COUNT`函数所特有的, 其他函数并不能将星号作为参数
> - `COUNT(<列名>)`统计该列非空行的行数


#### 计算NULL之外的数据的行数 ####

实例2+3: 计算`NULL`之外的数据的行数
```sql
SELECT COUNT(purchase_price) -- 这样排除NULL值
FROM Product;
```

#### 计算合计值 ####

实例4+5: 计算SUM
```sql
SELECT SUM(sale_price), SUM(purchase_price)
FROM product;
>>> 16780   12210
```
> - 包含`NULL`也可以计算,直接忽略(不是等于0)

#### 计算平均值 ####

实例6+7: 计算AVG
```sql
SELECT AVG(sale_price), AVG(purchase_price)
FROM Product;
>>> 2097.5  2035
-- 这里sale price是除以8, 而purchase_price中有两条是NULL, 所以只除以6
```
> - 包含`NULL`也可以计算,直接忽略,平均时也不计入被除总数目N
> - 可以强行把`NULL`包含进去作为分母的一部分,见Chapter 6

#### 计算最大值和最小值 ####

实例8: 计算MAX和MIN
```sql
SELECT MAX(sale_price), MIN(purchase_price)
FROM Product;
>>> 6800  320
```

实例9: 计算登记日期的最大值和最小值
```sql
SELECT MAX(regist_date), MIN(regist_date)
FROM Product;
```


#### 使用聚合函数结合去重(关键字`DISTINCT`) ####

实例10: 计算去重后的行数
```sql
SELECT COUNT(DISTINCT product_type)
FROM Product;
>>> 3
```
> - 也就是说有三种`product_type`的类型: 衣服, 办公用品, 厨房用具
> - 如果这一列全是`NULL`, 那么返回的`MAX`,`MIN`,`AVG`也是`NULL`
> - 这里得先对`product_type`去重再统计行数, 如果不这么做:

实例11: 先计算数据行数再删除重复数据的结果
```sql
SELECT DISTINCT COUNT(product_type)
FROM Product;
>>> 8
```
> - 因为这里面对整列进行统计, 所以得到的是8条完全不同的, 除非有两行完全相同
> - 但在这张table里不可能 因为`product_id`是Primary Key主键约束导致不能重复

实例12: 使不使用`DISTINCT`时的动作差异(`SUM`函数)
```sql
SELECT SUM(sale_price), SUM(DISTINCT sale_price)
FROM Product;
--- 16780 和 16280, 因为有两个500的值,被去重后只剩下1个
```

实例extra: 如果没有primary key作为区分, 则可以合并那些完全相同的行, 只能被出现一次
```sql
SELECT DISTINCT *
FROM Product_x;
```
> - 这样只会显示2行, 因为A和B全是复制了5次

实例extra: 如何统计Product_x有多少无重复的行呢? 使用复合用法:
```sql
SELECT Count(*)
FROM(SELECT DISTINCT * FROM product_x) as "Filtered_Table";
>>> 12
```
> - 这里必须先生成一张新表而去重
>   - 这张临时表必须要有alias名
>   - 然后再去统计这张表有几行


---
### 3-2 对表进行分组 ###

学习重点
- 使用`GROUP BY`子句可以像切蛋糕那样将表分割. 通过使用聚合函数和`GROUP BY`子句, 可以根据"商品种类"或者"登记日期"等将表分割后再进行汇总.
- 聚合键中包含NULL时, 在结果中会以"不确定"行(空行)的形式表现出来.
使用聚合函数和`GROUP BY`子句时需要注意以下4点.
    1. 只能写在`SELECT`子句之中
    2. `GROUP BY`子句中不能使用`SELECT`子句中列的别名
    3. `GROUP BY`子句的聚合结果是无序的
    4. `WHERE`子句中不能使用聚合函数

#### GROUP BY子句进行分类 ####

在 `GROUP BY` 子句中指定的列称为聚合键或者分组列

语法1: `GROUP BY`语句
```sql
SELECT <列名1>, <列名2>, <列名3>...
FROM <表名>
WHERE
GROUP BY <列名1>, <列名2>, <列名3>...;
```

子句的顺序(暂定):
- 书写顺序: `SELECT` -> `FROM` -> `WHERE` -> `GROUP BY`
- 执行顺序: `FROM` -> `WHERE` -> `GROUP BY` -> `SELECT`

实例13: 按照商品种类统计数据行数
```sql
SELECT product_type, COUNT(*)
FROM Product
GROUP BY product_type;
```
> - 这里提取`product_type`的数据列, 然后统计数目
> - 前提是必须按照`product_type`分组才能统计, 不然的话会报错, 因为`Count(*)`无法执行.
> - 因为是`Count(*) GROUP BY` Something.


#### GROUP BY子句中包含NULL ####

实例14: 如果包含`NULL`
```sql
SELECT purchase_price, COUNT(*)
FROM Product
GROUP BY purchase_price;
```
> - 这里`NULL`也会作为一个Item被统计, 出现了2次
> - `NULL`作为条目可能展示为空白


#### 使用WHERE + GROUP BY ####

语法2: 使用WHERE子句和GROUP BY子句进行汇总处理
```sql
SELECT <列名1>, <列名2>, <列名3>,...
FROM <表名>
WHERE
GROUP BY <列名1>, <列名2>, <列名3>,...;
```

实例15: 使用`WHERE` + `GROUP` BY
```sql
SELECT purchase_price, COUNT(*)
FROM Product
WHERE product_type = '衣服'
GROUP BY purchase_price;
```


#### 使用GROUP BY子句的常见错误 ####

在使用 `COUNT` 这样的聚合函数时,  `SELECT` 子句中的元素有严格
的限制:
- 常数
- 聚合函数
- `GROUP BY`子句指定的列名(聚合键)(可多选)


实例16, 错误1: 把聚合键之外的列名书写在 `SELECT` 子句之中
```sql
SELECT product_name, purchase_price, COUNT(*)
FROM Product
GROUP BY purchase_price;
```
> - `product_name`并没有存在于`GROUP BY`语句, 也不是常数或者聚合函数
> - 原因是, 根据`purchase_price`分组后, 行数减少, 而`product_name`行数没变, 导致不能一一对应

实例17, 错误2: 在`GROUP BY`子句中写了列的别名
```sql
SELECT product_type AS pt, COUNT(*)
FROM Product
GROUP BY pt;
```
> - 不应该使用`pt`而是应该保持`product_type`的写法

错误3: `GROUP BY`子句的结果不能排序
- 实际上分组出来后的显示顺序是**随机**的
- 再次执行可以能顺序不同
- 甚至只要是`SELECT`得语句得到的结果顺序也都是随机的

实例18+19, 错误4: 在`WHERE`子句中使用聚合函数
```sql
SELECT product_type, COUNT(*)
FROM Product
WHERE COUNT(*) = 2
GROUP BY product_type;
```
> - 想要指定选择条件时就要用到 `WHERE` 子句, 初学者通常会想到使用这招
> - 只有 `SELECT` 子句和 `HAVING` 子句(以及之后将要学到的`ORDER BY` 子句)中能够使用 `COUNT` 等聚合函数

#### 专栏: DISTINCT vs. GROUP BY ####

以下两端代码等效
```sql
SELECT DISTINCT product_type
FROM Product;
```

```sql
SELECT product_type
FROM Product
GROUP BY product_type;
```

> - 都会把 `NULL` 作为一个独立的结果返回
> - 对多列使用时也会得到完全相同的结果
> - 执行速度也基本上差不多


但其实这个问题本身就是本末倒置的, 我们应该考虑的是该 `SELECT` 语是否满足需求
- **想要删除选择结果中的重复记录** 使用`DISTINCT`
- **想要计算汇总结果** 使用`GROUP BY`
- 不使用`COUNT`等聚合函数, 而只使用`GROUP BY`子句的`SELECT`语句, 容易产生疑问: 为什么要分组呢?

---
### 3-3 为聚合结果指定条件 ###

学习重点
- 使用`COUNT`函数等对表中数据进行汇总操作时, 为其指定条件的不是`WHERE`子句, 而是`HAVING`子句.
- 聚合函数可以在`SELECT`子句, `HAVING`子句和`ORDER BY`子句中使用.
- `HAVING`子句要写在`GROUP BY`子句之后.
- `WHERE`子句用来指定数据行的条件, 子句用来指定分组的条件.

#### HAVING子句 ####

使用`GROUP BY`分组后, 如何能够单独提取特定的组呢? 使用`HAVING`就可以实现


语法3: `HAVING`语句
> - `HAVING` 子句**必须**写在 `GROUP BY` 子句之后, 其在 DBMS 内部的
> - 执行顺序也排在 `GROUP BY` 子句之后
```sql
SELECT <列名1>, <列名2>, <列名3>, ......
FROM <表名>
GROUP BY <列名1>, <列名2>, <列名3>, ......
HAVING <分组结果对应的条件>
```



实例20+21: 从按照商品种类进行分组后的结果中, 取出"包含的数据行数为2
行"的组
```sql
SELECT product_type, COUNT(*)
FROM Product
GROUP BY product_type
HAVING COUNT(*) = 2;
-- 对比:
SELECT product_type, COUNT(*)
FROM Product
GROUP BY product_type;
```


实例22+23: 销售单价的平均值大于等于2500日元
```sql
SELECT product_type, AVG(sale_price)
FROM Product
GROUP BY product_type;
-- 对比:
SELECT product_type, AVG(sale_price)
FROM Product
GROUP BY product_type
HAVING AVG(sale_price) >= 2500;
```
> - 首先把table按照`product type`分组
> - 然后对每个组的`sale_price`进行平均数计算
> - 最后只显示平均售价超过2500的`product_type`行
> - 不能用`WHERE`应为它是用于对`FROM`的过滤, 在分组之前
> - `HAVING`则是在分组之后的额外过滤手段


额外例子: 统计每种类型的产品有几种价位(`Product_x`)
```sql
SELECT product_type, count(DISTINCT sale_price)
FROM product_x
GROUP BY product_type;
```
> - **此表中, 每种类型的产品有重叠价位, 所以必须要对`COUNT()`的参数使用`DISTINCT`加以区分**


#### HAVING 子句的构成要素 ####

`HAVING`子句中能够使用的3种要素如下所示:
- 常数
- 聚合函数
- `GROUP BY`子句中指定的列名(即聚合键)

实例24, 常见错误:
```sql
SELECT product_type, COUNT(*)
FROM Product
GROUP BY product_type
HAVING product_name = '圆珠笔';
```
> - 此处`product_name`没有包含在`GROUP BY`中, 也不是一个聚合函数


#### 相对于HAVING子句, 更适合写在WHERE子句中的条件 ####

实例25+26: 两组代码得到相同结果:
```sql
SELECT product_type, COUNT(*)
FROM Product
GROUP BY product_type
HAVING product_type = '衣服';
```

```sql
SELECT product_type, COUNT(*)
FROM Product
WHERE product_type = '衣服'
GROUP BY product_type;
```

聚合键所对应的条件还是应该书写在 WHERE 子句之中:
1. 根本原因是 `WHERE` 子句和 `HAVING` 子句的作用不同(个人不认同, 因为要提取衣服的数目, 必须要按类型分组, 再对组进行筛选提取数据更符合逻辑. 不然的话, 筛选行就已经限定类型必须是衣服了, 然后又根据衣服类型来分组是什么意思呢?)
2. `WHERE`和`HAVING`的执行速度有区别
    - 聚合函数可能需要对整个数据进行排序
    - 先使用WHERE可以减少参与排序的数据总量

---
### 3-4 对查询结果进行排序 ###

学习重点:
- 使用`ORDER BY`子句对查询结果进行排序.
- 在`ORDER BY`子句中列名的后面使用关键字`ASC`可以进行升序排序, 使用`DESC`关键字可以进行降序排序.
- `ORDER BY`子句中可以指定多个排序键.
- 排序健中包含`NULL`时, 会在开头或末尾进行汇总.
- `ORDER BY`子句中可以使用`SELECT`子句中定义的列的别名.
- `ORDER BY`子句中可以使用`SELECT`子句中未出现的列或者聚合函数.

ORDER BY 子句中不能使用列的编号.

#### ORDER BY 子句 ####

一般的`SELECT`语句显示出来的结果排序是随机的(就算偶尔显示的时候似乎像是排过序)
在`SELECT`语句末尾添加`ORDER BY`就可以使得显示时强制排序

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


#### 指定升序或降序 ####

默认为升序排列, 如果需要降序则需要使用`DESC`关键字

实例27+28: 按照销售单价由高到低(降序)进行排列 (与上一例排序相反)
```sql
SELECT product_id, product_name, sale_price, purchase_price
FROM Product
ORDER BY sale_price DESC;
```

实例29: 按照销售单价由低到高(升序)进行排列
```sql
SELECT product_id, product_name, sale_price, purchase_price
FROM Product
ORDER BY sale_price;
```


#### 指定多个排序 ####

- 多个排序键则依主次顺序, 先确保按照主列排序, 然后在主列同数值范围内按次列排序
- 规则是优先使用左侧的键, 如果该列存在相同值的话, 再接着参考右侧的键

实例30: 按照销售单价和商品编号的升序进行排序
```sql
SELECT product_id, product_name, sale_price, purchase_price
FROM Product
ORDER BY sale_price, product_id;
```

#### NULL的顺序 ####

实例31: 按照进货单价的升序进行排列
```sql
SELECT product_id, product_name, sale_price, purchase_price
FROM Product
ORDER BY purchase_price;
```
> - **首先要明确不能对`NULL`使用比较符**
> - 不能对`NULL`和数字进行排列
> - 也不能对`NULL`和字符串和日期比较大小
> - NULL会在结果的开头或结尾显示
>   - 按照不同的SQL语言可能有所不同
>       - pSQL中`NULL`会被排在最后

#### 在排序中使用显示用的别名 ####

与`GROUP BY`不得使用别名不同, `ORDER BY`是允许使用别名的
- 一定要记住 `SELECT` 子 句的执行顺序在 `GROUP BY` 子句之后,  `ORDER BY` 子句之前
    - 因此, `GROUP BY`在执行时不理解别名, 因为`SELECT`还没有被执行

实例32: `ORDER BY`子句中可以使用列的别名
```sql
SELECT product_id AS id, product_name, sale_price AS sp, purchase_price
FROM Product
ORDER BY sp, id;
```

#### ORDER BY子句中可以使用的列 ####

由于相同的原因, `ORDER BY`中可以使用的列也不受`SELECT`限制
- `ORDER BY`可以使用`SELECT`中没有包含的列
- `ORDER BY`也还可以使用聚合函数

实例33: `SELECT` 子句中未包含的列也可以在 `ORDER BY` 子句中使用
```sql
SELECT product_name, sale_price, purchase_price
FROM Product
ORDER BY product_id;
```

实例34: `ORDER BY` 子句中也可以使用聚合函数
```sql
SELECT product_type, COUNT(*)
FROM Product
GROUP BY product_type
ORDER BY COUNT(*);
```

#### 不要使用列编号 ####

列编号
- SELECT 子句中的列按照从左到 右的顺序进行排列时所对应的编号(1, 2, 3, ...)

实例35: 不使用列编号与使用列编号
```sql
SELECT product_id, product_name, sale_price, purchase_price
FROM Product
ORDER BY sale_price DESC, product_id;
```

```sql
SELECT product_id, product_name, sale_price, purchase_price
--          1           2            3            4
FROM Product
ORDER BY 3 DESC, 1;
```

虽然列编号使用起来非常方便, 但我们并不推荐使用, 原因有以下两点:
1. 代码阅读起来比较难
2. 这也是最根本的问题, 实际上, 在 SQL-92 A中已经明确指出该排序功能将来会被删除, 随着 DBMS 的版本升级, 可能原本能够正常执行的 SQL 突然就会出错
