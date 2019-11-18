--
-- PostgreSQL database dump
--

-- Dumped from database version 11.4
-- Dumped by pg_dump version 11.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: sams_teach_sql; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sams_teach_sql;


ALTER SCHEMA sams_teach_sql OWNER TO postgres;

--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: customers; Type: TABLE; Schema: sams_teach_sql; Owner: postgres
--

CREATE TABLE sams_teach_sql.customers (
    cust_id character(10) NOT NULL,
    cust_name character(50) NOT NULL,
    cust_address character(50),
    cust_city character(50),
    cust_state character(5),
    cust_zip character(10),
    cust_country character(50),
    cust_contact character(50),
    cust_email character(255)
);


ALTER TABLE sams_teach_sql.customers OWNER TO postgres;

--
-- Name: orderitems; Type: TABLE; Schema: sams_teach_sql; Owner: postgres
--

CREATE TABLE sams_teach_sql.orderitems (
    order_num integer NOT NULL,
    order_item integer NOT NULL,
    prod_id character(10) NOT NULL,
    quantity integer NOT NULL,
    item_price numeric(8,2) NOT NULL
);


ALTER TABLE sams_teach_sql.orderitems OWNER TO postgres;

--
-- Name: orders; Type: TABLE; Schema: sams_teach_sql; Owner: postgres
--

CREATE TABLE sams_teach_sql.orders (
    order_num integer NOT NULL,
    order_date date NOT NULL,
    cust_id character(10) NOT NULL
);


ALTER TABLE sams_teach_sql.orders OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: sams_teach_sql; Owner: postgres
--

CREATE TABLE sams_teach_sql.products (
    prod_id character(10) NOT NULL,
    vend_id character(10) NOT NULL,
    prod_name character(255) NOT NULL,
    prod_price numeric(8,2) NOT NULL,
    prod_desc character varying(1000)
);


ALTER TABLE sams_teach_sql.products OWNER TO postgres;

--
-- Name: vendors; Type: TABLE; Schema: sams_teach_sql; Owner: postgres
--

CREATE TABLE sams_teach_sql.vendors (
    vend_id character(10) NOT NULL,
    vend_name character(50) NOT NULL,
    vend_address character(50),
    vend_city character(50),
    vend_state character(5),
    vend_zip character(10),
    vend_country character(50)
);


ALTER TABLE sams_teach_sql.vendors OWNER TO postgres;

--
-- Data for Name: customers; Type: TABLE DATA; Schema: sams_teach_sql; Owner: postgres
--

COPY sams_teach_sql.customers (cust_id, cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_contact, cust_email) FROM stdin;
1000000001	Village Toys                                      	200 Maple Lane                                    	Detroit                                           	MI   	44444     	USA                                               	John Smith                                        	sales@villagetoys.com                                                                                                                                                                                                                                          
1000000002	Kids Place                                        	333 South Lake Drive                              	Columbus                                          	OH   	43333     	USA                                               	Michelle Green                                    	\N
1000000003	Fun4All                                           	1 Sunny Place                                     	Muncie                                            	IN   	42222     	USA                                               	Jim Jones                                         	jjones@fun4all.com                                                                                                                                                                                                                                             
1000000004	Fun4All                                           	829 Riverside Drive                               	Phoenix                                           	AZ   	88888     	USA                                               	Denise L. Stephens                                	dstephens@fun4all.com                                                                                                                                                                                                                                          
1000000005	The Toy Store                                     	4545 53rd Street                                  	Chicago                                           	IL   	54545     	USA                                               	Kim Howard                                        	\N
\.


--
-- Data for Name: orderitems; Type: TABLE DATA; Schema: sams_teach_sql; Owner: postgres
--

COPY sams_teach_sql.orderitems (order_num, order_item, prod_id, quantity, item_price) FROM stdin;
20005	1	BR01      	100	5.49
20005	2	BR03      	100	10.99
20006	1	BR01      	20	5.99
20006	2	BR02      	10	8.99
20006	3	BR03      	10	11.99
20007	1	BR03      	50	11.49
20007	2	BNBG01    	100	2.99
20007	3	BNBG02    	100	2.99
20007	4	BNBG03    	100	2.99
20007	5	RGAN01    	50	4.49
20008	1	RGAN01    	5	4.99
20008	2	BR03      	5	11.99
20008	3	BNBG01    	10	3.49
20008	4	BNBG02    	10	3.49
20008	5	BNBG03    	10	3.49
20009	1	BNBG01    	250	2.49
20009	2	BNBG02    	250	2.49
20009	3	BNBG03    	250	2.49
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: sams_teach_sql; Owner: postgres
--

COPY sams_teach_sql.orders (order_num, order_date, cust_id) FROM stdin;
20005	2012-05-01	1000000001
20006	2012-01-12	1000000003
20007	2012-01-30	1000000004
20008	2012-02-03	1000000005
20009	2012-02-08	1000000001
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: sams_teach_sql; Owner: postgres
--

COPY sams_teach_sql.products (prod_id, vend_id, prod_name, prod_price, prod_desc) FROM stdin;
BR01      	BRS01     	8 inch teddy bear                                                                                                                                                                                                                                              	5.99	8 inch teddy bear, comes with cap and jacket
BR02      	BRS01     	12 inch teddy bear                                                                                                                                                                                                                                             	8.99	12 inch teddy bear, comes with cap and jacket
BR03      	BRS01     	18 inch teddy bear                                                                                                                                                                                                                                             	11.99	18 inch teddy bear, comes with cap and jacket
BNBG01    	DLL01     	Fish bean bag toy                                                                                                                                                                                                                                              	3.49	Fish bean bag toy, complete with bean bag worms with which to feed it
BNBG02    	DLL01     	Bird bean bag toy                                                                                                                                                                                                                                              	3.49	Bird bean bag toy, eggs are not included
BNBG03    	DLL01     	Rabbit bean bag toy                                                                                                                                                                                                                                            	3.49	Rabbit bean bag toy, comes with bean bag carrots
RGAN01    	DLL01     	Raggedy Ann                                                                                                                                                                                                                                                    	4.99	18 inch Raggedy Ann doll
RYL01     	FNG01     	King doll                                                                                                                                                                                                                                                      	9.49	12 inch king doll with royal garments and crown
RYL02     	FNG01     	Queen doll                                                                                                                                                                                                                                                     	9.49	12 inch queen doll with royal garments and crown
\.


--
-- Data for Name: vendors; Type: TABLE DATA; Schema: sams_teach_sql; Owner: postgres
--

COPY sams_teach_sql.vendors (vend_id, vend_name, vend_address, vend_city, vend_state, vend_zip, vend_country) FROM stdin;
BRS01     	Bears R Us                                        	123 Main Street                                   	Bear Town                                         	MI   	44444     	USA                                               
BRE02     	Bear Emporium                                     	500 Park Street                                   	Anytown                                           	OH   	44333     	USA                                               
DLL01     	Doll House Inc.                                   	555 High Street                                   	Dollsville                                        	CA   	99999     	USA                                               
FRB01     	Furball Inc.                                      	1000 5th Avenue                                   	New York                                          	NY   	11111     	USA                                               
FNG01     	Fun and Games                                     	42 Galaxy Road                                    	London                                            	\N	N16 6PS   	England                                           
JTS01     	Jouets et ours                                    	1 Rue Amusement                                   	Paris                                             	\N	45678     	France                                            
\.


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: sams_teach_sql; Owner: postgres
--

ALTER TABLE ONLY sams_teach_sql.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (cust_id);


--
-- Name: orderitems orderitems_pkey; Type: CONSTRAINT; Schema: sams_teach_sql; Owner: postgres
--

ALTER TABLE ONLY sams_teach_sql.orderitems
    ADD CONSTRAINT orderitems_pkey PRIMARY KEY (order_num, order_item);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: sams_teach_sql; Owner: postgres
--

ALTER TABLE ONLY sams_teach_sql.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_num);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: sams_teach_sql; Owner: postgres
--

ALTER TABLE ONLY sams_teach_sql.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (prod_id);


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: sams_teach_sql; Owner: postgres
--

ALTER TABLE ONLY sams_teach_sql.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (vend_id);


--
-- Name: orderitems fk_orderitems_orders; Type: FK CONSTRAINT; Schema: sams_teach_sql; Owner: postgres
--

ALTER TABLE ONLY sams_teach_sql.orderitems
    ADD CONSTRAINT fk_orderitems_orders FOREIGN KEY (order_num) REFERENCES sams_teach_sql.orders(order_num);


--
-- Name: orderitems fk_orderitems_products; Type: FK CONSTRAINT; Schema: sams_teach_sql; Owner: postgres
--

ALTER TABLE ONLY sams_teach_sql.orderitems
    ADD CONSTRAINT fk_orderitems_products FOREIGN KEY (prod_id) REFERENCES sams_teach_sql.products(prod_id);


--
-- Name: orders fk_orders_customers; Type: FK CONSTRAINT; Schema: sams_teach_sql; Owner: postgres
--

ALTER TABLE ONLY sams_teach_sql.orders
    ADD CONSTRAINT fk_orders_customers FOREIGN KEY (cust_id) REFERENCES sams_teach_sql.customers(cust_id);


--
-- Name: products fk_products_vendors; Type: FK CONSTRAINT; Schema: sams_teach_sql; Owner: postgres
--

ALTER TABLE ONLY sams_teach_sql.products
    ADD CONSTRAINT fk_products_vendors FOREIGN KEY (vend_id) REFERENCES sams_teach_sql.vendors(vend_id);


--
-- PostgreSQL database dump complete
--

