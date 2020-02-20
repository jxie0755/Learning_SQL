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
SELECT m, n,
ROUND(m, n) AS round_col
FROM SampleMath;
```

#### 字符串函数 ####




