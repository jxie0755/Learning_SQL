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
SET TIMEZONE = 'UTC';  -- GMT标准时间
SET TIMEZONE = 'EST';  -- 美国东岸时间
SET TIMEZONE = 'CST';  -- 美国中部时间
SET TIMEZONE = 'PST';  -- 美国西岸时间

-- 由于该表中直接有对每个ETC时区的name 例如:
-- name: ETc/GMT-8, abbrev: +08
-- 所以可以直接SET TIMEZONE = '+08'; 或者 SET TIMEZONE = '-05';等等
```

