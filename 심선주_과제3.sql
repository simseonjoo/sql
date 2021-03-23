20210323 과제
데이터 결합(outer join 실습 outer join 5)
outer join 4를 바탕으로 고객 이름 컬럼 추가하기 (테이블 3개로 해야한다.)

SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT *
FROM customer;

--outer join 4]
SELECT product.*, :cid cid, NVL(cycle.day, 0)day, NVL(cycle.cnt, 0)cut
FROM product, cycle
WHERE product.pid = cycle.pid (+)
    AND cid(+) = :cid;

--outer join 5]
SELECT product.*, :cid cid, NVL(cycle.day, 0)day, NVL(cycle.cnt, 0)cut, customer.cnm
FROM product, cycle, customer
WHERE product.pid = cycle.pid (+)
    AND cycle.cid(+) = :cid
    AND :cid = customer.cid;