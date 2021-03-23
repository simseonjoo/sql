실습 where 13 [AND, OR]
emp 테이블에서 job이 SALESMAN 이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회 하세요.
(단, LIKE 연산자 사용금지)
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
OR empno BETWEEN 7800 AND 7899 
OR empno BETWEEN 780 AND 789 
OR empno BETWEEN 78 AND 78;