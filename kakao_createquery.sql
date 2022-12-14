CREATE  DATABASE kakao_t;

use kakao_t;

CREATE TABLE PASSENGER_ID
(
USER_NUM INT NOT NULL,
USER_ID VARCHAR(20) NOT NULL,
PRIMARY KEY(USER_NUM),
FOREIGN KEY(USER_NUM) REFERENCES PASSENGER(USER_NUM)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PASSENGER(
USER_NUM INTEGER(9) NOT NULL,
USER_PW VARCHAR(20) NOT NULL,
USER_NAME VARCHAR(5) NOT NULL,
USER_PHONE_NUM VARCHAR(15) NOT NULL,
USER_BIRTHDAY DATE NOT NULL,
USER_ACCUMM INT NULL DEFAULT 0,
PRIMARY KEY(USER_NUM)
);

CREATE TABLE BOARD(
POST_NUM INT NOT NULL,
USER_NUM INT NOT NULL,
POST_DATE DATE NOT NULL,
POST_PW VARCHAR(20) NULL,
POST_CONTENTS VARCHAR(100) NOT NULL,
PRIMARY KEY(POST_NUM),
FOREIGN KEY(USER_NUM) REFERENCES PASSENGER(USER_NUM)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE COUPON(
COUPON_CODE VARCHAR(10) NOT NULL,
COUPON_VALIDITY DATE NULL DEFAULT '9999-12-31',
COUPON_CONTENTS VARCHAR(100) NOT NULL,
PRIMARY KEY(COUPON_CODE)
);

CREATE TABLE PASSENGER_COUPON(
USER_NUM INT NOT NULL,
COUPON_CODE VARCHAR(10) NOT NULL,
PRIMARY KEY(USER_NUM, COUPON_CODE),
FOREIGN KEY(USER_NUM) REFERENCES PASSENGER(USER_NUM)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(COUPON_CODE) REFERENCES COUPON(COUPON_CODE)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DRIVER (
   DRIVER_NUM INTEGER(9) NOT NULL,
   DRIVER_BRITHDAY DATE NOT NULL,
   DRIVER_PHONE_NUM INT NOT NULL,
   BUSINESS_AREA VARCHAR(20) NOT NULL,
   -- 기사 평점은 입력되는 평점들의 평균값이기 때문에 아무련 평점이 입력되지 않았을 경우 기본값은 NULL
   DRIVER_SCORE FLOAT DEFAULT NULL,
   DRIVER_NAME VARCHAR(5) NOT NULL,
   PRIMARY KEY(DRIVER_NUM)
);

ALTER TABLE DRIVER ADD CONSTRAINT DRIVER_SCORE CHECK(DRIVER_SCORE >= 0 and DRIVER_SCORE <= 5.0);


CREATE TABLE DRIVE (
   DRIVER_NUM INT NOT NULL,
   CAR_NUM VARCHAR(20) NOT NULL,
   PRIMARY KEY(DRIVER_NUM),
   FOREIGN KEY(DRIVER_NUM) REFERENCES DRIVER(DRIVER_NUM) ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY(CAR_NUM) REFERENCES CAR(CAR_NUM) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 호출이 성립하고 나서 나오는 이용기록 테이블
CREATE TABLE HISTORY (
   CALL_NUM INT NOT NULL,
   USER_NUM INTEGER(9) NOT NULL,
   DRIVER_NUM INTEGER(9) NOT NULL,
   STARTPOINT VARCHAR(20) NOT NULL,
   ENDPOINT VARCHAR(20) NOT NULL,
   PAYMENT VARCHAR(10) NOT NULL,
   CAR_NUM VARCHAR(10) NOT NULL,
   DRIVE_DATE DATE NOT NULL,
   PRIMARY KEY(CALL_NUM),
   -- 이용기록의 경우 회사입장에서 삭제나 변경이 기사번호와 회원번호가 변경이나 삭제되었다 해도
   -- 바뀌면 안된다. 
   FOREIGN KEY(USER_NUM) REFERENCES PASSENGER(USER_NUM)
   ON UPDATE CASCADE,
   FOREIGN KEY(DRIVER_NUM) REFERENCES DRIVER(DRIVER_NUM)
   ON UPDATE CASCADE
);


CREATE TABLE CAR(
CAR_NUM VARCHAR(20) NOT NULL,
CAR_TYPE VARCHAR(10) NOT NULL,
CAR_GRADE char(3) NOT NULL,
REGIST_DATE DATE NOT NULL,
PRIMARY KEY (CAR_NUM)
);

-- 공급은 운수업체로부터 받을수도 있고 아닐수도 있다.
CREATE TABLE SUPPLY(
BUSINESS_NUM INTEGER(20) NOT NULL,
SUPPLY_DATE DATE NOT NULL,
CAR_NUM VARCHAR(10) NOT NULL,
PRIMARY KEY(BUSINESS_NUM, CAR_NUM),
-- 운수업체가 바뀌거나 삭제되면 공급에서도 운수업체가 없거나 바뀌어야한다.
-- 운수업체가 바뀌면 업체가 바뀌는 것이고 삭제되면 계약이 끝난것이기에 
FOREIGN KEY(BUSINESS_NUM) REFERENCES COMPANY(BUSINESS_NUM) 
ON DELETE CASCADE ON UPDATE CASCADE,
-- 차량 번호가 바뀌거나 삭제되면 공급에서도 그 차량번호가 없거나 바뀌어야한다.
FOREIGN KEY(CAR_NUM) REFERENCES CAR(CAR_NUM)
ON DELETE CASCADE ON UPDATE CASCADE
);
 

-- 운수업체 테이블에서는 제약조건 딱히 없다.
CREATE TABLE COMPANY(
BUSINESS_NUM INTEGER(20) NOT NULL,
COMPANY_NAME VARCHAR(20) NOT NULL,
COMPANY_PHONE_NUM INTEGER(11) NOT NULL,
COMPANY_ADDRESS VARCHAR(20) NOT NULL,
BUSINESS_MANAGER VARCHAR(5) NOT NULL,
PRIMARY KEY(BUSINESS_NUM)
);

-- 사업자번호는 음수 불가
ALTER TABLE COMPANY ADD CONSTRAINT chk_business_num CHECK(BUSINESS_NUM > 0);