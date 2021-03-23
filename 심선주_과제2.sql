과제 20210322

SELECT *
FROM countries;

SELECT *
FROM regions;

SELECT *
FROM locations;

SELECT *
FROM departments;

SELECT *
FROM employees;

SELECT *
FROM jobs;

데이터 결합 (실습 join 8)
erd 다이어그램을 참고하여 countries, regions 테이블을 이용하여
지역별 소속 국가를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
(지역은 유럽만 한정)
SELECT c.region_id, r.region_name, c.country_name
FROM countries c, regions r
WHERE r.region_id = c.region_id
    AND r.region_name IN ('Europe'); 

데이터 결합 (실습 join 9)
erd 다이어그램을 참고하여 countries, regions, locations 테이블을 이용하여
지역별 소속 국가, 국가에 소속된 도시 이름을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
(지역은 유럽만 한정)
SELECT c.region_id, r.region_name, c.country_name, l.city
FROM countries c, regions r, locations l
WHERE r.region_id = c.region_id
    AND c.country_id = l.country_id
    AND r.region_name IN ('Europe'); 

데이터 결합 (실습 join 10)
erd 다이어그램을 참고하여 countries, regions, locations, departments 테이블을 이용하여
지역별 소속 국가, 국가에 소속된 도시 이름 및 도시에 있는 부서를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
(지역은 유럽만 한정)
SELECT c.region_id, r.region_name, c.country_name, l.city, d.department_name
FROM countries c, regions r, locations l, departments d
WHERE r.region_id = c.region_id
    AND c.country_id = l.country_id
    AND l.location_id = d.location_id 
    AND r.region_name IN ('Europe'); 

데이터 결합 (실습 join 11)
erd 다이어그램을 참고하여 countries, regions, locations, departments, employees 테이블을 이용하여
지역별 소속 국가, 국가에 소속된 도시 이름 및 도시에 있는 부서, 부서에 소속된 직원정보를
다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
(지역은 유럽만 한정)
SELECT c.region_id, r.region_name, c.country_name, l.city, d.department_name, 
       concat(e.first_name, e.last_name) name
FROM countries c, regions r, locations l, departments d, employees e
WHERE r.region_id = c.region_id
    AND c.country_id = l.country_id
    AND l.location_id = d.location_id 
    AND d.department_id = e.department_id
    AND r.region_name IN ('Europe'); 

데이터 결합 (실습 join 12)
erd 다이어그램을 참고하여 employees, jobs 테이블을 이용하여 직원의 담당업무 명칭을 포함하여
다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
SELECT e.employee_id, concat(e.first_name, e.last_name) name, 
        j.job_id, j.job_title
FROM employees e, jobs j 
WHERE j.job_id = e.job_id;

데이터 결합 (실습 join 13)
erd 다이어그램을 참고하여 employees, jobs 테이블을 이용하여 직원의
담당업무 명칭, 직원의 매니저 정보 포함하여 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.

SELECT e.manager_id mgr_id, e.employee_id, concat(e.first_name, e.last_name) mgr_name,
concat(e.first_name, e.last_name) name, j.job_id, j.job_title
FROM employees e, employees m, jobs j 
WHERE j.job_id = e.job_id
    AND e.employee_id = m.manager_id;
        

  
    



