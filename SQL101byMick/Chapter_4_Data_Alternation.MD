# SQL 101 by Mick #
## Chapter 4 数据更新 ##

学习重点:
- 使用`INSERT`语句可以向表中插入数据(行). 原则上, 语句每 次执行一行数据的插入.
- 将列名和值用逗号隔开, 分别括在`()`内, 这种形式称为清单.
- 对表中所有列进行`INSERT`操作时可以省略表名后的列清单.
- 插入`NULL`时需要在`VALUES`子句的值清单中写入`NULL`.
- 可以为表中的列设定默认值(初始值), 默认值可以通过在`CREATE TABLE`语句中为列设置`DEFAULT`约束来设定.
- 插入默认值可以通过两种方式实现，即在`INSERT`语句的`VALUES`子句中指定`DEFAULT`关键字(显式方法), 或省略列清单(隐式方法).
- 使用 `INSERT... SELECT`可以从其他表中复制数据.


---
### 4-1 数据的插入 ###

首先创建一个空表ProductIns用于试验:
```sql
CREATE TABLE ProductIns
(product_id      CHAR(4)      NOT NULL,
 product_name    VARCHAR(100) NOT NULL,
 product_type    VARCHAR(32)  NOT NULL,
 sale_price      INTEGER      DEFAULT 0,
 purchase_price  INTEGER,
 regist_date     DATE,
 PRIMARY KEY (product_id));
```

#### INSERT语句基本语法 ####
```sql
INSERT INTO <表名> (列1, 列2, 列3 , ...) 
VALUES 
    (值1, 值2, 值3, ...);
```

实例: 插入一条数据
```sql
INSERT INTO ProductIns
    (product_id, product_name, product_type, sale_price, purchase_price, regist_date)
VALUES ('0001', 'T恤衫', '衣服', 1000, 500, '2009-09-20');
```
>- 将列名和值用逗号隔开，分别括在`()`内，这种形式称为清单
>- 其中列与值得顺序必须对应起来
>    - 如果没有值, 且没有规定为`NOT NULL`则需要用`null`来填补空缺
>- 原则上, 执行一次`INSERT`语句则会插入一行数据


#### 列清单的省略 ####

对表进行全列 INSERT 时，可以省略表名后的列清单:
```sql
INSERT INTO ProductIns 
VALUES ('0005', '高压锅', '厨房用具', 6800, 5000, '2009-01-15');
```

**注意, 这里列的顺序, 取决于创建列表时的顺序, 数据库软件可以修改列表的中列的显示顺序, 但是这个顺序可能未必是真实顺序, 但是使用清单式就不会出现这样的问题**

引申:
如果创建一个`TABLE`后, 再想添加列或者改变列的顺序, 是无法直接实现的. 可行的方法有:

> https://stackoverflow.com/a/23837910/8435726
> 1. You can do it by creating a new table, copy all the data over, drop the old table, then renaming the new one to replace the old one
> 2. You could also add new columns to the table, copy the column by column data over, drop the old columns, then rename new columns to match the old ones


#### 插入NULL ####

`INSERT`语句中想给某一列赋予`NULL`值时，可以直接在`VALUES`子句的值清单中写入`NULL`
- 想要插入`NULL`的列一定不能设置`NOT NULL`约束


#### 插入默认值 ####

在创建`TABLE`的时候, 可以向表中插入默认值(初始值)
- 通过设置`DEFAULT`来约束

实例: 在创建`ProductIns`这个列表时,`sale_price`这列就有一个默认为0的初始值
```sql
CREATE TABLE ProductIns
(略
 sale_price      INTEGER      DEFAULT 0,
 略
 PRIMARY KEY (product_id));,
```

如果在创建`TABLE`时赋予了默认值, 那么插入数据时也可以插入默认值

实例: 显式方法插入默认值
```sql
INSERT INTO productins
    (product_id, product_name, product_type, sale_price, purchase_price, regist_date)
VALUES ('0007', '擦菜板', '厨房用具', DEFAULT, 790, '2009-04-28');
```
>- 在对应`sale_price`列的值区插入`DEFAULT`

实例: 隐式方法插入默认值

```sql
INSERT INTO productins
    (product_id, product_name, product_type, purchase_price, regist_date)
VALUES ('0007', '擦菜板', '厨房用具', 790, '2009-04-28');
```
>- 把`sale_price`列过滤掉,把对应的`DEFAULT`也直接略过
>- 不建议这么做, 容易引起混乱


实例: 列清单的省略之后必须用显示方法
```sql
INSERT INTO productins
VALUES ('0007', '擦菜板', '厨房用具', DEFAULT, 790, '2009-04-28');
```
>- 此处写入`DEFAULT`: 插入默认值成功


```sql
INSERT INTO productins
VALUES ('0007', '擦菜板', '厨房用具', 790, '2009-04-28');
>>> ERROR
```
>- 此处省略`DEFAULT`: 插入默认值失败


实例: 未设定默认值
```sql
INSERT INTO productins (product_id, product_name, product_type, sale_price, regist_date)
VALUES ('0008', '圆珠笔', '办公用品', 100, '2009-12-12');
```
>- 如果省略一个列, 也不赋值, 会自动设成默认值,如果不存在默认值,则会赋予`NULL`值

```sql
INSERT INTO productins (product_id, product_type, sale_price, purchase_price, regist_date)
VALUES ('0008', '办公用品', 1000, 500, '2009-12-12');
```
> - 但是如果省略的列是被设为`NOT NULL`的话就会出错


#### 从其他表中复制数据 ####

除了使用`VALUES`子句指定具体的数据之外, 还可以从其他表中复制数据

实例: 创建一张复制的表格

```sql
-- 首先创建一个和原Product表一样的空表格, 只是改了名字叫做ProductCopy
CREATE TABLE ProductCopy
(product_id CHAR(4) NOT NULL,
product_name VARCHAR(100) NOT NULL,
product_type VARCHAR(32) NOT NULL,
sale_price     INTEGER,
purchase_price INTEGER,
regist_date      DATE,
PRIMARY KEY (product_id));
```

```sql
-- 然后将Product表中的数据复制到ProductCopy表中
INSERT INTO ProductCopy (product_id, product_name, product_type,sale_price, purchase_price, regist_date)
SELECT product_id, product_name, product_type, sale_price, purchase_price, regist_date
FROM Product;
```
>- 先`INSERT`然后再`SELECT...FROM...`




---
### 4-2 数据的删除 ###






---
### 4-3 数据的更新 ###






---
### 4-4 事务 ###
