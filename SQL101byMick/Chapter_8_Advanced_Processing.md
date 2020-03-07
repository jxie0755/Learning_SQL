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


