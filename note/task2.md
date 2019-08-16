## 使用子查询

### 子查询

SQL允许创建子查询（subquery），即嵌套在其他查询中的查询

在 SELECT 语句中，子查询总是**从内向外**处理。

#### 过滤

- 示例

```mysql
SELECT cust_id 
FROM Orders 
WHERE order_num IN (SELECT order_num                     
					FROM OrderItems                     
					WHERE prod_id = 'RGAN01'); 
```

> 把子查询分解为多行并进行适当的缩进，能极大地 简化子查询的使用
> 
> 在实际使用时由于性 能的限制，不能嵌套太多的子查询。 
> 
> 作为子查询的 SELECT 语句只能查询单个列
> 

#### 计算字段

- 示例

```mysql
SELECT cust_name,         
	   cust_state,        
	   (SELECT COUNT(*)          
	   FROM Orders          
	   WHERE Orders.cust_id = Customers.cust_id) AS orders 
FROM Customers  
ORDER BY cust_name; 
```

orders 是一个计算字段，它是由圆括号中的 子查询建立的。该子查询对检索出的每个顾客执行一次

##### 完全限定列名

它指定表名和列名 （Orders.cust_id 和Customers.cust_id）

> 如果在 SELECT 语句中操作多个表，就应使用完全限定列名来避免歧义。 
> 

## 联结表

### 关系表

相同的数据出现多次决不是一件好事，这是关系数据库设计的 基础。

关系表的设计就是要把信息分解成多个表，一类数据一个表。各表通过某些共同的值互相关联（所以才叫关系数据库）。 

> 可伸缩（scale） 
> 能够适应不断增加的工作量而不失败。
> 
> 设计良好的数据库或应用程序 称为可伸缩性好（scale well）
> 

### 联结

联结是一种机制，用来在一条 SELECT 语句中关联表

- 示例

```mysql
SELECT vend_name, prod_name, prod_price 
FROM Vendors, Products 
WHERE Vendors.vend_id = Products.vend_id; 
```

WHERE 子句作为过滤 条件，只包含那些匹配给定条件（这里是联结条件）的行。

没有 WHERE 子句，第一个表中的每一行将与第二个表中的每一行配对，而不管它们 逻辑上是否能配在一起。
这称为笛卡儿积，检索出的行的数目 将是第一个表中的行数乘以第二个表中的行数。

> 要保证所有联结都有 WHERE 子句
> 

### 内联结

基于两个表之间的相 等测试称为内联结（inner join）或等值联结（equijoin）。

- 示例

```mysql
SELECT vend_name, prod_name, prod_price 
FROM Vendors INNER JOIN Products  
ON Vendors.vend_id = Products.vend_id; 
```
### 联结多个表

SQL 不限制一条 SELECT 语句中可以联结的表的数目。创建联结的基本 规则也相同。首先列出所有表，然后定义表之间的关系

> 不要联结不必要的表。联结的表越多，性 能下降越厉害
> 许多 DBMS 都有限制表的最大数目
> 

- 示例
```mysql
SELECT cust_name, cust_contact 
FROM Customers, Orders, OrderItems 
WHERE Customers.cust_id = Orders.cust_id  
AND OrderItems.order_num = Orders.order_num  
AND prod_id = 'RGAN01'; 
```

## 创建高级联结

### 表别名

SQL 除了可以对列名和计算字段使用别名，还允许给表名起别名。

这样 做有两个主要理由： 
- 缩短 SQL语句； 
- 允许在一条 SELECT 语句中多次使用相同的表。 

- 示例

```mysql
SELECT cust_name, cust_contact 
FROM Customers C, Orders O, OrderItems OI 
WHERE C.cust_id = O.cust_id  
AND OI.order_num = O.order_num  
AND prod_id = 'RGAN01';
```

> Oracle不支持 AS 关键字。
> 
> 要在 Oracle中使用别名，简单 地指定列名即可（因此，应该是 Customers C，而不是 Customers AS C）
> 

表别名只在查询执行中使用。与列别名不一样，表别名不返回到客户端

### 自联结

顾名思义，自联结就是将相同的表联结起来。

- 示例

```mysql
SELECT c1.cust_id, c1.cust_name, c1.cust_contact 
FROM Customers c1, Customers c2 
WHERE c1.cust_name = c2.cust_name  
AND c2.cust_contact = 'Jim Jones';
```

自联结通常作为外部语句，用来替代从相同表中检索数据的使用子查询语句。

虽然终的结果是相同的，但许多 DBMS处理联结远比处理 子查询快得多

### 自然联结

标准的联结（前一课中介绍的内联结）返回所有数据，相同的列 甚至多次出现。自然联结排除多次出现，使每一列只返回一次。 

自然联结要求你只能选择那些唯一的列，一般通过对一个表使用通配符 （SELECT *），而对其他表的列使用明确的子集来完成。

- 示例

```mysql
SELECT C.*, O.order_num, O.order_date,        
OI.prod_id, OI.quantity, OI.item_price 
FROM Customers C, Orders O, OrderItems OI 
WHERE C.cust_id = O.cust_id  
AND OI.order_num = O.order_num  
AND prod_id = 'RGAN01';
```

### 外联结

联结包含了那些在相关表中没有关联行的行。这种联结 称为外联结

在使用 OUTER JOIN 语法时，必须使用 RIGHT 或 LEFT 关键字指定包括其所有行的表 
（RIGHT 指出的是 OUTER JOIN 右边的表，而 LEFT 指出的是 OUTER JOIN 左边的表）

还存在另一种外联结，就是全外联结（full outer join），
它检索两个表中 的所有行并关联那些可以关联的行。
全外联结包含两个表的不关联的行

### 带聚集函数的联结

- 示例

```mysql
SELECT Customers.cust_id,        
COUNT(Orders.order_num) num_ord 
FROM Customers LEFT OUTER JOIN Orders  
ON Customers.cust_id = Orders.cust_id 
GROUP BY Customers.cust_id;
```

### 使用联结的要点

- 注意所使用的联结类型。一般我们使用内联结，但使用外联结也有效。
- 关于确切的联结语法，应该查看具体的文档，看相应的DBMS支持何 种语法（大多数 DBMS使用这两课中描述的某种语法）。 
- 保证使用正确的联结条件（不管采用哪种语法），否则会返回不正确 的数据。 
- 应该总是提供**联结条件**，否则会得出笛卡儿积。 
- 在一个联结中可以包含多个表，甚至可以对每个联结采用不同的联结 类型。虽然这样做是合法的，一般也很有用，但应该在一起测试它们前**分别测试每个联结**。这会使故障排除更为简单。 

## 组合查询

SQL允许执行多个查询（多条 SELECT 语句），并将结果作为一 个查询结果集返回。这些组合查询通常称为并（union）或复合查询 （compound query）。 

主要有两种情况需要使用组合查询： 
- 在一个查询中从不同的表返回结构数据；
- 对一个表执行多个查询，按一个查询返回数据。 

可用 UNION 操作符来组合数条 SQL 查询
所要做的只是在各条语句之间放上关键字 UNION。 

### 使用规则：
- UNION 必须由两条或两条以上的 SELECT 语句组成，语句之间用关键 字UNION分隔（因此，如果组合四条SELECT语句，将要使用三个UNION 关键字）。 
- UNION 中的每个查询必须包含**相同的列、表达式或聚集函数（不过， 各个列不需要以相同的次序列出）**。 
- 列数据类型必须兼容：类型不必完全相同，但必须是 DBMS可以隐含 转换的类型（例如，不同的数值类型或不同的日期类型）。 

UNION 从查询结果集中自动去除了重复的行

如果想返回 所有的匹配行，可使用 UNION ALL 而不是 UNION

- 示例

```mysql
SELECT cust_name, cust_contact, cust_email  
FROM Customers  
WHERE cust_state IN ('IL','IN','MI')  
UNION ALL 
SELECT cust_name, cust_contact, cust_email  
FROM Customers  
WHERE cust_name = 'Fun4All'; 
```

### 排序

在用 UNION 组合查询时，只 能使用一条 ORDER BY 子句，它必须位于最后一条 SELECT 语句之后

> 参考一下具体的 DBMS文档，了解它是否对 UNION 能组合的最大语句数目有限制。 
> 理论上上看使用多条 WHERE 子句条件 还是 UNION 应该没有实际的差别。实践中多数 查询优化程序并不能达到理想状态，需要进行测试。
> 

## 插入数据

### 数据插入

插入的方式：
- 完整的行
- 行的一部分
- 某些查询的结果

> 在你试图使用 INSERT 前，应该保证自己有足够的安全权限。
> 

#### 完整的行

- 示例

```mysql
INSERT INTO Customers 
VALUES('1000000006',        
		'Toy Land',        
		'123 Any Street',        
		'New York',        
		'NY',        
		'11111',        
		'USA',        
		NULL,        
		NULL); 
```

如果某列没有值， 则应该使用 NULL 值（假定 表允许对该列指定空值）。
各列必须以它们在表定义中出现的次序填充。

虽然上述这种语法很简单，但并不安全，应该尽量避免使用。

更安全（不过更烦琐）的方法如下： 
```mysql
INSERT INTO Customers(cust_id,                       
					cust_name,                       
					cust_address,                       
					cust_city,                       
					cust_state,                       
					cust_zip,                       
					cust_country,                       							cust_contact,                       							cust_email) 
VALUES('1000000006',        
		'Toy Land',        
		'123 Any Street',        
		'New York',        
		'NY',        
		'11111',        
		'USA',        
		NULL,        
		NULL);
```

因为提供了列名，VALUES 必须以其指定的次序匹配指定的列名，不一定 按各列出现在表中的实际次序。
其优点是，即使表的结构改变，这条 INSERT 语句仍然能正确工作。 

#### 插入部分行

如果表的定义允许，则可以在 INSERT 操作中省略某些列。
省略的列 必须满足以下某个条件。 
- 该列定义为允许 NULL 值（无值或空值）。 
- 在表定义中给出默认值。这表示如果不给出值，将使用默认值。 

- 示例

```mysql
INSERT INTO Customers(	cust_id,                       
						cust_name,                       								cust_address,                       							cust_city,                       								cust_state,                       								cust_zip,                       								cust_country) 
VALUES(	'1000000006',        
		'Toy Land',        
		'123 Any Street',        
		'New York',        
		'NY',        
		'11111',        
		'USA');
```

#### 插入检索出的数据

将 SELECT 语句的结果插入表中，这就是所谓的 INSERT SELECT

- 示例

```mysql
INSERT INTO Customers(	cust_id,                       
						cust_contact,                       							cust_email,                       								cust_name,                       								cust_address,                       							cust_city,                       								cust_state,                       								cust_zip,                       								cust_country) 
SELECT 	cust_id,        
		cust_contact,        
		cust_email,        
		cust_name,        
		cust_address,        
		cust_city,        
		cust_state,        
		cust_zip,        
		cust_country 
FROM CustNew;
```

不一定要求列名匹配。
SELECT 中的第一列（不管 其列名）将用来填充表列中指定的第一列，第二列将用来填充表列中 指定的第二列，如此等等

INSERT SELECT 中SELECT 语句可以包含 WHERE 子句，以过滤插入的数据。

INSERT 通常只插入一行。要插入多行，必须执行多个 INSERT 语句。 INSERT SELECT是个例外，它可以用一条INSERT插入多行，不管SELECT 语句返回多少行，都将被 INSERT 插入。

### 复制表

- 示例

```mysql
CREATE TABLE CustCopy AS 
SELECT * FROM Customers; 
```

- 任何 SELECT 选项和子句都可以使用，包括 WHERE 和 GROUP BY； 
- 可利用联结从多个表插入数据； 
- 不管从多少个表中检索数据，数据都只能插入到一个表中

> SELECT INTO 是试验新 SQL语句前进行表复制的很好工具。先进行复 制，可在复制的数据上测试 SQL代码，而不会影响实际的数据。 

## 更新和删除数据

> 在你使用 UPDATE和DELETE 前，应该保证自己有足够的安全权限
> 

### 更新

有两种使用 UPDATE 的方式： 
- 更新表中的特定行；
- 更新表中的所有行。 

基本的 UPDATE 语句 由三部分组成，分别是： 
- 要更新的表； 
- 列名和它们的新值； 
- 确定要更新哪些行的过滤条件。 

- 示例

```mysql
UPDATE Customers 
SET cust_contact = 'Sam Roberts',     
	cust_email = 'sam@toyland.com' 
WHERE cust_id = '1000000006'; 
```

UPDATE 语句总是以要更新的表名开始。
SET 命令用来将新值赋给被更新的列
UPDATE 语句以 WHERE 子句结束，它告诉 DBMS更新哪一行.
在更新多个列时，只需要使用一条 SET 命令，每个“列=值”对之间用逗号分隔（最后一列之后不用逗号）。

UPDATE 语句中可以使用子查询，使得能用 SELECT 语句检索出的数据 更新列数据。

> 有的 SQL实现支持在 UPDATE 语句中使用 FROM 子句，用一个表的数 据更新另一个表的行
> 

要删除某个列的值，可设置它为 NULL（假如表定义允许 NULL 值）


### 删除数据

有两种使用 DELETE 的方式
- 从表中删除特定的行；
- 从表中删除所有行。 

- 示例

```mysql
DELETE FROM Customers 
WHERE cust_id = '1000000006';
```

DELETE FROM 要求指定从中删除数据的表名， WHERE 子句过滤要删除的行

> 使用外键确保引用完整性的一个好处是， DBMS 通常可以防止删除某个关系需要用到的行
> 
> 在某些 SQL实现中，跟在 DELETE 后的关键字 FROM 是可选的。但是 即使不需要，也最好提供这个关键字。这样做将保证SQL代码在DBMS 之间可移植。 

DELETE 不需要列名或通配符。DELETE 删除整行而不是删除列。要删除 指定的列，请使用 UPDATE 语句。

> 如果想从表中删除所有行，不要使用 DELETE。可使用 TRUNCATE TABLE 语句，它完成相同的工作，而速度更快（因为不记录数据的变动）。 
> 

### 指导原则

- 除非确实打算更新和删除每一行，否则**绝对不要使用不带 WHERE 子句 **的 UPDATE 或 DELETE 语句。
- 保证每个表都有**主键**，尽可能 像 WHERE 子句那样使用它（可以指定各主键、多个值或值的范围）。 
- 在 UPDATE 或 DELETE 语句使用 WHERE 子句前，应该**先用 SELECT 进行测试，保证它过滤的是正确的记录**，以防编写的 WHERE 子句不正确。
- 使用强制实施引用完整性的数据库，这样 DBMS将不允许删除其数据与其他表相关联的行。 
- 有的 DBMS 允许数据库管理员施加约束，防止执行不带 WHERE 子句 的 UPDATE 或 DELETE 语句。如果所采用的 DBMS支持这个特性，应 该使用它。

## 创建和操纵表

> 这些语句必须小心使用，并且应该在备份后使 用。
> 

### 表创建

利用 CREATE TABLE 创建表，必须给出下列信息： 
- 新表的名字，在关键字 CREATE TABLE 之后给出； 
- 表列的名字和定义，用逗号分隔； 
- 有的 DBMS还要求指定表的位置。 

表名紧跟 CREATE TABLE 关键字。实际的表定 义（所有列）括在圆括号之中，
各列之间用逗号分隔。

每列的定义以列名（它在表中必须是唯一的）开始，后跟列的数据 类型

- 示例

```mysql
CREATE TABLE Products 
(     
	prod_id       CHAR(10)          NOT NULL,     
	vend_id       CHAR(10)          NOT NULL,     
	prod_name     CHAR(254)         NOT NULL,     
	prod_price    DECIMAL(8,2)      NOT NULL,     
	prod_desc     TEXT(1000)     	 
);
```

> 在创建新的表时，指定的表名必须不存在，否则会出错。防止意外覆 盖已有的表，SQL 要求首先手工删除该表
> 

#### 使用NULL

NULL 为默认设置，如果不指定 NOT NULL，就认为指定的是 NULL。
只有不允许NULL 值的列可作为主键，允许 NULL 值的列不能作为唯一标识。

> 如果指定''（两个单引号，其间没有字符），这在 NOT NULL 列中是允 许的。空字符串是一个有效的值，它不是无值。NULL 值用关键字 NULL 而不是空字符串指定。 
> 

#### 指定默认值

默认值在 CREATE TABLE 语句的列定义中用关键字 DEFAULT 指定

默认值经常用于日期或时间戳列。例如，通过指定引用系统日期的函数 或变量，将系统日期用作默认日期。MySQL 用户指定 DEFAULT CURRENT_DATE()

- 示例

```mysql
CREATE TABLE OrderItems 
(     
	order_num      INTEGER          NOT NULL,     
	order_item     INTEGER          NOT NULL,     
	prod_id        CHAR(10)         NOT NULL,     
	quantity       INTEGER          NOT NULL      DEFAULT 1,     	 item_price     DECIMAL(8,2)     NOT NULL 
);
```

### 更新表

在 ALTER TABLE 之后给出要更改的表名（该表必须存在，否则将 出错），列出要做哪些更改。

- 示例

```mysql
ALTER TABLE Vendors 
ADD vend_phone CHAR(20);

ALTER TABLE Vendors 
DROP COLUMN vend_phone; 
```

注意事项

- 应该在表的设 计过程中充分考虑未来可能的需求，避免今后对表的结构做大 改动。 
- 所有的 DBMS都允许给现有的表增加列，不过对所增加列的数据类型 （以及 NULL 和 DEFAULT 的使用）有所限制。 
- 许多 DBMS不允许删除或更改表中的列。 
- 多数 DBMS允许重新命名表中的列。 
- 许多 DBMS限制对已经填有数据的列进行更改，对未填有数据的列几 乎没有限制。 

> 使用 ALTER TABLE 要极为小心，应该在进行改动前做完整的备份（表结构和数据的备份）
> 

### 删除表

- 示例

```mysql
DROP TABLE CustCopy;
```

> 许多DBMS允许强制实施有关规则，防止删除与其他表相关联的表。在 实施这些规则时，如果对某个表发布一条 DROP TABLE 语句，且该表是 某个关系的组成部分，则DBMS将阻止这条语句执行，直到该关系被删 除为止
> 

### 重命名表

RENAME TABLE old_table_name TO new_table_name;

## 使用视图

### 视图

视图是虚拟的表。它们包含的不是数据而是根据需要检索数据的查询。

视图仅仅是用来查看存储在别处数据的一种设施。视图本身不包含数据，因此返回的数据是从其他表中检索出来的。

在添加或更改这些表中的数据时，视图将返回改变过的数据。

视图提供了一种封装 SELECT 语句的层次，可用来简化数据处理，重新 格式化或保护基础数据。 

#### 作用

- 重用 SQL语句。 
- 简化复杂的 SQL操作，不必知道基本查询细节。
- 使用表的一部分而不是整个表。
- 保护数据。可以授予用户访问表的特定部分的权限，而不是整个表的访问权限。 
- 更改数据格式和表示。视图可返回与底层表的表示和格式不同的数据。

> 如果你用多个联结和过滤创建了复杂的视图或者嵌 套了视图，性能可能会下降得很厉害
> 

#### 规则和限制

- 视图必须唯一命名
- 对于可以创建的视图数目没有限制。 
- 创建视图，必须具有足够的访问权限
- 视图可以嵌套，所允许的嵌套层数在不同的 DBMS中有所不同，嵌套视图可能会 严重降低查询的性能
- 许多 DBMS禁止在视图查询中使用 ORDER BY 子句
- 有些 DBMS要求对返回的所有列进行命名，如果列是计算字段，则需 要使用别名
- 视图不能索引，也不能有关联的触发器或默认值。 
- 有些 DBMS把视图作为只读的查询
- 有些 DBMS 允许创建这样的视图，它不能进行导致行不再属于视图的 插入或更新

### 视图创建与删除

- 创建

`CREATE VIEW viewname;`

- 删除

`DROP VIEW viewname;`

覆盖（或更新）视图，必须先删除它，然后再重新创建。 

### 应用

#### 简化复杂的联结 

- 示例

```mysql
-- 创建视图
CREATE VIEW ProductCustomers AS 
SELECT cust_name, cust_contact, prod_id 
FROM Customers, Orders, OrderItems 
WHERE Customers.cust_id = Orders.cust_id  
AND OrderItems.order_num = Orders.order_num; 

-- 检索
SELECT cust_name, cust_contact 
FROM ProductCustomers 
WHERE prod_id = 'RGAN01';
```

#### 重新格式化检索出的数据 

- 示例

```mysql
CREATE VIEW VendorLocations AS 
SELECT CONCAT(RTRIM(vend_name), ' (', RTRIM(vend_country), ')')   		 AS vend_title 
FROM Vendors;
```

#### 过滤不想要的数据

- 示例

```mysql
CREATE VIEW CustomerEMailList AS 
SELECT cust_id, cust_name, cust_email 
FROM Customers 
WHERE cust_email IS NOT NULL; 
```

#### 计算字段

- 示例

```mysql
CREATE VIEW OrderItemsExpanded AS 
SELECT order_num,        
		prod_id,        
		quantity, 
		item_price,        
		quantity*item_price AS expanded_price 
FROM OrderItems; 
```

创建不绑定特定数据的视图, 这样做不需要创 建和维护多个类似视图



















