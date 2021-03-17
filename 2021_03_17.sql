WHERE 조건 1 : 10건

WHERE 조건 1
AND 조건 2 : 10건을 넘을 수없음

WHERE depton = 10
  AND sal > 500
----------------------------------------------------------
Function
Single row function
단일 행을 기준으로 작업하고, 행당 하나의 결과를 반환
특정 컬럼의 문자열 길이 :length(ename)  -- ()안에 문자열이 들어감

Multi row function
여러 행을 기준으로 작업하고, 하나의 결과를 반환 -- 예) 우리 회사의 직원은 총 몇명인가
그룹 함수 : count, sum, avg

SELECT count(*)
FROM emp;

함수명을 보고
1. 파라미터(인자)가 어떤게 들어갈까?
2. 몇개의 파라미터가 들어갈까?
3. 반환되는 값은 무엇일까?

character
대소문자
LOWER : 입력값은 문자고, 입력되는 값을 소문자로 변환
UPPER : 대문자로 변환
INITCAP : 첫글자를 대문자로 변환


SELECT *| {column | expression }

SELECT ename, LOWER(ename), UPPER(ename), INITCAP(ename)
FROM emp;

SELECT ename, LOWER(ename), UPPER('TEST')
FROM emp;

문자열 조작
CONCAT : 연결(결합)하다. / 파라미터(인자)가 2개이다. 우리에게 반환되는건 문자열 1개 
SUBSTR : 부분 문자열 / 문자열의 일부분만 
LENGTH : 문자열의 길이를 반환해주는
INSTR : 특정 문자열에 검색하고 싶은 문자 있는지 검색
LPAD|RPAD :왼쪽에다가 특정 문자열을 넣는것, 오른쪽에다가 특정
TRIM : 공백 제거, 문자열의 시작과 종료만, 중간을 제거하지 않음
REPLACE : 치환, 중간에 있는것을 원하는 걸로 바꿔주는것 / 인자가 3개

SELECT ename, LOWER(ename), UPPER('TEST'), SUBSTR(ename, 1,3), REPLACE(ename, 'S','T')
--SUBSTR 은 ename에서 1번째 부터 3개만 가져온다. 예) SUBSTR(ename, 2)을 하게되면 2부터 끝까지 나오게됨
--REPLACE는 ename에서 'S'를 'T'로 변환시켜줌
FROM emp;

DUAL table
-sys 계정에 있는 테이블
-누구나 사용 가능
-DUMMY 컬럼 하나만 존재하며 값은 'X'이며 데이터는 한 행만 존재
사용용도
데이터와 관련 없이
- 함수 실행
- 시퀀스 실행
merge 문에서
데이터 복제시(connect by level)

SELECT *
FROM dual;

SELECT *
FROM dual
CONNECT BY LEVEL <=10;

SINGLE ROW FUNCTION : WHERE 절에서도 사용 가능
emp 테이블에 등록된 직원들 중에 직원의 이름의 길이가 5글자를 초과하는 직원만 조회

SELECT *
FROM emp
WHERE LENGTH(ename) > 5;

smith 직원을 조회 / 대문자인데 소문자로 해서 문자열 사용해서 조회
SELECT *
FROM emp
WHERE ename = 'SMITH'; -- 바로 실행가능 함수 없이

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith'; --14번이 실행이 됨

SELECT *
FROM emp
WHERE UPPER(LOWER(ename)) = UPPER('smith');

SELECT *
FROM emp
WHERE ename =  UPPER('smith'); -- 딱 한번만 실행이 됨

---------------------------------------------------
ORACLE 문자열 함수

SELECT 'HELLO' || ', ' || 'WORLD',
        CONCAT('HELLO', CONCAT(', ' ,'WORLD')) CONCAT, 
        SUBSTR('HELLO, WORLD', 1, 5) SUBSTR,
        LENGTH('HELLO, WORLD') LENGTH,
        INSTR('HELLO, WORLD', 'O') INSTR,
        INSTR('HELLO, WORLD', 'O', 6) INSTR2,
        LPAD('HELLO, WORLD', 15, '*') LPAD,
        RPAD('HELLO, WORLD', 15, '*') RPAD,
        REPLACE('HELLO, WORLD', 'O', 'X') REPLACE,
        TRIM('    HELLO, WORLD    ') TRIM,
        TRIM('D' FROM 'HELLO, WORLD') TRIM -- D라는 문자열을 제거해줌
FROM dual;

-----------------------------------------------------
number
숫자 조작
ROUND(반올림)
TRUNC(내림)
MOD(나눗셈의 나머지)

피제수, 제수
SELECT MOD(10,3) --인자 2개, (10(피제수),3(제수))
FROM dual;

SELECT *
FROM emp
WHERE ename ='SMITH';

SELECT 
ROUND(105.54, 1) round1, -- 반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째 자리에서 반올림 //105.5
ROUND(105.55, 1) round2, -- 반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째 자리에서 반올림 //105.6
ROUND(105.55, 0) round3, -- 반올림 결과가 소수점 첫번째 자리(일의자리)까지 나오도록 : 소수점 첫째 자리에서 반올림 //106 
ROUND(105.55, -1) round4, -- 반올림 결과가 소수점 두번째 자리(십의자리)까지 나오도록 : 정수 첫째 자리에서 반올림  //110
ROUND(105.55) round5 -- 두번째 인자를 생략하게되면 0으로 인식을 한다. //106
FROM dual;

SELECT 
TRUNC(105.54, 1) trunc1, -- 절삭 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째 자리에서 절삭 //105.5
TRUNC(105.55, 1) trunc2, -- 절삭 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째 자리에서 절삭 //105.5
TRUNC(105.55, 0) trunc3, -- 절삭 결과가 소수점 첫번째 자리(일의자리)까지 나오도록 : 소수점 첫째 자리에서 절삭 //105 
TRUNC(105.55, -1) trunc4, -- 절삭 결과가 소수점 두번째 자리(십의자리)까지 나오도록 : 정수 첫째 자리에서 절삭 //100
TRUNC(105.55) trunc5 -- 두번째 인자를 생략하게되면 0으로 인식을 한다.//105
FROM dual;

-- ex : 7499, ALLEN, 1600, 1, 600
SELECT empno, ename, sal, sal을 1000으로 나눴을 때의 몫, sal을 1000으로 나눴을 때의 나머지,
FROM emp;

SELECT empno, ename, sal , TRUNC(sal/1000), MOD(sal,1000)
FROM emp;
------------------------------------------------------------------
날짜 <==> 문자
서버의 현재 시간 : SYSDATE

SELECT SYSDATE, SYSDATE + 1, SYSDATE + 1/24, SYSDATE + 1/24/60, SYSDATE + 1/24/60/60
-- +1이면 하루 더한거고 1/24하면 1시간 더한거다, 1/24/60 하면 1분, 1/24/60/60하면 1초
FROM dual;

LENGTH('TEST')
SYSDATE
-----------------------------------------------------------------
Function (date 실습 fn 1)
1. 2019년 12월 31일을 date 형으로 표현
2. 2019년 12월 31일을 date 형으로 표현하고 5일 이전 날짜
3. 현재 날짜
4. 현재 날짜에서 3일전 값

위 4개의 컬럼을 생성하여 다음과 같이 조회하는 쿼리를 작성하세요.

SELECT TO_DATE('2019/12/31','YYYY/MM/DD') AS LASTDAY , 
       TO_DATE('2019/12/31','YYYY/MM/DD') -5 AS LASTDAY_BEFORE5, 
       SYSDATE AS NOW, 
       SYSDATE - 3 AS NOW_BEFORE3
FROM dual;

TO_DATE : 인자-문자, 문자의 형식
TO_CHAR : 인자-날짜, 문자의 형식

NLS : YYYY/MM/DD/ HH24:MI:SS

-- 1년 =52~53주
-- 숫자로 요일을 나타낸다/ 주간요일(D) 0-일요일, 1-월요일, 2-화요일, 3-수요일, 4-목요일, 5-금요일, 6-토요일
date
FORMAT
    YYYY : 4자리 년도, MM:2자리 월 , DD : 2자리 일자
    D : 주간일자(1~7)
    IW : 주차(1~53)
    HH,HH12 : 2자리 시간(12시간 표현)
    HH24 : 2자리 시간(24시간 표현)
    MI : 2자리 분
    SS : 2자리 초

SELECT SYSDATE,TO_CHAR(SYSDATE, 'IW'),TO_CHAR(SYSDATE, 'D') --IW는 1년중 몇주차인지.
FROM dual;  

Function (date 실습 fn2)
오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오
1. 년-월-일
2. 년-월-일 시간(24)-분-초
3. 일-월-년
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual; 

TO_DATE(문자열, 문자열 포맷)
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')
FROM dual; 

SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')
FROM dual;

--'2021-03-17' ==> '2021-03-17 12:41:00'
SELECT TO_CHAR(TO_DATE('2021-03-17', 'YYYY-MM-DD'),'YYYY-MM-DD HH24:MI:SS')
FROM dual; 

