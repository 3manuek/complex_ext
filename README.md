# Complex data type using PL/PGSQL

In this example, we try to reproduce the complex data type example from [src/tutorial](https://github.com/postgres/postgres/tree/master/src/tutorial)   using PL/pgsql functions.

# Usage

Just load `complex_data_type.sql` file in your database, this file contains the new data type, beside and functions and operators ti work with this data type


```sql

--create table witn complex data type and insert data
CREATE TABLE test_complex ( a complex,b complex);
INSERT INTO test_complex VALUES ((1.0, 2.5), (4.2, 3.55 ));
INSERT INTO test_complex VALUES ('(33.0, 51.4)', '(100.42, 93.55)');

--using + operator
SELECT (a + b) AS c FROM test_complex;

--aggregate function
SELECT complex_sum(a),complex_sum(b)  FROM test_complex;

--create index and use it with rthe custom operator complex_abs_ops
CREATE INDEX test_cplx_ind ON test_complex USING btree(a complex_abs_ops);
--generate random data
INSERT INTO
	test_complex WITH q AS (
	SELECT
		(random() * 100,
		random() * 100)::complex a,
		(random() * 100,
		random() * 100)::complex b,
		generate_series(1, 100000))
SELECT 	a, 	b FROM 	q;

--check the index use
ANALYZE test_complex;
EXPLAIN SELECT * FROM test_complex WHERE a < (1,1)::complex;

```


# Cleaning  objects 

```sql
DROP TABLE test_complex;
DROP TYPE public.complex CASCADE ; 

```