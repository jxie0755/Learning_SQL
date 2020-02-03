#Postgre SQL 语法总结#

---
## Chapter 0 搭建SQL和连接SQL##

---
## Chapter 1 数据库和SQL ##

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
```sql
DROP TABLE <表名>;
```

语法4+5: 表定义的更新使用`ALTER`
- 添加Column使用`ADD COLUMN`
- 删除Column使用`DROP COLUMN`
```sql
ALTER TABLE <表名> ADD COLUMN <列的定义>
ALTER TABLE <表名> DROP COLUMN <列名>;
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
```sql
SELECT <列名>, ...
FROM <表名>;
```

语法2: 查询所有列
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
```sql
SELECT <列名1>, <列名2>, <列名3>, ......
FROM <表名>
GROUP BY <列名1>, <列名2>, <列名3>, ......
HAVING <分组结果对应的条件>
```

语法4: `ORDER BY`语句
```sql
SELECT < 列名 1>, < 列名 2>, < 列名 3>, ...
FROM < 表名 >
ORDER BY < 排序基准列 1>, < 排序基准列 2>, ...
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

---
## Chapter 0 搭建SQL和连接SQL##

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
```sql
DROP TABLE <表名>;
```

语法4+5: 表定义的更新使用`ALTER`
- 添加Column使用`ADD COLUMN`
- 删除Column使用`DROP COLUMN`
```sql
ALTER TABLE <表名> ADD COLUMN <列的定义>
ALTER TABLE <表名> DROP COLUMN <列名>;
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

语法1: `SELECT`语句
```sql
SELECT <列名>, ...
FROM <表名>;
```

语法2: 查询所有列
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
```sql
SELECT <列名1>, <列名2>, <列名3>, ......
FROM <表名>
GROUP BY <列名1>, <列名2>, <列名3>, ......
HAVING <分组结果对应的条件>
```

语法4: `ORDER BY`语句
```sql
SELECT < 列名 1>, < 列名 2>, < 列名 3>, ...
FROM < 表名 >
ORDER BY < 排序基准列 1>, < 排序基准列 2>, ...
```

语法1: `INSERT`的使用
```sql
INSERT INTO <表名> (列1, 列2, 列3 , ...) 
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

