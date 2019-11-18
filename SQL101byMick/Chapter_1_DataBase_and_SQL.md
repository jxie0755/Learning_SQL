# SQL 101 by Mick #
## Chapter 1 数据库和SQL ##


### 数据库 ###

- 将大量数据保存起来，通过计算机加工而成的可以进行高效访数据的数据集合称为数据库（Database， DB）
    - 用来管理数据库的计算机系统称为数据库管理系统 (Database Management System， DBMS)
    - 系统的使用者通常无法直接接触到数据库。因此，在使用系统的时候往往意识不到数据库的存在
    - 文本文件/Excel 局限性
        - 无法多人共享数据
        - 无法提供操作大量数据所需的格式
        - 实现读写自动化需要编程能力
        - 实现读写自动化需要编程能力

#### DBMS的种类 ####

- 层次数据库（Hierarchical Database， HDB）
    - 把数据通过层次结构（树形结构）的方式表现出来
    - 曾经是数据库的主流
- 关系数据库（Relational Database， RDB）
    - 现在应用最广泛的数据库
    - 由行和列组成的二维表来管理数据，所以简单易懂
    - 使用专门的 SQL（StructuredQuery Language，结构化查询语言）对数据进行操作
        - Oracle Database：甲骨文公司的RDBMS
        - SQL Server：微软公司的RDBMS
        - DB2：IBM公司的RDBMS
        - PostgreSQL： 开源的RDBMS
        - MySQL：开源的RDBMS
- 面向对象数据库（Object Oriented Database， OODB
    - 把数据以及对数据的操作集合起来以对象为单位进行管理
- XML数据库（XML Database， XMLDB）
    - 在网络上进行交互的数据的形式逐渐普及起来
    - 对 XML 形式的大量数据进行高速处理
- 键值存储系统（Key-Value Store， KVS）
    - 单纯用来保存查询所使用的主键（Key）和值（Value）的组合的数据库
    - 把它想象成关联数组或者散列（hash）
    - 被应用到 Google 等需要对大量数据进行超高速查询的 Web 服务当中

---
### 数据库的结构 ###

#### RDBMS 常见结构 ####
- 客户端 - 服务器 - 数据库 结构
    - 客户端发送SQL语句给服务器
    - 服务器处理语句，写入或读取数据
    - 返回给客户端
        - 根据SQL语句的内容返回的数据同样必须是二维表的形式

#### 表的结构 ####
- 垂直方向称为 列 / 字段， 列有列名
- 水平方向称为 行 / 记录， 一行则是一条数据
    - 关系数据库必须以行为单位进行数据读写
- 行与列的交叉叫单元格, 一个单元格只能输入一个数据


### SQL ###

#### SQL 语句和类型 ####
- DDL (Data Defnition Language, 数据定义语言)
    - 用于创建或者删除储存数据用的数据库或者表
        - `CREATE`  创建
        - `DROP`    删除
        - `ALTER`   修改
- DML (Data Manipulation Language, 数据操纵语言)
    - 查询或者变更记录
        - `SELECT`  查询
        - `INSERT`  插入
        - `UPDATE`  更新
        - `DELETE`  删除
- DCL (Data Control Language, 数据控制语言)
    - 确认或者取消对数据库中的变更
    - 对RDBMS用户权限进行设定
        - `COMMIT`    确认数据变更
        - `ROLLBACK`  取消数据变更
        - `GRANT`     赋予用户权限
        - `REVOKE`    取消用户权限

**实际使用SQL时, 有90%的语句属于DML**



#### SQL 基本书写规则 ####

- 语句以分号`;`结尾
- 语句不区分大小写, 但是建议
    - 关键字大写
    - 表名首字母大写
    - 其他列名等,全用小写
- 常数的书写方式较为固定
    - 字符串, 使用单引号`'str'`
    - 日期, 也使用单引号', 格式可多种多样
    - 数字, 直接书写
- 单词需要使用空格分隔

---
### 数据库的创建 ###

```sql
CREATE DATABASE <数据库名称>;
```

例如:
```
CREATE DATABASE shop;
```


**注意不同RDBMS中对于`DATABASE`和`SCHEMA`的区别对待方式:**

    MySQL和PostgresSQL数据库结构略有不同:
    - MySQL/Schemas/Table
    - Postgresql/Database/Schemas/Table

    其中psql的database相当于Mysql的Schemas
    所以psql会自动生成一组Schemas
    其中Schemas中的public为默认

[Difference Between Schema / Database in MySQL](https://stackoverflow.com/a/19257781/8435726)
> Depends on the database server.

> MySQL doesn't care, its basically the same thing.

> Oracle, DB2, and other enterprise level database solutions make a distinction. Usually a schema is a collection of tables and a Database is a collection of schemas.

>In MySQL, physically, a schema is synonymous with a database. You can substitute the keyword  SCHEMA instead of DATABASE in MySQL SQL syntax, for example using CREATE SCHEMA instead of  CREATE DATABASE



**注意: postsql没有`USE`命令,不能在sql中切换databse**

[How to indicate in postgreSQL command in which database to execute a script? (simmilar to SQL Server “use” command)](https://stackoverflow.com/a/3909992/8435726)
> PostgreSQL doesn't have the USE command. You would most likely use psql with the --dbname option to accomplish this, --dbname takes the database name as a parameter.

[How to switch databases in postgres?](https://stackoverflow.com/a/43670984/8435726)
> Technically PostgreSQL can't switch databases. You must disconnect and reconnect to the new DB.


**注意: 设定`DATABASE`中的schemas**
```sql
set search_path = "public" -- 默认设为public
```

[How to select a schema in postgres when using psql?](https://stackoverflow.com/a/34098414/8435726)
> And to put the new schema in the path, you could use:
> SET search_path TO myschema;
> Or if you want multiple schemas:
> SET search_path TO myschema, public;


---
### 表的创建 ###
```sql
CREATE TABLE  <表名> (
<列名 1> <数据类型> <该列所需约束>，
<列名 2> <数据类型> <该列所需约束>，
<列名 3> <数据类型> <该列所需约束>，
<列名 4> <数据类型> <该列所需约束>，
    .
    .
    .
<该表的约束 1>，<该表的约束 2>，...）；
```

**约束可以在定义列的时 候进行设置，也可以在语句的末尾进行设置**

实际样本:
```
CREATE TABLE Product
(product_id      CHAR(4)      NOT NULL,
 product_name    VARCHAR(100) NOT NULL,
 product_type    VARCHAR(32)  NOT NULL,
 sale_price      INTEGER ,
 purchase_price  INTEGER ,
 regist_date     DATE ,
 PRIMARY KEY (product_id));
```


#### 命名规则 ####
- 使用:
    - 半角英文
    - 半角数字
    - 下划线 _

- 另外:
    - 名称必须以半角英文字母开头
    - 一个database/schemas之内名称不能重复

#### 数据类型 ####

- `INTEGER`
    - 整数

-`CHAR`
    - 字符串
    - 指定最大长度(两种情况)
        - 字符个数
        - 字节长度
        - 达不到最大长度时用半角空格补足
    - 区分大小写

- `VARCHAR`
    - 可变字符
        - 不到最大长度不会使用半角空格补足

- `DATE`
    - 储存日期
        - 年月日

#### 约束的设置 ####
对列中储存的数据进行限制或者追加条件
- `NOT NULL`
    - Null空白
    - 这里规定不能空白也就是输入数据时必填
- `PRIMARY KEY`
    - 主键约束
    - 通过主键提取一行数据
    - 主键不得重复

---
### 表的更新和删除 ###

**删除Table用`DROP`**
```sql
DROP TABLE <表名>;
```
- 一旦删除则无法恢复
- 执行前务必确认!


**表定义的更新使用`ALTER`**

添加Column:
```sql
ALTER TABLE <表名> ADD COLUMN <列的定义>
```

例如
```
ALTER TABLE product ADD COLUMN product_name_pinyin VARCHAR(100) NOT NULL;
```

删除Column:
```sql
ALTER TABLE <表名> DROP COLUMN <列名>;
```

例如
```
ALTER TABLE product DROP COLUMN product_name_pinyin;
```

改Table名:
```sql
ALTER TABLE <表名>
  RENAME TO <新表名>;
```

改Column名:
```sql
ALTER TABLE <表名>
  RENAME COLUMN <列名> TO <新列名>;
```



#### 向表中插入数据 ####

题头使用
```sql
BEGIN TRANSACTION;
```
**注意: 如果不写,则每条都是单独的`BEGIN TRANSACTION`**
- 如果中间有一条数据出错, 那之前的都被写进去了
- 如果使用`BEGIN TRANSACTION`, 则只要有一个地方出错, 整块都不会被输入
    - 这样就便于管理和避免混乱

随后使用
```sql
INSERT INTO <表名> VALUES (<列1数据>, <列2数据>, <列3数据>, ...)
```

最后使用`COMMIT`, 目的是提交, 使得其他用户能看到变化
```sql
COMMIT;
```
**注意: 不`COMMIT`本用户能看到变化, 但是其他用户看不到**

实例
```
BEGIN TRANSACTION ;
INSERT INTO Product VALUES ('0001', 'T恤' ,'衣服', 1000, 500, '2009-09-20');
INSERT INTO Product VALUES ('0002', '打孔器', '办公用品', 500, 320, '2009-09-11');
INSERT INTO Product VALUES ('0003', '运动T恤', '衣服', 4000, 2800, NULL);
INSERT INTO Product VALUES ('0004', '菜刀', '厨房用具', 3000, 2800, '2009-09-20');
INSERT INTO Product VALUES ('0005', '高压锅', '厨房用具', 6800, 5000, '2009-01-15');
INSERT INTO Product VALUES ('0006', '叉子', '厨房用具', 500, NULL, '2009-09-20');
INSERT INTO Product VALUES ('0007', '擦菜板', '厨房用具', 880, 790, '2008-04-28');
INSERT INTO Product VALUES ('0008', '圆珠笔', '办公用品', 100, NULL, '2009-11-11');
COMMIT ;
```

