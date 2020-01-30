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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: chars; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chars (
    chr character(3) NOT NULL
);


ALTER TABLE public.chars OWNER TO postgres;

--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    product_id character(4) NOT NULL,
    product_name character varying(100) NOT NULL,
    product_type character varying(32) NOT NULL,
    sale_price integer,
    purchase_price integer,
    regist_date date
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: product_x; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_x (
    product_name character varying(100) NOT NULL,
    product_type character varying(32) NOT NULL,
    sale_price integer,
    purchase_price integer,
    regist_date date,
    product_id character(4) NOT NULL
);


ALTER TABLE public.product_x OWNER TO postgres;

--
-- Name: productcopy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productcopy (
    product_id character(4) NOT NULL,
    product_name character varying(100) NOT NULL,
    product_type character varying(32) NOT NULL,
    sale_price integer,
    purchase_price integer,
    regist_date date
);


ALTER TABLE public.productcopy OWNER TO postgres;

--
-- Name: productins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productins (
    product_id character(4) NOT NULL,
    product_name character varying(100) NOT NULL,
    product_type character varying(32) NOT NULL,
    sale_price integer DEFAULT 0,
    purchase_price integer,
    regist_date date
);


ALTER TABLE public.productins OWNER TO postgres;

--
-- Name: producttype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producttype (
    product_type character varying(32) NOT NULL,
    sum_sale_price integer,
    sum_purchase_price integer
);


ALTER TABLE public.producttype OWNER TO postgres;

--
-- Data for Name: chars; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chars (chr) FROM stdin;
1  
2  
3  
10 
11 
222
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (product_id, product_name, product_type, sale_price, purchase_price, regist_date) FROM stdin;
0001	T恤	衣服	1000	500	2009-09-20
0002	打孔器	办公用品	500	320	2009-09-11
0003	运动T恤	衣服	4000	2800	\N
0004	菜刀	厨房用具	3000	2800	2009-09-20
0005	高压锅	厨房用具	6800	5000	2009-01-15
0006	叉子	厨房用具	500	\N	2009-09-20
0007	擦菜板	厨房用具	880	790	2008-04-28
0008	圆珠笔	办公用品	100	\N	2009-11-11
\.


--
-- Data for Name: product_x; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_x (product_name, product_type, sale_price, purchase_price, regist_date, product_id) FROM stdin;
打孔器	办公用品	500	320	2009-09-20	0002
菜刀	厨房用具	3000	2800	2009-09-20	0004
钢笔	办公用品	100	\N	2009-11-11	0011
打孔器B	办公用品	500	320	2009-09-20	0012
打孔器A	办公用品	500	330	2009-09-20	0014
擦菜板	厨房用具	880	790	2008-04-28	0007
裤子	衣服	1000	500	2009-09-20	0009
运动T恤	衣服	4000	2800	\N	0003
裤子2	衣服	2000	400	2009-09-30	0015
圆珠笔	办公用品	100	\N	2009-11-11	0008
打孔器C	办公用品	500	310	2009-09-20	0013
衣服2	衣服	2000	1000	2009-09-30	0010
T恤	衣服	1000	500	2009-09-20	0001
叉子	厨房用具	3000	\N	2009-09-20	0006
高压锅	厨房用具	6800	5000	2009-01-15	0005
\.


--
-- Data for Name: productcopy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productcopy (product_id, product_name, product_type, sale_price, purchase_price, regist_date) FROM stdin;
0001	T恤	衣服	1000	500	2009-09-20
0002	打孔器	办公用品	500	320	2009-09-11
0003	运动T恤	衣服	4000	2800	\N
0004	菜刀	厨房用具	3000	2800	2009-09-20
0005	高压锅	厨房用具	6800	5000	2009-01-15
0007	擦菜板	厨房用具	880	790	2008-04-28
0008	圆珠笔	办公用品	100	\N	2009-11-11
0006	叉子	厨房用具	500	\N	2009-09-20
\.


--
-- Data for Name: productins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productins (product_id, product_name, product_type, sale_price, purchase_price, regist_date) FROM stdin;
0001	T恤衫	衣服	1000	500	2009-09-20
0005	高压锅	厨房用具	6800	5000	2009-01-15
0007	擦菜板	厨房用具	0	790	2009-04-28
0008	圆珠笔	办公用品	100	\N	2009-12-12
\.


--
-- Data for Name: producttype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producttype (product_type, sum_sale_price, sum_purchase_price) FROM stdin;
衣服	5000	3300
办公用品	600	320
厨房用具	11180	8590
\.


--
-- Name: chars chars_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chars
    ADD CONSTRAINT chars_pkey PRIMARY KEY (chr);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- Name: product_x product_x_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_x
    ADD CONSTRAINT product_x_pk PRIMARY KEY (product_id);


--
-- Name: productcopy productcopy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productcopy
    ADD CONSTRAINT productcopy_pkey PRIMARY KEY (product_id);


--
-- Name: productins productins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productins
    ADD CONSTRAINT productins_pkey PRIMARY KEY (product_id);


--
-- Name: producttype producttype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producttype
    ADD CONSTRAINT producttype_pkey PRIMARY KEY (product_type);


--
-- PostgreSQL database dump complete
--

