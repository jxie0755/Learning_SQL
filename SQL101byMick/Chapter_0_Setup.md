# SQL 101 by Mick #
## Chapter 0 搭建SQL和连接SQL##


### 安装部分省略 ###

### 安装后 ###

- 通过命令行接入psql
- 找到安装路径的bin文件夹, 执行
- `psql.exe -U postgres`  (windows CMD)

连接到数据库后, 第一件事就是确认是否连接,使用命令:
    
```sql
SELECT 1;
```
    
- 若成功便会显示出column 1
- 注意不要忘记 `;` 符号, 它指示本条命令结束

### 创见学习用的数据库 ###

```
CREATE DATABASE shop;
```

### 结束psql ###
命令为:

```
\q
```

### 命令行连接数据库 ###
使用 `-d` 命令, 这样就进入了shop数据库:

```
psql.exe -U postgres -d shop (windows CMD)
```   
