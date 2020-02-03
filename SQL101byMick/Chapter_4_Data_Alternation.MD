# SQL 101 by Mick #
## Chapter 4 数据更新 ##

---
### 4-1 数据的插入 ###

学习重点:
- 使用`INSERT`语句可以向表中插入数据(行). 原则上, 语句每 次执行一行数据的插入.
- 将列名和值用逗号隔开, 分别括在`()`内, 这种形式称为清单.
- 对表中所有列进行`INSERT`操作时可以省略表名后的列清单.
- 插入`NULL`时需要在`VALUES`子句的值清单中写入`NULL`.
- 可以为表中的列设定默认值(初始值), 默认值可以通过在`CREATE TABLE`语句中为列设置`DEFAULT`约束来设定.
- 插入默认值可以通过两种方式实现, 即在`INSERT`语句的`VALUES`子句中指定`DEFAULT`关键字(显式方法), 或省略列清单(隐式方法).
- 使用 `INSERT... SELECT`可以从其他表中复制数据.

实例1: 首先创建一个空表ProductIns用于试验:
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

语法1: `INSERT`的使用
```sql
INSERT INTO <表名> (列1, 列2, 列3 , ...) 
VALUES 
    (值1, 值2, 值3, ...);
```

实例2: 插入一条数据
```sql
INSERT INTO ProductIns
    (product_id, product_name, product_type, sale_price, purchase_price, regist_date)
VALUES ('0001', 'T恤衫', '衣服', 1000, 500, '2009-09-20');
```
>- 将列名和值用逗号隔开, 分别括在`()`内, 这种形式称为清单
>- 其中列与值得顺序必须对应起来
>    - 如果没有值, 且没有规定为`NOT NULL`则需要用`null`来填补空缺
>- 原则上, 执行一次`INSERT`语句则会插入一行数据


#### 列清单的省略 ####

实例3: 对表进行全列 INSERT 时, 可以省略表名后的列清单:
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

实例4: purchase_price列中插入NULL
```sql
INSERT INTO ProductIns (product_id, product_name, product_type, sale_price, purchase_price, regist_date) 
    VALUES ('0006', '叉子', '厨房用具', 500, NULL, '2009-09-20');
```
>- `INSERT`语句中想给某一列赋予`NULL`值时, 可以直接在`VALUES`子句的值清单中写入`NULL`
>- 想要插入`NULL`的列一定不能设置`NOT NULL`约束


#### 插入默认值 ####

在创建`TABLE`的时候, 可以向表中插入默认值(初始值)
- 通过设置`DEFAULT`来约束

实例5: 在创建`ProductIns`这个列表时,`sale_price`这列就有一个默认为0的初始值
```sql
CREATE TABLE ProductIns
(略
 sale_price      INTEGER      DEFAULT 0,
 略
 PRIMARY KEY (product_id));,
```

如果在创建`TABLE`时赋予了默认值, 那么插入数据时也可以插入默认值

实例6: 显式方法插入默认值
```sql
INSERT INTO productins
    (product_id, product_name, product_type, sale_price, purchase_price, regist_date)
VALUES ('0007', '擦菜板', '厨房用具', DEFAULT, 790, '2009-04-28');
```
>- 在对应`sale_price`列的值区插入`DEFAULT`

实例7: 隐式方法插入默认值
```sql
INSERT INTO productins
    (product_id, product_name, product_type, purchase_price, regist_date)
VALUES ('0007', '擦菜板', '厨房用具', 790, '2009-04-28');
```
>- 把`sale_price`列过滤掉,把对应的`DEFAULT`也直接略过
>- 不建议这么做, 容易引起混乱


实例extra: 列清单的省略之后必须用显示方法
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


实例8: 未设定默认值
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

实例9: 创建一张复制的表格
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

实例10: 将Product表中的数据复制到ProductCopy表中
```sql
INSERT INTO ProductCopy (product_id, product_name, product_type,sale_price, purchase_price, regist_date)
SELECT product_id, product_name, product_type, sale_price, purchase_price, regist_date
FROM Product;
```
>- 先`INSERT`然后再`SELECT...FROM...`
>   - 简单的说以前就是`INSERT`指定一张表,`VALUE`则是输入一行数据
>   - 现在就是`INSERT`一整列到指定一张表, 而这一列是从另一张表中`SELECT`得来

实例10 extra:
```sql
-- 测试隐式复制, 也可以通过 (ProductCopy2的创建同ProductCopy)
INSERT INTO ProductCopy2  -- 如果是插入全部列, 这里可以省略
SELECT *
FROM Product;

-- 这样则不行:
INSERT INTO ProductCopy2 (*) -- 不需要*号
SELECT *
FROM Product;
```

实例11:尝试一下使用包含 GROUP BY 子句的 SELECT 语句进行插入
```sql
-- 根据商品种类进行汇总的表 : 
CREATE TABLE ProductType
(product_type VARCHAR(32) NOT NULL,
sum_sale_price INTEGER ,
sum_purchase_price INTEGER ,
PRIMARY KEY (product_type));
-- 此表一共三列, 类型, 售价总和 与 买入价总和
```

实例12: 插入全三列, 然后下面的SELECT语句则是从Product表中通过聚合函数得出
```sql
INSERT INTO ProductType (product_type, sum_sale_price, sum_purchase_price)
SELECT product_type, SUM(sale_price), SUM(purchase_price)
FROM Product
GROUP BY product_type;
```



---
### 4-2 数据的删除 ###

学习重点:
- 如果想将整个表全部删除, 可以使用`DROP TABLE`语句, 如果只想删除表中全部数据, 需使用`DELETE`语句.
- 如果想删除部分数据行, 只需在`WHERE`子句中书写对象数据的条件即可. 通过`WHERE`子句指定删除对象的`DELETE`语句称为搜索型`DELETE`语句.


#### DROP TABLE语句和DELETE语句 ####

两种方法删除数据, 区别:
- `DROP TABLE`语句可以将表完全删除
    - `DROP TABLE`语句会完全删除整张表
    - 删除之后再想插入数据, 就必须使用`CREATE TABLE`语句重新创建一张表
- `DELETE`语句会留下表(容器), 而删除表中的全部数据
    - `DELETE`语句在删除数据(行)的同时会保留数据表, 因此可以通过`INSERT`语句再次向表中插入数据


#### DELETE语句的基本语法 ####

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

实例13: 清空Product表
```sql
DELETE FROM Product;
```

#### 指定删除对象的DELETE语句(搜索型DELTE) ####

- 想要删除部分数据行时, 可以像`SELECT`语句那样使用`WHERE`子句指定删除条件.
- 这种指定了删除对象的`DELETE`语句称为搜索型`DELETE`

语法3: 删除部分数据行的搜索型`DELETE`
- `WHERE`子句的书写方式与此前介绍的`SELECT`语句完全一样
```sql
DELETE FROM <表名>
WHERE <条件>;
```

实例14: 删除销售单价(sale_price)大于等于4000日元的数据
```sql
DELETE FROM Product
WHERE sale_price >= 4000;
```

注意, 与`SELECT`语句不同的是, `DELETE`语句中:
- 只能使用`WHERE`子句
- 不能使用`GROUP BY`, `HAVING`和`ORDER BY`三类子句, 它们起不到什么作用
    - `GROUP BY`和`HAVING`是从表中选取数据时用来改变抽取数据形式的
    - `ORDER BY`是用来指定取得结果显示顺序的.


#### 专栏: 删除和舍弃 ####

只能删除表中全部数据的`TRUNCATE`语句
```sql
TRUNCATE <表名>;
-- 对等于:
DELETE FROM <表名> WHERE TRUE;   -- psql要求DELETE必须带有WHERE命令, 不然会出提示, 可以强制执行
```
>- 标准SQL中用来从表中删除数据的只有`DELETE`语句
>- 但是, 很多数据库产品中还存在另外一种被称为`TRUNCATE`的语句.
>   - 这些产品主要包括 Oracle, SQL Server, PostgreSQL, MySQL和DB2
>- 实际上, `DELETE`语句在DML语句中也属于处理时间比较长的
>   - 因此需要删除全部数据行时, 使用`TRUNCATE`可以缩短执行时间
>   - 产品不同需要注意的地方也不尽相同, 在Oracle中, 把`TRUNCATE`定义为DDL, 而不是DML
>   - 使用`TRUNCATE`时, 请大家仔细阅读使用手册, 多加注意. 便利的工具往往还是会存在一些不足之处的


---
### 4-3 数据的更新 (UPDATE语句的使用方法) ###

学习重点:
- 使用`UPDATE`语句可以更改(更新)表中的数据.
- 更新部分数据行时可以使用`WHERE`来指定更新对象的条件. 通过`WHERE`子句指定更新对象的`UPDATE`语句称为搜索型`UPDATE`语句.
- `UPDATE`语句可以将列的值更新为`NULL`.
- 同时更新多列时, 可以在`UPDATE`语句的`SET`子句中, 使用逗号分隔更新对象的多个列.

#### UPDATE语句的基本语法 ####

- 使用 INSERT 语句向表中插入数据之后, 有时却想要再更改数据
- 和`INSERT`语句, `DELETE`语句一样, `UPDATE`语句也属于DML语句

语法4: 改变表中数据的`UPDATE`语句
```sql
UPDATE <表名>
    SET <列名> = <表达式>;
```
>- 将更新对象的列和更新后的值都记述在`SET`子句中

实例15: 将登记日期全部更新为"2009-10-10"
```sql
UPDATE Product
    SET regist_date = '2009-10-10';
```
>- 如果不使用`WHERE`语句的话, 则会对整张表起作用
>   - psql会发出警告, 但是仍然可以强制执行


#### 指定条件的UPDATE语句 (搜索型UPDATE) ####

更新数据时也可以像`DELETE`语句那样使用`WHERE`子句, 这种指定更新对象的`UPDATE`语句称为搜索型`UPDATE`语句

语法5: 更新部分数据行的搜索型`UPDATE`
```sql
UPDATE <表名>
    SET <列名> = <表达式>
WHERE <条件>;
```

实例16: 将商品种类为厨房用具的记录的销售单价更新为原来的10倍
```sql
UPDATE Product
    SET sale_price = sale_price * 10
WHERE product_type = '厨房用具';
```

#### 使用NULL进行更新 ####

使用`UPDATE`也可以将列更新为NULL, 俗称`NULL`清空

实例17: 将商品编号为 0008 的数据(圆珠笔)的登记日期更新为 `NULL`
```sql
UPDATE Product
SET regist_date = NULL 
WHERE product_id = '0008';
```
>- 最快速锁定一行数据的方法显然是锁定primary key的值, 因为它不可重复
>- 此时只需要将赋值表达式右边的值直接写为`NULL`即可
>- 和`INSERT`语句一样, `UPDATE`语句也可以将`NULL`作为一个值来使用
>   - 但是, 只有未设置`NOT NULL`约束和主键约束的列才可以清空为`NULL`

#### 多列更新 ####

`UPDATE`语句的`SET`子句支持同时将多个列作为更新对象

实例18+19: 能够正确执行的繁琐的`UPDATE`语句
```sql
不必写两条UPDATE语句改两个列的数据, 只需要一条UPDATE可以实现多列操作

--第一种方法(比较通用):
UPDATE Product
SET sale_price = sale_price * 10, purchase_price = purchase_price / 2
WHERE product_type = '厨房用具';

--第二种方法(只能在psql和DB2中使用):
UPDATE Product 
SET (sale_price, purchase_price) = (sale_price * 10, purchase_price / 2)
WHERE product_type = '厨房用具';
```


---
### 4-4 事务 ###

学习重点:
- 事务是需要在同一个处理单元中执行的一系列更新处理的集合. 通过使用事务, 可以对数据库中的数据更新处理的提交和取消进行管理.
- 事务处理的终止指令包括`COMMIT`(提交处理)和`ROLLBACK`(取消处理)两种.
- DBMS的事务具有原子性(Atomicity), 一致性(Consistency), 隔离性 (Isolation)和持久性(Durability)四种特性. 通常将这四种特性的首字母结合起来, 统称为ACID特性.
