
group function 실습 grp 2
emp 테이블을 이용하여 다음을 구하시오
위의 문제와 같고 부서별로 
SELECT deptno, MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;

group function 실습 grp 3
emp 테이블을 이용하여 다음을 구하시오
grp2에서 작성한 쿼리를 활용하여
deptno 대신 부서명이 나올수 있도록 수정하시오

SELECT 
    CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        ELSE 'DDIT'
    END dname,MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno
ORDER BY deptno;

group function 실습 grp 4
emp 테이블을 이용하여 다음을 구하시오.
직원의 입사 년월별로 몇명의 직원이 이사했는지 조회하는 쿼리를 작성하세요.

SELECT TO_CHAR(hiredate, 'YYYYMM')HITR_YYYYMM,COUNT(*)
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM')
ORDER BY TO_CHAR(hiredate, 'YYYYMM');

group function 실습 grp 5
emp테이블을 이용하여 다음을 구하시오.
직원의 입사 년월별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요.
SELECT TO_CHAR(hiredate, 'YYYY')HITR_YYYY,COUNT(*)
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY COUNT(*);

group function 실습 grp 6
회사의 존재하는 부서의 개수는 몇개인지 조회하는 쿼리를 작성하시오
(dept)
SELECT count(*)
FROM dept;

group function 실습 grp 7
직원이 속한 부서의 개수를 조회하는 쿼리를 작성하시오.
(emp테이블 사용)
SELECT COUNT(*)
FROM (SELECT deptno
      FROM emp
      GROUP BY deptno);
----------------------------------------------------------------------
데이터를 확장 (결합)
1. 컬럼에 대한 확장 (JOIN)
2. 행에 대한 확장 : 집합연산자(UNION ALL, UNION(합집합), MINUS(차지합), INTERSECT(교집합))

JOIN
RDBMS는 중복을 최소화 하는 현태의 데이터 베이스
다른 테이블과 결합하여 데이터를 조회

중복을 최소화하는 RDBMS 방식으로 설계한 경우
emp 테이블에는 부서 코드만 존재, 부서정보를 담은 dept 테이블 별도로 생성
emp테이블과 dept 테이블의 연결고리(depton)로 조인하여 실제 부서명을 조회한다.

JOIN
1. 표준 SQL => ANSI SQL 
2. 비표준 SQL - DMBS를 만드는 회사에서 만든 고유의 SQL 문법 // 조금더 간결하다.

ANSI : SQL
ORACLE : SQL

ANSI - NATURAL JOIN
- 조인하고자 하는 테이블의 연결 컬럼명(타입도 동일)이 동일한 경우(emp.deptno, dept.deptno)
- 연결 컬럼이 값이 동일할 때(=) 컬럼이 확장된다.

SELECT emp.empon, emp.ename, deptno--deptno는 연결 컬럼이기 떄문에 한정자가 붙으면 조회가 안됨
FROM emp NATURAL JOIN dept;

ORACLE JOIN
1. FROM 절에 조인할 테이블을(,)콤마로 쿠분하여 나열
2. WHERE : 조인할 테이블의 연결조건을 기술

SELECT *
FROM emp, dept
WHERE deptno = deptno; --이렇게하면 오류가 뜸.

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno; --이렇게 해줘야 함. 만족하는 행을 연결 // 오라클에서는 조회를 이런식으로 함.

7369 SMITH, 7902 FORD
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno; -- 이 직원의 메니저(상사)를 찾아줌. --킹의 메니저는 null이기에 안뜸.(조인에 실패, 조건에 만족을 못해서)

ANSI SQL : JOIN WITH USING
조인 하려고 하는 테이블의 컬럼명과 타입이 같은 컬럼이 두개 이상인 상황에서
두 컬럼을 모두 조인 조건으로 참여시키지 않고, 개발자가 원하는 특정 컬럼으로만 연결을 시키고 싶을 때 사용

SELECT *
FROM emp JOIN dept USING(deptno);

SELECT * 
FROM emp, dept
WHERE emp.deptno = dept.deptno; --오라클로 했을때 이런 형식

JOIN WITH ON : NATURAL JOIN, JOIN WITH USING을 대체할 수 있는 보편적인 문법
조인 컬럼을 개발자가 임의로 지정.

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

사원 번호, 사원 이름, 해당 사원의 상사 사번, 해당 사원의 상사 이름 : JOIN WITH ON을 이용하여 쿼리 작성
단 사원의 번호가 7369에서 7698인 사원들만 조회
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;

--오라클로 바꾸게 되면
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m 
WHERE e.empno BETWEEN 7369 AND 7698
AND e.mgr = m.empno;

논리적인 조인 형태
1. SELF JOIN : 조인 테이블이 같은 경우
    - 계층 구조 
2. NONEQUI-JOIN : 조인 조건이 = (equals)가 아닌 조인

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno; -- 연결조건!! 두개의 컬럼의 값이 같을 때.

SELECT * --*************시험에 나와용
FROM emp, dept
WHERE emp.deptno != dept.deptno; -- 다를때 연결을해라 // NONEQUI-JOIN : 조인 조건이 = (equals)가 아닌 조인 ->이 말
                                -- 자기의 부서와 다른 deptno 와 모두 연결이되서 조회가 된다.

SELECT *
FROM salgrade;

-- salgrade를 이용하여 직원의 급여 등급 구하기
-- empno, ename, sal, 급여 등급
-----------------------------
emp.sal >= salgrade.losal
AND
emp.sal <= salgrade.hisal

emp.sal BETWEEN salgrade.losal AND salgrade.hisal
-------------------------------

SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal and s.hisal;


SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e JOIN salgrade s ON(e.sal BETWEEN s.losal and s.hisal);

데이터 결합 실습 JOIN 0)
emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
SELECT empno, ename, emp.deptno, dname 
FROM emp, dept 
WHERE emp.deptno = dept.deptno; 

데이터 결합 실습 JOIN 1)
emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를작성하세요.
(10,30 조회)
SELECT empno, ename, emp.deptno, dname 
FROM emp, dept 
WHERE emp.deptno = dept.deptno 
 AND emp.deptno IN (10, 30);

데이터 결합 실습 JOIN 2)
emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
(급여가 2500 초과)
SELECT empno, ename, sal, emp.deptno, dname 
FROM emp, dept 
WHERE emp.deptno = dept.deptno 
 AND sal > 2500;

데이터 결합 실습 JOIN 3)
emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
(급여가 2500 초과, 사번이 7600보다 큰 직원)
SELECT empno, ename, sal, emp.deptno, dname 
FROM emp, dept 
WHERE emp.deptno = dept.deptno 
 AND sal > 2500
 AND empno > 7600;

데이터 결합 실습 JOIN 4)
emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
(급여가 2500 초과, 사번이 7600보다 크고, RESEARCH 부서에 속하는 직원)
SELECT empno, ename, sal, emp.deptno, dname 
FROM emp, dept 
WHERE emp.deptno = dept.deptno 
 AND sal > 2500
 AND empno > 7600
 AND dname = 'RESEARCH';
 
-------------------------------------------------------------------
 가상화가 도입된 이유
 물리적 컴퓨터는 동시에 하나의 OS만 실행 가능
 성능이 좋은 컴퓨터(서버)라도 하드웨어 자원의 활용이 낮음 : 15~20%
 

 






























