연산자 우선 순위 (AND가 OR보다 우선순위가 높다.)
==> 헷갈리면 ()를 사용하여 우선순위를 조정하자

SUBSTR (SQL) = subString(JAVA)

SELECT *
FROM emp
WHERE ename = 'SMITH' OR (ename = 'ALLEN' AND job = 'SALESMAN');
                  1   +        2          *          3
==> 직원의 이름이 ALLEN이면서 job이 SALESMAN이거나
    직원의 이름이 SMITH인 직원 정보를 조회(두개 중 하나만 만족해라)
    
SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN') AND job = 'SALESMAN';
==> 직원의 이름이 ALLEN이거나 SMITH 이면서
    job이 SALESMAN인 직원 정보를 조회 (두가지 조건이 다 만족하라)
    
실습 where14[AND, OR]
emp 테이블에서
1. job이 SALESMAN이거나
2. 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인
직원의 정보를 다음과 같이 조회 하세요.
(1번 조건 또는 2번 조건을 만족하는 직원)

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR (empno LIKE '78%' AND hiredate >= TO_DATE ('19810601','YYYYMMDD')); 
-----------------------------------------------------------------------------------------------------------
데이터 정렬
TABLE 객체에는 데이터를 저장/조회시 순서를 보정하지 않음
- 보편적으로 데이터가 입력된 순서대로 조회됨
- 데이터가 항상 동일한 순서로 조회되는 것을 보장하지 않는다
- 데이터가 삭제되고, 다른 데이터가 들어 올 수도 있음

--okky
--jsp ==> java server page

데이터 정렬(ORDER BY)
ORDER BY
ASC : 오름차순 (기본)
DESC : 내림차순
ORDER BY {정렬기준 컬럼 OR alias OR 컬럼번호}

데이터 정렬이 필요한 이유?
1. table 객체는 순서를 보장하지 않는다.
==> 오늘 실행한 쿼리를 내일 실행할 경우 동일한 순서로 조회가 되지 않을 수도 있다.
2. 현실세계에서는 정렬된 데이터가 필요한 경우가 있다.
==> 게시판의 게시글은 보편적으로 가장 최신글이 처음에나오고, 가장 오래된 글이 맨 밑에 있다.

SQL에서 정렬 : ORDER BY ==> SELECT -> FROM -> WHERE / 있을 수도 있고 없을 수도 있고, -> ORDER BY
정렬 방법 : ORDER BY 컬럼명 | 컬럼인덱스(순서) | 별칭 [정렬순서]
정렬 순서 : 기본 ASC(오름차순), DESC(내림차순)

SELECT *
FROM emp
ORDER BY ename ASC;
==> 알파벳이 작은순부터 큰순으로 정렬 (A-->B-->C-->...)
==> 1, 2, 3 ... 100  오름차순 (ASC -> DEFAULT)
==> 100, 99 ... 1    내림차순 (DESC -> 명시)

SELECT *
FROM emp
ORDER BY job DESC, sal ASC;

정렬 : 컬럼명이 아니라 select 절의 컬럼 순서(index)
SELECT *
FROM emp
ORDER BY 2;

AS로 한것도 ORDER BY에 해서 사용 가능함.

실습 orderby1 1 [ORDER BY]
1. dept 테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요
SELECT *
FROM DEPT
ORDER BY dname;

2. dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요
SELECT *
FROM DEPT
ORDER BY loc DESC;

실습 orderby1 2 [ORDER BY]
emp 테이블에서 상여(comm) 정보가 있는 사람들만 조회하고, 상여(comm)를 많이 받는 삶이 먼저 조회되도록 정렬하고,
상여가 같을 경우 사번으로 내림차순 정렬하세요. (단, 상여가 0인 사람은 상여가 없는것으로 간주)
SELECT *
FROM emp
WHERE comm IS NOT NULL
  AND comm ! = 0
ORDER BY comm DESC, EMPNO DESC; 

실습 orderby1 3 [ORDER BY]
emp 테이블에서 관리자가 있는 사람들만 조회하고, 직군(job) 순으로 오름차순 정렬하고, 
직군이 같을 경우 사번이 큰 사원이 먼저 조회되도록 쿼리를 작성하세요.
SELECT * 
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

실습 orderby1 4 [ORDER BY]
emp 테이블에서 10번 부서(deptno) 혹은 30번 부서에 속하는 사람중 급여(sal)가 1500이 넘는 사람들만 조회하고
이름으로 내림차순 정렬되도록 쿼리를 작성하세요.
SELECT *
FROM emp
WHERE deptno IN (10, 30) AND sal > 1500
ORDER BY ename DESC;
-----------------------------------------------------------------------------------------------
[페이징 처리] : 전체 데이터를 조회하는게 아니라 페이지 사이즈가 정해졌을 때 원하는 페이지의 데이터만 가져오는 방법
(1. 400건을 다 조회하고 필요한 20것만 사용하는 방법 --> 전체조회(400)
 2. 400건의 데이터중 원하는 페이지의 20건만 조회 --> 페이징 처리(20))
페이징 처리(게시글) ==> 정렬의 기준이 뭔데? (일반적으로는 게시글의 작성일시 역순)
페이징 처리시 고려할 변수 : 페이지 번호, 페이지 사이즈 

ROWNUM : 행번호를 부여하는 특수 키워드(오라클에서만 제공) --**************
    * 제약사항
      ROWNUM은 WHERE 절에서도 사용 가능하다.
       단, ROWNUM의 사용을 1부터 사용하는 경우에만 사용 가능
       WHERE ROWNUM BETWEEN 1 AND 5;  ==> O
       WHERE ROWNUM BETWEEN 6 AND 10; ==> X
       WHERE ROWNUM = 1; ==> O
       WHERE ROWNUM = 2; ==> X
       WHERE ROWNUM < 10; ==> O //1번부터 10 이라고 되어 있기 때문에.
       WHERE ROWNUM > 10; ==> X //11번부터라고 되어있기 때문에 안돼
       
전체 데이터 : 14건
페이지 사이즈 : 5건
1번째 페이지 : 1 ~ 5
2번째 페이지 : 6 ~ 10 // WHERE ROWNUM BETWEEN 6 AND 10
3번째 페이지 : 11~ 15(14)

[인라인 뷰]--********
ALIAS 사용해야 함

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 5; //결과가 나옴

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 6 AND 10; //결과가 안나옴 //1번부터 읽지 않았기 때문에.

SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

SQL 절은 다음의 순서로 실행된다.
FROM => WHERE => SELECT => ORDER BY
ORDER BY 와 ROWNUM 을 동시에 사용하면 정렬된 기준으로 ROWNUM 이 부여되지 않는다.
(SELECT 절이 먼저 실행되므로 ROWNUM 이 부여된 상태에서 ORDER BY 절에 의해 정렬이)

SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename; --(1)

SELECT ROWNUM, empno, ename
FROM(SELECT empno, ename
     FROM emp -- 인라인뷰
     ORDER BY ename); --(2)
    
(1)과 (2) 비교해서 이해하기.
    
SELECT *
FROM(SELECT ROWNUM, empno, ename
     FROM(SELECT empno, ename
          FROM emp 
          ORDER BY ename)); --(2)랑 같음
--====================================
SELECT *
FROM(SELECT ROWNUM rn, empno, ename
     FROM(SELECT empno, ename
          FROM emp 
          ORDER BY ename))
WHERE rn BETWEEN 6 AND 10; -- 6 ~ 10 값이 나옴
--======================================
pageSize : 5건
1 page : rn BETWEEN 1 AND 5;
2 page : rn BETWEEN 6 AND 10;
3 page : rn BETWEEN 11 AND 15;
n page : rn BETWEEN n*pageSize-4 AND n*pageSize;
                    (n-1)pageSize + 1
rn BETWEEN (page-1)*pageSize + 1 AND page*pageSize; 
 
                    
n*pageSize - (pageSize - 1)
n*pageSize - pageSize + 1
(n-1)pageSize + 1

SELECT *
FROM(SELECT ROWNUM rn, empno, ename
     FROM(SELECT empno, ename
          FROM emp 
          ORDER BY ename))
WHERE rn BETWEEN (:page-1)*:pageSize + 1 AND :page*:pageSize; -- ***********

실습 가상컬럼 ROWNUM 실습 row 1
emp 테이블에서 ROWNUM 값이 1~10인 값만 조회하는 쿼리를 작성해보세요.
(단, 정렬없이 진행하세요. 결과는 화면과 다를 수 있습니다.)

SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

실습 가상컬럼 ROWNUM 실습 row 2
ROWNUM 값이 11~22(11~14)인 값만 조회하는 쿼리를 작성해보세요.

SELECT *
FROM(SELECT ROWNUM rn, empno, ename
    FROM emp)
    WHERE rn BETWEEN 11 AND 14;

실습 가상컬럼 ROWNUM 실습 row 3
emp 테이블의 사원 정보를 이름컬럼으로 오름차순 적용 했을 때의 11~14번째 행을 다음과 같이 조회하는 쿼리를 작성해보세요.
   SELECT *
   FROM
    (SELECT ROWNUM rn, empno, ename
     FROM
        (SELECT  empno, ename
         FROM emp
         ORDER BY ename))
            WHERE rn BETWEEN 11 AND 14;
            
    SELECT a.*
    FROM
    (SELECT ROWNUM rn, empno, ename
     FROM
        (SELECT  empno, ename
         FROM emp
         ORDER BY ename)) a
            WHERE rn BETWEEN 11 AND 14;


SELECT ROWNUM rn, emp.*
FROM emp;

SELECT ROWNUM rn, e.*
FROM emp e;




