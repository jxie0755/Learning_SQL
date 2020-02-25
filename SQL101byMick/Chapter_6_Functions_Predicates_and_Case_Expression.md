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

实例25+26: 使用`LIKE`和`_`（下划线）进行后方一致查询
```sql
SELECT *
FROM SampleLike 
WHERE strcol LIKE 'abc__';  -- abc+任意两个字符

SELECT *
FROM SampleLike 
WHERE strcol LIKE 'abc___';  -- abc+任意三个字符
```


#### BETWEEN谓词 - 范围查询 ####

- 使用`BETWEEN`可以进行范围查询。
- 该谓词与其他谓词或者函数的不同之处在于它使用了3个参数。
- 最大特点就是包括两端
  - 如果不想包括两端则需要使用`<`和`>`

实例27: 选取销售单价为 100～1000 日元的商品
```sql
SELECT product_name, sale_price
FROM Product 
WHERE sale_price BETWEEN 100 AND 1000;
```

