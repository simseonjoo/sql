날짜관련 함수
MONTHS_BETWEEN 
인자 - start date, end date, 반환값 : 두 일자 사이의 개월수

ADD_MONTHS (***)
인자 : date, number  더할 개월수 : date로 부터 x개월 뒤의 날짜

date + 90 
1/15 3개월 뒤의 날짜

NEXT_DAY (***)
인자 : date, number(weekday : 주간일자)
date 이후의 가장 첫번째 주간일자에 해당하는 date를 반환

LAST_DAY (***)
인자 : date : date가 속한 월의 마지막 일자를 date로 반환

---------------------------------------------------------------

MONTHS_BETWEEN
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') hiredate, -- emp의 이름과 날짜 출력
       MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
       ADD_MONTHS(SYSDATE, 5) add_months,-- 5개월 후
       ADD_MONTHS(TO_DATE('2021-02-15','YYYY-MM-DD'),-5)add_months2, -- 5개월 전
       NEXT_DAY(SYSDATE, 1) NEXT_DAY, -- 18일 이후 일요일
       LAST_DAY(SYSDATE) LAST_DAY, -- 이번달의 마지막
       TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD') || '01','YYYYMMDD') FIRST_DAY -- 이번달의 처음
FROM emp;

SYSDATE를 이용하여 SYSDATE가 속한 월의 첫번째 날짜 구하기
SYSDATE를 이용해서 년월까지 문자로 구하기 + || '01'
    '202103' || '01' ==> '20210301'
    TO_DATE('20210301','YYYYMMDD')

SELECT TO_DATE('2021' || '0101','YYYYMMDD') --고정된 문자열로 초기화가 가능하다.
FROM dual;

date 종합 실습 fn3] LAST_DAY(날짜) 
파라미터로 yyyymm형식의 문자열을 사용 하여 (ex : yyyymm = 201912)
해당 년월에 해당하는 일자 수를 구해보세요.
yyyymm = 201912 -> 31
yyyymm = 201911 -> 30
yyyymm = 201602 -> 29 (2016년은 윤년)

SELECT : YYYYMM, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')DT
FROM dual;

---------------------------------------------------------------

형변환
- 명시적 형변환
    TO_DATE(날짜), TO_CHAR(문자), TO_NUMBER(숫자)
- 묵시적 형변환

SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369'; -- 숫자를 문자열로

1. 위에서 아래로
2. 단, 들여쓰기 되어있을 경우(자식 노드) 자식 노드부터 읽는다.

FORMAT
NUMBER
9 : 숫자
0 : 강제로 0표시
, : 1000자리 표시
. : 소수점
L : 화폐단위(사용자 지역에 따라 다름)
$ : 달러 화폐 표시

--형변환 (NUMBER -> CHARACTER)
--SELECT ename, sal, TO_CHAR(sar, 'L009,9999.0')
--FROM emp;

---------------------------------------------------------------

NULL 처리 함수 : 4가지

1. NVL(expr1, expr2) -- 인자 2개
JAVA에선
--if(exprl == null) : expr1이 NULL 값이 아니면 expr1을 사용하고, expr1이 NULL값이며 expr2로 대체해서 사용한다.
--  Sysout.out.println(expr2)
--else
--  Sysout.out.println(expr1)

SQL에선
emp 테이블에서 comm 컬럼의 값이 NULL일 경우 0으로 대체 해서 조회하기
SELECT empno, comm, NVL(comm, 0)
FROM emp;

SELECT empno, sal, comm, sal + NVL(comm, 0)
FROM emp;

SELECT empno, sal, comm, 
    sal + NVL(comm, 0) nvl_sal_comm,
    NVL(sal + comm, 0) nvl_sal_comm2 --sla값이 무시가 된다.
FROM emp;

2. NVL2(expr1, expr2, expr3)
--if(expr1 != null)
--    System.out.println(expr2);
--else
--    System.out.println(expr3);
    
comm이 null이 아니면 sal+comm을 반환, 
comm이 null이면 sal을 반환

SELECT empno, sal, comm, 
    NVL2(comm, sal+comm, sal) nal2,
    sal + NVL(comm, 0)
FROM emp;

3. NULLIF(expr1, expr2)
--if(expr1 == expr2)
--    System.out.println(null)
--else
--    System.out.println(expr1)

SELECT empno, sal, NULLIF(sal, 1250) -- sal이 1250인 사람을 null표시
FROM emp;


4. COALESCE(expr1, expr2, expr3 .....) 
인자들 중에 가장 먼저 등장하는 NULL이 아닌 인자를 반환
--if(expr1 != null)
--    System.out.println(expr1);
--else
--    COALESCE(expr2, expr3.....);
--if(expr2 != null)
--    System.out.println(expr2);
--else
--    COALESCE(expr3.....);

SELECT empno, sal, comm, COALESCE
FROM emp;

null 실습 fn4
emp 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요.
(nvl, nvl2, coalesce)
SELECT empno, ename, mgr, 
    NVL(mgr, 9999) mgr_n,
    NVL2(mgr, mgr, 9999) mgr_n2,
    COALESCE(mgr, 9999)mgr_n3
FROM emp;

null 실습 fn5
users 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요
reg_dt가 null일 경우 sysdate를 적용
SELECT userid, usernm, reg_dt, nvl(reg_dt,sysdate)n_reg_dt
FROM users
WHERE userid IN('cony','sally','james','moon');

조건분기
1. CASE 절
    CASE expr1 비교식(참거짓을 판단 할 수 있는 수식) THEN 사용할 값  ==> if
    CASE expr2 비교식(참거짓을 판단 할 수 있는 수식) THEN 사용할 값2 ==> else if
    CASE expr3 비교식(참거짓을 판단 할 수 있는 수식) THEN 사용할 값3 ==> else if
    ELSE 사용할값 4                                              ==> else
    END
    
2. DECODE 함수 => COALESCE 함수 처럼 가변인자 사용 -- 사용이 한정적 // ==이게 아니라 >=이런거 ㄴ
DECODE(expr1, search1, return1, search2, return2, search3, return3,......[, default]
DECODE(expr1, 
    search1, return1, --search가 아니면 return으로 한다.
    search2, return2, 
    search3, return3,
    ...[, default]--마지막으로 한다.
--if(expr1 == search1)
--    System.out.println(retur1)
--else if(expr1 == search2)
--    System.out.println(retur2)
--else if(expr1 == search3)
--    System.out.println(retur3)
--else
--    System.out.println(default)

직원들의 급여를 인상하려고 한다.
job이 SALESMAN 이면 현재 급여에서 5%를 인상
job이 MANAGER 이면 현재 급여에서 10%를 인상
job이 PRESIDENT 이면 현재 급여에서 20%를 인상
그 이외의 직군은 현재 급여를 유지

SELECT ename, job, sal, --비교대상이 하나임.
    CASE
        WHEN job = 'SALESMAN' THEN sal * 1.05
        WHEN job = 'MANAGER' THEN sal * 1.10
        WHEN job = 'PRESIDENT' THEN sal * 1.20
        ELSE sal * 1.0
    END sal_bonus,
    
    DECODE(job, 'SALESMAN', sal * 1.05, 'MANAGER', sal * 1.10,'PRESIDENT', sal * 1.20, sal * 1.0) sal_bonus_decode
    
FROM emp;

condition 실습 cond1
emp 테이블을 이용하여 deptno에 따라 부서명으로 변경 해서
다음과 같이 조회되는 쿼리를 작성하세요.
10 -> 'ACCOUNTING'
20 -> 'RESEARCH'
30 -> 'SALES'
40 -> 'OPERATIONS'
기타 다른값 -> 'DDIT'

SELECT empno, ename, deptno,
    CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        ELSE 'DDIT'
    END dname,
    DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') dname2
FROM emp;

condition 실습 cond2
emp 테이블을 이용하여 hiredate에 따라올해 건강보험 검진
대상자인지 조회하는 쿼리를 작성하세요.
(생년을 기준으로 하나 여기서는 입사년도 기준으로 한다.)

2 => 0,1
SELECT MOD(1981,2)
FROM dual;

SELECT empno, ename, hiredate, 
    CASE
        WHEN
            MOD(TO_CHAR (hiredate, 'yyyy'),2)=
            MOD(TO_CHAR (SYSDATE, 'yyyy'),2)THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
    END CONTACT_TO_DOCTOR,
    DECODE (MOD(TO_CHAR(hiredate,'yyyy'),2),
            MOD(TO_CHAR(SYSDATE,'yyyy'),2), '건강검진 대상자','건강검진 비대상자')CONTACT_TO_DOCTOR_ECODE
FROM emp;

condition 실습 cond3
users 테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진
대상자 인지 조회하는 쿼리를 작성하세요.
(생년을 기준으로 하나 여기서는 reg_dt를 기준으로 한다.

SELECT *
FROM users;

SELECT userid, usernm, reg_dt,
    CASE
        WHEN
            MOD(TO_CHAR (reg_dt, 'yyyy'),2)=
            MOD(TO_CHAR (SYSDATE, 'yyyy'),2) THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
    END CONTACT_TO_DOCTOR,
    
    DECODE (MOD(TO_CHAR(reg_dt,'yyyy'),2),
            MOD(TO_CHAR(SYSDATE,'yyyy'),2), '건강검진 대상자','건강검진 비대상자')CONTACT_TO_DOCTOR_ECODE
            
FROM users
WHERE userid IN ('brown','cony','james','moon','sally');

-----------------------------------------------------------------------
GROUP FUNCTION : 여러행을 그룹으로 하여 하나의 행으로 결과값을 반환하는 함수
기준이 중요함. 여러 컬럼으로도 가능하다. 
ex) 부서별 조직원수
    부서별 가장 높은 급여
    부서별 급여 평균
    
GROUP FUNCTION
AVG : 평균
COUNT : 건수
MAX : 최대값
MIN : 최소값
SUM : 합

WHERE 다음 DMFH GROUP BY가 나옴

SELECT deptno, MAX(sal)--sal가 제일 큰
FROM emp
GROUP BY deptno -- deptno가 같은사람들로 묶어서한다.
ORDER BY deptno; -- 정렬해줌

30, 2850
20, 3000
10, 5000 이라고 결과가 나옴 근데 다시 정렬하기 위해 ORDER BY 사용


SELECT deptno, MAX(sal), MIN(sal), ROUND(AVG(sal),2),--소수점 둘째짜리
        SUM(sal), 
        COUNT(sal),-- count는 그룹핑된 행중에 sal 컬럼의 값이 NULL이 아닌 행의 건수
        COUNT(mgr),-- 그룹핑된 행중에 mgr 컬럼의 값이 NULL이 아닌 행의 건수 / emp의 mgr컬럼에 null이 하나 있음
        COUNT(*)-- 그룹핑된 행 건수
FROM emp
GROUP BY deptno 
ORDER BY deptno; 

--GROUP BY를 사용하지 않을 경우 테이블의 모든 행을 하나의 행으로 그룹핑한다.
SELECT COUNT(*)/*14명중의*/count , MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal) 
FROM emp;

SELECT *
FROM emp;

-- GROUP BY 절에 나온 컬럼이 SELECT절에 그룹함수가 적용되지 않은채로 기술되면 에러

SELECT deptno, empno,
        MAX(sal), MIN(sal), ROUND(AVG(sal),2),
        SUM(sal), 
        COUNT(sal),
        COUNT(mgr), 
        COUNT(*)
FROM emp
GROUP BY deptno;-------------에러
-------아래처럼 바꿔준다.-------

SELECT deptno, empno, -- 또는 GROUP BY에 안넣고 조건에 만족하는 MAX(empno) 로 하면 가능하다.
        MAX(sal), MIN(sal), ROUND(AVG(sal),2),
        SUM(sal), 
        COUNT(sal),
        COUNT(mgr), 
        COUNT(*)
FROM emp
GROUP BY deptno, empno;

SELECT deptno, COUNT(*)/*14명중의*/count , MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal) 
FROM emp -- 여기까지만 하면 에러
GROUP BY deptno; -- 여기까지해야 실행 가능


SELECT deptno, 'TEST', 100, -- 이건 가능
        MAX(sal), MIN(sal), ROUND(AVG(sal),2),
        SUM(sal), 
        COUNT(sal),
        COUNT(mgr), 
        COUNT(*), 
        SUM(comm),-- null값을 포함한 값 (null무시) // 30번은 널값이 있어도 그룹화하면서 제외가됨, 20번과 10번은 모두 널값
        SUM(NVL(comm,0)),--아래와 같음 (NULL을 0으로)
        NVL(SUM(comm),0)--위와 같음
FROM emp
GROUP BY deptno
HAVING COUNT(*) >= 4; -- COUNT가 4건 이상인것만 -- GROUP BY 다음으로 써준다.

GROUP FUNCTION
- 그룹 함수에서 null컬럼은 계산에서 제외된다.
- GROUP BY 절에 작성된 컬럼 이외의 컬럼이 select 절에 올 수 없다.
- WHERE 절에 그룹 함수를 조건으로 사용 할 수 없다.
   HEVING 절 사용
    where sum(sal) > 3000(X)
    heving sum(sal) > 3000(O)

group function 실습 grp 1
emp 테이블을 이용하여 다음을 구하시오
직원중 가장 높은 급여
직원중 가장 낮은 급여
직원의 급여 평균(소수점 두자리까지 나오도록 반올림)
직원의 급여 합
직원중 급여가 있는 직원의 수 (null제외)
직원중 상급자가 있는 직원의 수 (null제외)
전체 직원의 수

SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp;   

group function 실습 grp 2
emp 테이블을 이용하여 다음을 구하시오
위의 문제와 같고 부서별로 
SELECT deptno, MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;
