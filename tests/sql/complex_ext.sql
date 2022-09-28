CREATE EXTENSION complex_ext;
CREATE TABLE test_complex ( a complex,b complex);
INSERT INTO test_complex VALUES ((1.0, 2.5), (4.2, 3.55 ));
INSERT INTO test_complex VALUES ('(33.0, 51.4)', '(100.42, 93.55)');
SELECT (a + b) AS c FROM test_complex;