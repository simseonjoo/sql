월별실적
            반도체     핸드폰     냉장고
2021년 1월 : 500       300       400
2021년 2월 : 0         0         0
2021년 3월 : 500       300       400
.
.
.
2021년 12월 : 500      300       400


테이블 : 

데이터 결합(outer join 실습 outer join 1)
buyprod 테이블에 구매일자가 2005년 1월 25일인 데이터는 3품목 밖에 없다.
모든 품목이 나올수 있도록 쿼리를 작성 해보세요.
SELECT buy_date, buy_prod, prod_id, prod_name, NVL(buy_qty,0)--NVL 널값을 0으로
FROM buyprod, prod 
WHERE buyprod.buy_prod(+) = prod.prod_id 
    AND buy_date(+) = TO_DATE('20050125','YYYYMMDD'); --outer join(+)
    
SELECT buy_date, buy_prod, prod_id, prod_name, NVL(buy_qty,0)--NVL 널값을 0으로
FROM buyprod, prod 
WHERE buyprod.buy_prod = prod.prod_id 
    AND buy_date = TO_DATE('20050125','YYYYMMDD'); 
    
    
데이터 결합(outer join 실습 outer join 2~3)
outer join 1에서 작업을 시작, buy_date 컬럼이 null인 항목이 안나오도록 다음처럼
데이터를 채워지도록 쿼리를 작성하세요.(실무에서 나오는 사례이다.)/null 처리

SELECT TO_DATE(:yyyymmdd,'yyyymmdd'),buy_date, buy_prod, prod_id, prod_name, NVL(buy_qty,0)
FROM buyprod, prod 
WHERE buyprod.buy_prod(+) = prod.prod_id 
    AND buy_date(+) = TO_DATE(:yyyymmdd,'yyyymmdd');
    
데이터 결합(outer join 실습 outer join 4)
cycle, product 테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고,
애음하지 않는 제품도 다음과 같이 조회되도록 쿼리를 작성하세요.
(고객은 cid=1인 고객만 나오도록 제한, null처리)
SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT product.*, :cid, NVL(cycle.day, 0) day, NVL(cycle.cnt, 0)cnt
FROM product LEFT OUTER JOIN cycle ON(product.pid = cycle.cid AND cid = :cid); ----------오류 다시 해보기

SELECT product.*, :cid cid, NVL(cycle.day, 0)day, NVL(cycle.cnt, 0)cut
FROM product, cycle
WHERE product.pid = cycle.pid (+)
    AND cid(+) = :cid;

데이터 결합(outer join 실습 outer join 5)
outer join 4를 바탕으로 고객 이름 컬럼 추가하기 (테이블 3개로 해야한다.) --과제!

WHERE, GROUP BY(그룹핑), JOIN -- 중요!!!! 개념 정리해서 잘 외우기

JOIN 카테고리
문법 : ANSI / ORALCE 두가지로 했음
논리적 형태 : SELF JOIN, NON-EQUI-JOIN <==> EQUI-JOIN -- 예로 급여 등급 구하고 함
연결조건 성공 실패에 따라 조회여부 결정
: OUTER JOIN <==> INNER JOIN : 연결이 성공적으로 이루어진 행에 대해서만 조회가 되는 조인

SELECT *
FROM dept INNER JOIN emp ON (dept.deptno = emp.deptno);

CROSS JOIN
: 별도의 연결 조건이 없는 조인
: 묻지마 조인
: 두 테이블간의 행간 연결가능한 모든 경우의 수로 연결
  ==> CROSS JOIN의 결과는 두 테이블의 행의 수를 곱한 값과 같은 행이 반환된다.
: [데이터 복제를 위해 사용한다.(참고)] 

예) 
SELECT *
FROM emp,dept;

SELECT *
FROM emp CROSS JOIN dept;

CROSS JOIN 1)
customer, product 테이블을 이용하여 고객이 애음 가능한 모든 제품의 정보를 결합하여 다음과 같이
조회되도록 쿼리를 작성하세요.

SELECT *
FROM customer CROSS JOIN product;


-- 대전 중구
도시발전지수 : (kfc + 맥도날드 + 버거킹) / 롯데리아)
                1 + 3 + 2 / 3 ==> (1+3+2)/3 =2
                
대전 중구 2 --이런식 3가지 컬럼이 나오게 하고싶음 

SELECT sido, sigungu --도시발전지수 //다시하기//
FROM BURGERSTORE
WHERE sido = '대전'
  AND sigungu= '중구'
GROUP BY storecategory;

-- 행을 컬럼으로 변경 (PIVOT)
    storecategory가 BURGER KING 이면 1, 0 ,
    storecategory가 KFC 이면 1, 0 ,
    storecategory가 MACDONALD 이면 1, 0 ,
    storecategory가 LOTTERIA 이면 1, 0 

SELECT sido, sigungu,
        ROUND( (SUM(DECODE(storecategory, 'BURGER KING', 1, 0)) +
        SUM(DECODE(storecategory, 'KFC', 1, 0)) +
        SUM(DECODE(storecategory, 'MACDONALD', 1 ,0)) ) /
        DECODE(SUM(DECODE(storecategory, 'LOTTERIA', 1,0)),0,1, SUM(DECODE(storecategory, 'LOTTERIA', 1,0))), 2) idx
FROM BURGERSTORE
GROUP BY sido, sigungu
ORDER BY idx DESC;



SELECT sido, sigungu, storecategory,
CASE
        WHEN storecategory = 'BURGER KING' THEN 1
        ELSE 0
    END bk
FROM BURGERSTORE;
    