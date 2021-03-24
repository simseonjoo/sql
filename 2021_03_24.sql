WHERE, GROUP BY, JOIN

SMITH 가 속한 부서에 있는 직원들을 조회하기 ==> 20번 부서에 속하는 직원들 조회하기
1. SMITH 가 속한 부서 이름을 알아 낸다.
2. 1번에서 알아낸 부서번호로 해당 부서에 속하는 직원을 emp테이블에서 검색한다.

SELECT *
FROM emp;

1.  SELECT deptno
    FROM emp
    WHERE ename = 'SMITH';

2.  SELECT *
    FROM emp
    WHERE deptno = 20; --> deptno IN(20);

SUBQUERY를 활용
3.  SELECT *
    FROM emp
    WHERE deptno = (SELECT deptno
                    FROM emp
                    WHERE ename = 'SMITH');
        
    WHERE deptno = (20, 'SMITH')
    WHERE deptno IN (20, 30)
 
SUBQUERY : 쿼리의 일부로 사용되는 쿼리
1. 사용위치에 따른 분류
- SELECT : 스칼라 서브 쿼리 - 서브쿼리의 실행결과가 하나의 행, 하나의 컬럼을 반환하는 쿼리
- FROM : 인라이 뷰
- WHERE : 서브쿼리
        : 메인쿼리의 컬럼을 가져다가 사용할 수 있다.
        : 반대로 서브쿼리의 컬럼을 메인쿼리에 가져가서 사용할 수 없다.

2. 반환값에 따른 분류 (행, 컬럼의 개수에 따른 분류)
- 행-다중행, 단일행, 컬럼-단일 컬럼, 복수 컬럼
- 다중행 단일 컬럼 (IN, NOT IN)
- 다중행 복수 컬럼 (pairwise)
- 단일행 단일 컬럼
- 단일행 복수 컬럼

3. main-sub query의 관계에 따른 분류
- 상호 연관 서브 쿼리(correlated subquery) : 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓴 경우
  ==> 메인쿼리가 없으면 서브쿼리만 독자적으로 실행 불가능
- 비상호 연관 서브 쿼리(non-correlated subquery) : 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓰지 않은 경우   
  ==> 메인쿼리가 없어도 서브쿼리만 실행 가능 

서브쿼리 (실습 sub1)
평균 급여보다 높은 급여를 받는 직원의 수를 조회하세요.
SELECT AVG(sal)
FROM emp;
    
SELECT COUNT(*)
FROM emp
WHERE sal >= 2073;
    
SELECT COUNT(*) 
FROM emp
WHERE sal >= (SELECT AVG(sal)
              FROM emp);

서브쿼리 (실습 sub2)
평균 급여보다 높은 급여를 받는 직원의 정보를 조회하세요.
SELECT * 
FROM emp
WHERE sal >= (SELECT AVG(sal)
              FROM emp);

서브쿼리 (실습 sub3)
SMITH와 WARD사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리를
다음과 같이 작성하세요.
SELECT *
FROM emp;

SELECT *
    FROM emp m
    WHERE m.deptno IN (SELECT s.deptno
                       FROM emp s
                       WHERE s.ename IN ('SMITH','WARD'));

MULTI ROW 연산자
IN : = + OR
비교 연산자 ANY
비교 연산자 ALL

직원중에 급여값이 SMITH(800)나 WARD(1250)의 급여보다 작은 직원을 조회
(==> 직원중에 급여값이 1250보다 작은 직원 조회) - ANY사용
SELECT *
FROM emp m
WHERE m.sal < ANY(SELECT MAX(s.sal)
                  FROM emp s
                  WHERE s.ename IN ('SMITH','WARD'));

직원의 급여가 800보다 작고 1250보다 작은 직원 조회
(==> 직원의 급여가 800보다 작은 직원 조회) - ALL사용
SELECT *
FROM emp m
WHERE m.sal < ALL(SELECT MIN(s.sal)
                  FROM emp s
                  WHERE s.ename IN ('SMITH','WARD'));
                  
subquery 사용시 주의점 NULL 값
IN ()
NOT IN ()

SELECT *
FROM emp
WHERE deptno IN (10, 20, NULL);
==> deotno = 10 OR deotno = 20 OR deotno = NULL
                                      FALSE

SELECT *
FROM emp
WHERE deptno NOT IN (10, 20, NULL);

==> !(deotno = 10 OR deotno = 20 OR deotno = NULL)
 ==> deotno != 10 AND deotno != 20 AND  deotno != NULL
                                            FALSE                                
TRUE AND TRUE AND TRUE ==> TRUE
TRUE AND TRUE AND FALSE ==> FALSE


--누군가의 매니저가 아닌사람들--*****시험문제
SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr, 9999)
                    FROM emp);


PAIR WISE : 순서쌍
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN(7499, 7782))
AND deptno IN(SELECT deptno
              FROM emp
              WHERE empno IN(7499, 7782));
              
SELECT ename, mgr, deptno
FROM emp
WHERE empno IN (7499, 7782);

SELECT *
FROM emp
WHERE mgr IN (7499, 7839)
AND deptno IN (10, 30);
(7698, 10), /(7698, 30), (7839, 10)이 두가지에 대한것만 나옴/, (7839, 30)

요구사항 : ALLEN 또는 CLARK의 소속 부서번호와 같으면서 상사도 같은 직원들을 조회
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE ename IN ('ALLEN','CLARK'));

DISTINCT
1. 설계가 잘못된 경우
2. 개발자가 SQL를 잘 작성하지 못한 경우
3. 요구사항이 이상한 경우

스칼라 서브 쿼리 : SELECT 절에 사용된 쿼리, *하나의 행, 하나의 컬럼*을 반환하는 서브쿼리(스칼라 서브쿼리)

SELECT empno, ename, SYSDATE
FROM emp;

SELECT SYSDATE
FROM dual;

SELECT empno, ename, (SELECT SYSDATE FROM dual)/*비상호,서브쿼리만 단독으로 사용할때 실행이된다*/
FROM emp;


emp 테이블에는 해당 직원이 속한 부서번호는 관리하지만 해당 부서명 정보는 dept 테이블에만 있다.
해당 직원이 속한 부서 이름을 알고 싶으면 dept 테이블과 조인을 해야한다.
                
SELECT empno, ename, deptno
FROM emp;

SELECT dname FROM dept WHERE deptno=20;

상호연관 서브쿼리는 항상 메인 쿼리가 먼저 실행된다.
비상호연관 서브쿼리는 메인쿼리가 먼저 실행 될 수도 있고
                   서브쿼리가 먼저 실행 될 수도 있다. / 쿼리 실행 순서가 정해져 있지 않음.
                   ==> 성능측면에서 유리한 쪽으로 오라클이 선택.

SELECT empno, ename, deptno,
    (SELECT dname FROM dept WHERE dept.deptno = emp.deptno)
FROM emp; --15번 실행 메인은 1개 행의 개수만큼 돌아,쿼리의 횟수가 15번임 

인라인 뷰 : SELECT QUERY
- inline : 해당위치에 직접 기술함0
- inline view : 해당위치에 직접 기술한 view
         view : QUERY(O) ==> view table (X) ****기억

SELECT *
FROM(SELECT deptno, ROUND(AVG(sal),2) avg_sal
     FROM emp
     GROUP BY deptno);

아래 쿼리는 전체 직원의 급여 평균보다 높은 급여를 받는 직원을조회하는 쿼리이다.
SELECT * 
FROM emp
WHERE sal >= (SELECT AVG(sal)
              FROM emp);
              
아래 쿼리는 직원이 속한 부서의 급여 평균보다 높은 급여를 받는 직원을 조회해라.
SELECT empno, ename, sal, deptno
FROM emp e
WHERE e.sal > (SELECT AVG(sal)
               FROM emp a
               WHERE a.deptno = e.deptno);
--메인쿼리에 있는 값에 따라 바뀐다.

10번 부서의 급여 평균 (2916.666)
SELECT AVG(sal)
FROM emp
WHERE deptno = 10;

20번 부서의 급여 평균 (2175)
SELECT AVG(sal)
FROM emp
WHERE deptno = 20;

30번 부서의 급여 평균 (1566.6666)
SELECT AVG(sal)
FROM emp
WHERE deptno = 30;


deptno, dname, loc
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT *
FROM dept;

서브쿼리 (실습 sub4)
dept 테이블에는 신규 등록된 99번 부서에 속한 사람은 없음
직원이 속하지 않은 부서를 조회하는 쿼리를 작성해보세요.
(직원이 속하지 않은 부서 ==> 우리가 알수있는건 직원이 속한 부서)
SELECT *
FROM dept

SELECT deptno
FROM emp;

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                    FROM emp);

서브쿼리 (실습 sub5)
cycle, product 테이블을 이용하여 cid = 1인 고객이 애음하지 않는 제품을 조회하는
쿼리를 작성하세요.

SELECT *
FROM product;

SELECT pid
FROM cycle
WHERE cid = 1;

SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);