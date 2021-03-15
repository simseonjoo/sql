-- sun계정에 있는 prod 테이블의 모든 컬럼을 조회하는 SELECT 쿼리 (SQL) 작성

SELECT *
FROM prod;

-- sun계정에 있는 prod 테이블의 prod_id, prod_name 두개의 컬럼만 조회하는 SELECT 쿼리 (SQL) 작성

SELECT prod_id, prod_name
FROM prod;

--SELECT 1)
-- lprod 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요.
SELECT *
FROM lprod;

-- buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리를 작성하세요.
SELECT buyer_id, buyer_name
FROM buyer;

-- cart 테이블에서 모든데이터를 조회하는 쿼리를 작성하세요.
SELECT *
FROM cart;

-- member 테이블에서 mem_id, mem_pass, mem_name 컬럼만 조회하는 쿼리를 작성하세요.
SELECT mem_id, mem_pass, mem_name
FROM member;

컬럼 정보를 보는 방법
1. SELECT * ==> 컬럼의 이름을 알 수 있다.
2. SQL DEVELOPER의 테이블 객체를 클릭하여 정보확인
3. DESC 테이블명; DESC = DESCRIBE 설명하다.라는 뜻

DESC emp;

empno : number;
empno + 10 ==> expression
SELECT empno , empno +10 emp_plus , 10
hiredate, hiredate + 10 -- ***숫자, 문자, 날짜 / 이건 날짜 이며 10일이 증가함
FROM emp; -- 원본데이터와, 원본데이터에 +10한 값 두 가지가 나온다. 가공을 하더라도 데이터의 수정은 일어나지 않는다.
          -- 데이터의 수정이 가능한것은 UPDATE 명령어로 가능하다.
          -- 컬럼이 아닌 것들은 모두 expression라고 한다.
          
숫자, 날짜에서 사용가능한 연산자
일반적인 사칙연산 + - * /, 우선순위 연산자 ()

ALIAS : 컬럼의 이름을 변경
        컬럼 | expression [AS] [별칭명]
SELECT empno "empno" , empno + 10 AS empno_plus
FROM emp;

NULL : 아직 모르는 값
       0과 공백은 NULL과 다르다.
       **** NULL을 포함한 연산은 결과가 항상 NULL이다. **** <중요함>
       ==> 나중에 NULL 값을 다른 값으로치환해주는 함수를 배울 것.
       
SELECT ename, sal, comm, sal+comm, comm+100
FROM emp;
       
column alas (실습 select2)
prod 테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리를 작성하시오.
(단 prod_id-> id, prod_name -> name 으로 컬럼 별칭을 지정)

SELECT prod_id "id", prod_name "name"
FROM prod;

lprod 테이블에서 lprod_gu, lprod_nm 두 컬럼을 조회하는 쿼리를 작성하시오.
(단 lprod_gu-> gu, lprod_nm -> nm 으로 컬럼 별칭을 지정)

SELECT lprod_gu "gu", lprod_nm "nm"
FROM lprod;

buyer 테이블에서 buyer_id, buyer_name 두 컬럼을 조회하는 쿼리를 작성하시오.
(단 buyer_id-> 바이어아이디, buyer_name -> 이름 으로 컬럼 별칭을 지정)

SELECT buyer_id 바이어아이디, buyer_name 이름 -- 한글로 잘 하지않는데 그냥 가능하다는 것을 보여주기위해 한거임
FROM buyer;

literal(리터럴) : 값 자체
literal 표기법 : 값을 표현하는 방법

java 정수 값을 어떻게 표현할까 (10) ?
int a = 10; --숫자를 표기해라
float f = 10f;
long l = 10L;
String s = "Hello World"; --문자를 표기해라

* | {컬럼 | 표현식 [AS] [ALIAS], ...}
SELECT empno, 10, 'Hello World'
FROM emp;

SQL에서와 JAVA에서 문자 표현법은 다르다. 
JAVA는 ""사용, SQL는 ''사용. / ''를 안쓰고 문자만 쓰게된다면 컬럼 또는 표현식이라고 인식을 함 / 올바른 표현 아님

문자열 연산
java : String msg = "Hello" +", World";

SELECT empno + 10, ename || 'Hello' || ', World' , CONCAT(ename, ', World') 
FROM emp;
--숫자는 +로 결합을하고 문자는 ||로 결합을 한다.
--CONCAT는 2개 까지만 가능하고 3개 이상은 불가능하다.
--||를 사용하면 3개이상도가능하다.
DESC emp;

SELECT *
FROM users;


SELECT userid
FROM users;


아이디 : brown
아이디 : apeach

SELECT '아이디 : ' || userid, CONCAT('아이디: ' , userid)
FROM users;

SELECT *
FROM user_tables; --오라클에서 관리하는 테이블이기에 옆에 테이블에 없어도 뜨는거임.

-- 문자열 결합 방법 두가지 ||와 CONCAT사용
-- 결합할 두개의 문자열을 입력받아 결합하고 결합된 문자열을 반환 해준다.
==> CONCAT(문자열1과 문자열2가 결합된 문자열, 문자열3)
 ==> CONCAT(CONCAT(문자열1, 문자열2),문자열3)
SELECT table_name
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name || ';' AS QUERY
FROM user_tables; 

SELECT CONCAT('SELECT * FROM ' , table_name || ';') AS QUERY
FROM user_tables; 

SELECT CONCAT(CONCAT('SELECT * FROM ' , table_name), ';') AS QUERY
FROM user_tables; 


조건에 맞는 데이터 조회하기
WHERE절 조건연산자 --중요함
= 같은값
!=, <> 다른값
> 클때
>= 크거나 같을때
< 작을때
<= 작거나 같을때

--부서번호가 10인 직원들만 조회
--부서번호 : deptno
SELECT *
FROM emp
WHERE deptno = 10;

--users 테이블에서 userid 컬럼의 값이 brown인 사용자만 조회
SELECT *
FROM users
WHERE userid = 'brown';
--*****SQL 키워드는 대소문자를 가리지 않지만 데이터 값은 대문자를 가린다.*****

--emp 테이블에서 부서번호가 20번보다 큰부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno > 20;

--emp 테이블에서 부서번호가 20번 부서에 속하지 않은 모든 직원 조회
SELECT *
FROM emp
WHERE deptno <> 20;

결국 WHERE 이란 : 기술한 조건을 참(TRUE)으로 만족하는 행들만 조회한다. (FILTER/필터링)

SELECT *
FROM emp
WHERE 1 = 1; --참 1=1은 항상 참이기에 모든 행이 다 나온다.
WHERE 1 = 2; --이렇게하게되면 거짓이기에 아무것도 나오지 않는다.


SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= '81/03/01'; --81년 3월 1일 날짜값을 표기하는 방법(문자로)

--날짜값 표시할 때 주의사항
--날짜나 시간은 데이터와 시스템설정에 따라 안 맞을수도 있음.

(날짜) 문자열을 날짜 타입으로 변환하는 방법
TO_DATE(날짜 문자열, 날짜 문자열의 포맷팅) --문자열 두개로 날짜 타입으로 변환해주는 거다.
TO_DATE('1981/12/11', 'YYYY/MM/DD')

SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1981/03/01', 'YYYY/MM/DD'); 
-- 이렇게 바꾸면 된다. / 쿼리가 길어지는 단점이 있지만 위에 했던것 보단 더 안전하다.


































