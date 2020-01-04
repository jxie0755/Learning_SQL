# SQL 101 by Mick #
## Chapter 3 聚合与查询 ##

---
### 3-1 对表进行聚合查询 ###

- 用于汇总的函数成为聚合函数或者聚集函数
- 5个常用函数
    - `COUNT`: 计算行数
    - `SUM`: 求和
    - `AVG`: 求平均值
    - `MAX`: 最大值
    - `MIN`: 最小值

#### 计算表中数据的行数 ####

实例: 统计Product列表的行数
```
SELECT COUNT(*)
FROM Product;
>>> 8
```
- `COUNT(*)`统计所有行数
- `COUNT(<列名>)`统计该列非空行的行数

#### 计算合计值 ####
 
实例: 计算SUM
```
SELECT SUM(sale_price), SUM(purchase_price)
FROM product;
>>> 16780   12210
```

注意: 
- 包含`NULL`也可以计算,直接忽略(不是等于0)

#### 计算平均值 ####

实例: 计算AVG
```
SELECT AVG(sale_price), AVG(purchase_price)
FROM Product;
>>> 2097.5  2035
# 这里sale price是除以8, 而purchase_price中有两条是NULL, 所以只除以6
```

注意: 
- 包含`NULL`也可以计算,直接忽略,平均时也不计入被除总数目N
- 可以强行把`NULL`包含进去作为分母的一部分,见Chapter 6

#### 计算最大值和最小值 ####

实例: 计算MAX和MIN
```
SELECT MAX(sale_price), MIN(purchase_price)
FROM Product;
>>> 6800  320
```

#### 使用聚合函数结合去重(关键字`DISTINCT`) ####

实例: 计算去重后的行数
```
SELECT COUNT(DISTINCT product_type)
FROM Product;
>>> 3
```

- 也就是说有三种`product_type`的类型: 衣服, 办公用品, 厨房用具

注意:
- 如果这一列全是`NULL`, 那么返回的`MAX`,`MIN`,`AVG`也是`NULL`
- 这里得先对`product_type`去重再统计行数, 如果不这么做:

```
SELECT DISTINCT COUNT(product_type)
FROM Product;
>>> 8
```

- 因为这里面对整列进行统计, 所以得到的是8条完全不同的, 除非有两行完全相同
- 但在这张table里不可能 因为`product_id`是Primary Key主键约束导致不能重复


---
### 3-2 对表进行分组 ###

#### `GROUP BY`子句进行分类 ####

在 `GROUP BY` 子句中指定的列称为聚合键或者分组列

GROUP BY语法:
```
SELECT <列名1>, <列名2>, <列名3>...
FROM <表名>
WHERE
GROUP BY <列名1>, <列名2>, <列名3>...;
```

子句的顺序（暂定）: 
- 书写顺序: `SELECT` → `FROM` → `WHERE` → `GROUP BY`
- 执行顺序: `FROM` → `WHERE` → `GROUP BY` → `SELECT`

实例: 按照商品种类统计数据行数
```
SELECT product_type, COUNT(*)
FROM Product
GROUP BY product_type;
```
解释:
- 这里提取`product_type`的数据列, 然后统计数目
- 前提是必须按照`product_type`分组才能统计, 不然的话会报错, 因为`Count(*)`无法执行.
- 因为是`Count(*) GROUP BY` Something.


#### `GROUP BY`子句中包含`NULL` ####

实例: 如果包含`NULL`
```
SELECT purchase_price, COUNT(*)
FROM Product
GROUP BY purchase_price;
```

注意:
- 这里`NULL`也会作为一个Item被统计, 出现了2次
- `NULL`作为条目可能展示为空白


#### 使用`WHERE` + `GROUP BY` ####

实例: 使用WHERE+ GROUP BY

```
SELECT purchase_price, COUNT(*)
FROM Product
WHERE product_type = '衣服'
GROUP BY purchase_price;
```


#### 使用`GROUP BY`子句的常见错误 ####

在使用 `COUNT` 这样的聚合函数时， `SELECT` 子句中的元素有严格
的限制:
- 常数
- 聚合函数
- `GROUP BY`子句指定的列名(聚合键) (可多选)


错误1: 把聚合键之外的列名书写在 `SELECT` 子句之中
```
SELECT product_name, purchase_price, COUNT(*)  
FROM Product
GROUP BY purchase_price;
```

解释:
- `product_name`并没有存在于`GROUP BY`语句, 也不是常数或者聚合函数
- 原因是, 根据`purchase_price`分组后, 行数减少, 而`product_name`行数没变, 导致不能一一对应

错误2: 在`GROUP BY`子句中写了列的别名
```
SELECT product_type AS pt, COUNT(*)
FROM Product
GROUP BY pt;
```

解释:
- 不应该使用`pt`而是应该保持`product_type`的写法

错误3: `GROUP BY`子句的结果不能排序

解释:
- 实际上分组出来后的显示顺序是**随机**的
- 再次执行可以能顺序不同
- 甚至只要是`SELECT`得语句得到的结果顺序也都是随机的

错误4: 在`WHERE`子句中使用聚合函数
```
SELECT product_type, COUNT(*)
FROM Product
WHERE COUNT(*) = 2
GROUP BY product_type;
```

解释:
- 想要指定选择条件时就要用到 `WHERE` 子句，初学者通常会想到使用这招
- 只有 `SELECT` 子句和 `HAVING` 子句（以及之后将要学到的`ORDER BY` 子句）中能够使用 `COUNT` 等聚合函数

#### 专栏: `DISTINCT` vs.`GROUP BY` ####

以下两端代码等效
```
SELECT DISTINCT product_type
FROM Product;
```

```
SELECT product_type
FROM Product
GROUP BY product_type;
```

- 都会把 `NULL` 作为一个独立的结果返回
- 对多列使用时也会得到完全相同的结果
- 执行速度也基本上差不多 

但其实这个问题本身就是本末倒置的，我们应该考虑的是该 `SELECT` 语是否满足需求
- **想要删除选择结果中的重复记录** 使用`DISTINCT`
- **想要计算汇总结果** 使用`GROUP BY`
- 不使用`COUNT`等聚合函数，而只使用`GROUP BY`子句的`SELECT`语句, 容易产生疑问: 为什么要分组呢?

---
### 3-3 为聚合结果指定条件 ###

