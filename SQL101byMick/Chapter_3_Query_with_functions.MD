# SQL 101 by Mick #
## Chapter 3 聚合与查询 ##


### 对表进行聚合查询 ###

- 用于汇总的函数成为聚合函数或者聚集函数
- 5个常用函数
    - `COUNT`: 计算行数
    - `SUM`: 求和
    - `AVG`: 求平均值
    - `MAX`: 最大值
    - `MIN`: 最小值


实例: 统计Product列表的行数
```
SELECT COUNT(*)
FROM Product;
```
- `COUNT(*)`统计所有行数
- `COUNT(<列名>)`统计该列非空行的行数

实例: 计算SUM
```
SELECT SUM(sale_price), SUM(purchase_price)
FROM product;
>>> 16780   12210
```

**注意: 包含`NULL`也可以计算,直接忽略(不是等于0)**

实例: 计算AVG
```
SELECT AVG(sale_price), AVG(purchase_price)
FROM Product;
>>> 2097.5  2035
```

实例: 计算AVG
```
SELECT AVG(sale_price), AVG(purchase_price)
FROM Product;
>>> 2097.5  2035
```
**注意: 包含`NULL`也可以计算,直接忽略,平均时也不计入被除总数目N**


实例: 计算MAX和MIN
```
SELECT MAX(sale_price), MIN(purchase_price)
FROM Product;
>>> 6800  320
```

实例: 计算去重后的行数
```
SELECT COUNT(DISTINCT product_type)
FROM Product;
>>> 3  -- 也就是说有三种product type的类型
```
**注意这里得先对product type去重再统计行数**

**注意,如果这一列全是`NULL`, 那么返回的`MAX`,`MIN`,`AVG`也是`NULL`**

### 对表进行分组 ###
