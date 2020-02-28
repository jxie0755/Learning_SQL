# SQL 101 by Mick #
## Chapter 6 函数, 谓词, CASE表达式 ##

---
### 6-1 各种各样的函数 ###

学习重点:
- 根据用途, 函数可以大致分为算术函数, 字符串函数, 日期函数, 转换函数和聚合函数
- 函数的种类很多, 无需全都记住, 只需要记住具有代表性的函数就可以了, 其他的可以在使用时再进行查询.


#### 函数的种类 ####

函数大致可以分为以下几种
- 算术函数(用来进行数值计算的函数)
- 字符串函数(用来进行字符串操作的函数)
- 日期函数(用来进行日期操作的函数)
- 转换函数(用来转换数据类型和值的函数)
- 聚合函数(用来进行数据聚合的函数)

聚合函数基本上只包含`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`这5种, 而其他种类的函数总数则超过200种.

#### 算数函数 ####

算术函数是最基本的函数, 加减乘除四则运算
- +(加法)
- -(减法)
- *(乘法)
- /(除法)

实例1: 创建SampleMath表
```sql
CREATE TABLE SampleMath
(m NUMERIC (10,3),
n INTEGER,
p INTEGER);

BEGIN TRANSACTION;
INSERT INTO SampleMath(m, n, p) VALUES (500, 0, NULL);
INSERT INTO SampleMath(m, n, p) VALUES (-180, 0, NULL);
INSERT INTO SampleMath(m, n, p) VALUES (NULL, NULL, NULL);
INSERT INTO SampleMath(m, n, p) VALUES (NULL, 7, 3);
INSERT INTO SampleMath(m, n, p) VALUES (NULL, 5, 2);
INSERT INTO SampleMath(m, n, p) VALUES (NULL, 4, NULL);
INSERT INTO SampleMath(m, n, p) VALUES (8, NULL, 3);
INSERT INTO SampleMath(m, n, p) VALUES (2.27, 1, NULL);
INSERT INTO SampleMath(m, n, p) VALUES (5.555,2, NULL);
INSERT INTO SampleMath(m, n, p) VALUES (NULL, 1, NULL);
INSERT INTO SampleMath(m, n, p) VALUES (8.76, NULL, NULL);
COMMIT;
```
> - NUMERIC 是大多数DBMS都支持的一种数据类型, 通过`NUMBERIC(全体位数,小数位数)`的形式来指定数值的大小
> -  PostgreSQL 中的`ROUND`函数只能使用`NUMERIC`类型的数据, 因此我们在示例中也使用了该数据类型


语法1: `ABS`函数
- 就是求
```sql
ABC(数值)
```

实例2: 计算数值的绝对值
```sql
SELECT m, ABS(m) AS ab_col
FROM SampleMath;
```
> -  ABS 函数的参数为`NULL`时, 结果也是`NULL`.
> -  并非只有`ABS`函数如此, 其实绝大多数函数对于`NULL`都返回`NULL`

语法2: `MOD`函数
- `MOD`是计算除法余数(求余)的函数, 是modulo的缩写
```sql
MOD(被除数, 除数)
```

实例3: 计算除法(n ÷ p)的余数
```sql
SELECT n, p, n/p AS quo_col, MOD(n, p) AS mod_col  -- 额外加了商
FROM SampleMath;
```

语法3: `ROUND`四舍五入
- `ROUND`函数用来进行四舍五入操作. 四舍五入在英语中称为 round.
- 如果指定四舍五入的位数为1, 那么就会对小数点第2位进行四舍五入处理
```sql
ROUND(对象数值, 保留小数的位数)
```

实例4: 对m列的数值进行n列位数的四舍五入处理
```sql
SELECT m, n, ROUND(m, n) AS round_col
FROM SampleMath;
```

#### 字符串函数 ####

算术函数只是SQL(其他编程语言通常也是如此)自带的函数中的一部分. 虽然算术函数是我们经常使用的函数, 但是字符串函数也同样经常被使用.

实例5: 创建SampleStr表
```sql
CREATE TABLE SampleStr
(str1 VARCHAR(40),
str2 VARCHAR(40),
str3 VARCHAR(40));

BEGIN TRANSACTION;
INSERT INTO SampleStr (str1, str2, str3) VALUES ('opx', 'rt', NULL);
INSERT INTO SampleStr (str1, str2, str3) VALUES ('abc', 'def', NULL);
INSERT INTO SampleStr (str1, str2, str3) VALUES ('山田', '太郎', '是我');
INSERT INTO SampleStr (str1, str2, str3) VALUES ('aaa', NULL, NULL);
INSERT INTO SampleStr (str1, str2, str3) VALUES (NULL, 'xyz', NULL);
INSERT INTO SampleStr (str1, str2, str3) VALUES ('@!#$%', NULL, NULL);
INSERT INTO SampleStr (str1, str2, str3) VALUES ('ABC', NULL, NULL);
INSERT INTO SampleStr (str1, str2, str3) VALUES ('aBC', NULL, NULL);
INSERT INTO SampleStr (str1, str2, str3) VALUES ('abc太郎', 'abc', 'ABC');
INSERT INTO SampleStr (str1, str2, str3) VALUES ('abcdefabc', 'abc', 'ABC');
INSERT INTO SampleStr (str1, str2, str3) VALUES ('micmic', 'i', 'I');
COMMIT;
```


语法4: `||`拼接
- 在实际业务中, 我们经常会碰到abc + de = abcde这样希望将字符串进行拼接的情况.
- 在SQL中, 可以通过由两条并列的竖线变换而成的`||`函数来实现
- 只要存在`NULL`, 则输出`NULL`, SQL不会拼接任何`str+NULL`
- `||`函数在SQL Server(`+`)和MySQL(`CONCAT`)中无法使用
```sql
字符串1||字符串2
```

实例6+7: 拼接两个/三个字符串(str1+str2)
```sql
SELECT str1, str2, str1||str2 AS str_concat
FROM SampleStr;

SELECT str1, str2, str3, str1||str2||str3 AS str_concat
FROM SampleStr
WHERE str1 = '山田';
```

语法5: `LENGTH`函数计算字符串长度
```sql
LENGTH(字符串)
```

实例8: 计算字符串长度
```sql
SELECT str1, LENGTH(str1) AS len_str
FROM SampleStr;
```

语法6: `LOWER`函数小写转换
- 只能针对英文字母使用, 它会将参数中的字符串全都转换为小写
- 混合型字符串只变化大写字符部分
- 并不影响原本就是小写的字符
```sql
LOWER(字符串)
```

实例9: 大写转换为小写
```sql
SELECT str1, LOWER(str1) AS low_str
FROM SampleStr
WHERE str1 IN ('ABC', 'aBC', 'abc', '山田');
```

语法7: `REPLACE`函数字符串的替换
- 这里有一个要求就b必须存在于a里面, 才会把a中的b部分替换成c
    - 不然的话, 不存在替换动作, 返回的还是a本身
    - 如果a中存在多个b部分, 则所有b都会被替换成c
```sql
REPLACE(对象字符串, 替换前的字符串, 替换后的字符串)
--          a         b           c
```

实例10: 替换字符串的一部分
```sql
SELECT str1, str2, str3, REPLACE(str1, str2, str3) AS rep_str
FROM SampleStr;
```

语法8: `SUBSTRING`函数(PostgreSQL/MySQL专用语法)
- 截取的起始位置从字符串最左侧开始计算
- 注意index从1开始, 不为0
```sql
SUBSTRING(对象字符串 FROM 截取的起始位置 FOR 截取的字符数)
--           str          index           长度
```

实例11: 截取出字符串中第3位和第4位的字符
```sql
SELECT str1, SUBSTRING(str1 FROM 3 FOR 2) AS sub_str
FROM SampleStr;
```


语法9: `UPPER`函数大写转换
- 只能针对英文字母使用, 它会将参数中的字符串全都转换为大写
- 混合型字符串只变化小写字符部分
- 并不影响原本就是大写的字符
```sql
UPPER(字符串)
```

实例12: 将小写转换为大写
```sql
SELECT str1, UPPER(str1) AS up_str
FROM SampleStr
WHERE str1 IN ('ABC', 'aBC', 'abc', '山田');
```

#### 日期函数 ####

语法10: `CURRENT_DATE`函数
- `CURRENT_DATE`函数能够返回SQL执行的日期, 也就是该函数执行时的日期.
- 由于没有参数, 因此无需使用括号行时的时间
```sql
CURRENT_DATE
```

实例13: 获得当前日期
```sql
SELECT CURRENT_DATE;
```


语法11: `CURRENT_TIME`函数
- `CURRENT_TIME`函数能够取得SQL执行的时间, 也就是该函数执行时的时间
```sql
CURRENT_TIME;
```

实例14: 取得当前时间
```sql
SELECT CURRENT_TIME;
```
> - 这里返回的是GMT时间


语法12: `CURRENT_TIMESTAMP`函数
- `CURRENT_TIMESTAMP`函数具有`CURRENT_DATE` + `CURRENT_TIME`的功能.
- 使用该函数可以同时得到当前的日期和时间
- 当然也可以从结果中截取日期或者时间
```sql
CURRENT_TIMESTAMP
```

实例15: 取得当前日期和时间
```sql
SELECT CURRENT_TIMESTAMP;
```
> - 这里返回的是GMT日期和时间


语法13: `EXTRACT`函数
- 使用`EXTRACT`函数可以截取出日期数据中的一部分,  例如"年" "月", 或者"小时""秒"等
- 该函数的返回值并不是日 期类型而是数值类型
- `EXTRACT`函数不能独立使用, 必须用在一条SELECT命令之后
- `EXTRACT`函数不能提取出时区信息, 因为在psql中所有时区信息都会被转换成UTC时间记录下来, 所以没有独立的时区信息被保留
```sql
-- 批量
SELECT 列名 as D
    EXTRACT(日期元素 FROM D)

-- 单独
SELECT EXTRACT(日期元素 FROM TIMESTAMP 'YYYY-MM-DD HH-MM-SS.123456')
```

实例16: 截取日期元素
```sql
SELECT CURRENT_TIMESTAMP,
    EXTRACT(YEAR FROM CURRENT_TIMESTAMP) AS year,      -- 2010
    EXTRACT(MONTH FROM CURRENT_TIMESTAMP) AS month,    -- 4
    EXTRACT(DAY FROM CURRENT_TIMESTAMP) AS day,        -- 25
    EXTRACT(HOUR FROM CURRENT_TIMESTAMP) AS hour,      -- 19
    EXTRACT(MINUTE FROM CURRENT_TIMESTAMP) AS minute,  -- 7
    EXTRACT(SECOND FROM CURRENT_TIMESTAMP) AS second;  -- 33.987
    
-- 也可以这样独立使用:
SELECT EXTRACT(SECOND FROM timestamptz '2020-02-22 10:52:11.123456-05') AS second;  -- 11.123456
```


#### EXTRA: 时区问题 ####

psql默认给的都是UTC时区, 可以通过修改时区

语法extra: 查询和修改时区
```sql
-- 查询所有时区
SELECT *
FROM pg_timezone_names; -- 位于pg_catalog/views中

-- 查询所在时区有哪些地方
SELECT *
FROM pg_timezone_names
WHERE utc_offset = '+08:00:00';  -- 中国的GMT+8时区

SELECT *
FROM pg_timezone_names
WHERE utc_offset = '-05:00:00';  -- 美国东岸GMT-5时区

-- 调整时区
-- 设置时可以使用pg_timezone_names表中的name或者abbrev作为字符串
-- 注意: 每次在新的Console中都需要设置,设置不是永久在database中保存
SET TIMEZONE = 'UTC';  -- GMT标准时间
SET TIMEZONE = 'EST';  -- 美国东岸时间
SET TIMEZONE = 'CST';  -- 美国中部时间
SET TIMEZONE = 'PST';  -- 美国西岸时间

-- 由于该表中直接有对每个ETC时区的name 例如:
-- name: ETc/GMT-8, abbrev: +08
-- 所以可以直接SET TIMEZONE = '+08'; 或者 SET TIMEZONE = '-05';等等
```

实例: 创建一个测试DATE/TIME的表
```sql
CREATE TABLE Timezonetest
(
    id              char(4)     NOT NULL,
    time_col        time        NOT NULL,
    timetz_col      timetz      NOT NULL,
    timestamp_col   timestamp   NOT NULL,
    timestamptz_col timestamptz NOT NULL,
        PRIMARY KEY (id)
);

-- 插入数据
INSERT INTO Timezonetest VALUES
('10:49:50', '10:49:50-05', '2020-02-22 10:52:00', '2020-02-22 10:52:00-05');

-- 注意, 在表中, 显示出来的四列数据为:
-- 10:49:50,  10:49:50.000000 -05:00, 2020-02-22 10:52:00.000000, 2020-02-22 15:52:00.000000
-- 没有显示毫秒    带毫秒,保留时区-5信息     带毫秒,没有时区信息            带毫秒,直接时间比原数据+5小时, 没有单独显示时区
-- 即使输入带时区的时间戳, postgres底层存的也是转换后的UTC时间. 通过set timezone可以改变了数据库展示时间的方式(带时区)
-- 意思就是说, 输入timestamptz数据时, 应该输入[当地时间+当地时区], 而不是直接输入[GMT时间+修改时区]

-- 提取数据
SET TIMEZONE = '-05';  -- 如果没有这一个设置, 则显示的还是 2020-02-22 15:52:00.000000 (转换后的UTC时间)
SELECT timestamptz_col
FROM Timezonetest
WHERE id = '1';                       -- 显示回当地时间 2020-02-22 10:52:00.000000 -05:00

SET TIMEZONE = '+08';
SELECT timestamptz_col
FROM Timezonetest
WHERE id = '1';                       --显示成北京时间 2020-02-22 23:52:00.000000 +08:00

-- 而没带TZ的类型, 则不管怎么改时区设置, 都是输出一样的, 也就是说没有默认UTC的说法, 是纯粹就是没有时区
SET TIMEZONE = '+08';
SELECT timestamp_col
FROM Timezonetest
WHERE id = '1';                          -- 显示的还是 2020-02-22 10:52:00.000000


-- 直接获取一个日期/时间数据(不用从TABLE)
SELECT time '10:49:50';
SELECT timetz '10:49:50.123456-05';
SELECT timestamp '2020-02-22 10:52:11.123456';
SELECT timestamptz '2020-02-22 10:52:11.123456-05';
```

#### 转换函数 ####

一类比较特殊的函数 -- 转换函数. 虽说有些特殊, 但是由于这些函数的语法和之前介绍的函数类似, 数量也比较少,  因此很容易记忆


语法14: `CAST`函数实现类型转换
- 之所以需要进行类型转换, 是因为可能会插入与表中数据类型不匹配的数据
- 或者在进行运算时由于数据类型不一致发生了错误
- 又或者是进行自动类型转换会造成处理速度低下. 这些时候都需要事前进行数据类型转换
- 将字符串转换为日期 类型时, 从结果上并不能看出数据发生了什么变化, 理解起来也比较困难.
  - 从这一点我们也可以看出, 类型转换其实并不是为了方便用户使用而开发的功能, 而是为了方便DBMS内部处理而开发的功能
```sql
CAST (转换前的值 AS 想要转换的数据类型)
```

实例17+18: 将字符串类型转换为数值类型
```sql
SELECT CAST('0001' AS INTEGER) AS int_col;
SELECT CAST(100 AS VARCHAR) AS char_col;
SELECT CAST('2020-02-20 15:10:33' AS timestamp) AS timestamp_col;
```

语法15: `COALSECE`函数
- `COALESCE`是SQL特有的函数.
- 该函数会返回可变参数A中左侧开始第1个不是`NULL`的值.
- 参数个数是可变的, 因此可以根据需要无限增加.
- 在 SQL 语句中将`NULL`转换 为其他值时就会用到转换函数.
    - 运算或者函数中含有`NULL`时, 结果全都会变为`NULL`.
    - 能够避免这种结果的函数就是 COALESCE
```sql
COALESCE( 数据1, 数据2, 数据3 ...... )
```

实例19+20: 将`NULL`转换为其他值
```sql
SELECT 
    COALESCE(NULL, 1) AS col_1, 
    COALESCE(NULL, 'test', NULL) AS col_2, 
    COALESCE(NULL, NULL, '2009-11-01') AS col_3;
-- 筛选出`1`, `'test'`, `'2009-11-01'`

SELECT COALESCE(str2, 'IT WAS NULL') FROM SampleStr;
-- 把str2这一列中所有的NULL替换成了`'IT WAS NULL'`
```



---
### 6-2 谓词 ###

学习重点:
- 谓词就是返回值为真值的函数.
- 掌握`LIKE`的三种使用方法(前方一致, 中间一致, 后方一致).
- 需要注意`BETWEEN`包含三个参数.
- 想要取得`NULL`数据时必须使用`IS NULL`.
- 可以将子查询作为`IN`和`EXISTS`的参数.


#### 什么是谓词 ####

- 谓词(predicate)是SQL的抽出条件中不可或缺的工具.
- 谓词就是6-1节中介绍的函数中的一种, 是需要满足特定条件的函数, 该条件就是返回值是真值
- 本节将会介绍以下谓词:
  - LIKE
  - BETWEEN
  - IS NULL
  - IS NOT NULL
  - IN
  - EXISTS


#### LIKE谓词 - 字符串的部分一致查询 ####

- 我们使用字符串作为查询条件的例子中使用的都是`=`.
  - `=`只有在字符串完全一致时才为真
- 与之相反, `LIKE`谓词更加模糊,
  - 当需要进行字符串的部分一致查询时需要使用该谓词

实例21: 创建 SampleLike 表
```sql
CREATE TABLE SampleLike
(strcol VARCHAR(6) NOT NULL,
PRIMARY KEY (strcol));

BEGIN TRANSACTION;
INSERT INTO SampleLike (strcol) VALUES ('abcddd');
INSERT INTO SampleLike (strcol) VALUES ('dddabc');
INSERT INTO SampleLike (strcol) VALUES ('abdddc');
INSERT INTO SampleLike (strcol) VALUES ('abcdd');
INSERT INTO SampleLike (strcol) VALUES ('ddabc');
INSERT INTO SampleLike (strcol) VALUES ('abddc');
COMMIT;
```

现在我们想在这张表取出包含`'ddd'`的字符串:
- 前方一致: 与查询对象字符串起始部分相同的记录的查询方法, 必须以`'ddd'`开头
  - 选出`'dddabc'`
- 中间一致: 就是选取出查询对象字符串中含有作为查询条件的字符串的记录的查询方法, 无论前后
- 也就是说中间一致全部包括了前方一致,后方一致和中间一致三种情况, 是最宽容的方法
  - 选出`'abcddd'`, `'dddabc'`, `'abdddc'`
- 后方一致: 与前方一致相反, 结尾必须为`'ddd'`
  - 选出`'abcddd'`
- 使用`%`来表示省略的部分
  - `'ddd%'`表示`'ddd'`开头, 后面不管 (前方一致)
  - `'%ddd%'`表示前后都可以有任何东西, 甚至没有也行, 只要包含`'ddd'`就行 (中间一致)
  - `'%ddd'`表示前面有什么都不重要, 但是结尾必须是`'ddd'` (后方一致)
- 此外, 我们还可以使用`_`(下划线)来代替`%`, 与`%`不同的是, 它代表了"任意1个字符"
  - 这就固定了长度
  - 


实例22+23+24: 使用`LIKE`进行前方/中间/后方一致查询
```sql
-- 前方一致
SELECT *
FROM SampleLike 
WHERE strcol LIKE 'ddd%';

-- 中间一致
SELECT *
FROM SampleLike 
WHERE strcol LIKE '%ddd%';

-- 后方一致
SELECT *
FROM SampleLike 
WHERE strcol LIKE '%ddd';
```

实例25+26: 使用`LIKE`和`_`(下划线)进行后方一致查询
```sql
SELECT *
FROM SampleLike 
WHERE strcol LIKE 'abc__';  -- abc+任意两个字符

SELECT *
FROM SampleLike 
WHERE strcol LIKE 'abc___';  -- abc+任意三个字符
```


#### BETWEEN谓词 - 范围查询 ####

- 使用`BETWEEN`可以进行范围查询.
- 该谓词与其他谓词或者函数的不同之处在于它使用了3个参数.
- 最大特点就是包括两端
  - 如果不想包括两端则需要使用`<`和`>`

实例27 + 28: 选取销售单价为 100~1000 日元的商品
```sql
-- Use BETWEEN
SELECT product_name, sale_price
FROM Product 
WHERE sale_price BETWEEN 100 AND 1000;

--- Use < and >
SELECT product_name, sale_price
FROM Product
WHERE sale_price > 100 AND sale_price < 1000;
```


#### IS NULL, IS NOT NULL - 判断是否为NULL ####

为了选取出某些值为`NULL`的列的数据, 不能使用`=`, 而只能使用特定的谓词`IS NULL`

实例29+30: 选取出进货单价(purchase_price)为/不为`NULL`的商品
```sql
SELECT product_name, purchase_price
FROM Product
WHERE purchase_price IS NULL;

SELECT product_name, purchase_price
FROM Product
WHERE purchase_price IS NOT NULL;
```


#### IN谓词 - OR的简便用法 ####

连续使用太多OR可能会显得代码太长

实例31+32+33: 通过`OR`/`IN`/`NOT IN`指定或者排除多个进货单价进行查询
```sql
-- Use OR
SELECT product_name, purchase_price
FROM Product
WHERE purchase_price = 320 OR purchase_price = 500 OR purchase_price = 5000;

-- Use IN
SELECT product_name, purchase_price
FROM Product
WHERE purchase_price IN (320, 500, 5000); -- 类似python的tuple

-- Use NOT IN
SELECT product_name, purchase_price
FROM Product
WHERE purchase_price NOT IN (320, 500, 5000);
```


#### 使用子查询作为IN谓词的参数 ####

`IN`谓词(`NOT IN`谓词)具有其他谓词所没有的用法, 那就是可以使用子查询作为其参数
- 子查询就是SQL内部生成的表, 因此也可以说"能够将表作为`IN`的参数".
- 同理, 我们还可以说"能够将视图作为`IN`的参数"

实例34: 建ShopProduct(商店商品)表的CREATE TABLE语句
```sql
CREATE TABLE ShopProduct
(shop_id CHAR(4) NOT NULL,
shop_name VARCHAR(200) NOT NULL,
product_id CHAR(4) NOT NULL,
quantity INTEGER NOT NULL,
PRIMARY KEY (shop_id, product_id));  -- 两个主键, 不能同时重复

BEGIN TRANSACTION; ①
INSERT INTO ShopProduct (shop_id, shop_name, product_id, quantity) VALUES ('000A', '东京', '0001', 30);
INSERT INTO ShopProduct (shop_id, shop_name, product_id, quantity) VALUES ('000A', '东京', '0002', 50);
INSERT INTO ShopProduct (shop_id, shop_name, product_id, quantity) VALUES ('000A', '东京', '0003', 15);
INSERT INTO ShopProduct (shop_id, shop_name, product_id, quantity) VALUES ('000B', '名古屋', '0002', 30);
INSERT INTO ShopProduct (shop_id, shop_name, product_id, quantity) VALUES ('000B', '名古屋', '0003', 120);
INSERT INTO ShopProduct (shop_id, shop_name, product_id, quantity) VALUES ('000B', '名古屋', '0004', 20);
INSERT INTO ShopProduct (shop_id, shop_name, product_id, quantity) VALUES ('000B', '名古屋', '0006', 10);
INSERT INTO ShopProduct (shop_id, shop_name, product_id, quantity) VALUES ('000B', '名古屋', '0007', 40);
INSERT INTO ShopProduct (shop_id, shop_name, product_id, quantity) VALUES ('000C', '大阪', '0003', 20);
INSERT INTO ShopProduct (shop_id, shop_name, product_id, quantity) VALUES ('000C', '大阪', '0004', 50);
INSERT INTO ShopProduct (shop_id, shop_name, product_id, quantity) VALUES ('000C', '大阪', '0006', 90);
INSERT INTO ShopProduct (shop_id, shop_name, product_id, quantity) VALUES ('000C', '大阪', '0007', 70);
INSERT INTO ShopProduct (shop_id, shop_name, product_id, quantity) VALUES ('000D', '福冈', '0001', 100);
COMMIT
```
> - 该`CREATE TABLE`语句的特点是指定了 2 列作为主键(primarykey).

实例36: 使用子查询作为IN的参数
```sql
-- 得到大阪店所出售商品的单价
SELECT product_name, sale_price
FROM product
WHERE product_id IN (SELECT product_id
                        FROM shopproduct
                    WHERE shop_id = '000C')
```
> -   既然子查询展开后得到的结果同样是('0003','0004','0006','0007'), 为什么一定要使用子查询呢?
>     - 因为这个语句能应付商店内出售商品的变化, 而不需要更改代码


实例37: 使用子查询作为`NOT IN`的参数
```sql
SELECT product_name, sale_price
FROM Product
WHERE product_id NOT IN (SELECT product_id
                            FROM ShopProduct
                        WHERE shop_id = '000A');
```

#### EXIST谓词 ####

`EXIST`是使用方法特殊而难以理解的谓词, 但是一旦能够熟练使用就能体会到它极大的便利性
1. EXIST 的使用方法与之前的都不相同.
2. 语法理解起来比较困难.
3. 实际上即使不使用`EXIST`, 基本上也都可以使用`IN`(或者`NOT IN`)来代替.

实例38+39+40: 使用`EXIST`选取出"大阪店在售商品的销售单价"
```sql
SELECT product_name, sale_price
    FROM Product AS P                 ---- 
WHERE EXISTS (SELECT *
                FROM ShopProduct AS SP ---
            WHERE SP.shop_id = '000C' AND SP.product_id = P.product_id);
            
-- 注意, 这样不行
SELECT product_name, sale_price
    FROM Product AS P                 
WHERE EXISTS (SELECT product_id as SP  --- 直接选product_id并给alias
                FROM ShopProduct
            WHERE SP = '000C' AND SP = P.product_id); -- 无法成立, 一定要引用table.col = table.col
            
            
-- 可以把子查询替换为常数
SELECT 1 -- 这里可以书写适当的常数
    FROM ShopProduct AS SP
WHERE SP.shop_id = '000C' AND SP.product_id = P.product_id)

-- 使用NOT EXIST
SELECT product_name, sale_price
    FROM Product AS P
WHERE NOT EXISTS (SELECT *
                    FROM ShopProduct AS SP
                  WHERE SP.shop_id = '000A' AND SP.product_id = P.product_id);
```
> - `EXIST`的左侧并没有任何参数
> - 这是因为`EXIST`是只有1个参数的谓词


### 6-3 CASE表达式 ###

学习重点:
- CASE表达式分为简单CASE表达式和搜索CASE表达式两种. 搜索CASE表达式包含简单CASE表达式的全部功能.
- 虽然CASE表达式中的`ELSE`子句可以省略, 但为了让SQL语句更加容易理解, 还是希望大家不要省略.
- CASE表达式中的`END`不能省略.
- 使用CASE表达式能够将`SELECT`语句的结果进行组合.
- 虽然有些DBMS提供了各自特有的CASE表达式的简化函数, 例如Oracle中的`DECODE`和MySQL中的`IF`, 等等, 但由于它们并非通用的函数, 功能上也有些限制, 因此有些场合无法使用

#### 什么是CASE表达式 ####

本节将要学习的 CASE 表达式, 和"1 + 1"或者"120 / 4"这样的表达式一样, 是一种进行运算的功能.
- CASE表达式也是函数的一种.
- 它是SQL中数一数二的重要功能.
- CASE表达式是在区分情况时使用的, 这种情况的区分在编程中通常称为(条件)分支

#### CASE表达式的语法 ####

CASE表达式的语法分为两种:
1. 简单CASE表达式
2. 搜索CASE表达式

但是由于搜索CASE表达式包含了简单CASE表达式的全部功能, 因此本节只会介绍搜索CASE表达

语法16: 搜索CASE表达式
> - WHEN 子句中的"<求值表达式>"就是类似"`列 = 值`"这样, 返回值为真值(`TRUE`/`FALSE`/`UNKNOWN`)的表达式
> - CASE 表达式会从对最初的`WHEN`子句中的"< 求值表达式 >"进行求值开始执行.
>   - 所谓求值, 就是要调查该表达式的真值是什么
> - 如果结果为真(`TRUE`), 那么就返回`THEN`子句中的表达式
>   - CASE 表达式的执行到此为止 (相当于if...elif, 而不是if...if...)
```sql
CASE WHEN <求值表达式> THEN <表达式>
     WHEN <求值表达式> THEN <表达式>
     WHEN <求值表达式> THEN <表达式>
       .
       .
       .
    ELSE <表达式>
END
```


#### CASE表达式的使用方法 ####

实例41: 通过CASE表达式将A~C的字符串加入到商品种类当中
```sql
SELECT product_name,
    CASE WHEN product_type = '衣服' THEN 'A: ' || product_type
        WHEN product_type = '办公用品' THEN 'B: ' || product_type
        WHEN product_type = '厨房用具' THEN 'C: ' || product_type
        ELSE NULL
    END AS abc_product_type
FROM Product;
```
> - 输出产品的类型


