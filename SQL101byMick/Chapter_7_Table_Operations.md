# SQL 101 by Mick #
## Chapter 7 表的加减法 ##


---
### 7-1 表的加减法 ###

学习重点:
- 集合运算就是对满足同一规则的记录进行的加减等四则运算.
- 使用`UNION`(并集), `INTERSECT`(交集), `EXCEPT`(差集)等集合运算符来进行集合运算.
- 集合运算符可以去除重复行.
- 如果希望集合运算符保留重复行, 就需要使用ALL选项.


#### 什么是集合运算 ####

集合在数学领域表示"(各种各样的)事物的总和"
- 在数据库领域表示记录的集合.
- 具体来说, 表, 视图和查询的执行结果都是记录的集
- 通过集合运算, 可以得到两张表中记录的集合或者公共记录的集合, 又或者其中某张表中的记录的集合. 像这样用来进行集合运算的运算符称为集合运算符


#### 表的加法 - UNION ####

`UNION`就是集合中的并集

实例1+2: 创建表Product2
```sql
-- 注意, Product2表的结构和Product完全相同, 包括product_id作为KEY
CREATE TABLE Product2
(product_id CHAR(4) NOT NULL,
product_name VARCHAR(100) NOT NULL,
product_type VARCHAR(32) NOT NULL,
sale_price INTEGER ,
purchase_price INTEGER ,
regist_date DATE ,
PRIMARY KEY (product_id));

-- 插入数据
BEGIN TRANSACTION;
INSERT INTO Product2 VALUES ('0001', 'T恤衫', '衣服', 1000, 500, '2008-09-20');
INSERT INTO Product2 VALUES ('0002', '打孔器', '办公用品', 500, 320, '2009-09-11');
INSERT INTO Product2 VALUES ('0003', '运动T恤', '衣服', 4000, 2800, NULL);
INSERT INTO Product2 VALUES ('0009', '手套', '衣服', 800, 500, NULL);
INSERT INTO Product2 VALUES ('0010', '水壶', '厨房用具', 2000, 1700, '2009-09-20');
COMMIT;
```


实例3+4: 使用`UNION`对表进行加减法
- `UNION`等集合运算符通常都会除去重复的记录
```sql
SELECT product_id, product_name
FROM Product
UNION
SELECT product_id, product_name
FROM Product2;

-- 使用ORDER BY
SELECT product_id, product_name
FROM Product
WHERE product_type = '厨房用具'
UNION
SELECT product_id, product_name
FROM Product2
WHERE product_type = '厨房用具'
ORDER BY product_id;
```


#### 集合运算的注意事项 ####

集合运算的注意事项
1. 作为运算对象的记录的列数必须相同
2. 作为运算对象的记录中列的类型必须一致
3. 可以使用任何`SELECT`语句, 但`ORDER BY`子句只能在最后使用一次
   - 对集合结果进行全体排序


#### 包含重复行的集合运算 - ALL选项 ####

`UNION`的结果中保留重复行的语法. 其实非常简单, 只需要在`UNION`后面添加`ALL`关键字就可以了

实例5: 保留重复行
```sql
SELECT product_id, product_name
FROM Product
UNION ALL
SELECT product_id, product_name
FROM Product2;
```


#### 选取表中的公共部分 - INTERSECT ####

选取两个记录集合中公共部分的关键字是`INTERSECT`(交集)
- 与使用`AND`可以选取出一张表中满足多个条件的公共部分不同, `INTERSECT`应用于两张表, 选取出它们当中的公共记录

实例6: 使用`INTERSECT`选取出表中公共部分
```sql
SELECT product_id, product_name
FROM Product
INTERSECT
SELECT product_id, product_name
FROM Product2
ORDER BY product_id;
```


#### 记录的减法 - EXCEPT ####

进行减法运算的`EXCEPT`(差集), 其语法也与`UNION`相同

实例7+8: 使用`EXCEPT`对记录进行减法运算
```sql
SELECT product_id, product_name
FROM Product
EXCEPT
SELECT product_id, product_name
FROM Product2
ORDER BY product_id;

-- 互换两张表的顺序结果也不同
SELECT product_id, product_name
FROM Product2
EXCEPT
SELECT product_id, product_name
FROM Product
ORDER BY product_id;
```

---
### 7-2 联结 (以列为单位对表进行联结) ###

学习重点:
- 联结(JOIN)就是将其他表中的列添加过来, 进行"添加列"的集合运算. UNION是以行(纵向)为单位进行操作, 而联结则是以列(横向)为单位进行的.
- 联结大体上分为内联结和外联结两种. 首先请大家牢牢掌握这两种联结的使用方法.
- 请大家一定要使用标准SQL的语法格式来写联结运算, 对于那些过时的或者特定SQL中的写法, 了解一下即可, 不建议使用.

#### 什么是联结 ####

联结(`JOIN`)运算, 简单来说, 就是将其他表中的列添加过来, 进行"添加列"的运算. 期望得到的数据往往会分散在不同的表之中. 使用联结就可以从多张表(3 张以上的表也没关系)中选取数据了


#### 内联结 - INNER JOIN ####

内联结是应用最广泛的联结运算, 可以暂时忽略这个内字


实战内联Product表和ShopProduct表
- 首先分析下两张表
  -  两张表中都包含的列
     -  商品编号
  -  只存在于一张表内的列
     - Product表
       - 商品名称
       - 商品种类
       - 销售单价
       - 进货单价
       - 登记日期
     - ShopProduct表
       - 商店编号
       - 商店名称
       - 数量
- 内联之后, 会合并公共列, 然后其它列就直接连接

实例9: 将Product表和ShopProduct表内联
```sql
SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price
FROM ShopProduct AS SP INNER JOIN Product AS P
ON SP.product_id = P.product_id;
```
> - 内联结要点1 - `FROM`子句
>   - 之前的`FROM`子句中只有一张表, 而这次我们同时使用了ShopProduct和Product两张表
>   - 在 SELECT 子句中直接使用表的原名也没有关系, 但为了SQL语句的可读性, 建议使用别名
> - 内联结要点2 - `ON`子句
>   - 可以在`ON`之后指定两张表联结所使用的列(联结键)
>   - `ON`是专门用来指定联结条件的, 它能起到与 WHERE 相同的作用
>   - 需要指定多个键时, 同样可以使用`AND`, `OR`
>   - 在进行内联结时`ON`子句是必不可少的(如果没有~会发生错误), 并且`ON`必须书写在`FROM`和`WHERE`之间
>     - 也就是说不能平白无故连接两个毫无关联的表, 中间必须要存在一个联结点
>     - 在联结条件也可以使用`=`来记述.
>     - 在语法上, 还可以使用`<=`和`BETWEEN`等谓词
> - 内联结要点3 - `SELECT`子句
>   - 在`SELECT`子句中指定的列要使用使用`<表的别名>.<列名>`的形式来指定列
>     - 只有那些同时存在于两张表中的列必须使用这样的书写方式
>     - 其他的列直接书写列名也不会发生错误
>     - 为了避免混乱, 建议全部按照`<表的别名>.<列名>`

实例10: 内联和`WHERE`子句结合使用`
```sql
-- 如果并不想了解所有商店的情况, 例如只想知道东京店(000A)的信息时:

SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price
FROM ShopProduct AS SP INNER JOIN Product AS P
ON SP.product_id = P.product_id
WHERE SP.shop_id = '000A';  -- 加入WHERE指定
```
> - 像这样使用联结运算将满足相同规则的表联结起来时, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`等工具都可以正常使用

实例extra: 将联结之后的结果想象为新创建出来的一张表, 并存为视图:
```sql
CREATE VIEW ProductJoinShopProduct(shop_id, shop_name, product_id, product_name, sale_price)
AS
SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price
FROM ShopProduct AS SP INNER JOIN Product AS P
ON SP.product_id = P.product_id;
```

#### 外联结 - OUTER JOIN ####

外联结也是通过`ON`子句的联结键将两张表进行联结, 并从两张表中同时选取相应的列的. 基本的使用方法并没有什么不同, 只是结果却有所不同

实例11+12 将两张表进行外联结
```sql
SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price
FROM ShopProduct AS SP RIGHT OUTER JOIN Product AS P
ON SP.product_id = P.product_id;

SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price
FROM Product AS P LEFT OUTER JOIN ShopProduct AS SP
ON SP.product_id = P.product_id;

-- 上两例结果一样, 因为LEFT的左侧和RIGHT的右侧指到了同一张表
```
> - 外联结要点1 - 选取出单张表中全部的信息
>   - 与内联结的结果相比, 不同点显而易见, 那就是结果的行数不一样
>   - 这是一个并集和交集的关系, 内联结属于交集, 外联结类似并集
>   - 多出来的数据
>     - 由于内联结只能选取出同时存在于两张表中的数据
>     - 对于外联结来说, 只要数据存在于某一张表当中, 就能够读取出来
>     - 那些表中不存在的信息我们还是无法得到, 结果中高压锅和圆珠笔的商店编号和商店名称都是 NULL
> - 外联结要点2 - 每张表都是主表吗
>   - 设定主表可以使得主表内所有数据存在于外联结后的结果之中
>     - 此例中由于Product是主表, 所以虽然ShopProduct中没有任何关于高压锅和圆珠笔的记录, 也会在外联时被显示出来.
>     - 若是相反? 在此例中没有意义, 因为商店不可能有商品名单中没有的商品, 只存在"有商品,但是没有店铺在卖"的情况
>   - 指定主表的关键字是`LEFT`和`RIGHT`
>   - 使用`LEFT`时FROM子句中写在左侧的表是主表, 使用`RIGHT`时右侧的表是主表
>   -  `LEFT`和`RIGHT`的功能没有任何区别, 使用哪一个都可以
>      -  通常使用`LEFT`的情况会多一些


#### 3张以上的表的联结 ####

通常联结只涉及2张表
- 但有时也会出现必须同时联结3张以上的表的情况
- 原则上联结表的数量并没有限制

实例13: 创建一个InventoryProduct表并插入数据
```sql
-- 假设商品都保存在P001和P002这2个仓库之中

CREATE TABLE InventoryProduct
( inventory_id CHAR(4) NOT NULL,
product_id CHAR(4) NOT NULL,
inventory_quantity INTEGER NOT NULL,
PRIMARY KEY (inventory_id, product_id));

BEGIN TRANSACTION;
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P001', '0001', 0);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P001', '0002', 120);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P001', '0003', 200);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P001', '0004', 3);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P001', '0005', 0);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P001', '0006', 99);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P001', '0007', 999);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P001', '0008', 200);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P002', '0001', 10);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P002', '0002', 25);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P002', '0003', 34);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P002', '0004', 19);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P002', '0005', 99);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P002', '0006', 0);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P002', '0007', 0);
INSERT INTO InventoryProduct (inventory_id, product_id, inventory_quantity) VALUES ('P002', '0008', 18);
COMMIT;
```


实例14: 对3张表进行内联结
```sql
-- 针对原代码做了小改动, 增加了IP.inventory_id列, 确定了只筛选出P001仓库的货品
SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price, IP.inventory_id, IP.inventory_quantity
FROM ShopProduct AS SP INNER JOIN Product AS P
ON SP.product_id = P.product_id    -- 以上和第一次内联结两张表完全相同
INNER JOIN InventoryProduct AS IP  -- 第二次内联结开始
ON SP.product_id = IP.product_id
WHERE IP.inventory_id = 'P001';
```
> - 外联结也是同理, 但是也要注意`LEFT`和`RIGHT`的处理, 和依次选择主表


#### 交叉联结 - CROSS JOIN ####

第3种联结方式 — 交叉联结(`CROSS JOIN`)
- 其实这种联结在实际业务中并不会使用（笔者使用这种联结的次数也屈指可数)
- 交叉联结是所有联结运算的基础
- 交叉联结本身非常简单，但是其结果有点麻烦

实例15: 将两张表进行交叉联结
```sql
SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name
FROM ShopProduct AS SP CROSS JOIN Product AS P;
```
> - 对满足相同规则的表进行交叉联结的集合运算符是`CROSS JOIN`（笛卡儿积）
> - 进行交叉联结时无法使用内联结和外联结中所使用的`ON`子句
> - 内联结是交叉联结的一部分
>   - “内”也可以理解为“包含在交叉联结结果中的部分”。
>   - “外”可以理解为“交叉联结结果之外的部分”


#### 联结的特定语法和过时语法 ####

SQL 是一门特定语法及过时语法非常多的语言. 使用中一定会碰到需要阅读他人写的代码并进行维护的情况，而那些使用特定和过时语法的程序就会成为我们的麻烦

实例16: 使用过时语法的内联结(与实例10结果相同)
```sql
-- 过时语法:
SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price
FROM ShopProduct SP, Product P
WHERE SP.product_id = P.product_id AND SP.shop_id = '000A';

-- 实例9的标准语法
SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price
FROM ShopProduct AS SP INNER JOIN Product AS P
ON SP.product_id = P.product_id
WHERE SP.shop_id = '000A';
```
> - 这样的书写方式所得到的结果与标准语法完全相同
> - 并且这样的语法可以在所有的DBMS中执行，并不能算是特定的语法，只是过时了而已
> - 不推荐大家使用，理由主要有以下三点:
>   - 使用这样的语法无法马上判断出到底是内联结还是外联结（又或者是其他种类的联结）
>   - 由于联结条件都写在 WHERE 子句之中，因此无法在短时间内分辨出哪部分是联结条件，哪部分是用来选取记录的限制条件
>   - 我们不知道这样的语法到底还能使用多久。每个 DBMS 的开发者都会考虑放弃过时的语法，转而支持新的语法。虽然并不是马上就不能使用了，但那一天总会到来
