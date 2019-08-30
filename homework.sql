drop database if exists iii;
create database iii;
-- create database iii default character set utf8 collate utf8_unicode_ci;
use iii;

--------------------------------------------------------------------------------
create table customers (
    customerId int primary key auto_increment,
    customerName varchar(40),
    customerPhone varchar(40) unique key,
    customerEmail varchar(40),
    customerAddress varchar(40));

create table suppliers (
    supplierId int primary key auto_increment,
    supplierName varchar(40),
    supplierPhone varchar(40) unique key,
    supplierAddress varchar(40));

create table products (
    productId int primary key auto_increment,
    productNo varchar(40) unique key,
    productName varchar(40),
    productSpec varchar(40),
    unitPrice int unsigned default 0,
    supplierPhone varchar(40),
    foreign key (supplierPhone) references suppliers (supplierPhone));
    -- foreign key (supplierPhone) references suppliers (supplierPhone) on update cascade on delete cascade);
-- https://lagunawang.pixnet.net/blog/post/25455909-mysql-%E5%BB%BA%E7%AB%8Bforeign-key-%28-innodb-%29-%E6%99%82%E8%A6%81%E6%B3%A8%E6%84%8F%E7%9A%84%E4%B8%80%E4%BB%B6%E4%BA%8B


create table orders (
    orderId int primary key auto_increment,
    orderNo varchar(40) unique key,
    customerPhone varchar(40),
    foreign key (customerPhone) references customers (customerPhone));

create table orderDetails (
    orderDetailId int primary key auto_increment,
    orderNo varchar(40),
    foreign key (orderNo) references orders (orderNo),
    productNo varchar(40),
    foreign key (productNo) references products (productNo),
    actualPrice int unsigned default 0,
    quantity int unsigned default 0);

--------------------------------------------------------------------------------
-- customerId int primary key auto_increment,
-- customerName varchar(40),
-- customerPhone varchar(40) unique key,
-- customerEmail varchar(40),
-- customerAddress varchar(40)

-- generic query customer
\d #
create procedure queryCustomer()
begin
    select * from customers;
end #
\d ;

-- query customer by customer name
\d #
create procedure queryCustomerByCustomerName(in nameNew varchar(40))
begin
    if (nameNew = "") then
        -- query all customer
        select * from customers order by customerName;
    else
        -- query customer by customer name
        set @n2 = concat('%', nameNew, '%');
        select * from customers where customerName like @n2;
    end if;
end #
\d ;

-- query customer by customer phone
\d #
create procedure queryCustomerByCustomerPhone(in phoneNew varchar(40))
begin
    if (phoneNew = "") then
        -- query all customer
        select * from customers order by customerPhone;
    else
        -- query customer by customer phone
        set @p2 = concat('%', phoneNew, '%');
        select * from customers where customerPhone like @p2;
    end if;
end #
\d ;

-- add customer
\d #
create procedure insertCustomer(in nameNew varchar(40), in phoneNew varchar(40), in emailNew varchar(40), in addressNew varchar(40))
begin
    select * from customers;
    -- insert into customers (customerName, customerPhone, customerEmail, customerAddress) values (nameNew, phoneNew, emailNew, addressNew);
    insert into customers (customerName, customerPhone, customerEmail, customerAddress)
    select nameNew, phoneNew, emailNew, addressNew from dual
    where not exists (select customerPhone from customers where customerPhone = phoneNew);
    select * from customers;
end #
\d ;

-- update customer
\d #
create procedure updateCustomer(in phoneOld varchar(40), in nameNew varchar(40), in phoneNew varchar(40), in emailNew varchar(40), in addressNew varchar(40))
begin
    select * from customers;
    select * from orders;
    -- update customers set customerName = nameNew, customerPhone = phoneNew, customerEmail = emailNew, customerAddress = addressNew where customerPhone = phoneOld;
    select count(*) into @countOld from customers where customerPhone = phoneOld;
    select count(*) into @countNew from customers where customerPhone = phoneNew;
    select phoneOld, @countOld, phoneNew, @countNew;
    if (@countOld != 0) and (@countNew = 0) then
        select true;
        set foreign_key_checks = 0;
        update orders set customerPhone = phoneNew where customerPhone = phoneOld;
        update customers set customerName = nameNew, customerPhone = phoneNew, customerEmail = emailNew, customerAddress = addressNew where customerPhone = phoneOld;
        set foreign_key_checks = 1;

        -- insert into customers (customerName, customerPhone, customerEmail, customerAddress) values (nameNew, phoneNew, emailNew, addressNew);
        -- update orders set customerPhone = phoneNew where customerPhone = phoneOld;
        -- delete from customers where customerPhone = phoneOld;
    end if;
    select * from customers;
    select * from orders;
end #
\d ;

-- delete customer
\d #
create procedure deleteCustomer(in phoneOld varchar(40))
begin
    select * from customers;
    select * from orders;
    select * from orderDetails;
    delete from orderDetails where orderNo in (select orderNo from orders where customerPhone = phoneOld);
    delete from orders where customerPhone = phoneOld;
    delete from customers where customerPhone = phoneOld;
    select * from customers;
    select * from orders;
    select * from orderDetails;
end #
\d ;

--------------------------------------------------------------------------------
-- supplierId int primary key auto_increment,
-- supplierName varchar(40),
-- supplierPhone varchar(40) unique key,
-- supplierAddress varchar(40)

-- generic query supplier
\d #
create procedure querySupplier()
begin
    select * from suppliers;
end #
\d ;

-- query supplier by supplier name
\d #
create procedure querySupplierBySupplierName(in nameNew varchar(40))
begin
    if (nameNew = "") then
        -- query all supplier
        select * from suppliers order by supplierName;
    else
        -- query supplier by supplier name
        set @n2 = concat('%', nameNew, '%');
        select * from suppliers where supplierName like @n2;
    end if;
end #
\d ;

-- query supplier by supplier phone
\d #
create procedure querySupplierBySupplierPhone(in phoneNew varchar(40))
begin
    if (phoneNew = "") then
        -- query all supplier
        select * from suppliers order by supplierPhone;
    else
        -- query supplier by supplier phone
        set @p2 = concat('%', phoneNew, '%');
        select * from suppliers where supplierPhone like @p2;
    end if;
end #
\d ;

-- add supplier
\d #
create procedure insertSupplier(in nameNew varchar(40), in phoneNew varchar(40), in addressNew varchar(40))
begin
    select * from suppliers;
    -- insert into suppliers (supplierName, supplierPhone, supplierAddress) values (nameNew, phoneNew, addressNew);
    insert into suppliers (supplierName, supplierPhone, supplierAddress)
    select nameNew, phoneNew, addressNew from dual
    where not exists (select supplierPhone from suppliers where supplierPhone = phoneNew);
    select * from suppliers;
end #
\d ;

-- update supplier
\d #
create procedure updateSupplier(in phoneOld varchar(40), in nameNew varchar(40), in phoneNew varchar(40), in addressNew varchar(40))
begin
    select * from suppliers;
    select * from products;
    -- update suppliers set supplierName = nameNew, supplierPhone = phoneNew, supplierAddress = addressNew where supplierPhone = phoneOld;
    select count(*) into @countOld from suppliers where supplierPhone = phoneOld;
    select count(*) into @countNew from suppliers where supplierPhone = phoneNew;
    select phoneOld, @countOld, phoneNew, @countNew;
    if (@countOld != 0) and (@countNew = 0) then
        select true;
        set foreign_key_checks = 0;
        update products set supplierPhone = phoneNew where supplierPhone = phoneOld;
        update suppliers set supplierName = nameNew, supplierPhone = phoneNew, supplierAddress = addressNew where supplierPhone = phoneOld;
        set foreign_key_checks = 1;

        -- insert into suppliers (supplierName, supplierPhone, supplierAddress) values (nameNew, phoneNew, addressNew);
        -- update products set supplierPhone = phoneNew where supplierPhone = phoneOld;
        -- delete from suppliers where supplierPhone = phoneOld;
    end if;
    select * from suppliers;
    select * from products;
end #
\d ;

-- delete supplier
\d #
create procedure deleteSupplier(in phoneOld varchar(40))
begin
    select * from suppliers;
    select * from products;
    select * from orderDetails;
    delete from orderDetails where productNo in (select productNo from products where supplierPhone = phoneOld);
    delete from products where supplierPhone = phoneOld;
    delete from suppliers where supplierPhone = phoneOld;
    select * from suppliers;
    select * from products;
    select * from orderDetails;
end #
\d ;

--------------------------------------------------------------------------------
-- productId int primary key auto_increment,
-- productNo varchar(40) unique key,
-- productName varchar(40),
-- productSpec varchar(40),
-- unitPrice int unsigned default 0,
-- supplierPhone varchar(40),
-- foreign key (supplierPhone) references suppliers (supplierPhone)

-- generic query product
\d #
create procedure queryProduct()
begin
    select * from products;
end #
\d ;

-- query product by product no
\d #
create procedure queryProductByProductNo(in noNew varchar(40))
begin
    if (noNew = "") then
        -- query all product
        select * from products order by productNo;
    else
        -- query product by product no
        set @n2 = concat('%', noNew, '%');
        select * from products where productNo like @n2;
    end if;
end #
\d ;

-- query product by product name
\d #
create procedure queryProductByProductName(in nameNew varchar(40))
begin
    if (nameNew = "") then
        -- query all product
        select * from products order by productName;
    else
        -- query product by product name
        set @n2 = concat('%', nameNew, '%');
        select * from products where productName like @n2;
    end if;
end #
\d ;

-- add product
\d #
create procedure insertProduct(in noNew varchar(40), in nameNew varchar(40), in specNew varchar(40), in priceNew int unsigned, in phoneNew varchar(40))
begin
    select * from products;
    -- insert into products (productNo, productName, productSpec, unitPrice, supplierPhone) values (noNew, nameNew, specNew, priceNew, phoneNew);
    insert into products (productNo, productName, productSpec, unitPrice, supplierPhone)
    select noNew, nameNew, specNew, priceNew, phoneNew from dual
    where not exists (select productNo from products where productNo = noNew);
    select * from products;
end #
\d ;

-- update product
\d #
create procedure updateProduct(in noOld varchar(40), in noNew varchar(40), in nameNew varchar(40), in specNew varchar(40), in priceNew int unsigned, in phoneNew varchar(40))
begin
    select * from products;
    select * from orderDetails;
    select * from suppliers;
    -- update products set productNo = noNew, productName = nameNew, productSpec = specNew, unitPrice = priceNew, supplierPhone = phoneNew where productNo = noOld;
    select count(*) into @countOld from products where productNo = noOld;
    select count(*) into @countNew from products where productNo = noNew;
    select noOld, @countOld, noNew, @countNew;
    if (@countOld != 0) and (@countNew = 0) then
        select true;
        select supplierPhone into @phoneOld from products where productNo = noOld;
        set foreign_key_checks = 0;
        update orderDetails set productNo = noNew where productNo = noOld;
        update products set productNo = noNew, productName = nameNew, productSpec = specNew, unitPrice = priceNew, supplierPhone = phoneNew where productNo = noOld;
        update suppliers set supplierPhone = phoneNew where supplierPhone = @phoneOld;
        set foreign_key_checks = 1;

        -- insert into products (productNo, productName, productSpec, unitPrice, supplierPhone) values (noNew, nameNew, specNew, priceNew, phoneNew);
        -- update orderDetails set productNo = noNew where productNo = noOld;
        -- delete from products where productNo = noOld;
    end if;
    select * from products;
    select * from orderDetails;
    select * from suppliers;
end #
\d ;

-- delete product
\d #
create procedure deleteProduct(in noOld varchar(40))
begin
    select * from products;
    select * from orderDetails;
    delete from orderDetails where productNo = noOld;
    delete from products where productNo = noOld;
    select * from products;
    select * from orderDetails;
end #
\d ;

--------------------------------------------------------------------------------
-- orderId int primary key auto_increment,
-- orderNo varchar(40) unique key,
-- customerPhone varchar(40),
-- foreign key (customerPhone) references customers (customerPhone)

-- generic query order
\d #
create procedure queryOrder()
begin
    select * from orders;
end #
\d ;

-- add order
\d #
create procedure insertOrder(in noNew varchar(40), in phoneNew varchar(40))
begin
    select * from orders;
    -- insert into orders (orderNo, customerPhone) values (noNew, phoneNew);
    insert into orders (orderNo, customerPhone)
    select noNew, phoneNew from dual
    where not exists (select orderNo from orders where orderNo = noNew);
    select * from orders;
end #
\d ;

-- update order
\d #
create procedure updateOrder(in noOld varchar(40), in noNew varchar(40), in phoneNew varchar(40))
begin
    select * from orders;
    select * from orderDetails;
    select * from customers;
    -- update orders set orderNo = noNew, customerPhone = phoneNew where orderNo = noOld;
    select count(*) into @countOld from orders where orderNo = noOld;
    select count(*) into @countNew from orders where orderNo = noNew;
    select noOld, @countOld, noNew, @countNew;
    if (@countOld != 0) and (@countNew = 0) then
        select true;
        set foreign_key_checks = 0;
        select customerPhone into @phoneOld from orders where orderNo = noOld;
        update orderDetails set orderNo = noNew where orderNo = noOld;
        update orders set orderNo = noNew, customerPhone = phoneNew where orderNo = noOld;
        update customers set customerPhone = phoneNew where customerPhone = @phoneOld;
        set foreign_key_checks = 1;

        -- insert into orders (orderNo, customerPhone) values (noNew, phoneNew);
        -- update orderDetails set orderNo = noNew where orderNo = noOld;
        -- delete from orders where orderNo = noOld;
    end if;
    select * from orders;
    select * from orderDetails;
    select * from customers;
end #
\d ;

-- delete order
\d #
create procedure deleteOrder(in noOld varchar(40))
begin
    select * from orders;
    select * from orderDetails;
    delete from orderDetails where orderNo = noOld;
    delete from orders where orderNo = noOld;
    select * from orders;
    select * from orderDetails;
end #
\d ;

--------------------------------------------------------------------------------
-- orderDetailId int primary key auto_increment,
-- orderNo varchar(40),
-- foreign key (orderNo) references orders (orderNo),
-- productNo varchar(40),
-- foreign key (productNo) references products (productNo),
-- actualPrice int unsigned default 0,
-- quantity int unsigned default 0

-- generic query order detail
\d #
create procedure queryOrderDetail()
begin
    select * from orderDetails;
end #
\d ;

-- add order detail
\d #
create procedure insertOrderDetail(in orderNoNew varchar(40), in productNoNew varchar(40), in priceNew int unsigned, in quantityNew int unsigned)
begin
    select * from orderDetails;
    insert into orderDetails (orderNo, productNo, actualPrice, quantity) values (orderNoNew, productNoNew, priceNew, quantityNew);
    select * from orderDetails;
end #
\d ;

-- update order detail
\d #
create procedure updateOrderDetailById(in id int, in priceNew int unsigned, in quantityNew int unsigned)
begin
    select * from orderDetails;
    -- update orderDetails set actualPrice = priceNew, quantity = quantityNew where orderDetailId = id;
    select count(*) into @countOld from orderDetails where orderDetailId = id;
    select noOld, @countOld;
    if (@countOld != 0) then
        select true;
        update orderDetails set actualPrice = priceNew, quantity = quantityNew where orderDetailId = id;
    end if;
    select * from orderDetails;
end #
\d ;

-- delete order detail
\d #
create procedure deleteOrderDetailById(in id int)
begin
    select * from orderDetails;
    delete from orderDetails where orderDetailId = id;
    select * from orderDetails;
end #
\d ;

--------------------------------------------------------------------------------
-- query order detail by customer phone
\d #
create procedure queryOrderDetailByCustomerPhone(in phoneNew varchar(40))
begin
    if (phoneNew = "") then
        -- query all order detail
        select c.customerName, c.customerPhone, od.orderNo, od.productNo, od.actualPrice, od.quantity from orderDetails od
        join orders o on (od.orderNo = o.orderNo)
        join customers c on (o.customerPhone = c.customerPhone)
        order by c.customerPhone, o.orderNo, od.productNo;
    else
        -- query order detail by customer phone
        set @n2 = concat('%', phoneNew, '%');
        select c.customerName, c.customerPhone, od.orderNo, od.productNo, od.actualPrice, od.quantity from orderDetails od
        join orders o on (od.orderNo = o.orderNo)
        join customers c on (o.customerPhone = c.customerPhone)
        where c.customerPhone like @n2
        order by c.customerPhone, o.orderNo, od.productNo;
    end if;
end #
\d ;

-- query order detail income by customer phone
\d #
create procedure queryOrderDetailIncomeByCustomerPhone(in phoneNew varchar(40))
begin
    if (phoneNew = "") then
        -- query all order detail income
        select c.customerName, c.customerPhone, od.orderNo, sum(od.actualPrice * od.quantity) from orderDetails od
        join orders o on (od.orderNo = o.orderNo)
        join customers c on (o.customerPhone = c.customerPhone)
        group by c.customerPhone, o.orderNo
        order by c.customerPhone, o.orderNo;
    else
        -- query order detail income by customer phone
        set @n2 = concat('%', phoneNew, '%');
        select c.customerName, c.customerPhone, od.orderNo, sum(od.actualPrice * od.quantity) from orderDetails od
        join orders o on (od.orderNo = o.orderNo)
        join customers c on (o.customerPhone = c.customerPhone)
        where c.customerPhone like @n2
        group by c.customerPhone, o.orderNo
        order by c.customerPhone, o.orderNo;
    end if;
end #
\d ;

-- query customer's product quantity by product no
\d #
create procedure queryCustomerProductQuantityByProductNo(in noNew varchar(40))
begin
    if (noNew = "") then
        -- query customer's product quantity of all product no
        select p.productNo, p.productName, c.customerName, c.customerPhone, sum(od.quantity) from orderDetails od
        join products p on (od.productNo = p.productNo)
        join orders o on (od.orderNo = o.orderNo)
        join customers c on (o.customerPhone = c.customerPhone)
        group by od.productNo, c.customerPhone
        order by od.productNo, c.customerPhone;
    else
        -- query customer's product quantity by product no
        set @n2 = concat('%', noNew, '%');
        select p.productNo, p.productName, c.customerName, c.customerPhone, sum(od.quantity) from orderDetails od
        join products p on (od.productNo = p.productNo)
        join orders o on (od.orderNo = o.orderNo)
        join customers c on (o.customerPhone = c.customerPhone)
        where od.productNo like @n2
        group by od.productNo, c.customerPhone
        order by od.productNo, c.customerPhone;
    end if;
end #
\d ;

-- query product quantity by supplier phone
\d #
create procedure queryProductQuantityBySupplierPhone(in phoneNew varchar(40))
begin
    if (phoneNew = "") then
        -- query product quantity of all supplier phone
        select s.supplierName, s.supplierPhone, od.productNo, sum(od.quantity) from orderDetails od
        join products p on (od.productNo = p.productNo)
        join suppliers s on (p.supplierPhone = s.supplierPhone)
        group by s.supplierPhone, od.productNo
        order by s.supplierPhone, od.productNo;
    else
        -- query product quantity by supplier phone
        set @n2 = concat('%', phoneNew, '%');
        select s.supplierName, s.supplierPhone, od.productNo, sum(od.quantity) from orderDetails od
        join products p on (od.productNo = p.productNo)
        join suppliers s on (p.supplierPhone = s.supplierPhone)
        where s.supplierPhone like @n2
        group by s.supplierPhone, od.productNo
        order by s.supplierPhone, od.productNo;
    end if;
end #
\d ;

--------------------------------------------------------------------------------
