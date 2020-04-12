# SQL 101 by Mick #
## Chapter 8 SQL高阶处理 ##


---
### 8-1 窗口函数 ###

学习重点:
- 口函数可以进行排序、生成序列号等一般的 操作。
- 理解 PARTITION BY 和 ORDER BY 这两个关键字的含义十分重要。


#### 什么是窗口函数 ####

窗口函数也称为OLAP函数, 全称是Online Analytical Processing, 意思是对数据库进行实时分析处理. 窗口函数就是为了实现OLAP而添加的SQL标准功能.


#### 窗口函数的语法 ####

语法1: 窗口函数
> - 窗口函数大体可以分为以下两种:
>   1. 能够作为窗口函数的聚合函数（`SUM`、`AVG`、`COUNT`、`MAX`、`MIN`）
>      - 将聚合函数书写 在`<窗口函数>`中，就能够当作窗口函数来使用了
>   2. `RANK`、`DENSE_RANK`、`ROW_NUMBER`等专用窗口函数
```sql
<窗口函数> OVER ([PARTITION BY <列清单>]
                        ORDER BY <排序用列清单>)   
```

#### 语法的基本使用方法 - 使用RANK函数 ####

RANK 是用来计算记录排序的函数
≥
实例1/语法2: 根据不同的商品种类, 按照销售单价从低到高顺序创建排序表
> - `PARTITION BY`能够设定排序的对象范围 (就是先把商品根据类型分区)
>   - `PARTITION BY`在横向上对表进行分组
> - `ORDER BY`能够指定按照哪一列、何种顺序进行排序 (也就是在各分区内按照规定排序)
>   - `ORDER BY`决定了纵向排序的规则
> - 通过`PARTITION BY`分组后的记录集合称为窗口。
>   - 此处的窗口并 非“窗户”的意思，而是代表范围。
>   - 这也是“窗口函数”名称的由来。
```sql
SELECT product_name, product_type, sale_price,
       RANK() OVER (PARTITION BY product_type
           ORDER BY sale_price) AS ranking     --- 根据排序结果依次分配序号
FROM product;
```

`RANK`函数的意义在于排好序后, 可以将每行数据分配序号, 方便任意提取第N大的数据


