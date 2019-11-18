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
-- Name: gg; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA gg;


ALTER SCHEMA gg OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: g_table; Type: TABLE; Schema: gg; Owner: postgres
--

CREATE TABLE gg.g_table (
    product_id character(4) NOT NULL,
    product_name character varying(100) NOT NULL,
    product_type character varying(32) NOT NULL,
    sale_price integer,
    purchase_price integer,
    regist_date date
);


ALTER TABLE gg.g_table OWNER TO postgres;

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
-- Data for Name: g_table; Type: TABLE DATA; Schema: gg; Owner: postgres
--



--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product VALUES ('0001', 'T恤', '衣服', 1000, 500, '2009-09-20');
INSERT INTO public.product VALUES ('0002', '打孔器', '办公用品', 500, 320, '2009-09-11');
INSERT INTO public.product VALUES ('0003', '运动T恤', '衣服', 4000, 2800, NULL);
INSERT INTO public.product VALUES ('0004', '菜刀', '厨房用具', 3000, 2800, '2009-09-20');
INSERT INTO public.product VALUES ('0005', '高压锅', '厨房用具', 6800, 5000, '2009-01-15');
INSERT INTO public.product VALUES ('0006', '叉子', '厨房用具', 500, NULL, '2009-09-20');
INSERT INTO public.product VALUES ('0007', '擦菜板', '厨房用具', 880, 790, '2008-04-28');
INSERT INTO public.product VALUES ('0008', '圆珠笔', '办公用品', 100, NULL, '2009-11-11');


--
-- Name: g_table g_table_pkey; Type: CONSTRAINT; Schema: gg; Owner: postgres
--

ALTER TABLE ONLY gg.g_table
    ADD CONSTRAINT g_table_pkey PRIMARY KEY (product_id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- PostgreSQL database dump complete
--

