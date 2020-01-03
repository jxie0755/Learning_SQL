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
- 可以强行把NULL包含进去作为分母的一部分,见Chapter 6

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
>>> 3  -- 也就是说有三种product type的类型: 衣服, 办公用品, 厨房用具
```

注意:
- 如果这一列全是`NULL`, 那么返回的`MAX`,`MIN`,`AVG`也是`NULL`
- 这里得先对product type去重再统计行数, 如果不这么做:

```
SELECT DISTINCT COUNT(product_type)
FROM Product;
>>> 8, 因为这里面对整列进行统计, 所以得到的是8条完全不同的, 除非有两行完全相同
  # 但在这张table里不可能 因为product_id是Primary Key主键约束导致不能重复
```

---
### 3-2 对表进行分组 ###

#### 使用`GROUP BY`语句进行汇总 ####

GROUP BY语法:
```
SELECT <列名1>, <列名2>, <列名3>...
FROM <表名>
GROUP BY <列名1>, <列名2>, <列名3>...;
```

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


