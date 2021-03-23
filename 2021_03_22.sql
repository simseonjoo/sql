데이터 결합 (실습 join 1)
SELECT *
FROM lprod;

SELECT *
FROM prod;

SELECT lprod.lprod_gu, lprod.lprod_nm,
    prod.prod_id, prod.prod_name
FROM lprod, prod
WHERE lprod.lprod_gu = prod.prod_lgu;
-- 자바랑 연결해서 prod.exerd에 확인 
 
SELECT prod_id, prod_name, prod_lgu 
FROM prod;

데이터 결합 (실습 join 2)
erd 다이어그램을 참고하여 buyer, prod 테이블을 조인하여 buyer별 담당하는 제품
정보를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.

SELECT *
FROM buyer;

SELECT *
FROM prod;

SELECT buyer.buyer_id, buyer.buyer_name,
    prod.prod_id, prod.prod_name
FROM buyer, prod
WHERE buyer.buyer_id = prod.prod_buyer;

데이터 결합 (실습 join 3)
erd 다이어그램을 참고하여 member, cart, prod 테이블을 조인하여 회원별 장바구니에 담은 제품정보를
다음과 같은 결과가 나오도록 쿼리를 작성해보세요.

SELECT *
FROM member;

SELECT *
FROM cart;

SELECT *
FROM prod;

SELECT *
FROM member, cart
WHERE member.mem_id = cart.cart_member;
-------------------------------------------member와 cart 만 봤을때 (두개 먼저 잘되는지 보고 그 다음 하나 더 추가해서)
SELECT member.mem_id, member.mem_name,
    prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member
    AND cart.cart_prod = prod.prod_id;

SELECT member.mem_id, member.mem_name,
    prod.prod_id, prod.prod_name, cart.cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member)
            JOIN prod ON (cart.cart_prod = prod.prod_id);

데이터 결합 (실습 join 4)
erd 다이어그램을 참고하여 customer, cycle 테이블을 조인하여 고객별 애음 제품,
애음요일, 개수를 다음과 같은 결과가 나오도록 작성해보세요.
(고객명이 brown, sally인 고객만 조회)
(*정렬과 관계없이 값이 맞으면 정답)
SELECT *
FROM customer;

SELECT *
FROM cycle;

SELECT customer.cid, customer.cnm,
    cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
    AND customer.cnm IN ('brown', 'sally');

데이터 결합 (실습 join 5)
erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여 고객별 애음 제품,
애음요일, 개수, 제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
(고객명이 brown, sally인 고객만 조회)
(*정렬과 관계없이 값이 맞으면 정답)

SELECT *
FROM product;

SELECT customer.cid, customer.cnm,
    cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
    AND cycle.pid = product.pid
    AND customer.cnm IN ('brown', 'sally');

데이터 결합 (실습 join 6)
erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여
애음요일과 관계없이 고객별 애음 제품별, 개수의 합과, 제품명을 다음과 같은 결과가
나오도록 쿼리를 작성해보세요.
(*정렬과 관계없이 값이 맞으면 정답)

SELECT customer.cid, customer.cnm,
    cycle.pid, product.pnm, SUM(cycle.cnt) cut
FROM customer, cycle, product
WHERE cycle.pid = product.pid
GROUP BY customer.cid, customer.cnm,
    cycle.pid, product.pnm;

데이터 결합 (실습 join 7)
erd 다이어그램을 참고하여 cycle, product 테이블을 이용하여 제품별, 개수의 합과, 제품명을
다음과 같은 결과가 나오도록 쿼리를 작성해보세요
(정렬과 관계없이 갓이 맞으면 정답)

SELECT cycle.pid, product.pnm, SUM(cycle.cnt) cut
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, product.pnm;

---------------------------------------------------------------------------------

이너 조인과 아우터 조인

OUTER JOIN : 컬럼 연결이 실패해도 [기준]이 되는 테이블 쪽의 컬럼 정보는 나오도록 하는 조인
1. LEFT OUTER JOIN : 기준이 왼쪽에 기술한 테이블이 되는 OUTER JOIN
2. RIGHT OUTER JOIN : 기준이 오른쪽에 기술한 테이블이 되는 OUTER JOIN
3. FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - 중복데이터 1개만 남기고 제거(사용빈도가 거의 없음 / 정의정도는 기억하기)

테이블1 JOIN 테이블2

테이블1 LEFT OUTER JOIN 테이블2
== 위와 아래 같음
테이블2 RIGH OUTER JOIN 테이블1

직원의 이름, 직원의 상사 이름 두개의 컬럼이 나오도록 JOIN QUERY 작성
SELECT *
FROM emp;

SELECT e.ename, m.ename 
FROM emp e,emp m 
WHERE e.mgr = m.empno;

SELECT e.ename, m.ename 
FROM emp e JOIN emp m ON(e.mgr = m.empno); -- e.mgr = m.empno 연결/13개의 결과값이 나옴

SELECT e.ename, m.ename 
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno); --NULL값 포함 14개의 결과값이 나옴

-- ORACLE SQL OUTER JOIN 표기 : (+)
-- OUTER 조인으로 인해 데이터가 안 나오는 쪽 컬럼에 (+)를 붙여준다.
SELECT e.ename, m.ename 
FROM emp e,emp m 
WHERE e.mgr = m.empno(+); 

-- 부서번호 추가
SELECT e.ename, m.ename, m.deptno 
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno AND m.deptno = 10); 
--CLARK과 KING해서 총 4개만 값이 나오고 나머지는 NULL값으로

SELECT e.ename, m.ename, m.deptno 
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno) --여기까진 14개 다 나옴.
WHERE m.deptno = 10; --10인것만 나옴 

-------------------------------------------
SELECT e.ename, m.ename, m.deptno
FROM emp e,emp m 
WHERE e.mgr = m.empno(+)
    AND m.deptno = 10;

SELECT e.ename, m.ename, m.deptno
FROM emp e,emp m 
WHERE e.mgr = m.empno(+)
    AND m.deptno(+) = 10;
------------------------------------------- (+)로 결과값이 달라짐.

SELECT e.ename, m.ename, m.deptno 
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);

SELECT e.ename, m.ename, m.deptno 
FROM emp m RIGHT OUTER JOIN emp e ON(e.mgr = m.empno);

-- 데이터는 몇건이나 나올까? - 21건
SELECT e.ename, m.ename, m.deptno 
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno); 


-- FULL OUTER : LEFT OUTER JOIN(14건) + RIGHT OUTER JOIN(21건) - 중복데이터 1개만 남기고 제거(13건) = 22건
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno); --22 건

-- FULL OUTER 조인은 오라클 SQL 문법으로 제공하지 않는다.
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr(+) = m.empno (+); -- 이렇게하면 오류가 남

outerjoin 1]
SELECT *
FROM buyprod
WHERE buy_date = TO_DATE('20050125','YYYYMMDD'); 

모든 제품을 다 보여주고, 실제 구매가 있을 때는 구매수량을 조회,
없을 경우 NULL로 표현
제품 코드 : 수량
P101000001 : NULL

데이터 결합(outer join 실습 outer join 1)
buyprod 테이블에 구매일자가 2005년 1월 25일인 데이터는 3품목 밖에 없다.
모든 품목이 나올수 있도록 쿼리를 작성 해보세요.

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id 
    AND buy_date = TO_DATE('20050125','YYYYMMDD'));


SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod 
WHERE buyprod.buy_prod(+) = prod.prod_id 
    AND buy_date(+) = TO_DATE('20050125','YYYYMMDD'); 