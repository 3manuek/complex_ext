
\echo Use "CREATE EXTENSION complex_ext" to load this file. \quit

CREATE TYPE complex AS (
    x double precision,
    y double precision
);

--function for sum
CREATE OR REPLACE FUNCTION public.complex_add (a complex, b complex)
    RETURNS complex
    LANGUAGE plpgsql 
    AS $function$
DECLARE
    result complex;
BEGIN
    result.x := a.x + b.x;

    result.y := a.y + b.y;

RETURN result;

END;
$function$;

--operator for sum
CREATE OPERATOR + (
    LEFTARG = complex,
    RIGHTARG = complex,
    PROCEDURE = complex_add,
    commutator = +);

--aggreate function for sum
CREATE AGGREGATE complex_sum (
    SFUNC = complex_add,
    BASETYPE = complex,
    STYPE = complex,
    INITCOND = '(0,0)'
);

--functions for operators
CREATE FUNCTION complex_abs_cmp_internal (a complex, b complex)
    RETURNS int
    LANGUAGE plpgsql
    AS $function$
DECLARE
    amag double precision;
    bmag double precision;
BEGIN
    amag := a.x * a.x + a.y * a.y;
    bmag := b.x * b.x + b.y * b.y;
    IF amag < bmag THEN
        RETURN -1;
    ELSIF amag > bmag THEN
        RETURN 1;
    END IF;
    RETURN 0;
END;
$function$;

CREATE FUNCTION complex_abs_lt (a complex, b complex)
    RETURNS boolean
    LANGUAGE plpgsql
    AS $function$
BEGIN
    RETURN complex_abs_cmp_internal (a, b) < 0;
END;
$function$;

CREATE FUNCTION complex_abs_le (a complex, b complex)
    RETURNS boolean
    LANGUAGE plpgsql
    AS $function$
BEGIN
    RETURN complex_abs_cmp_internal (a, b) <= 0;
END;
$function$;

CREATE FUNCTION complex_abs_eq (a complex, b complex)
    RETURNS boolean
    LANGUAGE plpgsql
    AS $function$
BEGIN
    RETURN complex_abs_cmp_internal (a, b) = 0;
END;
$function$;

CREATE FUNCTION complex_abs_ge (a complex, b complex)
    RETURNS boolean
    LANGUAGE plpgsql
    AS $function$
BEGIN
    RETURN complex_abs_cmp_internal (a, b) >= 0;
END;
$function$;

CREATE FUNCTION complex_abs_gt (a complex, b complex)
    RETURNS boolean
    LANGUAGE plpgsql
    AS $function$
BEGIN
    RETURN complex_abs_cmp_internal (a, b) > 0;
END;
$function$;

CREATE FUNCTION complex_abs_cmp (a complex, b complex)
    RETURNS int
    LANGUAGE plpgsql
    AS $function$
BEGIN
    RETURN complex_abs_cmp_internal (a, b);
END;
$function$;

--operators for indexes
CREATE OPERATOR < (
    LEFTARG = complex,
    RIGHTARG = complex,
    PROCEDURE = complex_abs_lt,
    commutator = >,
    negator = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);

CREATE OPERATOR <= (
    LEFTARG = complex,
    RIGHTARG = complex,
    PROCEDURE = complex_abs_le,
    commutator = >=,
    negator = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);

CREATE OPERATOR = (
    LEFTARG = complex,
    RIGHTARG = complex,
    PROCEDURE = complex_abs_eq,
    commutator = =,
    -- leave out negator since we didn't create <> operator
    -- negator = <> ,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);

CREATE OPERATOR >= (
    LEFTARG = complex,
    RIGHTARG = complex,
    PROCEDURE = complex_abs_ge,
    commutator = <=,
    negator = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);

CREATE OPERATOR > (
    LEFTARG = complex,
    RIGHTARG = complex,
    PROCEDURE = complex_abs_gt,
    commutator = <,
    negator = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);

--OPERATOR CLASS fors indexes
CREATE OPERATOR class complex_abs_ops DEFAULT FOR TYPE complex
    USING btree AS
    OPERATOR 1 <,
    OPERATOR 2 <=,
    OPERATOR 3 =,
    OPERATOR 4 >=,
    OPERATOR 5 >,
    FUNCTION 1 complex_abs_cmp ( complex, complex
);

