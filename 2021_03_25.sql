서브쿼리 (실습 sub6)
cycle 테이블을 이용하여 cid = 1인 고객이 애음하는 제품중 cid = 2인 고객도
애음하는 제품의 애음정보를 조회하는 쿼리를 작성하세요.
 
SELECT *
FROM cycle
WHERE cid = 1
  AND pid IN(SELECT pid
             FROM cycle
             WHERE cid = 2);
2번 고객이 먹는 제품에 대해서만 1번 고객이 먹는 애음 정보조회
SELECT *
FROM cycle
WHERE cid = 2;

서브쿼리 (실습 sub7)
customer, cycle, product 테이블을 이용하여 cid = 1인 고객이 애음하는 제품중 cid = 2인 고객도
애음하는 제품의 애음정보를 조회하고 고객명과 제품명까지 포함하는 쿼리를 작성하세요.

SELECT 
FROM cycle c, customer u, product p
WHERE c.cid = 1
  AND c.cid = u.cid
  AND c.pid = p.pid
  AND pid IN(SELECT pid
             FROM cycle
             WHERE cid = 2);
             
             
EXISTS 서브쿼리 연산자 : 단항
IN : WHERE 컬럼 | EXPRESSION IN (값1, 값2, 값3...)
EXISTS : WHERE EXISTS (서브쿼리)
         ==> 서브쿼리의 실행결과로 조회되는 행이 ***하나라도*** 있으면 TRUE, 없으면 FALSE
         EXISTS 연산자와 사용되는 서브쿼리는 상호연관, 비상호연관 서브쿼리 둘다 사용 가능하지만
         행을 제한하기 위해서 상호연관 서브쿼리와 사용되는 경우가 일반적이다.
         
         서브쿼리에서 EXISTS 연산자를 만족하는 행을 하나라도 발견을 하면 더 이상 진행하지 않고 효율적으로 일을 끊어 버린다.
         서버쿼리가 1억건이라 하더라도 10번째 행에서 EXISTS 연산을 만족하는 행을 발견하면 나머지 9999만 건 정도의 데이터는
         확인 안한다.
NOT IN
NOT EXISTS


-- 매니저가 존재하는 직원(상호, 비상호연관 쿼리)
SELECT *
FROM emp
WHERE mgr IS NOT NULL; 

SELECT *
FROM emp e
WHERE EXISTS (SELECT empno
              FROM emp m
              WHERE e.mgr = m.empno); --킹을 제회한 모든게 나옴

SELECT *
FROM dual;

SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X' --이것도 가능 / 많이 씀
              FROM emp m
              WHERE e.mgr = m.empno);
              
SELECT COUNT(*) cut
FROM emp
WHERE deptno = 10;

if( cnt > 0 ){

}

SELECT *
FROM dual
WHERE EXISTS (SELECT 'X' FROM emp WHERE deptno = 10);


서브쿼리 (실습 sub9)
cycle, product 테이블을 이용하여 cid = 1 인 고객이 애음하는 제품을
조회하는 쿼리를 EXISTS 연산자를 이용하여 작성하세요.
SELECT *
FROM cycle
WHERE cid = 1; 
//존재한다.
SELECT *
FROM product
WHERE EXISTS (SELECT *
              FROM cycle
              WHERE cid = 1
              AND product.pid = cycle.pid);

//존재하지 않는다.     
SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'X'
                  FROM cycle
                  WHERE cid = 1
                  AND product.pid = cycle.pid);
                  
                  
집합연산
행(row)을 확장 -> 위아래
 위 아래 집합의 col의 개수와 타입이 일치해야 한다.
join
열(clo)을 확장 -> 양옆

UNION : {a, b} U {a, c} = {a, a, b, c} ==> {a, b, c}
수학에서 이야기하는 이란적인 합집합 / 중복을 제거
UNION : 합집합, 두개의 SELECT 결과를 하나로 합친다. 단 중복되는 데이터는 중복을 제거한다.
==> 수학적 집합 개념과 동일

UNION ALL : {a, b} U {a, c} = {a, a, b, c} 
중복을 허용하는 합집합 / 중복을 제거 하지않음 - union 연산자에 비해 속도가 빠르다.

INTERSECT - 교지합 : 두 집합의 공통된 부분

MINUS - 차집합 : 한 집합에만 속하는 데이터
---------------------------------------------------------------------
UNION (쿼리와 쿼리사이에 사용)

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521); --결과가 3건이 나옴
-- 컬럼 수가 같아야하며 다른 방법으로는 위에는 NULL을 쓰고 밑에 컬럼을 쓰면됨.
-- 그럼 그 빈 공간은 null값으로 표시됨
예)
SELECT empno, ename, NULL
FROM emp
WHERE empno IN (7369, 7499)

UNION

SELECT empno, ename, deptno 
FROM emp
WHERE empno IN (7369, 7521);
---------------------------------------------------------------------
UNION ALL : 중복을 허용하는 합집합
            중복 제거 로직이 없기 때문에 속도가 빠르다.
            합집합 하려는 집합간 중복이 없다는 것을 알고 있을 경우 UNION 연산자 보다 UNION ALL 연산자가 유리하다.

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521); -- 중복되는것이 나와서 총 4건이나옴
---------------------------------------------------------------------
INTERSECT : 두개의 집합중 중복되는 부분만 조회

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521); -- 중복되는 7369만 나온다.
---------------------------------------------------------------------
MINUS : 한쪽 집합에서 다른 한쪽 집합을 제외한 나머지 요소들을 반환

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);
---------------------------------------------------------------------
교환 법칙
A U B == B U A (UNION, UNION ALL)
A ^ B == B ^ A
A - B != B - A ==> 집합의 순서에 따라 결과가 달라질 수 있다.[주의하기]

집합연산 특징
1. 집합연산의 결과로 조회되는 데이터의 컬럼 이름은 첫번째 집합의 컬럼을 따른다.
SELECT empno e, ename em
FROM emp
WHERE empno IN (7369, 7499)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521); -- 가장 위쪽에 있는 컬럼을 따름.

2. 집합연산의 결과를 정렬하고 싶으면 가장 마지막 집합 뒤에 ORDER BY 를 기술한다.
    - 개별 집합에 ORDER BY를 사용한 경우 에러
      단, ORDER BY를 적용한 인라인 뷰를 사용하는 것은 가능 
SELECT empno e, ename em
FROM emp
WHERE empno IN (7369, 7499)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521)
ORDER BY e; --가능

--인라인 뷰로도 가능
SELECT e, em
FROM(SELECT empno e, ename em
FROM emp
WHERE empno IN (7369, 7499)
ORDER BY e)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521)
ORDER BY e;

3. 중복이 제거 된다. (예외 UNION ALL)

[4. 9i(internet) 이전 버전에서 그룹연산을 하게되면 기본적으로 오름차순으로 정렬되어 나온다.
    이후 버전 ==> 정렬을 보장하지 않음]
---------------------------------------------------------------------

DML
- SELECT 
- 데이터 신규 입력 : INSERT
- 기존 데이터 수정 : UPDATE
- 기존 데이터 삭제 : DELETE

[INSERT 문법]

INSERT INTO 테이블명 [({column,})] VALUES ({value, })

INSERT INTO 테이블명 (컬럼명1, 컬럼명2, 컬럼명3....)
            VALUES (값1, 값2, 값3....)
--위의 두가지 방법
만약 테이블에 존재하는 모든 컬럼에 데이터를 입력하는 경우 컬럼명은 생략 가능하고
값을 기술하는 순서를 테이블에 정의된 컬럼 순서와 일치시킨다.
DESC dept; --이거와 같다.

INSERT INTO 테이블명 VALUES (값1, 값2, 값3);
INSERT INTO dept VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept (deptno, dname, loc) VALUES (99, 'ddit', 'daejeon');

DESC dept;

SELECT *
FROM dept;

INSERT INTO emp (ename, job) VALUES ('brown', 'RANGER'); --오류 남
/*INSERT INTO emp (ename, job) VALUES ('brown', 'RANGER')
오류 보고 -
ORA-01400: cannot insert NULL into ("SUN"."EMP"."EMPNO")*/ -- sun에 emp계정에 empno에 값을 넣을 수 없다.
INSERT INTO emp (empno, ename, job) 
         VALUES (9999, 'brown', 'RANGER'); -- 이렇게 사용해야함 -- 그럼 행이 삽입되었다고 함.
         
SELECT *
FROM emp; -- 행삽입확인.

INSERT INTO emp (empno, ename, job, hiredate, sal, comm) 
         VALUES (9998, 'sally', 'RANGER', SYSDATE/*또는 TO_DATE('2021-03-24','YYYY-MM-DD')*/,
         1000, NULL);

여러건을 한번에 입력하기
INSERT INTO 테이블명
SELECT 쿼리

INSERT INTO dept
SELECT 90, 'DDIT','대전' FROM dual 
UNION ALL
SELECT 80, 'DDIT8','대전' FROM dual -- 2개의 행이 한번에 삽입됨.

SELECT *
FROM dept;
---------------------------------------------------------------------
ROLLBACK; -- 데이터 추가한 것을 없애줌
---------------------------------------------------------------------
[UPDATE 문법] - 테이블에 존재하는 기존 데이터의 값을 변경 

UPDATE 테이블명 SET 컬럼명1 = 값1, 컬럼명2 = 값2, 컬럼명3 = 값3....
WHERE ;

SELECT *
FROM dept;

부서번호 99번 부서정보를 부서명 = 대덕IT 로 loc = 영민빌딩으로 변경

UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'; -- 이대로하면 5개 행이 다 바뀜
WHERE 절이 누락 되었는지 확인
WHERE 절이 누락 된 경우 테이블의 모든 행에 대해 업데이트를 진행

UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
WHERE deptno = 99; -- 99번만 바뀜.