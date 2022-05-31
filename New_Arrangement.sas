
/********************* Pass-Through in Oracle */

/* Preparing Dailer Data */
options compress=yes;   **to commpress the data soits reduce the size and transfer fast;
proc sql;
	connect to ODBC as con_1 (DATASRC=hive_prd authdomain=DB_Cloudera_Auth); **ODBC- Open Database connection;
		Create table adhoc4.az_Dialer_Dec AS			**creating table in permanent table (adhoc4) and dataset (az_Dialer_Dec) in the SAS library;
		Select * from connection to Con_1
		(
		select * from campaign_raw.csi_calldetail
		where starttime between to_date('2020-12-01') and to_date('2020-12-31')
		);
	Disconnect from con_1;
quit;
****************;



/*2. Connecting to teradata using pass through
Most efficient way
*/
proc sql;
connect to teradata(USERID="&userid." PASSWORD="&dbpass" TDpid=rchgrp2   MODE='Teradata');
	create table work.acc_details as 
		(
		select acc_no, roll_no, sex, date, sales, city from mater_acc_details
		where acc_no is not null and sales gt 40000
		);
	disconnect from teradata;
quit;


*********connect to DB2**;
Proc sql;
Connect to db2(  DATABASE=CRD_ PROD USER= “ &user_id.” PASSWORD=” &dbpass” MODE= "db2");
Create table work. Account_details as 
(
Select Account_ Number, Enroll_ Date, Sales , City From Master_ acct_ details
Where Account_ Number is not null and Sales gt 40000
);
Disconnect from db2;
quit;
*********************;






% let user_id = %sysget(USER);

231456


/*Update password to encrypt userid, PW and save to UNIX home directory*/
Filename pw “/home/sasuser/231456/pwfile”;
Proc  pwencode in= “amit” out=pwfile method =sas003;
Run;

Data _ null_ ;
Infile pw Truncover;
Input line: $50;
Call symputx('dbpass' ,line);
Run;
% put &dbpass;


*************
user_id : For id
dbpass : Encypted password



/*1st way : Libname statement with id and encrypted password

using the library assignments:; 
user_id : For id
dbpass : Encypted password */

Libname AMIT DB2 DATABASE= CARD_USA Schema=DDKAUTO USER=”&user_ id.” PASSWORD= “&dbpass”;

Proc sql;
Create table amit.Account_details as 
Select
Account_ Number, Enroll_ Date, Sales , City 
From AMIT.Master_ acct_ details
Where Account_ Number is not null and Sales gt 40000;
Quit;

/****************************************************************************/




							/* CLASS-1 */


/* Their are 5 types of windows present in SAS  */

*Editor: Used to write SAS codes/programe/scripts.;
*Log: Audit_Trail: Shows the processing done by SAS
 -> Error:Fatal :The SAS stops at the error
 -> Warring:Non Fatal :SAS continues with data warning.;
*Output: It shows the output/Result;
*Explorer:Navigation :Moving here and there;
*Rsults: Save the results;

/* Frequently used term in SAS */
*Dataset: 2D arrangement of data in rows and column;
*Table: Alias name of dataset;
*SAS: Dataset/Observations/Variables;
*SQL: Table/Row/columns;
*Library: Collection of sas files(sas datasets);

/* Building Blocks of sas programs: Black & White */
*1) Data step: Use to create table/dataset;
*2) Proc Step: Procedure.. SOP(Standard Operating Procedure)..Used for Analytics;
/**************************************************************/






								/*CLASS-2*/


*How to create multiple datasets: comment: way 1;
data a b c;
set sasuser.admit;
run;

data a b c sasuser.d;
set sasuser.admit;
run;
data my name is sashelp.amit sasuser.saswale;
set sasuser.admit;
run;


*subsetting in SAS: what is subset: Smaller portion of a set;
* I need 3 variables/column from sasuser.admit;
data a(keep=id name sex);
set sasuser.admit;
run;

data a(drop=id name sex);
set sasuser.admit;
run;

* Give a new data set a: age should be above 40;

data a;
set sasuser.admit;
if age >40;
run;

data b;
set sasuser.admit;
if age gt 40;
run;
data c;
set sasuser.admit;
where age gt 40;
run;

* What is the difference in if and where?;
/*If and where gives the same output*/
data a;
set sasuser.admit;
if age gt 40;
run;
data b;
set sasuser.admit;
where age gt 40;
run;
/*
If and where gives the same output however if read the complete data into
memory and then applies filter ;
however where first applies the filter and then push the data in memory

If is post memory
Where is pre memory
*/




/* How to create new variables
age_months that should have age in months for all customers

x=5
LHS=RHS
*/
data a;
set sasuser.admit;
age_months=age*12;
run;


data a(keep=id name age age_months);
set sasuser.admit;
age_months=age*12;
if age gt 40;
run;

data a;
set sasuser.admit;
x=5;
run;
data a;
set sasuser.admit;
age_months=age*12;
if age_months>300;
run;

data a;
set sasuser.admit;
label age ="age in years";
run;

/*** compound filters: multiple criterias 
I need customer with age above 40 and all males
*/
data a;
set sasuser.admit;
where age gt 40 and sex="M"; *Both are true;
run;

data a;
set sasuser.admit;
where age gt 40 or sex="M"; * Any is true;
run;
/**************************************************************/







									/*CLASS-3*/


data a;
set sasuser.admit;
run;

data a(keep=id name);
set sasuser.admit;
run;

data a(drop=id name);
set sasuser.admit;
run;


* And /  or: BTech +5yrs ;
data a;
set sasuser.admit;
if age gt 40 and sex="M";
run;

* Ya.. ya to yeh yto woh     btech/mca;
data b;
set sasuser.admit;
if age gt 40 or sex="M";
run;

*where >if then why we use where?;

* If we are creating a new variable we cannot use where;
data a;
set sasuser.admit;
age_m=age*12;
if age_m gt 400;
run;


data b;*4th data set is created;
set sasuser.admit; *1 The data is read first;
age_m=age*12; *3 new var;
where age_m gt 400; *2 The where is read first;
run;



data a(keep=id name); * Output: 2 varisble;
set sasuser.admit (keep=id name age); *3 variables come to memory: Input;
run;

** Padega 9 and write karega 2;
data a (keep=id name);
set sasuser.admit;
run;

** Padega 2 and write karega 2;
data b;
set sasuser.admit (keep=id name);
run;


data b;
set sasuser.admit (keep=id name age);
age_m=age*12;
run;


data c(keep=id name age_m); *3: only 3 vars are written to dataset;
set sasuser.admit (keep=id name age); *1: Set ;
age_m=age*12; *2 New variable;
run;



** SAS Rules of coding;

*1. Sas is line free;

data a;
set sasuser.admit;
run;

data a; set sasuser.admit;run;

*2. Sas is space  free;
data a;
set sasuser.admit;
run;
data                      a;
set sasuser.admit;
run;
*3. SAS is not case  sensitive;
data a;
set sasuser.admit;
run;

DATA A;
SET sasuser.admit;
if sex="M";
run;


libname kaka "C:\Users\ami13\Desktop\B95";

data kaka.a;
set sasuser.admit;
run;





**********Doubts;

Data a; 4
Set sasuser.admit; 1
If age_m gt 400; 2   *it will create dataset NOT throw an error but the dataset has 0 observation;
age_m=age*12; 3
Run;

Data a; 4
Set sasuser.admit;  1
age_m=age*12; 2
If age_m gt 400; 3 *here it will work fine bcoz if condition applying after creating new variable;
Run;

Data a; 5
Set sasuser.admit;  1
age_m=age*12; 3
x=5;4
where age_m gt 400; 2
Run;           *ERROR: Variable age_m is not on file SASUSER.ADMIT;





Data a; 
Set sasuser.admit;  
age_m=age*12; 
x=5;
if age_m gt 400; 
Run;



*** Id is char variable : YOU SHOULD KNOW YOUR DATA;

Data a; 
Set sasuser.admit;  
where id="2458";
Run;


Data a; 
Set sasuser.admit;  
where age=.;
Run;


Data a; 
Set sasuser.admit;  
where actlevel="";
Run;


* How to create your own data;

data a;
input id name $;
datalines;
1 A
2 B
3 C
4 D
;
run;

data a;
input id name $ age;
datalines;
1 A 20
2 B 30
3 C 40
4 D 50
;
run;

data b;
set a;
if age gt 35;
run;



data sales;
input city $ sale month$ prod $;
datalines;
G 20000 Jan WM
G 20000 Jan LA
G 20000 Jan FR
G 20000 Jan MO
N 20000 Jan WM
N 20000 Jan LA
N 20000 Jan FR
N 20000 Jan MO
D 20000 Jan WM
D 20000 Jan LA
D 20000 Jan FR
D 20000 Jan MO
;
run;

data gurgaon;
set sales;
where city="G";
run;
/*************************************************************************/









data A;
length name $10.;
input ID Name$ Sex$ Age Date Height Weight ActLevel$ Fee;
informat fee comma5.2;
format fee comma5.2;
cards;
2458 Murray M 27 1 72 168 HIGH 85.2
2462 Almers F 34 3 66 152 HIGH 124.8
2501 Bonaventure F 31 17 61 123 LOW 149.75
2523 Johnson F 43 31 63 137 MOD 149.75
2539 LaMance M 51 4 71 158 LOW 124.8
2544 Jones M 29 6 76 193 HIGH 124.8
2552 Reberson F 32 9 67 151 MOD 149.75
2555 King M 35 13 70 173 MOD 149.75
2563 Pitts M 34 22 73 154 LOW 124.8
2568 Eberhardt F 49 27 64 172 LOW 124.8
2571 Nunnelly F 44 19 66 140 HIGH 149.75
2572 Oberon F 28 17 62 118 LOW 85.2
2574 Peterson M 30 6 69 147 MOD 149.75
2575 Quigley F 40 8 69 163 HIGH 124.8
2578 Cameron M 47 5 72 173 MOD 124.8
2579 Underwood M 60 22 71 191 LOW 149.75
2584 Takahashi F 43 29 65 123 MOD 124.8
2586 Derber M 25 23 75 188 HIGH 85.2
2588 Ivan F 22 20 63 139 LOW 85.2
2589 Wilcox F 41 16 67 141 HIGH 149.75
2595 Warren M 54 7 71 183 MOD 149.75
;
run;

proc print;
run;

data B;
set A;
run;
data B ;
set A;
label age="age as years";
run;


data c(keep=name actlevel);
set b (keep= name age actlevel);
where age > 40 and actlevel ="MOD";
run;
proc print ;
run;


/*why we use if while where is better*/

/*when we creating new varriable and applying any filter we have to use IF bcoz where is not work its apply the filter 
befor creating the varriable*/

data d; *4 #this code run last on the sequentially;
set a; *1 #this code run first;
N_age=age*2; *2 #this code run second code sequentially ;
if N_age > 100; *3 #this code run third sequentially;
run;

/*Imprtant: here where is NOT GIVES THE OUTPUT bcoz where applies the filter on varriable before its cereated..... see how*/
data e; *4 #this code run last;
set a; *1 #this code run first;
N_age=age*2; *3 #this code run after the where condition and then so on as usual;
where N_age > 100; *2 #this code run on second place bcoz where is a pre filter statement/condition always;
run;

*example by no. u can see which statements run when;
Data a; 5
Set sasuser.admit;  1
age_m=age*12; 3
x=5;4
where age_m gt 400; 2
Run;




/*HOW TO CREATE NEW LIBRARY*/
LIBNAME library "E:\raj\SAS\Amit_Sir_classes\libraryfolder";


data library.f;
set a;
run;

/* if i dont want to effect the position of the variable by length statement so, use retain statement */
***Retain:-The retain statement keeps the value once assigned.***;
data r;
retain ID Name Sex Age Date Height Weight ActLevel Fee;
length name $10.;
input ID Name$ Sex$ Age Date Height Weight ActLevel$ Fee;
informat fee comma5.2;
format fee comma5.2;
cards;
2458 Murray M 27 1 72 168 HIGH 85.2
2462 Almers F 34 3 66 152 HIGH 124.8
2501 Bonaventure F 31 17 61 123 LOW 149.75
2523 Johnson F 43 31 63 137 MOD 149.75
2539 LaMance M 51 4 71 158 LOW 124.8
2544 Jones M 29 6 76 193 HIGH 124.8
2552 Reberson F 32 9 67 151 MOD 149.75
2555 King M 35 13 70 173 MOD 149.75
2563 Pitts M 34 22 73 154 LOW 124.8
2568 Eberhardt F 49 27 64 172 LOW 124.8
2571 Nunnelly F 44 19 66 140 HIGH 149.75
2572 Oberon F 28 17 62 118 LOW 85.2
2574 Peterson M 30 6 69 147 MOD 149.75
2575 Quigley F 40 8 69 163 HIGH 124.8
2578 Cameron M 47 5 72 173 MOD 124.8
2579 Underwood M 60 22 71 191 LOW 149.75
2584 Takahashi F 43 29 65 123 MOD 124.8
2586 Derber M 25 23 75 188 HIGH 85.2
2588 Ivan F 22 20 63 139 LOW 85.2
2589 Wilcox F 41 16 67 141 HIGH 149.75
2595 Warren M 54 7 71 183 MOD 149.75
;
run;

proc print;
run;
/*********************************************************/






							/* CLASS-4 */

data A;
retain ID Name Sex Age Date Height Weight ActLevel Fee;
length name $10.;
input ID Name$ Sex$ Age Date Height Weight ActLevel$ Fee;
informat fee comma5.2;
format fee comma5.2;
cards;
2458 Murray M 27 1 72 168 HIGH 85.2
2462 Almers F 34 3 66 152 HIGH 124.8
2501 Bonaventure F 31 17 61 123 LOW 149.75
2523 Johnson F 43 31 63 137 MOD 149.75
2539 LaMance M 51 4 71 158 LOW 124.8
2544 Jones M 29 6 76 193 HIGH 124.8
2552 Reberson F 32 9 67 151 MOD 149.75
2555 King M 35 13 70 173 MOD 149.75
2563 Pitts M 34 22 73 154 LOW 124.8
2568 Eberhardt F 49 27 64 172 LOW 124.8
2571 Nunnelly F 44 19 66 140 HIGH 149.75
2572 Oberon F 28 17 62 118 LOW 85.2
2574 Peterson M 30 6 69 147 MOD 149.75
2575 Quigley F 40 8 69 163 HIGH 124.8
2578 Cameron M 47 5 72 173 MOD 124.8
2579 Underwood M 60 22 71 191 LOW 149.75
2584 Takahashi F 43 29 65 123 MOD 124.8
2586 Derber M 25 23 75 188 HIGH 85.2
2588 Ivan F 22 20 63 139 LOW 85.2
2589 Wilcox F 41 16 67 141 HIGH 149.75
2595 Warren M 54 7 71 183 MOD 149.75
;
run;

proc print;
run;

data male female;
set a;
if sex="M" then output male;
else output female;
run;



data b;
input model$ car$ rent;
datalines;
HY i20 20000
HY santro 10000
HO civic 25000
HO city 20000
HY i20 20000
HY santro 10000
HO civic 25000
HO city 20000
HY i20 20000
HY santro 10000
HO civic 25000
HO city 20000
HY i20 20000
HY santro 10000
HO civic 25000
HO city 20000
HY i20 20000
HY santro 10000
HO civic 25000
HO city 20000
HY i20 20000
HY santro 10000
HO civic 25000
HO city 20000
;
run;
proc print;
run;

data honda hyundai;
set b;
if model="HO" then output honda;
if model="HY" then output hyundai;
run;



data c ;
input id name$ marks;
if marks >= 60 then class="first_class";
if marks < 60 then class="second_class"; *here we have to remind that the variable values should be equal in length or always bigger value write first eg:"second_class";
cards;
201 raj 60
202 sita 45
203 manoj 34
206 rahul 55
204 nisha 72
;
run;

data first second;
set c;
if class="first_class" then output first;
if class="second_class" then output second;
run;


/*if,ELSE if,ELSE*/

data male female;
set a;
if sex="M" then output male;
if sex="F" then output female; *it not process the data in single time it use again if condition and data again goes to memory then gives the output;
run;


*if and else if;
data male female;
set a;
if sex="M" then output male;
else if sex="F" then output female; *it process the all data in single time;
run;


*code risky: work only when 2 value;
data male female;
set a;
if sex="M" then output male;
else output female;
run;


/*HOW TO READ DATA FROM EXTERNAL FLAT FILES*/

data cars;
infile "E:\raj\SAS\car_rent.txt" ;
input brand$ model$ rent;
run;
data hyundai honda;
set cars;
if brand="HY" then output hyundai;
else if brand="HO" then output honda;
run;


data credit;
infile "E:\raj\SAS\Amit_Sir_classes\class4-25-04-20\spend.csv" dlm=",";
input cc name$ salary spend pc;
run;

data low mid high;
set credit;
if pc > .30 then output high;
else if  0.20 <= pc <= 0.30 then output mid;
else output low;
run;

data low1 mid1 high1;
set credit;
if pc > .30 then output high1;
else if  0.30 >= pc >= 0.20 then output mid1;
else output low1;
run;

data low mid high;
set credit;
if pc > 0.30 then output high;
else if pc >=0.20 and pc <= 0.30 then output mid;
else output low;
run;
/****************************************************************/









							/*CLASS-5*/


*proc print is used to print a given dataset;
proc print data=a;
run;

proc print data=a;
var id name;
run;

proc print data=a;
where age > 40;
run;

proc print data=a n;
where age > 40;
run;

proc print data=a n noobs;
where age > 40;
run;

proc print data=a n noobs;
where age > 40;
sum fee;
run;

/*if cannot be use in proc step*/
proc print data=a;
if age > 40;
run;


/*TITLE AND FOOTNOTES*/
proc print data=a n noobs;
title "This is the title of this reporting page";
title "this is the next line of the title";
footnote "batch-95";
footnote "amit_sir_batch";
where age > 40;
sum fee;
run;


 data G N D;
 infile "E:\raj\SAS\Amit_Sir_classes\class4-25-04-20\spend.csv" dlm=",";
 input  cc name$ salary spend pc city$;
 if city="G" then output g;
else if city="N" then output n;
else output d;
run;

proc print data=g;
title "segmentation of data and then genrate the report sum of spend of city";
footnote "spend data of gurugram city";
sum spend;
run;
	
proc print data=n;
title "segmentation of data and then genrate the report sum of spend of city";
footnote "spend data of noida city";
sum spend;
run;

proc print data=d;
title "segmentation of data and then genrate the report sum of spend of city";
footnote "spend data of delhi city";
sum spend;
run;



/*ODS(OUTPUT DELIVERY SYSTEM)*/

ods pdf file="E:\raj\SAS\Amit_Sir_classes\ODS_files\reporting_odsfile.pdf";

proc print data=a n noobs;
title "This is the title of this reporting page";
title1 "this is the next line of the title";
footnote "batch-95";
footnote1 "amit_sir_batch";
where age > 40;
sum fee;
run;

ods pdf close;

ods rtf file="E:\raj\SAS\Amit_Sir_classes\ODS_files\reporting_odsfile.rtf";

proc print data=a n noobs;
title1 "This is the title of this reporting page";
title2 "this is the next line of the title";
footnote1 "batch-95";
footnote2 "amit_sir_batch";
where age > 40;
sum fee;
run;

ods rtf close;


/*PROC SORT*/
proc sort data=a;
by age;
run;

proc sort data=a out=b;
by descending age;
run;


data d;
input id name$;
cards;
1 g
. h
3 f
. j
;
run;
proc sort data=d;
by id;
run;


/*MULTILEVEL SORTING*/
*multiple level filtring data;

proc sort data=a;
by sex;
where age > 40 and sex="M";
run;

proc sort data=a  out=b;
by sex actlevel;
run;

proc sort data=a  out=b;
by descending sex  descending actlevel;
run;
/**************************************************************/







							/* CLASS-6 */


data a;
input city $ sector   building$;
cards;
G 1 P
G 1 A
G 2 B
N 1 A
N 2 B
N 1 C
N 1 A
;
run;

proc sort data=a  out=b;
by city sector building;
run;

data d;
set a;
where city ^= "G";
run;



/*REMOVING DUPLICATES*/
data a;
input rollno name $ ;
cards;
1 A 
2 B
3 B
4 D
5 K
5 M
5 M
;
run;
proc sort data=a out=b  nodupkey;
by rollno;
run;

proc sort data=a out=c nodupkey;
by rollno name;
run;


/** to see the duplicates values or storing duplicates value in another dataset**/
data d;
input rollno name $ ;
cards;
1 A 
2 B
3 B
4 D
5 K
5 M
5 L
5 N
5 S
;
run;
proc sort data=d out=e dupout=f nodupkey;
by rollno ;*it gives e:5observation and f:4 duplicate rows;
run;

proc sort data=d out=e dupout=f nodupkey;
by rollno name; *it will gives total observation;
run;



*Removing Full duplicate observation;
data a;
input cc data$ time$ spend;
cards;
1 02may 9:55:12  100
1 02may 9:57:12  100
1 02may 9:58:12  100
1 02may 9:58:12  100
;
run;

proc sort data=a out=b  dupout=d nodupkey;
by cc data time spend;
run;
*OR;
proc sort data=a out=b2  dupout=d2 nodupkey;
by _all_;
run;


/*if we want to remove exactlly duplicate observation so, we also can use nodup rather to write all variable in by statement*/
proc sort data=a out=b1  dupout=d1 nodup;
by cc;
run;

*Nodupkey: Is used to remove to duplicates of the key variable;
*Nodup: Is not dependent on key variable, just remove full duplicate observartion;




/*BY GROUP*/    *it is working similar as like GROUP BY in sql;
data A;
retain ID Name Sex Age Date Height Weight ActLevel Fee;
length name $10.;
input ID Name$ Sex$ Age Date Height Weight ActLevel$ Fee;
informat fee comma5.2;
format fee comma5.2;
cards;
2458 Murray M 27 1 72 168 HIGH 85.2
2462 Almers F 34 3 66 152 HIGH 124.8
2501 Bonaventure F 31 17 61 123 LOW 149.75
2523 Johnson F 43 31 63 137 MOD 149.75
2539 LaMance M 51 4 71 158 LOW 124.8
2544 Jones M 29 6 76 193 HIGH 124.8
2552 Reberson F 32 9 67 151 MOD 149.75
2555 King M 35 13 70 173 MOD 149.75
2563 Pitts M 34 22 73 154 LOW 124.8
2568 Eberhardt F 49 27 64 172 LOW 124.8
2571 Nunnelly F 44 19 66 140 HIGH 149.75
2572 Oberon F 28 17 62 118 LOW 85.2
2574 Peterson M 30 6 69 147 MOD 149.75
2575 Quigley F 40 8 69 163 HIGH 124.8
2578 Cameron M 47 5 72 173 MOD 124.8
2579 Underwood M 60 22 71 191 LOW 149.75
2584 Takahashi F 43 29 65 123 MOD 124.8
2586 Derber M 25 23 75 188 HIGH 85.2
2588 Ivan F 22 20 63 139 LOW 85.2
2589 Wilcox F 41 16 67 141 HIGH 149.75
2595 Warren M 54 7 71 183 MOD 149.75
;
run;
proc sort data=a        out=new1;
by sex;
run;

proc print data=new1;
title "Report gender wise with fee";
footnote "the report is genrated by raj";
sum fee;
by sex;
run;

proc print data=new1;
run;
/*************************************/

/*MERGING*/

*Pre-requisite of Merging;
*COMMON PRIMARY KEY;
*PRIMARY KEY SHOULD BE SORTED AND IF NOT THNE SORT EITHER BY asc AND desc;
*TYPES OF THE PRIMARY KEY SHOULD BE THE SAME;

data a;
input id name $;
datalines;
1 A
2 B
;
run;

data b;
input id sal;
cards;
1 100
2 300
;
run;

data a_b;
merge a b;
by id;
run;
*CODE IN CASE OF DESENDING SORTED DATA: This will only work when data is sorted in both files to be merged in descending order;


/*************************************************************************/







							/* CLASS-7 */


/*ONE TO ONE MERGING*/
*1-1 Merging: The by group have 1 row;

data a;
input id name $;
cards;
1 A
2 B
3 C
;
run;

data b;
input id sal;
cards;
1 100
2 200
3 400
;
run;

data a_b;
merge a b;
by id;
run;


/*ONE TO MANY*/

data a;
input id name $;
cards;
1 A
2 B
3 C
;
run;

data c;
input id sub$;
cards;
1 H
2 M
1 S
2 H
2 J
;
run;

proc sort data=c;
by id;
run;
data a_c;
merge a c;
by id;
run;


/*MANY TO ONE*/
*Many-1 Merging: The rows are not 1**;
data A;
input id name $;
cards;
1 A
2 B
3 C
;
run;

data Z;
input id sub$;
cards;
1 H
2 M
1 S
2 H
2 J
;
run;
proc sort data=A;
by id;
run;
proc sort data=Z;
by id;
run;
data A_Z;
merge z a; * here we have to interchange the dataset position so it will become many to one merge;
by id;
run;

/******************************************************************/








								/* CLASS-8 */

/*SPECIAL MERGING*/
*special merging: important for practical aspect;

*portfolio analysis;
data jan;
input cc;
cards;
1
2
3
;
run;
data feb;
input cc;
cards;
1
2
4
5
;
run;
data loyal left new;
merge jan(in=x) feb(in=y);
by cc;
if x=1 and y=1 then output loyal;
else if x=1 and y=0 then output left;
else if x=0 and y=1 then output new;
run;

/*CATCHING THE VALEUE OF BOOLEAN VARIABLE*/

data final;
merge jan(in=x) feb(in=y);
by cc;
j=x;
f=y;
run;


*PROBLEM;
*ARAR: ACCNT RECIVABLE ANALYTICS REPORTING;
data arar;
input empid name$;
cards;
1 A
2 B
3 C
;
run;

data pacific;
input empid sal;
cards;
1 500
2 200
3 400
4 100
5 300
;
run;

*QUESTION: Now we need to extract the salary of employees working in Team arar;
data arar_pac;
merge arar(in=x) pacific(in=Y);
by empid;
if x=1;
run;


*QUESTION: Salary of the people not working in team arar;
data sal_arar1 sal_notarar1;
merge arar(in=x) pacific(in=y);
by empid;
if x=0  and y=1 then output sal_notarar1;
else if x=1 then output sal_arar1;
run;


*QUESTION: Now we need to extract the defaulters that is the people who were supposed to pay but have not in dataset defaulter.;
data arar;
input cust name $ paid;
cards;
1 A 200
3 C 500
;
run;

data total;
input cust name$ due$;
cards;
1 A y
2 B n
3 C y
4 D n
5 E y
;
run;

data paid defalter;
merge arar(in=x) total(in=y);
by cust;
if due="y" and x=1 then output paid;
else if due="y" and x=0 then output defalter;
run;

/*From above examples we can conclude the concept of*/
/*1) Inner Join*/
/*2) Left Join*/
/*3) Right Join*/
/*4) Full Join*/


/*INNER JOIN*/
*If x=1 and y =1;


/*LEFT JOIN*/
*If x=1;


/*Right Join*/
*If y=1;


/*Full Join*/

/*****************************************************************/










								/* CLASS-9 */


/*SPECIAL CASES OF MERGING*/

*COMMON VARIABLE IS NOT THE SAME;
data a;
input id name$;
cards;
1 A
2 B
;
run;

data b;
input pid sal;
cards;
1 100
2 200
;
run;

data a_b;
merge a b(rename=(pid=id));
by id;
run;

data a_b_2;
merge a(rename=(id=pid)) b;
by pid;
run;





data admit;
retain ID Name Sex Age Date Height Weight ActLevel Fee;
length name $10.;
input ID Name$ Sex$ Age Date Height Weight ActLevel$ Fee;
informat fee comma5.2;
format fee comma5.2;
cards;
2458 Murray M 27 1 72 168 HIGH 85.2
2462 Almers F 34 3 66 152 HIGH 124.8
2501 Bonaventure F 31 17 61 123 LOW 149.75
2523 Johnson F 43 31 63 137 MOD 149.75
2539 LaMance M 51 4 71 158 LOW 124.8
2544 Jones M 29 6 76 193 HIGH 124.8
2552 Reberson F 32 9 67 151 MOD 149.75
2555 King M 35 13 70 173 MOD 149.75
2563 Pitts M 34 22 73 154 LOW 124.8
2568 Eberhardt F 49 27 64 172 LOW 124.8
2571 Nunnelly F 44 19 66 140 HIGH 149.75
2572 Oberon F 28 17 62 118 LOW 85.2
2574 Peterson M 30 6 69 147 MOD 149.75
2575 Quigley F 40 8 69 163 HIGH 124.8
2578 Cameron M 47 5 72 173 MOD 124.8
2579 Underwood M 60 22 71 191 LOW 149.75
2584 Takahashi F 43 29 65 123 MOD 124.8
2586 Derber M 25 23 75 188 HIGH 85.2
2588 Ivan F 22 20 63 139 LOW 85.2
2589 Wilcox F 41 16 67 141 HIGH 149.75
2595 Warren M 54 7 71 183 MOD 149.75
;
run;

*how we can use rename;
data admit2;
set admit;
rename sex=gender;
run;

data admit3;
set admit;
rename sex=gender fee=fee_dollar;
run;

data admit4;
set admit (rename=(height=height_inches)); *option;
rename sex=gender fee=fee_dollar; *statement;
run;


*COMMON VARIABLE IN 2 DATASETS BESIDE THE KEY;

/*2.0: SPECIAL SCENARIOS OF MERGING;
common variable in 2 datasets beside the key
*/
data a;
input id name$ age;
cards;
1 A 20
1 B 30
;
run;

data b;
input id sal age;
cards;
1 100 40
1 200 45
;
run;

data a_b;
merge a b;
by id;
run;
*With a same variable in both the datasets, the values of the last dataset overwrite the variable of the initial dataset. In the above example , when we merge with a common primary key (id) and if the othercommon variable has different values.;
*The values of the latter dataset (Dataset B) overrides the value of the former dataset (dataset A).;


/*2.1: SPECIAL SCENARIOS OF MERGING;
*COMMON VARIABLE IN 2 DATASETS BESIDE THE KEY
*/
data a;
input id name$ age;
cards;
1 A 20
2 B 30
;
run;
data b;
input id sal age;
cards;
1 100 40
2 200 45
;
run;

data a_b;
merge a b;
by id;
run;
*If we don’t want the values of the second dataset to override the first dataset , then we use DROP as shown above.;
data a_b;
merge a b(drop=age);
by id;
run;



/*2.2: SPECIAL SCENARIOS OF MERGING;
common variable in 3 datasets beside the key
*/
data a;
input id name$ age;
cards;
1 A 20
2 B 30
;
run;
data b;
input id sal age;
cards;
1 100 40
2 200 45
;
run;

data c;
input id sal age;
cards;
1 100 21
2 200 22
;
run;

data ab;
merge a b c;
by id;
run;


/*2.3: SPECIAL SCENARIOS OF MERGING;
COMMON VARIABLE IN 2 DATASETS BESIDE THE KEY;
*/
data e;
input id name$ age;
cards;
1 A 20
2 B 30
;
run;
data f;
input id sal age;
cards;
1 100 .
2 200 .
;
run;

data ab;
merge e f;
by id;
run;


/*3: SPECIAL SCENARIOS OF MERGING;
forgot to write the by statement
merge 1st row by 1st.. 2nd by second
*/
data e;
input id name$;
cards;
1 A
2 B
;
run;
data f;
input id sal;
cards;
1 100
12 200
;
run;

data e_f;
merge e f;
run;

data e_f1;
merge e f;
by id;
run;


/*3.1 SPECIAL SCENARIOS OF MERGING;
 forgot to the write the by statement
when this is ok?
*/
data a;
input id name$ ;
cards;
1 A
2 B
;

data b;
input id sal;
cards;
1 100
2 200
;

data a_b;
merge a b;
run;
*it gives same output as above;
data a_b1;
merge a b;
by id;
run;



/*WHEN MERGE BEHAVES LIKE APPEND*/
/* special secnarios of merging;
common variable is there .. but there is no common value.
then merge behave like append..
*/
data a;
input id name$ ;
cards;
1 A
2 B
;

data b;
input id sal;
cards;
3 100
4 200
;
data ab;
merge a b;
by id;
run;

data c1;
set a b;
run;


/*WHEN THERE IS NO PRIMARY KEY*/
data a;
input name$ father$ city$ marks;
cards;
amit ram gurgaon 100
amit ram delhi 90
baba shyam fbd 80
;
run;

data b;
input name$ father$ city$ class$;
cards;
amit ram gurgaon IX
amit ram delhi X
baba shyam fbd IX
;
run;

proc sort data=a;
by name father city;
run;
proc sort data=b;
by name father city;
run;

data merge_ab;
merge a b;
by name father city;
run;

*When there is no primary key then we try to make a COMPOUND KEY which is unique in nature, 
for example the key is name father and city in the above example;




/*DOUBTS*/
*how to selectively get the age;
data a;
input id name$ age;
cards;
1 A 25
2 B 30
;
run;
data b;
input id age;
cards;
1 .
2 20
;
run;
data a_b(drop=age age1);
merge a b(rename=(age=age1));
by id;
if age1=. then newage=age;
else newage=age1;
run;




/*UPDATE*/
*This helps to update the data with the latest details.
Update picks up the last value of the new dataset and merges with the other dataset.;
data ctc;
input id name$ sal;
cards;
1 A 100
2 B 200
3 C 300
;
run;
data temp;
input id name$ sal;
cards;
1 A 110
1 A 120
1 A 125
2 B 210
2 B 220
3 C 295
;
run;
data newsal;
update ctc temp;
by id;
run;


*No new dataset will be created but the values of the sal will be updated in dataset ctc.;
data ctc;
update ctc temp;
by id;
run;


*Variable pc can be created which gives the percentage increment of the sal.;
data ctc;
input id name$ sal;
cards;
1 A 100
2 B 200
3 C 300
;
run;
data temp;
input id name$ salary;
cards;
1 A 110
1 A 120
1 A 125
2 B 210
2 B 220
3 C 295
;
run;
data newsal1;
update ctc temp;
by id;
pc=(salary-sal)/sal*100;
run;
/*************************************************************/







								/* CLASS-10 */

data A;
retain ID Name Sex Age Date Height Weight ActLevel Fee;
length name $10.;
input ID Name$ Sex$ Age Date Height Weight ActLevel$ Fee;
informat fee comma5.2;
format fee comma5.2;
cards;
2458 Murray M 27 1 72 168 HIGH 85.2
2462 Almers F 34 3 66 152 HIGH 124.8
2501 Bonaventure F 31 17 61 123 LOW 149.75
2523 Johnson F 43 31 63 137 MOD 149.75
2539 LaMance M 51 4 71 158 LOW 124.8
2544 Jones M 29 6 76 193 HIGH 124.8
2552 Reberson F 32 9 67 151 MOD 149.75
2555 King M 35 13 70 173 MOD 149.75
2563 Pitts M 34 22 73 154 LOW 124.8
2568 Eberhardt F 49 27 64 172 LOW 124.8
2571 Nunnelly F 44 19 66 140 HIGH 149.75
2572 Oberon F 28 17 62 118 LOW 85.2
2574 Peterson M 30 6 69 147 MOD 149.75
2575 Quigley F 40 8 69 163 HIGH 124.8
2578 Cameron M 47 5 72 173 MOD 124.8
2579 Underwood M 60 22 71 191 LOW 149.75
2584 Takahashi F 43 29 65 123 MOD 124.8
2586 Derber M 25 23 75 188 HIGH 85.2
2588 Ivan F 22 20 63 139 LOW 85.2
2589 Wilcox F 41 16 67 141 HIGH 149.75
2595 Warren M 54 7 71 183 MOD 149.75
;
run;


/*SUBSTR Function*/ *1. Substr: String function and gives you the sub.. part of string;

data b;
string="yadavraj";
output_of_substr=substr(string,5,3); * variable,start,length (NOT the stop);
run;
* If the substr creates a new variable then the length of the new variable would be same as that of parent variable;


data b1;
string="yadavraj";
output_of_substr=substr(string,1,5); * variable,start,length (NOT the stop);
run;



/*PROBLEM*/
data cars;
input reg$;
state=substr(reg,1,2);
plate=substr(reg,3);
cards;
HR123
PB345
DL789
UP456
;
run;

data cars1;
set cars;
if substr(reg,1,2)="HR" then state="haryana";
else if substr(reg,1,2)="PB" then state="punjab";
else if substr(reg,1,2)="DL" then state="delhi";
else if substr(reg,1,2)="DL" then state="utter pradesh";
run;




/**MASKING OF THE PERSONAL DATA*/
data a1;
set a;
b2=substr(actlevel,1,2);
substr(actlevel,1,2)="xx";
run;


/*SCAN Function*/
data cars;
input reg$;
state=scan(reg,1,"-");
plate=scan(reg,2,"-");
cards;
HR-123
PB-1345
DL-789
GUJ-3256	
;
run;

data cars;
input reg$1-15;
state=scan(reg,1,"-");
plate=scan(reg,2,"-");
model=scan(reg,3,"-");
cards;
HR-123-Merc
PB-1345-BMW
DL-789-Audi
GUJ-3256-Merc
;
run;


DATA cars;
input reg$1-15;
year="20"||substr(scan(reg,3,"-"),5,2);
cards;
HR-123-Merc20
PB-1345-Audi19
DL-789-Audi20
GUJ-3256-Merc19
;
run;


/*The scan can read different delimiters if no third argument is provided*/
data a;
x="ab-cd,123";
a=scan(x,1);
b=scan(x,2);
c=scan(x,3);
run;
data a;
x="ab-cd,123";
a=scan(x,1,"-");
b=scan(x,2,"-");
run;


/*To scan the data from right side , for this the negative argument is given*/
data cust;
input name$1-40;
first_name=scan(name,1,",");
last_name=scan(name,-1,",");
cards;
amit,kumar
neha,kumari,sharma
venu,gopal,ayengar,krishna,murthy
;
run;




/*LAG FUNCTION: It pushes the value by n row, where n is the number of rows*/
* Time series data: You have the time and values;
data company;
input year sale;
cards;
2001 100
2002 200
2003 350
2004 400
2005 300
2006 250
2007 100
2008 90
2009 150
;
run;


/*pushes the value by 1 row*/
data company1;
input year sale;
sale1=lag(sale);
cards;
2001 100
2002 200
2003 350
2004 400
2005 300
2006 250
2007 100
2008 90
2009 150
;
run;


/*To calculate the percentage change of sale , from the last year .*/
data company2;
input year sale;
sale1=lag(sale);
pc=(sale-sale1)/sale1*100;
cards;
2001 100
2002 200
2003 350
2004 400
2005 300
2006 250
2007 100
2008 90
2009 150
;
run;

/*To calculate the percentage change of sale, from the last year, without creating the variable sale1*/
*to excute all in single line;
data company3;
input year sale;
pc=(sale-lag(sale))/lag(sale)*100;
cards;
2001 100
2002 200
2003 350
2004 400
2005 300
2006 250
2007 100
2008 90
2009 150
;
run;


/*To push down the values of a variable by two rows.*/
data company_new;
input year sale;
sale1=lag2(sale);

cards;
2001 100
2002 200
2003 350
2004 400
2005 300
2006 250
2007 100
2008 90
2009 150
;
run;
/*************************************************************************/









								/* CLASS-11 */


/* UPCASE LOWCASE PROPCASE */
data a;
x="amiTaBh";
up_case=upcase(x);
Low_case=lowcase(x);
prop_case=propcase(x);
run;


data Aa;
retain ID Name Sex Age Date Height Weight ActLevel Fee;
length name $10.;
input ID Name$ Sex$ Age Date Height Weight ActLevel$ Fee;
informat fee comma5.2;
format fee comma5.2;
cards;
2458 Murray M 27 1 72 168 HIGH 85.2
2462 Almers F 34 3 66 152 HIGH 124.8
2501 Bonaventure F 31 17 61 123 LOW 149.75
2523 Johnson F 43 31 63 137 MOD 149.75
2539 LaMance M 51 4 71 158 LOW 124.8
2544 Jones M 29 6 76 193 HIGH 124.8
2552 Reberson F 32 9 67 151 MOD 149.75
2555 King M 35 13 70 173 MOD 149.75
2563 Pitts M 34 22 73 154 LOW 124.8
2568 Eberhardt F 49 27 64 172 LOW 124.8
2571 Nunnelly F 44 19 66 140 HIGH 149.75
2572 Oberon F 28 17 62 118 LOW 85.2
2574 Peterson M 30 6 69 147 MOD 149.75
2575 Quigley F 40 8 69 163 HIGH 124.8
2578 Cameron M 47 5 72 173 MOD 124.8
2579 Underwood M 60 22 71 191 LOW 149.75
2584 Takahashi F 43 29 65 123 MOD 124.8
2586 Derber M 25 23 75 188 HIGH 85.2
2588 Ivan F 22 20 63 139 LOW 85.2
2589 Wilcox F 41 16 67 141 HIGH 149.75
2595 Warren M 54 7 71 183 MOD 149.75
;
run;

data a1;
set aa;
where actlevel="HIGH";
run;

data a2;
set aa;
where lowcase(actlevel)="high";
run;

data a3;
set aa;
where upcase(actlevel)="HIGH";
run;

data a4;
set aa;
new_act=lowcase(actlevel);
run;


data a5;
x="r0hHJK9U";
y=lowcase(x);
z=upcase(x);
b=propcase(x);
run;



/*COALESCE Function*/
*CRM: Customer Relationship management: Campaing analysis;
*m1 > m2 > hl > ol   9999;

/*To find first non-missing(NUM) value*/
data a;
input id $ M1 M2 H1 O1;
contact=coalesce(M1,M2,H1,O1,9999);
cards;  
A 1 . 5 6
B . . 7 8
C . . . .
D . . . 9
;
run;

/* To find the first non-missing CHARACTER value  */
data a;
input ra$ ra1$ pa$ oa$;
contact_address= coalescec(oa,pa,ra1,ra,"NA");
cards;  
sec46 . . .
. . . sec57
. sec78 sec92 .
. . . .
;
run;

/* There are 4 functions which handle blanks in different ways: */
/* COMPRESS Function */
data a;
x=" am it ";
y=compress(x); *it kills the all blanks of the string like:leading,tralling and intermediate blank.;
z=strip(x); *it kills leading and trailling blank of the string;
k=trim(x); *it kills trailling blank only;
run;


/* COMPBL */
*It would gives 1 uniform space in string;
data a;
x="geeta    is a good girl";
y=compbl(x);
run;



data a;
retain ID Name Sex Age Date Height Weight ActLevel Fee;
length name $10.;
input ID Name$ Sex$ Age Date Height Weight ActLevel$ Fee;
informat fee comma5.2;
format fee comma5.2;
cards;
2458 Murray M 27 1 72 168 HIGH 85.2
2462 Almers F 34 3 66 152 HIGH 124.8
2501 Bonaventure F 31 17 61 123 LOW 149.75
2523 Johnson F 43 31 63 137 MOD 149.75
2539 LaMance M 51 4 71 158 LOW 124.8
2544 Jones M 29 6 76 193 HIGH 124.8
2552 Reberson F 32 9 67 151 MOD 149.75
2555 King M 35 13 70 173 MOD 149.75
2563 Pitts M 34 22 73 154 LOW 124.8
2568 Eberhardt F 49 27 64 172 LOW 124.8
2571 Nunnelly F 44 19 66 140 HIGH 149.75
2572 Oberon F 28 17 62 118 LOW 85.2
2574 Peterson M 30 6 69 147 MOD 149.75
2575 Quigley F 40 8 69 163 HIGH 124.8
2578 Cameron M 47 5 72 173 MOD 124.8
2579 Underwood M 60 22 71 191 LOW 149.75
2584 Takahashi F 43 29 65 123 MOD 124.8
2586 Derber M 25 23 75 188 HIGH 85.2
2588 Ivan F 22 20 63 139 LOW 85.2
2589 Wilcox F 41 16 67 141 HIGH 149.75
2595 Warren M 54 7 71 183 MOD 149.75
;
run;

/* Compress */
data b;
set a;
where compress(lowcase(actlevel))="low";
run;

data b1;
set a;
where lowcase(actlevel)="low";
run;


data b3;
set a;
where actlevel="low";
run;

*when ignor the upcase and compress the string;
data c;
set a;
where actlevel="LOW";
run;

data c1;
set a;
where upcase(actlevel)="LOW";
run;

data c2;
set a;
where compress(upcase(actlevel))="LOW";
run;


/*COALESCE-C Function*/
data a;
input ra$ ra1$ pa$ oa$;
contact_address= coalescec(oa,pa,ra1,ra,"NA");
cards;  
sec46 . . .
. . . sec57
. sec78 sec92 .
. . . .
;
run;

/* 1 argument if we have to remove blank space */
/* 2 arguments when we have to remove any character other than blank space. */
/* 3 arguments when we use modifiers. */
data a;
x="am itabh";
y=compress(x,"a");
run;



data a1;
x="am itabh";
y=compress(x,"abh");
run;


data a2;
input add$1-15;
new_add=compress(add,":-");

cards;
sec46:hno-34
sec47:hno-35
sec48:hno-36
;
run;




data a;
input ra$ ra1$ pa$ oa$;
contact_address= coalescec(oa,pa,ra1,ra,"NA");
cards;  
sec46 . . .
. . . sec57
. sec78 sec92 .
. . . .
;
run;

*if want to extract numeric and charcter value in different variables;
data a3;
input add$;
flat_no=compress(add," ",'kd');
bulding=compress(add," ",'d');
cards;
P123
PK456
KKL345
;
run;


data a3;
input add$;
flat_no=compress(add,"",'kd');
bulding=compress(add,"",'d');
cards;
P123
PK456
KKL345
;
run;

data a;
input add$;
flat=compress(add,"",'kd');
building=compress(add,"L",'d');
cards;
P123
PK456
KKL345
;
run;
/**
a – Remove all upper and lower case characters from String.
ak – Keep only alphabets from String.
kd – Keeps only numeric values
d – Remove numerical values from String.
i – Remove specified characters both upper and lower case from String.
k – keeps the specified characters in the string instead of removing them.
l – Remove lowercase characters from String.
p – Remove Punctuation characters from String.
s – Remove spaces from String. This is default.
u – Remove uppercase characters from String.
**/
*if we want to IGNOR the uppercase/lowercase;
data a;
x="Amita";
y=compress(x,"axm","i");
run;

data a;
x="amita";
y=compress(x,"aA");
run;

data a;
x="Raj";
y="Yadav";
full=x||""||y;
run;

data b;
x="Raj";
y="Yadav";
full=cat(x,"",y);
run;


/* question */
*if we want to remove character from numeric and then add something in it;
data a;
input trt$;
dose=compress(compress(trt,"","kd")||"mg");
cards;
a150
b250
;
run;
/*************************************************************************/







								/* CLASS-12 */


*Do statement: To do multiple task for any logical statement;
data a;
retain ID Name Sex Age Date Height Weight ActLevel Fee;
length name $10.;
input ID Name$ Sex$ Age Date Height Weight ActLevel$ Fee;
informat fee comma5.2;
format fee comma5.2;
cards;
2458 Murray M 27 1 72 168 HIGH 85.2
2462 Almers F 34 3 66 152 HIGH 124.8
2501 Bonaventure F 31 17 61 123 LOW 149.75
2523 Johnson F 43 31 63 137 MOD 149.75
2539 LaMance M 51 4 71 158 LOW 124.8
2544 Jones M 29 6 76 193 HIGH 124.8
2552 Reberson F 32 9 67 151 MOD 149.75
2555 King M 35 13 70 173 MOD 149.75
2563 Pitts M 34 22 73 154 LOW 124.8
2568 Eberhardt F 49 27 64 172 LOW 124.8
2571 Nunnelly F 44 19 66 140 HIGH 149.75
2572 Oberon F 28 17 62 118 LOW 85.2
2574 Peterson M 30 6 69 147 MOD 149.75
2575 Quigley F 40 8 69 163 HIGH 124.8
2578 Cameron M 47 5 72 173 MOD 124.8
2579 Underwood M 60 22 71 191 LOW 149.75
2584 Takahashi F 43 29 65 123 MOD 124.8
2586 Derber M 25 23 75 188 HIGH 85.2
2588 Ivan F 22 20 63 139 LOW 85.2
2589 Wilcox F 41 16 67 141 HIGH 149.75
2595 Warren M 54 7 71 183 MOD 149.75
;
run;
data b;
set a;
if age > 40 then do;
fee1=fee+10; *task1;
status=1; *task2;
end;
else do;
fee1=fee;
status=2;
end;
run;


data c;
set a;
if age> 40 then fee1=fee+10;
if age> 40 then status=1;
run;

*Do statement: It is mothers day: Give all females a discount of 10 $ + gender Female;
data b1;
set a;
if sex="F" then do;
fee1=fee-10;
gender="female";
x=1;
end;
else do;
fee1=fee;
gender="male";
x=2;
end;
run;


*Do loops: they are used to execute a code in an iterative manner;
*Loop is when the start and end poistions coincide;

data a;
do i=1 to 5;

end;
run;

data a;
do i=1 to 5;
output;
end;
run;

data a;
do i=1 to 5;
output;
end;
output;
run;

data a;
do i=1 to 5;
output ;
output;
end;
run;


data b;
set a;
x=x+1; *This is + operator;
run;
 

data c;
x=.;
y=2+x;
run;
*when we use operator we get .+1=. always;

data f;
set a;
z+1; *x=x+1...... but this is sum(x,1);
run;

data b1;
x=.;
y=sum(2,x);
run;

/*
p=100000   1 year after 109000 : 1 st year

p+p*r >> 100000+100000*.09 >> 109000

p=109000   2 year after ? : 2 st year

*/
data interst;
p=100000;
r=.09;
do i=1 to 5;
p+p*r;
output;
end;
drop r;
rename i=year;
run;

data interst1;
p=100000;
r=.09;
do year=1 to 5;
p+p*r;
output;
end;
run;
*if the output statement not given the what will happen let's see;
data interst;
p=100000;
r=.09;
do year=1 to 5;
p+p*r;
end;
run;

/*QUESTION: */
data Loss_shayam;
p1=100000;
p2=100000;
R1=.09;
R2=.08;
do years=1 to 5;
p1+p1*r1;
p2+p2*r2;
final=p1-p2;
output;
end;
drop r1 r2;
run;


*conditional interest;
data xx;
p=100000;
r1=0.09;
r2=.05;
do years=1 to 5;
if years <=3 then p+p*r1;
else p+p*r2;
output;
end;
drop r1 r2;
run;
 


data xx1;
p=100000;
do years=1 to 5;
if years <=3 then p+p*.09;
else p+p*.05;
output;
end;
drop r1 r2;
run;


*when we have to find the interest with regular intervals;
data a3;
do i=1 to 5 by 2;
output;
end;
run;

data a4;
do i=1 to 5 by 1;
output;
end;
run;

data ab;
do i=10 to 1 by -1;
output;
end;
run;

data ab1;
do i=10 to 1 by -2;
output;
end;
run;
/*********************************************************************/








								/* CLASS-13 */


*count the words in a sting;
data a;
x="raj is not so cool";
n=countw(x);
run;


*this way we also count the word in a string;
data b;
s="raj is  not so cool";
c=1;
do while (scan(s,c," ") ne " "); *tabtak chalate raho jab tak NE " " ho jaye :or jabtak condition true na ho jaye:;
output;
c+1;
end;
run;

*counting the words in a string by untill statement;
data c;
s="raj is not so cool";
c=1;
do until(scan(s,c," ") eq " " );    *raj=" "     :False; *condition true hote hi stop ho jaega;
output;
c+1;
end;
run;


*To find the words in a sting by length statement;
data d;
s="raj is not so cool";
x=length(s);
y=length(compress(s));
spaces=x-y;
words=spaces+1;
run;


data x;
s="raj is not      socool";
y=scan(s,4," "); *scan(s,4)--- we can also write it like that;
run;




/* ARRAY */

/*Array is collection of homogenous elements: stores variables of same type why i should use
array and when*/
data clinic;
input name$ d1-d4;
cards;
A 12 13 13 14
B 14 15 11 12
;
run;
*Question: here we have to convert the weight in grms from kg of four days clinical data;
data clinic1;
input name $ d1-d4;
g1=d1*1000;
g2=d2*1000;
g3=d3*1000;
g4=d4*1000;
cards;
A 12 13 13 14
B 14 15 11 12
;
run;
*Doing same thing with the help of array and it will us when we have to calculate so many variables;
data clinic1;
input name$ d1-d4;
array g(4) d1-d4;
array h(4) grm1-grm4;
do i=1 to 4;
h(i)=g(i)*1000;
end;
drop i;
cards;
A 12 13 13 14
B 14 15 11 12
;
run;


*To keep only 3 out of four variables;
data clinic5(keep=d1-d3);
input name $ d1 d2 d3 d4;
cards;
A 12 12 13 14
B 12 12 13 15
;
run;
/*************************************************************************/










							/* CLASS-14 */






















								/* CLASS-15 */


/*ONE DIRECTIONAL ARRAY*/
data a ;
input name$ d1-d4;
array k(4) d1-d4;
array g(4) g1-g4;
do i=1 to 4;
g(i)=k(i)*1000;
end;
cards;
A 12 12 13 14
B 12 12 12 13
;
run;


DATA b;
input name $ d1-d4;
array k(4) d1-d4;
array g(4) y1-y4;
array p(4) z1-z4;
do i=1 to 4;
g(i)=k(i)*1000;
p(i)=k(i)*2.2;
end;
drop d1-d4;
drop i;

/*TWO DIRECTIONAL ARRAY*/
data c;
input name$ d1-d4;
array kgp(3,4) d1-d4 g1-g4 p1-p4;
do i=1 to 4;
kgp(2,i)=kgp(1,i)*1000;
kgp(3,i)=kgp(1,i)*2.2;
end;
cards;
A 12 12 13 14
B 12 12 12 13
;
run;


data d;
input name$ Q1-Q4;
array r(2,4) Q1-Q4 P1-P4;
do i=1 to 4;
r(2,i)=r(1,i)*0.05;
end;

cards;
TATA 50 30 42 54
RIL 12 43 51 95
AIRTEL 65 35 26 46
ADANI 45 75 42 52 
;
run;



*if we have to make 5 diffrent year of 10,20,30,40,50 add on result of data's with four quaters result;
data increment;
input name$ q1-q4;
array R(6,4) q1-q4 A1-A4 B1-B4 C1-C4 D1-D4 E1-E4;
do i=1 to 4;
R(2,i)=R(1,i)*10;
R(3,i)=R(1,i)*20;
R(4,i)=R(1,i)*30;
R(5,i)=R(1,i)*40;
R(6,i)=R(1,i)*50;
end;
cards;
TATA 50 30 42 54
RIL 12 43 51 95
AIRTEL 65 35 26 46
ADANI 45 75 42 52 
;
run;


data a(keep=id name);
set sasuser.admit;
run;
data b;
set sasuser.admit (keep=id name);
run;
data a;
set sasuser.admit;
keep id name;
run;
data a(keep=a:);
set sasuser.admit;
run;
data a(keep=a: w:);
set sasuser.admit;
run;

data a(keep=_numeric_);
set sasuser.admit;
run;
data a(keep=_character_);
set sasuser.admit;
run;
data a(keep=_character_) b(keep=_numeric_);
set sasuser.admit;
run;



data a(keep=sex--weight);
set sasuser.admit;
run;




**** You need to increment all the numeric variables value by 10;
data P;
set az;
array x(*) _numeric_;
do i=1 to dim(x); *coz we dont know how many times we have to continue the do loop so we use dim();
x(i)=x(i)+10;
end;
run;



data aq;
input vendor$ jan feb mar;
cards;
ram 700 200 400
shyam 300 700 150
gyan 200 400 800
;
run;

data aq1;
set aq;
x=whichn(400,of jan--mar); *here we want to find position of the any no. in the coloum,so its done by WHICHN function;
run;

data w;
input vendor$ jan feb mar;
array k(*) jan--mar;
x=vname(k(2)); *its tell us the variable name for which coloum we want by VNAME Function;
cards;
ram 700 200 400
;
run;
/***********************************************************************/












								/*CLASS-16*/

/*FORMATS/INFORMATS*/

data a1;
x=100;
y=put(x,6.2);
run;

data a2;
x=100;
y=put(x,7.3);
run;


data a;
x=100;
y=put(x,9.2); *6.2 or above.... so no issues;
run;

data a3;
x=1000;
y=put(x,comma8.2);
run;

data a4;
x=1000;
y=put(x,dollar9.2);
run;


data a;
input phone;
new=put(phone,4.);
isd=substr(new,1,2);
cards;
9199
9289
9188
;
run;

data a1;
input phone;
isd=substr(put(phone,4.),1,2);
cards;
9199
9289
9188
;
run;

data c;
input acc;
acc_new=put(acc,z6.);   *Z format : to aline 0 on right side to remove the blanks;
cards;
1
12
123
1234
12345
;
run;

data c;
input acc;
acc_new=put(acc,z18.);
cards;
1
12
123
1234
12345
;
run;

data A;
retain ID Name Sex Age Date Height Weight ActLevel Fee;
length name $10.;
input ID Name$ Sex$ Age Date Height Weight ActLevel$ Fee;
informat fee comma5.2;
format fee comma5.2;
cards;
2458 Murray M 27 1 72 168 HIGH 85.2
2462 Almers F 34 3 66 152 HIGH 124.8
2501 Bonaventure F 31 17 61 123 LOW 149.75
2523 Johnson F 43 31 63 137 MOD 149.75
2539 LaMance M 51 4 71 158 LOW 124.8
2544 Jones M 29 6 76 193 HIGH 124.8
2552 Reberson F 32 9 67 151 MOD 149.75
2555 King M 35 13 70 173 MOD 149.75
2563 Pitts M 34 22 73 154 LOW 124.8
2568 Eberhardt F 49 27 64 172 LOW 124.8
2571 Nunnelly F 44 19 66 140 HIGH 149.75
2572 Oberon F 28 17 62 118 LOW 85.2
2574 Peterson M 30 6 69 147 MOD 149.75
2575 Quigley F 40 8 69 163 HIGH 124.8
2578 Cameron M 47 5 72 173 MOD 124.8
2579 Underwood M 60 22 71 191 LOW 149.75
2584 Takahashi F 43 29 65 123 MOD 124.8
2586 Derber M 25 23 75 188 HIGH 85.2
2588 Ivan F 22 20 63 139 LOW 85.2
2589 Wilcox F 41 16 67 141 HIGH 149.75
2595 Warren M 54 7 71 183 MOD 149.75
;
run;

data x;
set a;
format fee dollar8.2;
fee=fee+10;
run;


data b;
a=100;
x=put(a,dollar7.2);
y=input(x,dollar7.2);
run;

data b;
a=100;
x=put(a,dollar7.2);
y=input(x,dollar9.2); *not an issue if we increase the length but it will not short;
run;

data a;
x=5673; *5673.00;
y=put(x,4.2);  *The decimal shifted the "BEST" format.;
run ;

data a;
input salary dollar8.2;
format salary comma9.2;
cards;
$1000.89
$5999.80
;
run;
/***************************************************/












								/* CLASS-17 */


data a;
do i=1 to 10;
date=put(i,date9.);
output;
end;
run;

data a;
input dob date9.;
format dob mmddyyc10.;
cards;
15jan2020
17jan2020
;
run;

data gg;
dat1='15jun2020'd;
dat2='20jun2020'd;
dif=intck("Day",dat1,dat2);
format dat1 dat2 date9.;
run;


data a;
input salary dollar7.2;
cards;
$100.00
;
run;
***********************************************************;





							/*CLASS-33*/

/* Best of 3  : first dot and last dot
Best
*/
data a;
input name$ marks;
cards;
Amit 21
Amit 29
Amit 22
Baba 30
Baba 27
Baba 21
;
run;


proc sort data=a out=b;
by name descending marks;
run;

proc sort data=b nodupkey;
by name ;
run;


/* Best of 3  : first dot and last dot
worst
*/
data a;
input name$ marks;
cards;
Amit 21
Amit 29
Amit 22
Baba 30
Baba 27
Baba 23
;
run;

proc sort data=a out=r;
by name marks;
run;

proc sort data=r nodupkey out=z;
by name;
run;


/* Best of 3  : first dot and last dot
*/
data a;
input name$ marks;
cards;
Amit 21
Amit 29
Amit 22
Baba 30
Baba 27
Baba 23
;
run;

proc sort data=a out=x;
by name marks;
run;

data best3 last3;
set x;
by name marks;  *it will tell the below condition on this parameter;
if first.name then output last3;
else if last.name then output best3;
run;


/* Best of 3  : first dot and last dot
*/
data a;
input name$ marks;
cards;
Amit 21
Amit 29
Amit 22
Baba 30
Baba 27
Baba 23
;
run;
proc sort data=a out=v;
by name marks;
run;

data check;
set v;
by name marks;
f=first.name;
l=last.name;
run;


/*
Identify the student that has given the exam once
*/
data a;
input name$ marks;
cards;
Amit 21
Amit 29
Amit 22
Baba 30
Baba 27
Baba 23
Kaka 23
;
run;
proc sort data=a out=bx;
by name marks;
run;

data attempt1;
set bx;
by name ;
if first.name=1 and last.name=1;
run;


/*
Get me all the entries beside highest and lowest 
*/
data a;
input name$ marks;
cards;
Amit 21
Amit 29
Amit 22
Amit 34
Baba 30
Baba 27
Baba 23
Baba 27
;
run;
proc sort data=a out=b;
by name marks;
run;

data beside;
set b;
by name ;
if first.name=0 and last.name=0;
run;


data a;
input id;
cards;
1
1
2
3
;
run;
data uni dup; *here we find duplicates values(which is also find by nodupkey) and unique values; 
set a;
by id;
if first.id=1 and last.id=1 then output uni;
else output dup;
run;
/*************************************************************************/









							/*CLASS-34*/


data sale;
input cc merchant $;
cards;
1 N 100
1 N 100
1 P 200
1 P 300
2 N 300
2 P 900
2 W 800
;
run;

data check;
set sale;
by cc merchant;
f=first.cc;
l=last.cc;
m=first.merchant;
n=last.merchant;
run;

data a;
set sasuser.admit;
x+1;
run;

data b;
set sasuser.admit;
retain x 0;
x=x+1;
run;


data c;
set sasuser.admit;
retain fee1 0;
fee1=fee1+fee;   *here we can find cumulative sum of the fee as in fee1 variable;
run;


data d;
set sasuser.admit;
x=sum(x,1);       *its function and its gives only 1 in all rows;
run;


data e;
set sasuser.admit;
x=0;
x=x+1;           *it is operator and its give same 1 in all rows;
run;

****how to find highest and second highest spend of customer;
data sale;
input cc merchant $ amnt;
cards;
1 N 100
1 N 1100
1 P 2100
1 P 1300
2 N 300
2 P 900
2 W 800
;
run;
proc sort data=sale out=sale_sorted;
by cc descending amnt;
run;


/*
1. Variable in sum statement initialize with 0
2. retain previous value
3. ignore missing value
*/

data high second_high;   ******IMPORTANT***;
set sale_sorted;
by cc ;
if first.cc then c=1; *here we find any nth no person salary;
else c+1;
if c=1 then output high;
else if c=2 then output second_high;
run;

*finding the 4th highest paid person;
data b4th;
set sale_sorted;
by cc;
if first.cc then x=1;
else x+1;
if x=4 then output;
run;

**important*******cumulative sum of the each customer card(cc)**;
data sale;
input cc merchant $ amnt;
cards;
1 N 100
1 N 1100
1 P 2100
1 P 1300
2 N 300
2 P 900
2 W 800
;
run;

proc sort data=sale out=sale_sorted;
by cc descending amnt;
run;

data final;
set sale_sorted;
by cc ;
if first.cc then bill=amnt;
else bill+amnt;
if last.cc;      *it gives last value by cc group and also we can say sum of each cc;
run;

**It "writes the values of all variables, which includes automatic variables, that are defined in the current 
DATA step by using named output."**;
data a;
set sasuser.admit;
put _all_;
run;

** it gives new variable of name x and in that serial no. till the end;
data b;
set sasuser.admit;
x=_n_;
run;

*** as we seen that name is numeric variable but in 2 row B is char value so, its show in log as error by _all_;
data a;
input id name;
put _all_;
cards;
11 22
22 B
;
run;

*if we want only top three rows;
data b;
set sasuser.admit;
if _n_ le 3;
run;

*if we want only even rows;
data c;
set sasuser.admit;
if _n_ in (2,4,6);
run;


*** if we want all even rows from the dataset;
data d;
set sasuser.admit;
if mod (_N_,2)=0;
run;


*** if we want all apart from even(or we can say odd) rows from the dataset;
data e;
set sasuser.admit;
if mod (_N_,2);
run;


data a;           *post buffer concept;
set sasuser.admit;
if age gt 40;
put _all_;
run;


data b;            *pre buffer concept;
set sasuser.admit;
where age gt 40;
put _all_;
run;

***********;
data b;
set sasuser.admit;
length gender $10;
if sex="M" then gender ="male";
else gender="female";
run;
/*********************************************************************************/






						/*CLASS-43*/

* Reading raw data using card and datalines ;
data a;
input id name $;
datalines;
1 A
2 B
;
run;

data a1;
input id name $;
cards;
1 A
2 B
;
run;
	
data a2;
input id add $;
datalines;
1 GGN,P91
2 GGN,P99
3 GGN;P91
;
run;
data a3;
input id add $;
datalines4;
1 GGN,P91
2 GGN,P99
3 GGN;P91
;;;;
run;
data a4;
input id add $;
cards4;
1 GGN,P91
2 GGN,P99
3 GGN;P91
;;;;
run;
************;



data x;
infile "C:\Users\RAJ\Desktop\hh.txt";
input id name$;
run;
******;

filename am "C:\Users\RAJ\Desktop\hh.txt" ;
data x1;
infile am;  *yaha humne ek am name ka folder bana liya h jisme ki txt file padi so hame baar baar path nahi dena padega;
input id name$;
run;



/* 1: Column pointers for flexible reading */
data raj;
input @1 name $7. @9 sex $1. @10 marks; *yaha @x is telling starting point $x. is telling length of value;
datalines;
rahul   M300
seema   F40
;
run;

/* 2. Column pointers for  reading in any : to change the sequence also */
data amit;
input @9 sex $1. @10 marks @1name $7.;
datalines;
amitkum M123
nanannn F32
;run;


/* 3.Column pointers: To keep any var */
data amit;
input  @9 sex $1. @1name $7.;
datalines;
amitkum M123
nanannn F32
;
run;
proc print data=amit;
run; 




/*1. Column pointer:  Pointer control or +n for jump */
data amit;
input @1name $7. +2 marks 3.;
datalines;
amitkum M123
nanannn F32
;
run;
proc print data=amit;
run; 

/* 2. Pointer control or -n for jump */
data amit;
input @1name $7. +2 marks 3. +(-4) sex$ 1. ;
datalines;
amitkum M123
nanannn F321
;
run;
proc print data=amit;
run;


data amit;
input name $ age building $;
datalines;
amit 23 castle 
preeti 24 suncty 
baba 56 kendriya
;
run;
proc print data=amit;
run;



****Double trailing @@: To read multiple values in a single line***;
data amit;
input name $ age building $ @@;
datalines;
amit 23 castle preeti 24 suncty baba 56 kendriya
;
run;
proc print data=amit;
run;
/********************************************************************/









								/*CLASS-44*/

/* Single @ or trailing is used to hold the line and conditional read data */
data amit;
input @1 gender $1. @; *jab condition lagani ho kisi column me to last me single @ laga k hold krk condition lagate h;
if gender = 'M' then delete;
input @3 age @5 marks;
datalines;
M 13 56
M 12 78
F 13 78
M 56 90
;
run;
proc print data=amit;
run;



data amit;
input name $ age / building  $ ; *yaha / use kiya kyuki bulding name niche h raw data me isliye;
datalines;
amit 23
jvt
preeti 24
devinder
;
run;
proc print data=amit;
run;



data amit;
input #3 marks #2 building $ city $ #1 name $ age ; *#3 line me marks and #2 line me building & city h and #1 line me name & age h;
datalines;
amit 23
jvt G
300
preeti 24
devinder G
900
;
run;
proc print data=amit;
run;





/*Missover concept*/
data amit;
input name $ age sex $; * sex ki value missing h second row me toh raw data ko galat read karega ;
datalines;
amit 23 M 
kaka 24 
Baba 25 M
Nana 34 M
;
run;
proc print data=amit;
run;

data amit;
input name $ age sex $;
infile datalines missover; 
datalines ;
amit 23 M 
kaka 24 
Baba 25 M
Nana 34 M
;
run;
proc print data=amit;
run;




data amit;
input name $ age sex $; 
datalines ;
amit 23 M 
kaka 
Baba 25 M
Nana 34 M
;
run;
proc print data=amit;
run;

/* dsd: delimeter sensitive data */
data x;
infile datalines dsd dlm ="," missover;
input name $ age  marks;
datalines;
a,12,23
b,,
,,57
;
run;

proc print data=x;
run;


/********************* Pass-Through in Oracle */

/* Preparing Dailer Data */
options compress=yes;   **to commpress the data soits reduce the size and transfer fast;
proc sql;
	connect to ODBC as con_1 (DATASRC=hive_prd authdomain=DB_Cloudera_Auth); **ODBC- Open Database connection;
		Create table adhoc4.az_Dialer_Dec AS			**creating table in permanent table (adhoc4) and dataset (az_Dialer_Dec) in the SAS library;
		Select * from connection to Con_1
		(
		select * from campaign_raw.csi_calldetail
		where starttime between to_date('2020-12-01') and to_date('2020-12-31')
		);
	Disconnect from con_1;
quit;
****************;



/*2. Connecting to teradata using pass through
Most efficient way
*/
proc sql;
connect to teradata(USERID="&userid." PASSWORD="&dbpass" TDpid=rchgrp2   MODE='Teradata');
create table work.acc_details as 
(
select acc_no, roll_no, sex, date, sales, city from mater_acc_details
where acc_no is not null and sales gt 40000
);
disconnect from teradata;
quit;



*********connect to DB2**;
Proc sql;
Connect to db2(  DATABASE=CRD_ PROD USER= “ &user_id.” PASSWORD=” &dbpass” MODE= "db2");
Create table work. Account_details as 
(
Select Account_ Number, Enroll_ Date, Sales , City From Master_ acct_ details
Where Account_ Number is not null and Sales gt 40000
);
Disconnect from db2;
quit;
*********************;






% let user_id = %sysget(USER);

231456


/*Update password to encrypt userid, PW and save to UNIX home directory*/
Filename pw “/home/sasuser/231456/pwfile”;
Proc  pwencode in= “amit” out=pwfile method =sas003;
Run;

Data _ null_ ;
Infile pw Truncover;
Input line: $50;
Call symputx('dbpass' ,line);
Run;
% put &dbpass;


*************
user_id : For id
dbpass : Encypted password



/*1st way : Libname statement with id and encrypted password

using the library assignments:; 
user_id : For id
dbpass : Encypted password */

Libname AMIT DB2 DATABASE= CARD_USA Schema=DDKAUTO USER=”&user_ id.” PASSWORD= “&dbpass”;

Proc sql;
Create table amit.Account_details as 
Select
Account_ Number, Enroll_ Date, Sales , City 
From AMIT.Master_ acct_ details
Where Account_ Number is not null and Sales gt 40000;
Quit;

/****************************************************************************/






								/* CLASS-17 */


data a;
do i=1 to 10;
date=put(i,date9.);
output;
end;
run;

data a;
input dob date9.;
format dob mmddyyc10.;
cards;
15jan2020
17jan2020
;
run;

data gg;
dat1='15jun2020'd;
dat2='20jun2020'd;
dif=intck("Day",dat1,dat2);
format dat1 dat2 date9.;
run;


data a;
input salary dollar7.2;
cards;
$100.00
;
run;





/*SQL: STRUCTURED QUERY LANGUAGE :
Proc SQL: It is the adaptation of SQL in SAS 

Selectt
From
Where
Group by
Having
Order by
*/


proc sql;
select* from sasuser.admit; *This whole syntax is called query;
quit;

proc print data=sasuser.admit; * This is the base SAS code exactly work same as above code.; 
run;

proc sql;
select (columns) from (Source: Table name); 
quit;


/*SAS & SQL same output*/

proc print data =sasuser.admit;
var id name;
run;
proc sql;
select id, name from sasuser.admit;
quit;




data a;
set sasuser.admit;
run;
proc sql;
create table a as select* from sasuser.admit;
quit;



data temp;
set sasuser.admit;
run;
proc sql;
create table temp as select* from sasuser.admit;
quit;



data a (keep=id name age);
set sasuser.admit;
run;
proc sql;
create table a as select id,name,age from sasuser.admit ;
quit;




data sasuser.temp(keep=id name age sex);
set sasuser.admit;
run;
proc sql;
create table sasuser.temp as select id,name,age,sex from sasuser.admit;
quit;





data a;
set xx;
run;
proc print data=a;
run;
proc sql;
create table b as select* from xx;
select* from b;
quit;





data a (drop=id name age);
set xx;
run;
data a;
set xx(drop=id name age); *efficient code take less time;
run;
proc sql;
create table a(drop=id name age) as select* from xx;
quit;
proc sql;
create table a as select* from xx (drop=id name age); *efficient code take less time;
quit;


/******************/
data a b c;
set sasuser.admit;
run;
proc sql;
create table a as select* from sasuser.admit;
create table b as select* from sasuser.admit;
create table c as select* from sasuser.admit;
quit;



data a(keep=id name age) b(drop=id name) c;
set sasuser.admit;
run;
proc sql;
create table a as select id,name,age from sasuser.admit;
create table b as select * from sasuser.admit (drop= id name age);
create table c as select* from sasuser.admit;
quit;



data a;
set xx (keep=id name age);
run;
proc sql;
create table a as select* from xx(keep=id name age);
run;



data temp;
set sasuser.admit;
where age gt 40;
run;
proc sql;
create table temp as select * from sasuser.admit 
where age gt 40;
quit;



data temp;
set sasuser.admit;
where age gt 40 and sex="M";
run;
proc sql;
create table temp as select* from sasuser.admit
where age gt 40 and sex="M";
quit;



data temp(keep=id age sex name);
set sasuser.admit;
where age gt 40 and sex="M";
run;
proc sql;
create table temp as select id,age,sex,name from xx 
where age gt 40 and sex="M";
quit;
/**************************************************************************/











								/* CLASS-18 */


ods pdf file="E:\raj\SAS\Amit_Sir_classes\ODS_files\admit.pdf";
proc sql;
title "this is proc sql report";
select* from sasuser.admit;
quit;
ods pdf close;


/*HOW TO CREATE A NEW VARIABLE*/
DATA A;
set sasuser.admit;
N_Var=age*12;
run;
proc sql;
create table a as select*,age*12 as N_Var from sasuser.admit;
quit;




data a;
set sasuser.admit;
N_age=age*12;
bmi=height/weight;
run;
proc sql;
create table a as select*, age*12 as N_age, height/weight as bmi from sasuser.admit;
quit;



proc sql;
create table b as select*,sex as gender from sasuser.admit; * here we are not edit the existing one, we just created new one(variable);
quit;





/*using Function in sql*/
data a;
set sasuser.admit;
first_name=scan(name,2,",");
last_name=scan(name,1,",");
run;

proc sql;
create table b as select*,scan(name,2,",") as first_name, scan(name,1,",") as last_name from sasuser.admit;
quit;


data a;
input reg$;
x=;
cards;
HR-3235
DL-1247
PB-7556
;
run;

*I need two new variables state and Plate_No.;
proc sql;
create table c as select*, scan(reg,1,"-") as state, scan(reg,2,"-") as Plate_No 
from a;
select* from c;
quit;


/*How to code 'if else and if' in proc sql*/
data a;
set sasuser.admit;
if sex="M" then gen="male";
else if sex="F" then gen="female";
run;

proc sql;
create table d as select*, 
case
when sex="M" then "Male"
when sex="F" then "Female"
end as gen
from sasuser.admit;
select* from d;
quit;


data x;
set sasuser.admit;
if sex="M" then gen="Male";
else gen="female";
run;
proc sql;
create table xx as select*,
case 
when sex="M" then "Male"
else "female"
end as gen
from sasuser.admit;
quit;




data temp;
set sasuser.admit;
if age > 40 then status=2;
else if age < 40 then status=1;
else status=0;

if sex="M" then gen="male";
else gen="female";
run;

proc sql;
create table temp2 as select*,
case
when age>40 then 2
when age<40 then 1
else 0
end as status,

case
when sex="M" then "Male"
else "female"
end as gen

from sasuser.admit;
quit;





***Summary functions***;
proc sql;
create table a as
select sum(fee) as total from sasuser.admit;
select avg(fee) as mean from sasuser.admit;
select max(fee) as max from sasuser.admit;
select min(fee) as min from sasuser.admit;
select count(fee) as cnt from sasuser.admit;
quit;


proc sql;
create table bb as
select sum(fee) as total, avg(fee) as mean, max(fee) as max, min(fee) as min, count(fee) as cnt 
from sasuser.admit;
quit;



***group by***;

proc sql;
create table hum as
select * from sasuser.admit;
quit;

proc sql;
select sex,count(*) as cnt from hum
group by sex;
quit;
*******same output by data step*****;
*This is the solution when we have to do groupping in data step(as we are doing in proc sql by :Group By);
data x;
set sasuser.admit;
run;
proc sort data=x out=x1;
by sex;
run;
data x2;
set x1 (keep=sex);
by sex;
if first.sex then cnt=1 ;
else cnt+1;
if last.sex then output ;
run;
proc print n noobs;
run;
**********************;
 
 
proc sql;
select sex, sum(fee) as total format=dollar10.2
from sasuser.admit 
group by sex;
quit;



data hum;
set sashelp.prdsale;
run;
options nolabel;
proc sql;
title "country wise counts";
select country, count(*) as country_count from hum 
group by country;
quit;


proc sql;
title "country wise CTC of employee";
select country, count(*) as count, sum(Actual) as expence format=dollar12.2 from hum
group by country;
quit;



data xx;
input reg $;
y=scan(reg,1);
cards;
HR-123
PB-234
HR-133
PB-254
Dl-321
;
run;

proc sql;
select y, count(*) as cnt from xx
group by y;
quit;


proc sql;
select actlevel,count(*) as cnt from sasuser.admit
group by actlevel;
quit;



proc sql;
select sex,count(*) as cnt from sasuser.admit
group by sex;
quit;


proc sql;
select sex, actlevel, count(*) as cnt from sasuser.admit
group by sex, actlevel;
quit;



options nolabel;
proc sql;
title "Country wise employee count";
select country,location,count(*) as count from sasuser.empdata 
group by country,location;
quit;
/*********************************************************************/











								/*CLASS-19*/


data a;
x=100;
y=200;
PC=put((y-x)/x,percent9.2);
run;



********* HOW TO APPLY FIRTER ON NEW VARIABLE;
proc sql;
create table w as
select*, age*12 as new_age from sasuser.admit
where new_age > 400 ; *error throw kr dega kyuki naye variable pe where work nahi karega;
quit;



****1 way*****;
proc sql;
create table r as select*,age*12 as N_age from sasuser.admit;

create table r1 as select* from r
where N_age >400 ;
quit;


****2 way******;
proc sql;
create table k as select*, age*12 as N_age from sasuser.admit 
where age*12 >400;
quit;


****3 way*****;
proc sql;
create table t as select*, age*12 as N_age from sasuser.admit 
where calculated N_age > 400;
quit;


****4 Way(Inline view)****;

proc sql;
create table p as select* from
(
select*, age*12 as N_age from sasuser.admit
)
where age*12 > 400;
quit;



data a;
set sasuser.admit;
run;
proc sql;
select*from
(select*,age*12 as N_age from a)
where N_age > 400;
quit;
/**********************************/



****How many people in sasuser.admit have age above 40: only use inline view;
proc sql;
select count(*) as cnt from        *without createing any table get the output;
(select* from sasuser.admit
where age > 40);
quit;


****How many people in sasuser.admit have actlevel either HIGH or LOW;
proc sql;
select count(*) as cnt from
( 
select* from sasuser.admit
where lowcase(actlevel) in ("high","low")
);
quit;


****pehle age gt 40 ka data lao usek bad usme se males nikalo;
proc sql;
select*  from 
(
select* from sasuser.admit
where age>40
)
where sex="M";
quit;





****pehle age gt 40 ka data lao usek bad usme se males nikalo phir jiski fee >130 h wo nikalo;
proc sql;
select* from
(
select*from
(
select * from sasuser.admit
where age>40
)
where sex="M"
)
where fee>130;

quit;



***********I need all people from s.a which have max age***********;
proc sql; *ERROR: Summary functions are restricted to the SELECT and HAVING clauses only.
          (we can't use summary function with where so we use SUB QUERRY here to resolve this issue);
select*from sasuser.admit    
where age=max(age); *yaha where k saath summary function nahi lagta toh hum select me lagayege;  
quit;


proc sql; *yaha humne select k saath summary function laga k max value nikal li age ki magar sirf value only;
select max(age) from sasuser.admit;
quit;

proc sql;
select* from sasuser.admit 
where age=60;        *or agar aise kare tho age ki value hardcoded ho jaegi;
quit;

******SUBQUERRY KA JANAM;
proc sql;
select* from sasuser.admit 
where age=(select max(age) from sasuser.admit); *upper ki problems ko takel krrne k liye aata h subquerry yaha max age ki puri row mil jaegi;
quit;
***** The first difference is that inline views can contain multiple columns, while subqueries (in the Oracle meaning)
     should return only one. The reason is simple – an inline view works like a table and tables can contain more than 
     one column. Subqueries, on the other hand, generally work as a single value.****;
     
 
 
 
*****This gives only the value not the whole row :from inline view as well;
proc sql;
select max(age) from 
(select* from sasuser.admit);
quit;


***** I need people whose age is above average age****;
proc sql;
select * from sasuser.admit 
where age>(select avg(age) from sasuser.admit);
quit;

proc sql;
select avg(age) from sasuser.admit;
quit;




data a;
input empid tenure;
cards;
1 12
2 12
3 10
4 2
5 10
6 10
7 7
;
run;
** I need people with tenure more than avg tenure;
proc sql;
select * from a where tenure gt (select avg(tenure) from a);
quit;


proc sql;
select count(*) as employee_above_avgTenure from 
(
select* from a
 where tenure > (select avg(tenure) from a )
 );
quit;


data a;
input empid tenure city$;
cards;
1 12 G
2 12 G
3 10 N
4 2 G
5 10 N
6 10 N
7 7 N
;
run;
** I need employee above the average tenure (senior) who live in Gurgaon;

proc sql;
select * from a where tenure gt (select avg(tenure) from a) and city="G";
quit;


proc sql;   *ye lengthy process h k pehle avg tenure nikala fir dusare me usnka city G nikala ;
select*  from 
(
select* from a
where tenure > (select avg(tenure) from a)
)
where city="G";
quit;
/********************************************************************/










							
							/* CLASS-20 */

proc sql;
select* from sasuser.admit 
where age=max(age);    *Here summary funtion is used in where which we can't use so, here use sub querry;
quit;

proc sql;
select*from sasuser.admit
where age=(select max(age) from sasuser.admit);
quit;

*******I need salary of employee who work in Travel team**********;
data gl; 
input id sal;
cards;
1 100
2 200
3 300
4 500
;
run;
data travel;
input id;
cards;
1
2
;
run;

proc sql;
select* from gl
where id in (select id from travel);
quit;

proc sql;
select* from gl
where id Not in (select id from travel);
quit;






data a;
input age;
cards;
30
40
50
;
run;

***I need all rows from S.A whose age is gt the average age of data a;
*solution: phele avg age nikal lo phir usme gt avg age laga do ;

proc sql;        *1 Step;
select avg(age) from a;
quit;


proc sql;                  *2 Step;
select* from sasuser.admit
where age >(select avg(age) from a);
quit;





data a;
input age;
cards;
30
40
50
;
run;
***I need all rows from S.A whose age is gt the average age of data a and all male;
proc sql;
select avg(age) from a;
quit;

proc sql;
select* from sasuser.admit
where age gt (select avg(age) from a) and sex="M";
quit;







data all;
input id spend;
cards;
1 100
2 200
3 300
4 400
5 500
;
run;
data jan;
input id;
cards;
1
2 
;run;
data feb;
input id;
cards;
1
2
3 
;run;
*I need spend data from customers who are active in jan and feb;
proc sql;
select* from all
where id in (select id from jan) and id in (select id from feb);

quit;








data all;
input id spend;
cards;
1 100
2 200
3 300
4 400
5 500
;
run;
data jan;
input id;
cards;
1
2 
;run;
data feb;
input id;
cards;
1
2
3 
;run;
*I need spend data from customers who are NOT active in jan and active feb;
proc sql;
select* from all 
where id not in (select id from jan) and id in (select id from feb);
quit;







*I need spend data from customers who are NOT active at all;
data all;
input id spend;
cards;
1 100
2 200
3 300
4 400
5 500
;
run;
data jan;
input id;
cards;
1
2 
;run;
data feb;
input id;
cards;
1
2
3 
;run;

proc sql;
select* from all
where id not in (select * from jan ) and id not in (select * from feb);
quit;





data a;
input age;
cards;
30
40
50
;
run;

/*
age	flag
34   0
56   1 
*/

proc sql;
select*,
case
when age gt (select avg(age) from a) then 1
when age LE (select avg(age) from a) then 0
end as flag
from sasuser.admit;
quit;
***if we count the above flaged persons whose age is gt then avg(age) ;
proc sql;
select flag,count(flag) as cnt from 
(
select*,
case
when age gt (select avg(age) from a) then 1
when age LE (select avg(age) from a) then 0
end as flag
from sasuser.admit
)
group by flag;
quit;



** how we find the percentage change ;
option nolable;
proc sql;
select*,fee/sum(fee) as pc format=percent9.2 from sasuser.admit;
quit;


proc sql;
select*, count/sum(count) as ps format=9.2 from
(
select country, count(*) as count from sasuser.empdata
group by country
)
;
quit;



*** I need the percentage count country and Location wise**********;
proc sql;
select *,count/sum(count) as ps format=percent9.2 from
(
select country,location,count(*) as count from sasuser.empdata 
group by country,location
);
quit;





/*
Audi Sedan 4 
Audi Suv 5
Audi Sport 13
*/
********Find Maximum percentage shear of SEDAN****;
proc sql;
create table car as select*, cnt/sum(cnt) as percentage_shear_sedan format=percent9.2, sum(cnt) as total_sedan from
(
select make, type,  count(*) as cnt from sashelp.cars
where type="Sedan"
group by make,type
)
;
select* from car where percentage_shear_sedan=(select max(percentage_shear_sedan) from car);
quit;

**********another way*****;
proc sql;
create table ty as select*, cnt/sum(cnt) as p_cnt format=percent10.2, sum(cnt) as total_cnt from(
select make,type,count(type) as cnt from sasuser.cars
where type="Sedan"
group by make,type)
;
select* from ty
where p_cnt=(select max(p_cnt) from ty);
quit;

/*********************************************************************************/










								/* CLASS-21 */


***having: It applies filter on groups:  Group : group by : summary fxn; 
proc sql;
select actlevel, count(*) as cnt from sasuser.admit group by actlevel
having lowcase(actlevel) in ("high" "low");
quit;

******NOTE: Where: applies filter on rows.. and having: filter on groups:;



*** Having behave like where if we dnt use group by and summar fxn;
proc sql;
select* from sasuser.admit having age gt 40;
quit;

proc sql;
select*from sasuser.admit having age=max(age); *here, age=max(age) summary function it won't work with where but with having it works;
quit;



***I need state wise coustomer count from frequentflyer table***;
proc sql;
select state, count(*) as cnt from frequentflyers group by state;
quit;

***I need state wise type wise coustomer count***;
proc sql;
select state,membertype, count(*) as cnt from sasuser.frequentflyers group by state,membertype;
quit;


***I need state wise type wise coustomer count whose not used any point***;
proc sql;
select state,membertype, count(*) as cnt from sasuser.frequentflyers 
where pointused eq 0
group by state,membertype;
quit;


proc sql;
select state,membertype, count(*) as cnt from sasuser.frequentflyers 
where pointused eq 0
group by state,membertype
having cnt gt 1;
quit;


* Please tell me students who made more than 1 attempt;
* Picking duplicates;
data students;
input id marks;
cards;
1 20
1 30
1 40
2 40
3 30
3 40
;
run;
proc sql;
select id, count(*)as cnt from students group by id 
having cnt gt 1;
quit;

proc sql;
select id, count(*)as cnt from students group by id 
having cnt = 1;
quit;


* I need the customers who have made more than 1  transaction on Electronics;
data cust;
input id spend type$;
cards;
1 200 Elec
1 300 Elec
1 400 Groc
2 400 Groc
2 300 Elec
3 300 Groc
3 400 Elec
3 500 Elec
;
run;
proc sql;
select id,type, count(*) as cnt from cust where type="Elec"  group by id
having  cnt gt 1 ;
quit;

proc sql; * this code done by sir;  *This is best according to as well;
select *, count(id) as cnt from cust  where type="Elec" group by id
having cnt gt 1;
quit;




**order by: to sort the data: proc sort;

proc sql;
select * from sasuser.admit order by age;
select * from sasuser.admit order by sex;
select * from sasuser.admit order by sex,actlevel;

select * from sasuser.admit order by age desc;
select * from sasuser.admit order by sex desc,actlevel;
select * from sasuser.admit order by sex desc,actlevel desc;

select * from sasuser.admit order by 3;
select * from sasuser.admit order by 3,2;
select id,sex,fee,name from sasuser.admit order by 3;

select * from sasuser.admit order by 3 desc;
quit;


proc sql;
select * from sasuser.mechanics;
quit;
 

proc sql;
select* from sasuser.mechanics order by 8;
quit;

proc sql;
select* from sasuser.mechanics order by 6desc,5;
quit;



proc sql;
select country,count(*) as cnt from sasuser.empdata 
where country in ("USA" "CANADA") 
group by country
having cnt gt 1 order by country desc;
quit;



***where operators********;

proc sql;
select * from sasuser.admit where age gt 40;
select * from sasuser.admit where age lt 40;
select * from sasuser.admit where age ge 40;
select * from sasuser.admit where age le 40;
select * from sasuser.admit where age eq 40;

select * from sasuser.admit where actlevel in ("HIGH" ,"LOW");
select * from sasuser.admit where actlevel not in ("HIGH" ,"LOW");

select * from sasuser.admit where actlevel between 20 and 50;

select * from sasuser.admit where name contain "O";
select * from sasuser.admit where name ? "y";


select * from sasuser.admit where name like "M%";
select * from sasuser.admit where name like "%M";
select * from sasuser.admit where name like "%m%";

quit;



data a;
input name $;
cards;
eno
neo
nee
aba
;
run;
proc sql;
select * from a where name like "%e%";
quit;


proc sql;
select *, monotonic() as seq_NO from sasuser.admit ;
quit;

proc sql;
select*, monotonic () as  seq_no from sasuser.admit 
having seq_no gt 7;
quit;
proc sql;
select*, monotonic () as  seq_no from sasuser.admit 
where calculated seq_no gt 7;
quit;


proc sql;
select*, monotonic () as seq_no from sasuser.admit
having seq_no =max(seq_no);
quit;

proc sql;
select*, monotonic () as seq_no from sasuser.admit 
having seq_no between 10 and 17;
quit;

proc sql;
select*, monotonic () as seq_no from sasuser.admit 
having Age between 30 and 50; *sequencing done after the having condition applied;
quit;





data a;
set sasuser.admit;
L=length(name);
run;
proc print;
run;


data b;
name="amit ";
run;

proc sql;
select* from b where compress(name) like "%t";
quit;

proc sql;
select* from b where name like "%t";
quit;


proc sql inobs=5; * it gives us starting 5 observations; **this is using in proc sql;
select* from sasuser.admit;
quit;
/*************************************************************************/








								/* CLASS-35 */


/*SQL Join: Base sas merge ... vlookup  */

data a;
input id;
cards;
1
2
3
;
run;

data b;
input id;
cards;
1
2
3
4
;run;
proc sql;
select * from a,b;
quit;

*if we want the dataset of the same as above;
proc sql;
create table x as select * from a,b; *it will not create dataset coz in one dataset two variable name is not possible ;
quit;
	
*to counter the same variable name;
proc sql;
create table x1 as select a.id, b.id as cid from a,b;
quit;




data a;
input id name $;
cards;
1 A
2 B
;
run;
data b;
input id salary;
cards;
1 100
2 200
;
run;
proc sql;
select a.id,a.name,b.salary from a,b;
quit;
*we can also write it like that;
proc sql;
select a.id,name,salary from a,b;
quit;






data a;
input id name $;
cards;
1 A
2 B
;
run;
data b;
input id salary;
cards;
1 100
7 200
;
run;
data c;
input id city $;
cards;
1 G
7 N
;
run;
*here we have to do simple join of three tables;
proc sql;
select a.*,salary,city from a,b,c 
where a.id=b.id=c.id;
quit;

*here we want some change in G as gurgaon and N as noida in city of output table;
proc sql;
select a.*,salary,case
when city="G" then "gurgaon"
when city="N" then "noida"
end as city

from a,b,c where a.id=b.id=c.id ;
quit;






data a;
input id des $ city $;
cards;
1 vp G
2 vp G
3 vp N
4 vp N
;
run;
data b;
input id dept $;
cards;
1 IT
2 IT
3 HR
4 IT
;
run;
*we have to find dept wise designation count;
proc sql;
select dept,des, count(des) as cnt from a,b 
where a.id=b.id
group by dept,des;
quit;

proc sql;
select dept,des, count(*) as cnt from a,b 
where a.id=b.id
group by dept,des;
quit;
/***********************************************************/










								/* class-36 */


/*Left Join*/
data a;
input id name $;
cards;
1 A
2 B
;
run;

data b;
input id sal;
cards;
1 100
2 200
3 300
;
run;
proc sql;
select a.*,b.sal from a left join b 
on a.id=b.id;
quit;



/*Find the total expens of aug month from cc(credit card) wise*/
proc import out=cust_info datafile="C:\Users\RAJ\Desktop\cust.xls" dbms=excel replace;
		  sheet="cust_info";
		  getnames=yes;		
run;
proc import out=limit datafile="C:\Users\RAJ\Desktop\cust.xls" dbms=excel replace;
		  sheet="limit";
		  getnames=yes;		
run;
proc import out=aug_spend datafile="C:\Users\RAJ\Desktop\cust.xls" dbms=excel replace;
		  sheet="aug_spend";
		  getnames=yes;		
run;

proc sql;
create table aug as select cc, sum(swipe_amount) as total format=dollar9.2 from aug_spend
group by cc;
quit;

proc sql;
select aug.*,name,city,monthly_limit format=dollar15.2 from aug left join cust_info
on aug.cc=cust_info.cc left join limit
on aug.cc=limit.cc;
quit;



*other way;
libname king "C:\Users\RAJ\Desktop\cust.xls";
proc sql;
create table king.aug as
select cc,sum(swipe_amount)  format=dollar9.2 as total from king.'aug_spend$'n
group by cc;
quit;

libname king clear;






proc import out=cust_info datafile="C:\Users\RAJ\Desktop\cust.xls" dbms=excel replace;
		  sheet="cust_info";
		  getnames=yes;		
run;
proc import out=limit datafile="C:\Users\RAJ\Desktop\cust.xls" dbms=excel replace;
		  sheet="limit";
		  getnames=yes;		
run;
proc import out=aug_spend datafile="C:\Users\RAJ\Desktop\cust.xls" dbms=excel replace;
		  sheet="aug_spend";
		  getnames=yes;		
run;
*here we have to find balance_limit of customer augest month;
proc sql;
select aug.*,name,city,monthly_limit format=dollar13.2,
monthly_limit-total as balance_limit format=dollar13.2
from
		(select cc,sum(swipe_amount) format=dollar9.2 as total,count(*)
		as cnt from aug_spend
		group by cc
		) as aug

left join cust_info 
on aug.cc=cust_info.cc left join limit 
on aug.cc=limit.cc;
quit;


*doing same thing as above on my style;
proc sql;
create table aug as
select cc,sum(swipe_amount) as total format=dollar15.2,count(*) as no_trans from aug_spend
group by cc
;
quit;
proc sql;
create table xxj as
select aug.*,name,city,monthly_limit format=dollar15.2,monthly_limit-total as balance_limit format=dollar15.2
from aug left join cust_info
on aug.cc=cust_info.cc left join limit
on aug.cc=limit.cc;
quit;
 


proc sql;
create table xx as
select aug.*,name,city,monthly_limit format=dollar15.2,monthly_limit-total as balance_limit format=dollar15.2
from 
(select cc,sum(swipe_amount) as total format=dollar15.2,count(*) as no_trans from aug_spend
group by cc) as 
aug left join cust_info
on aug.cc=cust_info.cc left join limit
on aug.cc=limit.cc;
quit;






/* Payment Reversal Tracking (PRT) */
/*City wise how many transaction are reversed and amount and loss */
proc import out=cust_info datafile="C:\Users\RAJ\Desktop\cust.xls" dbms=excel replace;
		  sheet="cust_info";
		  getnames=yes;		
run;
proc import out=limit datafile="C:\Users\RAJ\Desktop\cust.xls" dbms=excel replace;
		  sheet="limit";
		  getnames=yes;		
run;
proc import out=aug_spend datafile="C:\Users\RAJ\Desktop\cust.xls" dbms=excel replace;
		  sheet="aug_spend";
		  getnames=yes;		
run;
*find citywise count of revesal and %loss of merchant due to reversal of transation; 

proc sql;
select city,sum(count) as count,sum(total)as total_sale format=dollar9.2,
sum(loss) as loss_dollar format=dollar9.2 from
(
select city,count,total,total*.02 as loss format=dollar9.2  from

(select cc,sum(swipe_amount) format=dollar9.2 as total,count(*) 
	as count from aug_spend where reversal=1 group by cc
) aug left join cust_info on aug.cc=cust_info.cc
)group by city
;
quit;

*this is my way to solve above problem;
proc sql;
create table aug as select cc,sum(swipe_amount) as total format=dollar15.2, count(*) as cnt from aug_spend
where reversal =1
group by cc;
quit;

proc sql;
 select *, s_total*.02 as loss_dollar format=dollar15.2 from
(
select city,sum(cnt) as s_cnt,sum(total) as s_total  from aug left join cust_info
on aug.cc=cust_info.cc 
group by city
);
quit;


*first i solved it with 2 step then arrange it on 1 step;
proc sql;
 select *, s_total*.02 as loss_dollar format=dollar15.2 from
(
select city,sum(cnt) as s_cnt,sum(total) as s_total  from 
(
select cc,sum(swipe_amount) as total format=dollar15.2, count(*) as cnt from aug_spend
where reversal =1
group by cc
) as aug left join cust_info
on aug.cc=cust_info.cc 
group by city
);
quit;















                         		/*CLASS-37*/

*Right Join: it is similar as left join but the driver table is right table;




/*Full Join: */
data a;
input id name$;
cards;
1 A
2 B
3 C
;
run;

data b;
input id sal;
cards;
1 100
2 200
7 300
;
run;
proc sql;
select a.*,b.* from a full join b
on a.id=b.id; *here the id are not overwrited coz sql never overwrite data so we use coalesce to resolve this issue;
quit;

proc sql;
select coalesce(a.id,b.id) as id,name, sal from a full join b
on a.id=b.id;
quit;

/* what are the advantages of sql joins */

*1. No need of sorting ;

*2. No need of rename;

*3. never overwrite the data(observations);

/*
data a;
input id name$;
cards;
1 A
2 B
3 C
;
run;

data b;
input pid sal;
cards;
1 100
2 200
7 300
;
run;
proc sql;
select coalesce(a.id,b.id) as id,sal,name from a full join b 
on a.id=b.pid;
quit;
*/




*3. It never overwrite data;
data a;
input id name$ sal;
cards;
1 A 900
2 B 1900
3 C 1800
;
run;

data b;
input id sal;
cards;
1 100
2 200
7 300
;
run;
proc sql;
select coalesce(a.id,b.id) as id,name,b.sal from a full join b
on a.id=b.id;
quit;

proc sql;
select coalesce(a.id,b.id) as id,name,coalesce(a.sal,b.sal) as salary from a full join b
on a.id=b.id; *basically if 1 dataset have no value of same variable then its fill the 2 dataset observation due to coalesce;
quit;







/*Self Join*/

data emp;
input emp$ mgr $;
cards;
Amit Aish
Aish Manish
June Dong
Dong Kiran
;
run;
proc sql;
select a.*,b.mgr from emp as a inner join emp as b 
on a.mgr=b.emp;
quit;



data emp;
input emp$ mgr $;
cards;
Am Ai
Ai Ma
Ma Ta
Ju De
De Kr
Kr Ha
;
run;
proc sql;
select a.*,b.mgr as smgr,c.mgr as AVP from emp as a inner join emp as b
on a.mgr=b.emp  inner join emp as c
on b.mgr=c.emp;
quit;

*we can also do it like below code;
proc sql;
select a.*,b.mgr as smgr,c.mgr as Avp from emp a,emp b,emp c
where a.mgr=b.emp and b.mgr=c.emp;
quit;
****************************************************************;







							/* CLASS-38 */

/*Query Operator and views*/
data jan;
input cc;
cards;
1
2
3
;
run;
data feb;
input cc;
cards;
1
2
4
5
;
run;
*Find those customer who are active in jan and feb as well;
proc sql;*this will give us intersection/inner join/common part of two table;  
Title "Loyal customer 'those who active in both month jan & fab'";
select* from jan intersect select* from feb;
quit;


*now find those customer who was active in jan but left in feb month;
proc sql;
Title "Attrition of customer 'Left Customer or Left join in two tables'";
select * from jan except select* from feb;
quit;

*now find those customer who are active only in feb or we can say new customer added in feb;
proc sql;
Title "New customer 'added in feb month only or right join'";
select* from feb except select* from jan;
quit;




*Append by interleving;
data jan;
input cc amount;
cards;
1 100
2 100
3 300
3 300
;
run;
data feb;
input cc amount;
cards;
1 1200
2 220
;
run;
/*Removing duplicate and then Append data*/
proc sql;
Title "Appending the data after the removing duplicate";
select* from jan union select* from feb;*it append the data in sorted form and remove duplicates;
quit;

proc  sql;
Title "Append the data but unsorted manner";
select* from jan union all select* from feb;*it append 2nd dataser below the 1st dataset and unsorted manner; 
quit;



data jan;
input cc amount;
cards;
1 100
2 100
3 300
3 300
;
run;
data feb;
input cc amount;
cards;
1 1200
2 220
;
run;
data raj;
set jan feb;*it append the data but unsorted manner;
run;

data raj1;
set jan feb;
by cc;*it append the data and it also sorted the data;
run;


****Append when the variable of second table is not same;
data jan;
input cc amount;
cards;
1 100
2 100
3 300
3 300
;
run;
data feb;
input cc salary;
cards;
1 120000
2 220000
;
run;
proc sql;
select coalesce(cc,cc1) as cc, amount, salary from
(
select jan.cc, amount from jan outer union select feb.cc as cc1, salary from feb
);
quit;

proc sql;
select jan.cc, amount from jan outer union select feb.cc as cc1, salary from feb;
quit;



*****Append when no of variable is more then 1 dataset and diffrent;
data jan;
input cc amount;
cards;
1 100
2 100
3 300
3 300
;
run;
data feb;
input cc amount age;
cards;
1 120000 23
2 220000 35
;
run;

proc sql;
select* from jan union corr all select* from feb;*it gives output of corresponding variables (age variable not come);
quit;
/*
all>> duplicates removal
corr >> corresponding variables
outer >> for outer union
*/


/*NATURAL JOIN*/
data jan;
input cc amount;
cards;
1 100
2 100
3 300
3 300
;
run;
data feb;
input cc salary age;
cards;
1 120000 23
2 220000 35
;
run;
/*
jan-100 variables
feb-200 variables and you dnt know the key
*/
proc sql;
select jan.*,salary,age from jan natural join feb;
quit;
*Natural join gives the output as inner join so we also call it similar as inner join, but we are using NATURAL JOIN at 
that time when we DON'T KNOW the primary key; 




***when the two variables are common in both the tables;
data jan;
input cc amount age;
cards;
1 100 23
2 100 14
3 300 12
3 300 12
;
run;
data feb;
input cc salary age;
cards;
1 120000 23
2 220000 35
;
run;
/*
jan.cc=feb.cc and jan.age=feb.age
*/
proc sql;
select jan.*,salary,age from jan natural join feb;
quit;



*****When nothing is comman variable b/w both the tables;
data jan;
input cc1 amount age1;
cards;
1 100 23
2 100 14
3 300 12
3 300 12
;
run;
data feb;
input cc salary age;
cards;
1 120000 23
2 220000 35
;
run;
/*
Nothing is common : Cartesian
*/
proc sql;
select jan.*,salary,age from jan natural join feb;
quit;





/* Views: Virtual tables or imaginary tables*/
proc sql;
create table a as select* from sasuser.admit;
quit;

proc sql;
create view b as select* from sasuser.admit;*its store query not data;
quit;

proc sql;
describe table a;
quit;

/* A view does not store data: it stores a compiled query
It collects data at run time
NOTE: SQL view WORK.B is defined as:

        select *
          from SASUSER.ADMIT;

quit;
*/

proc sql;
describe view b ;
quit;

data c;
set b;
run; /* 1. less space 2. Always fresh data */

/************************************************************/









							/* CLASS-39 */

***1. Creating Table using query;
proc sql;
create table a as select* from sasuser.admit;
quit;

***2. Creating Table: empty using like;
proc sql;
create table b like sasuser.admit;
quit;

data c;
set sasuser.admit;
if 1=0;
run;

***3.Column definition ;
proc sql;
create table temp 
(
name char, sex char(2),
age num 'age of subject'
);
quit;

proc sql;
describe table sasuser.admit;
quit;

proc sql;
describe table temp ;
quit;

*1. How to Insert rows in an existing table;
proc sql;
create table temp as select* from sasuser.admit (keep=age sex name);
quit;
proc sql;
insert into temp
set name='amit',
	age=39,
	sex="M"
				/*No comma and semicolon while starting the description of the new variable*/
set name="raj",
	age=29,
	sex="M"

;
quit;

*2. Insert using values;
proc sql;
create table temp1 as select * from sasuser.admit(keep=id name sex age);
quit;

proc sql;
insert into temp1
value ("4567","raj","M",29)
value ("7890","kanchan","F",21);
quit;

*3. Insert using a query;
proc sql;
create table ranjeet like sasuser.admit;
quit;
proc sql;
insert into ranjeet
select * from sasuser.admit where age gt 40;
quit;

proc sql;
insert into master_employee
select * from temp where doj=today();
quit;


***How to update the rows;
proc sql;
create table king as select* from sasuser.admit ;
quit;
proc sql;
update king 
set age=age*2;
quit;

proc sql;
update king
set age=age+2,
	height=height*10,
	actlevel=substr(actlevel,1,2),
	name=scan(name,2,","),
	fee=fee+10;
quit;

proc sql;
update king
set name=cats(scan(name,2,","),",",scan(name,1,","));*its change the letter position from first name to last name or viseversa;
quit;



**2. Conditional update for diff values;
proc sql;
create table raj as select* from sasuser.admit;
quit;
proc sql;
update raj
set age=age*
	case when actlevel="HIGH" then 1.2
		 when actlevel="MOD" then 2
		 when actlevel="LOW" then 3.5
		 else 1
		 end;
quit;



/*
ratings 
1 >> 8%
2 >> 6%
3 >> 5%
4 >> same
*/
data a;
input name $ ctc rating;
cards;
A 15 1
B 12 2
C 16 3
D 26 4
;
run;

proc sql;
update a
set ctc=ctc*
case when rating=1 then 1.08
	 when rating=2 then 1.06
	 when rating=3 then 1.05
	 
	 else 1
	 end;
quit;


*Deleting rows;
proc sql;
create table raj as select* from sasuser.admit;
quit;

proc sql;
delete from raj where sex eq "M";
quit;

proc sql;
delete from raj where sex eq "M" and age gt 30;*here 'and' is used so both the condition satisfy then code will excute;
quit;

proc sql;
delete from raj where sex eq "M" or age gt 30;
quit;


*Deleting all rows for the deletion;
proc sql;
delete from raj;
quit;



*******Deletig table or Tables;
proc sql;
drop table raj;
quit;


*******Deletig multiple Tables;
data a b c;
set sasuser.admit;
run;
proc sql;
drop table a,b,c;
quit;



**How you validate the syntax of query;
proc sql;
validate select name ,age from sasuser.admit;
quit;


/* 2 No exec is for not executing the query and cjecking syntax*/
proc sql noexec;
select name, age from sasuser.admit;
quit;
 
/* 3. How to check in base sas if the code is correct*/
data _Null_;
set sasuser.admit;
if age gt 40;
run;

proc sql;
create table raj as select* from sasuser.admit;
quit;


proc sql;
alter table raj
drop age ;
quit;

proc sql;
create table test as select *, age*12 as age_m from sasuser.admit;
quit;

**********;
proc sql;                                                                                                                               
create table hum as select * from sasuser.admit;                                                                                      
quit;

proc sql;
alter table hum
add newage num label="new age of the patients"
add newheight num label="new heights in inches";
quit;
/**************************************************************/







								/* CLASS-22 */

%let a=New_dataset;
%let lib=sasuser.admit;

data &a;
set &lib;
run;
proc print data=&a;
Title "This document is copy of &lib with new name &a";
run;



%let a=new_dataser2;
%let lib=sasuser.admit;
%let var=age;
%let val=40;

data &a;
set &lib;
where &var gt &val;
run;
proc print data=&a;
title "person whose &var gt &val from &lib";
run;
/*same code with sql*/
%let a=new_data3;
%let lib=sasuser.admit;
%let var=age;
%let val=50;

proc sql;
create table &a as select* from &lib where &var gt &val;
select* from &a;
quit;


%let a=hurr;
&a;


%macro new_dat;
data a;
set sasuser.admit;
run;
%mend new_dat;

%new_dat;


/*************/

%macro hanji(ds=, lib=);
data &ds;
set &lib;
run;

%mend hanji;

%hanji(ds=kuku, lib=sasuser.admit);

%hanji(ds=chucha, lib=sashelp.class);
/*
I have created a macro or automated code that ask for 2 arguments
what need to be created and source table name
*/


%macro bhenji(ds=,lib=);  * second way of creatying macro variables;
proc sql;
create table &ds as select* from &lib ;
quit;

%mend bhenji;

%bhenji(ds=ali, lib=sasuser.admit);



/*
Create a macro that create any dataset from any dataset
and also can sort by any variable

1. Kuch bhi ban jaye
2. Kisi se bhi
3. kisi bhi var se sort kar pau

a >> sasuser.admit se and sort by sex
*/
%macro king(ds=, lib=, var=);
data &ds;
set &lib;
run;
proc sort data = &ds;
by &var;
run;
%mend king;

%king(ds=new_data, lib=sasuser.admit, var=sex);


%macro ring(ds=,lib=,var=);
proc sort data=&lib    out=&ds;  
by &var;
run;
%mend ring;

%ring(ds=new_data2, lib=sasuser.admit, var= sex);

%ring(ds=new_data3, lib=sasuser.admit, var=decending age);



*with proc sql;
%macro ching(ds=, lib=, var=);
proc sql;
create table &ds as select* from &lib order by &var;
quit;
%mend ching;

%ching(ds=hell, lib=sasuser.admit, var=sex);

%ching(ds=hell1, lib=sasuser.admit, var=sex desc);


/********************************************************/










								/*CLASS-23*/

%macro a; * Start Macro;        |
                                |
%let a=amit;                    | 
data &a;                        |
set sasuser.admit;       		| *COMPLIING MACRO;
run;							|
								|
%mend a; *End Macro;            | 



%a; *Call Macro;                | *CALLING MACRO;

*****************************;

/*
Macros: Tools for performing automation
Macro variables: Variables that are used in macros
They store data as text

7 ways to create the Macro variables

2ways we have studied: 1. %let
2. Passing parameters to macro

Trigger to macro var: &
*/


%let a=amit;
data &a;   * & is trigger so &a ke jagah amit aa jayega;
set sasuser.admit;
run;


data b&a;  * here a dataset going to create as a name of 'bamit' from sasuser.admit;
set sasuser.admit;
run;

data raj_&a; * here dataset created as raj_admit from sasuser.admit;
set sasuser.admit;
run;

data YoYo&a; * here dataset created as Yoyoamit from sasuser.admit;
set sasuser.admit;
run;


data &aabh; * here it will throw an error bcoz &aabh name of macro variable not created: we only created %let a=admit: so we use 'dot' after macro variable name;
set sasuser.admit;
run;

data &a.abh; *now its gives us dataset amitabh from sasuser.admit;
set sasuser.admit;
run;
/**********************/


%macro Report(file=,type=);

ods &type file="E:\raj\SAS\Amit_Sir_classes\ODS_files\&file..&type"; * this code is basically for 'dot' concept;

proc sql;
select* from sasuser.admit;
quit;

ods &type close;

%mend Report;

%Report(file=raj070620 , type=html );

%Report(file=ranjeet070620, type=pdf); * here i can generate diff file with only changing the file name and file type ;

%Report(file=Anshu070620, type=rtf);

/*&file.&type >> newhtml  >> new.html*/



%macro loopy(n= );
%do i=1 %to &n;    * The counter variable i becomes macro var;

data raj&i;
set sasuser.admit;
run;

%end;

%mend loopy;

%loopy(n=7 );

********************;

%macro loppy(n=);

%do i=1 %to &n;   * The counter variable i becomes macro var;
data a&i.&i.;
set sasuser.admit;
run;

%end;
%mend loppy;

%loppy(n=5);


%macro loopy(n=);
%do i=1 %to &n;      * The counter variable i becomes macro var;

	%do j=1 %to 3;
	data x&j.&i.;
	set sasuser.admit;
	run;
	%end;

%end;

%mend loopy;

%loopy(n=5);


/* S.A se 3 dataset bana do.. HIGH LOW MOD... High me high wale chale jai */

%macro data_H_M_L( );
	%let a=HIGH@MOD@LOW;

%do i=1 %to 3;                * The counter variable i becomes macro var;
	%let c=%scan(&a,&i,"@");
		data &c;
		set sasuser.admit;
		where actlevel= "&c";
		run;

%end;
%mend data_H_M_L;

%data_H_M_L ();






/* S.A se 3 dataset bana do.. HIGH LOW MOD... High me high wale chale jai */

%macro awsm();

%let gender=F@M@N;

%do i=1 %to 3;

%let ge=%scan(&gender,&i,"@");

data &ge;
set sasuser.admit;
where sex="&ge";
run;
PROC EXPORT DATA=&ge  OUTFILE= "C:\Users\ami13\Desktop\gender.XLS" DBMS=EXCEL REPLACE;
     SHEET="&ge"; 
RUN;

%end;

%mend awsm;

%awsm();
/***************************************************************************/








								/* CLASS-24 */

/*
Macro: Tools/utilities for performing automation
Macro variables: Store data as text

Macro variables: 7 ways

1. %let
2. Parameters
3. Do loop
*/

%macro a;


Base sas code or Proc sql code


%mend a;

%a;





%macro a;

%let gen=M@F;  * Hardcoding 1;

%do i=1 %to 2 ; * Hardcoding 2;
 
%let g=%scan(&gen,&i,"@"); 

data &g;
set sasuser.admit;
where sex="&g";
run;

%end;
%mend a;

%a;

*now we going to fully automate the above code;
%Macro m(ds=,v=);

proc sql;
select count(distinct &v) into:n from &ds;         *This is the fourth way of creating macro variable "into:";
select distinct &v into:s separated by "@" from &ds;
quit;


	%do i=1 %to &n;
		%let a=%scan(&s,&i,"@");
		 data &a;
		 set &ds;
		 where &v="&a";
		 run;

PROC EXPORT DATA= &a
            OUTFILE= "E:\raj\SAS\junk\&a..xls" 
            DBMS=EXCEL REPLACE;
     SHEET="&a"; 
RUN;

	%end;
%mend m;

%m (ds=sasuser.admit, v=sex);

%m (ds=sashelp.cars, v=make);
%m (ds=sashelp.prdsale, v=state);
%m (ds=sasdata.emp, v=sex);

/******************************************/




*****how we can use function in Macro;

%let a=%sysfunc(compress(amit kumar));
%put *&a*;

data &a;
set sasuser.admit;
run;

data %sysfunc(compress(amit kumar));
set sasuser.admit;
run;




*here we find product distribution state wise;
%macro h(ds=);

proc sql;
select count(distinct product) into: n from &ds;
select distinct product into: p separated by "$" from &ds;
quit;

%do i=1 %to &n;
%let Product_state=%scan(&P,&i,"$");

	proc sql;
	create table &Product_state as select state, product, count(state) as cnt from &ds  where product="&Product_state" group by state, product;
	quit;

PROC EXPORT DATA= &Product_state  OUTFILE= "E:\raj\SAS\junk\&Product_state..xls"  DBMS=EXCEL REPLACE;
           SHEET="&Product_state"; 
RUN;

%end;
%mend h;

%h(ds=sashelp.prdsal2);



/*2 Way...... state wise product count*/
%macro h(ds=);

proc sql;
select count(distinct state) into: n from &ds;
select distinct state into: p separated by "$" from &ds;
quit;

%do i=1 %to &n;
%let Product_state=%scan(&P,&i,"$");

	proc sql;
	create table &Product_state as select state, product, count(product) as cnt from &ds  where state="&Product_state" group by state, product;
	quit;

PROC EXPORT DATA= &Product_state  OUTFILE= "E:\raj\SAS\junk\&Product_state..xls"   DBMS=EXCEL REPLACE;
           SHEET="&Product_state"; 
RUN;

%end;
%mend h;

%h(ds=sashelp.prdsal2);

/************************************************************************/








								/* CLASS-25 */

/*
Metadta RepositorY: Where does sas store the metadata?
column level info
*/
proc sql;
create table a as select * from dictionary.columns;
quit;
		
/*
tell me the 1st and 5th of S.A
*/
proc sql;
create table c as select name, varnum from dictionary.columns where lowcase(libname)="sasuser" and lowcase(memname)="admit" and varnum in (1,5);
quit;
	
/*
tell me the char and numeric variable count
	
proc sql;
select type, count(type) as ty from dictionary.columns group by type;
quit;

/*
tell me the char and numeric variable count of S.A
*/
option nolabel; *by using option nolabel we got varible name not the label of the variable;
proc sql;
select type,count(*) as cnt from dictionary.columns where lowcase(libname)="sasuser" and lowcase(memname)="admit"
group by type;
quit;
*here we find the data on the baisis of columns(variables) name so,we do dictionary.columns and in that particular dataset;



*if we want to know if their is any table(dataset) is sorted by any variable ;
proc sort data=sasuser.admit;
by sex ;
run;

proc sql;
select name,sortedby from dictionary.columns 
where lowcase(libname)="sasuser" and lowcase(memname)="admit";
quit;

proc sql;
select name,sortedby from dictionary.columns 
where lowcase(libname)="sasuser" and lowcase(memname)="admit" and sortedby gt 0;
quit;



*if dataset is sortedby morethen 1 variables;
proc sort data=sasuser.admit;
by sex actlevel;
run;

proc sql;
select name,sortedby from dictionary.columns 
where lowcase(libname)="sasuser" and lowcase(memname)="admit" ;
quit;






/*
Table level information
*/
proc sql;
create table b as select * from dictionary.tables;
quit;
*it just tell us information about tables(dataset) like: size, manifacturing date, encrpted or not etc.;
	
proc sql;
select libname, count(*) as count, sum(filesize)/1000000 as soze_mb from dictionary.tables
group by libname;
quit;




*we have excel sales data of 3 months, now we impot these excel files with the help of macros and then going to append
that 3 months data then export to the same excel file with new sheet4(all) with the help of macros as well;
option mlogic symbolgen mprint;
%macro Append_3M;
%do i=1 %to 3;
proc import out=s&i. datafile="C:\Users\RAJ\Desktop\sale.xls" dbms=excel replace;
			range="sheet&i.$";
			getnames=yes;
run;
%end;

proc sql noprint;
select memname into: ds separated by " " from dictionary.tables
where lowcase(libname)="work" ;
quit;
%put **&ds**;

data all;
set &ds.;
run;

proc export data=all outfile="C:\Users\RAJ\Desktop\sale.xls" dbms=excel replace;
			sheet="all";
run;
%mend Append_3M;

%Append_3M;
*the excel file should be unprotected othewise on export code will gives error bcoz excel protected hone ki wajah se 
filnal file ko edit ya new sheet nahi banane dega;


proc contents data=sasuser.admit;
run;

proc contents data=sasuser.admit out=xx;
run;
/*
Summarizing Data with PROC CONTENTS. The CONTENTS procedure generates summary information about the contents of a dataset,
including: The variables' names, types, and attributes (including formats, informats, and labels) How many observations are
in the dataset.
*/
/***********************************************************************/








									/*CLASS-26*/

%macro yoyo;
libname king "C:\Users\RAJ\Desktop\cust_data.xls";

proc sql noprint;
select cats(libname,".","'",memname,"'","n") into: ds separated by " " from dictionary.tables
where lowcase(libname)="king";
quit;
%put **&ds**;

data king.all;
set &ds;
run;

%mend yoyo;

%yoyo;

libname king clear;

***********************;

%macro yoyoasm;
libname kiran "C:\Users\RAJ\Desktop\cust_data.xls";

proc sql noprint;
select cats(libname,".","'",memname,"'","n") into: ds separated by " " from dictionary.tables
where lowcase(libname)="kiran"   and lowcase(memname) contains "gold";
quit;
%put **&ds**;

data kiran.gold_data;
set &ds;
run;

%mend yoyoasm;

%yoyoasm;

libname kiran clear;

**********************;
*Try this name of the datasets as well;
data new;
set am.'''12India_asia$'''n;
run;


data '1test'n;
set sasuser.admit;
run;
/**********************************************************************************************/






								/* CLASS-40 */

/* Parameters: Inputs that you pass to the macro */
/*Keyword parameter*/
%macro a(d=,l=);
data &d;
set &l;
run;

%mend a;
%a(d=kaka,l=sasuser.admit);
%a(l=sasuser.admit,d=kaka);*it won't matter if change the sequence in keyword parameter;

/*Positional parameter*/
%macro a1(d,l);
data &d;
set &l;
run;
%mend a1;
%a1 (baba,sasuser.admit); *here we have to must follow position of the macro parameter : first come first;


/*What if mixed of positional and keyword parameters macros*/
%macro a(d,l=); /* positional should always come first */
data &d;
set &l;
run;
%mend a;
%a (amit,l=sasuser.admit);

%macro a(d,l=); /* positional should always come first: PK */
data &d;
set &l;
run;
%mend a;
%a (l=sasuser.admit,amit); 




/*  && concept :(2^n)-1    */
%macro a;
%let act1=HIGH;
%let act2=MOD;
%let act3=LOW;

%do i=1 %to 3;
data &&act&i;
set sasuser.admit;
where actlevel="&&act&i";
run;

%end;
%mend a;
%a;



/*macro debugging techniques */

option mprint mlogic symbolgen;
%macro king(d=,l=,v=);

%do i=1 %to 3;
data &d.&i;
set &l;
where &v gt 40;
run;
%end;
%mend king;
%king (d=hello, l=sasuser.admit, v=age);

/*
MLogic: MacroLogic :gives all the logics of macro code
Symbolgen: help to resolve macro variables values : like %put
Mprint: convert sas macros to base sas code
*/


/*How to print log data into any external file*/

filename logfile "C:\Users\RAJ\Desktop\xx.log"; 
proc printto log=logfile; *to print log data into external file;
run;

data b;
set sasuser.admit;
run;

proc printto; *to resume the log data in sas enviroment;
run;
/*******************************************************************/









							/*CLASS-41*/


%let a=amit;

%macro y;

%global b;   *You are creating a macro var b: with no value;*within macro parameter here global b makes b as global macro variable;

%let b=baba;

data &a;
run;

data &b;
run;

%mend y;
%y;

data &a;
run;

data &b;
run;




*here a is global as well as local macro variable so what would be the result when we call the macro;
%let a=amit;   *golbal macro with the name of a;

%macro a;
%let a=baba;   *local macro with the name of a;
data &a;
run;
%mend a;

%a;

data &a; *now when we calling macro here its gives output of local macro variable ;
run;

*so now we going to tackel the above problem;

%let a=amit;

%macro a;
%local a; *yaha %local a ko as a local macro variable assing krr raha taki baba sirf macro program k ander tak hi kaam kare;

%let a=baba;

data &a;
run;
%mend a;

%a;

data &a;
run;



/*CALL ROUTIEN: IT IS A HYBRID OF PROC & FUNCTION*/
*****call sortn & call sortc : use to sort the Rows values;
data a;
input  city $ day1 day2 day3 day4;
call sortn(of day1-day4);
cards;
G 1200 700 300 1500
N 500 1600 900 1100
;
run;


data x;
input city $ add1 $ add2 $ add3 $ add4 $;
call sortc(of add1-add4);
cards;
G a k b a
N p q r s
;
run;


data aish;
input city $ a b c d;
call sortn(of a--d);
cards;
G 1200 1300 700 1800
N 1200 1400 1500 900
;
run;

data amit;
input city $ day1 day2 day3 day4;
call sortn(of day4-day1);
cards;
G 1200 1300 700 1800
N 1200 1400 1500 900
;
run;





*********call symput****;
*it is the only macro variable which is use in data step;

data _null_;
x="amit";
call symput("baba",x); * To create macro var in a data setp ;
run;


data &baba; *baba ki jagah x aa jaega or jab &x ki value resolve hogi to amit aa jayega as x ki value amit upper assign h;
run;
*****************;
%let a=amit;

data new;
b=symget('a');
run;

/**
41. What are SYMGET and SYMPUT?
SYMPUT puts the value from a dataset into a macro variable where as
SYMGET gets the value from the macro variable to the dataset.




Comparisons
CALL SYMPUTX is similar to CALL SYMPUT. Here are the differences.

CALL SYMPUTX does not write a note to the SAS log when the second argument is numeric. CALL SYMPUT, however, writes a note to the log stating that numeric values were converted to character values.
CALL SYMPUTX uses a field width of up to 32 characters when it converts a numeric second argument to a character value. CALL SYMPUT uses a field width of up to 12 characters.
CALL SYMPUTX left-justifies both arguments and trims trailing blanks. CALL SYMPUT does not left-justify the arguments, and trims trailing blanks from the first argument only. Leading blanks in the value of name cause an error.
CALL SYMPUTX enables you to specify the symbol table in which to store the macro variable, whereas CALL SYMPUT does not.
Example
The following example shows the results of using CALL SYMPUTX.

%let x=1;
%let items=2;
%macro test(val);

data _null_;
 call symputx('items', ' leading and trailing blanks removed ', 'L');
 call symputx('  x   ', 123.456);
run;

%put local items &items;
%mend test;
  
%test(100)
      
%put items=!&items!;
%put x=!&x!;

The following lines are written to the SAS log:

82   %let x=1;
83   %let items=2;
84   %macro test(val);
85   
86   data _null_;
87    call symputx('items', ' leading and trailing blanks removed ', 'L');
88    call symputx('  x   ', 123.456);
89   run;
90   
91   %put local items &items
92   %mend test;
93   
94   %test(100)
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
local items leading and trailing blanks removed
95   
96   %put items=!&items!;
items=!2!
97   %put x=!&x!;
x=!123.456!

**/


/* 8.  Create a macro variable and store TomDick&Harry 

Issue : When the value is assigned to the macro variable, the ampersand placed after TomDick may cause SAS to interpret it as a macro trigger and an warning message would be occurred.
**/
%let x = %NRSTR(TomDick&Harry);
%PUT &x.;
%NRSTR function is a macro quoting function which is used to hide the normal meaning of special tokens and other comparison and logical operators so that they appear as constant text as well as to mask the macro triggers ( %, &).


/**
9. Difference between %STR and %NRSTR
Both %STR and %NRSTR functions are macro quoting functions which are used to hide the
normal meaning of special tokens and other comparison and logical operators so that 
they appear as constant text. The only difference is %NRSTR can mask the 
macro triggers ( %, &) whereas %STR cannot.
**/



/*** %SYSEVALF supports floating-point numbers. However, %EVAL performs only integer arithmetic. ***/



/**
13. How to reference a macro variable in selection criteria
Use double quotes to reference a macro variable in a selection criteria. Single quotes would not work.
**/



/** 
18. Selecting Random Samples with PROC SQL

The RANUNI and OUTOBS functions can be used for selecting N random samples. The RANUNI function is used to generate random numbers.
**/
;


proc sql outobs = 10;
create table tt as
select * from sashelp.class
order by ranuni(1234);
quit;

%Let StDate = &SysDate.;
%*Let StDate = %sysfunc(date(),yymmddn8.);
%Put StDate: &StDate.:


May I know how to get the "Today Datetime" in current datetime instead of 1960? Thanks.


data _null_;

x=today();

y=x;
z=x;
format y date9.;
format z datetime20.;
put "Unformatted:" x "Formatted:" y "Today Datetime:" z;
run;


/*********************************************************************/






								/* CLASS-27 */


/* proc format : You can create user defined formats */
*100 >> $100.00  dollar7.2  >> put()  or fomat statement  ;

/* 1. if else  2. sql case statement*/
proc format;
value age_f 
1-30.99='young'
31-50.99='mid'
51-70='old';
run;
data a;
set sasuser.admit;
age_class=put(age,age_f.);
run;

/**Options: options are 2 types  
		1.Global: Valid for the entire sas session
		2.Local : valid for the datastep *****/

data a;
set sasuser.admit(obs=5); *Local options as it affect just this datastep;
run;



options obs=12; *Global options as it affect this as well below datastep too;
data b;
set sasuser.admit;
run;

data x ; *now here we only get 12 observation because global options use in above example so its work here as well;
set sasuser.admit;
run;

proc print data=sasuser.admit;
run;

option obs=12;
data d;
set sasuser.admit(obs=7); *here its gives only seven obs bcoz fisrt statement exicute with only 7 obs after that global option statement exicuted;
run;

option obs=5;
data e;
set sasuser.admit(obs=12);*local options has prioties statement wise that its excute first so, always local options output comes between local and global;
run;

data f;
set sasuser.admit;
run;

option obs=max;
data g;
set sasuser.admit;
run;

proc format lib=work.formats fmtlib; *it gives the data(information) about format folder;
select age_f; *here it mention information only about age_f name;
run;

proc format lib=work.formats fmtlib; *it gives the data(information) about whole format folder;
run;




/***Appplication;   
r1 r2=Africa
r3 r4 =europe
r5 r6 = Asia
*/
proc format ;		*now this is format for charcter variable ;
value $r
'Route1','Route2' ='Africa'
'Route3','Route4' ='Europe'
'Route5','Route6' ='Asia';
run;
Proc sql;
select Route,count(*) as cnt from
(
select put(Route,$r.) as route from sasuser.cargorev
) group by route;
quit;






proc format ;
value $st
'HR'='Haryana'
'PB'='Punjab'
'DL'="Delhi";
;
run;

data a;
input reg $;
state=put(substr(reg,1,2),$st.); *1.way;
state2=put(scan(reg,1,"-"),$st.); *2.way;
cards;
HR-123
PB-456
DL-321
HR-212
PB-653
DL-111
;
run;

 


/*
proc format lib=work.formats fmtlib;  
run; *all the files in the format folder;

proc format lib=work.formats fmtlib;
select $st; *specific file in the format folder;
run;
*/




/******Now how can we copy one dataset from one library to 2 library*/

*Proc copy: used for moving datasets from one library to another;
data raj;
set sasuser.admit;
run;

proc copy in=work   out=sasuser; *its copy the data from work(in) and paste it sasuser(out) library;
select raj;
run;

proc copy in=sasuser out=work; *here it copy pilots from sasuser(in) and paste it work(out) library;
select pilots;
run;


/*if we want to copy multiple data on a single time then*/
proc copy in=sasuser out=work;
select finance europe heart insure;
run;



******How to copy one entire library to another********;
proc copy in=sasuser out=work;
run;

*******Handle with care********;
libname kiran "C:\Users\RAJ\Desktop\kiranraj"; *kiran is library creating in sas inviorment and kiranraj is desktop folder name;
proc copy in=work out=kiran move;
run;

proc copy in=kiran out=work ;
exclude admit a;
run;

proc copy in=kiran out=work move;
exclude admit a;
run;
/******************************************************************/









									/* CLASS-28 */


/* Proc Freq: The occurence of an event in a time

1 1 2 3 4: what is the freq of 1: 2.. count
*/
proc freq data=sasuser.admit;
table actlevel;
run;

/* What kind of variables should i use for proc freq */
proc freq data=sasuser.admit;
table age;
run;
proc freq data=sasuser.admit;
table id; 			*id is unique value so their frequency(count) will not matter(useless) it always come one only;
run;
*****************;

proc format;
value age_fmt
1-30.99='Minor'
31-50.99='Adult'
51-70='Senior';
run;
proc freq data=sasuser.admit;
table age;
format age age_fmt.;
run;



data xx;
set sasuser.admit;
seggrigate=put(age,age_fmt.);
run;


/* It would show the freq of both vars ... separately */
proc freq data=sasuser.admit;
table sex actlevel;    *it would gives two frequency table sex and actlevel basis;
run;


****** Inter realtion freq ********;
proc freq data=sasuser.admit;
tables sex*actlevel;
run;

proc freq data=sasuser.admit;
tables sex*actlevel / list;
run;

proc freq data=sasuser.admit;
table sex*actlevel / list;
where age gt 40;
run;


proc format;
value sal_fmt
Low-1999.99='Low Income'
2000-3999.99='Mid Income'
4000-High='High Income';
run;

proc freq data=sasuser.staff;
tables wagerate; 
format wagerate sal_fmt.; *here we catogorise wage of staff and then we find the frequency of wagerate;
run;


proc freq data=sasuser.empdata; 
tables country*salary / list;
run;

proc freq data=sasuser.empdata;
tables country*location*salary / list;
format salary sal_fmt;
where country="USA";
run;




proc sort data=sasuser.admit out=test;
by sex;
run;
proc format;
value agef
1-30.99='young'
31-50.99='Mid'
51-70='old';
run;

ods pdf file="C:\Users\RAJ\Desktop\kiranraj.pdf";
proc freq data=test;
tables age;
format age agef.;
by sex;               *we are using by statement here so before that we must have to sort the data by the same variable;
run;

ods pdf close;




proc freq data=sasuser.admit;
table sex /out=new;
run;


proc freq data=sasuser.cargorev  order=freq; 
tables route;
run;
************************************;


data servey;
input city response count;
cards;
1 1 35
1 0 65
2 1 40
2 0 60
3 1 25
3 0 75
;
run;

PROC freq data=servey;
tables response / list;
weight count;
run;


proc freq data=sasuser.admit;
tables sex;
run;
proc freq data=sasuser.admit;
tables sex;
weight fee;         *here we using weight statement to check the frequency on a basis of sex wise fee frequency; 
run;
/***********************************************************************/











							/*CLASS-29*/

/*  Tranpose is used to convert rows to columns and vice versa
Doesnt change data.. Layout/orientation of the data :)
*/
data pets;
input po $ pet $ count;
cards;
amit cat 2
amit dog 2
Neha cat 5
Arnab fish 4
;
run;
* 1. simple Transpose, only numeric variable gets transposed by default;
proc transpose data=pets out=pets1;
run;

data pets;
input po $ pet $ count food_cost;
cards;
amit cat 2 100
amit dog 2 200
Neha cat 5 500
Arnab fish 4 700
;
run;
* 1. simple Transpose;
proc transpose data=pets out=pets2;
run;


data pets;
input po $ pet $ count;
cards;
amit cat 2
amit dog 2
Neha cat 5
Arnab fish 4
;
run;
* 2. Prefix;
proc transpose data=pets out=pets3  prefix=petcount;
run;
* 3. Name;
proc transpose data=pets out=pet4 prefix=petcount name=col_jo_tran_hua;
run;


data pets;
input po $ pet $ count;
cards;
amit horse 2
amit dog 2
Neha cat 5
Arnab fish 4
;
run;
* 4. ID;
proc transpose data=pets out=pets5 name=col_trans;
id pet;
run;



data pets;
input po $ pet $ count;
cards;
amit cat 2
amit dog 2
Neha cat 5
Arnab fish 4
;
run;
* 4. ID;   *ERROR: The ID value "cat" occurs twice in the input data set.;
proc transpose data=pets out=pets6  name=col_trans;
id pet;
run;
****************************;


proc sql;					
create table ro as 
select route,count(*) as count from sasuser.cargorev group by route;
quit;

proc transpose data=ro out=ro_transposed name=col_that_was_trans;
id route;
run;



data pets;
input po $ pet $ count;
cards;
amit cat 2
amit dog 2
Neha cat 5
Neha dog 4
Arnab fish 4
Arnab cat 14
Arnab dog 12
;
run;

proc sort data=pets out=pet_sorted;
by po;
run;

* 5. ID and BY;
proc transpose data=pet_sorted  out=pet_sorted1 ;
id pet;
by po;
run;




data details;
input name$ acct$ bal;
cards;
Amit saving 120000
Amit CC 15000
Amit HL 20000
Trivali saving 100
Trivali CC 200
Trivali HL 400
;
run;
proc sort data=details out=details_sort;
by name;
run;
*yaha acct ki values repet ho rahi h magar name k according kare to error nahi aaega or kyuki name by me use krr rahe h
toh usse sort karege kyuki by me use krrne k liye sort hona chahiye;
proc transpose data=details_sort out=details_sort1;
id acct; 
by name;
run;

data all_details;
set details_sort1;
array new (*) saving cc;
avg=mean(of new(*));
run;




data pets;
input po $ pet $ count sale_price breed$;
cards;
amit cat 2 200 persian
amit dog 2 300 bulldog
Neha cow 5 500 desi
Arnab fish 4 800 rohu
;
run;
proc transpose data=pets out=pets1 ;
id pet;
run;


proc transpose data=pets out=pets2;
id pet;
var count sale_price breed po;
run;



proc sql;
create table cars as select make,type,count(*) as count
from sashelp.cars
group by make,type order by make;
quit;

proc transpose data=cars out=car_t;
ID type;
by make;
run;
***************************************;

data stocks;
    input Company $14. Date $ Time $ Price;
    datalines;
Horizon Kites jun11 opening 29
Horizon Kites jun11 noon    27
Horizon Kites jun11 closing 27
Horizon Kites jun12 opening 27
Horizon Kites jun12 noon    28
Horizon Kites jun12 closing 30
SkyHi Kites   jun11 opening 43
SkyHi Kites   jun11 noon    43
SkyHi Kites   jun11 closing 44
SkyHi Kites   jun12 opening 44
SkyHi Kites   jun12 noon    45
SkyHi Kites   jun12 closing 45
;
run;

proc transpose data=stocks out=close(drop=_:) let;
   by company;
   id date;
 run;
proc print data=close noobs;
   title 'Closing Prices for Horizon Kites and SkyHi Kites';
run;




**********************;

data jan;
input id sale;
cards;
1 100
2 200
;
run;

data feb;
input id sale;
cards;
1 1100
2 1200
;
run;

data all;
set jan feb;
run;

* why append is more efficient ;
proc append base=jan data=feb; *space memory kam leta h and yaha feb ka data jan k wale file me add ho jaega ;
run;


data jan;
input id sale name $;
cards;
1 100 A
2 200 B
3 100 C
4 200 D
;
run;

data feb;
input id sale ;
cards;
1 1100
2 1200
;
run;
* why append is more efficient ;
proc append data=feb force base=jan;  *force is not work on SAS V9.0;
run;
/********************************************************/







							/* CLASS-30 */


/* proc means: Use for calculating the statistical values */

/* Only for numeric variables: it gives 5 default stats */
proc means data=sasuser.admit;
var age;
run;

proc means data=sasuser.admit;
var age;
class sex;
run;


proc means data=sasuser.admit maxdec=2;
var age;
class sex;
run;

proc means data=sasuser.admit maxdec=2 max std;
var age;
class sex;
run;


proc means data=sasuser.admit maxdec=2 max std;
var age ;
class sex;
output out=jma;
run;


data all fem mal;
set jma;
if _type_=0 then output all;
else if sex="F" then output fem;
else output  mal;
run;


proc sql;
select count(distinct sex) from jma;
quit;


proc means data=sasuser.cargorev noprint;
var revcargo;
class route;
output out=amit;
run;
%macro yummy;
proc sql;
select count(distinct route) into: n from amit;
select distinct route into: s separated by "@" from amit;
quit;
%do i=1 %to &n;
%let se=%scan(&s,&i,"@");
data &se;
set amit;
where route="&se";
run;
%end;

data all;
set amit;
where _type_=0;
run;
%mend yummy;

%yummy;





proc means data=sasuser.admit;
run;

proc means data=sasuser.admit;
class sex;
run;


proc rank data=golf out=rankings;
   var strokes;
   ranks Finish;
run;

proc print data=rankings;
run;
/**********************************************************************/










							/*CLASS-31*/

proc plot data=sasuser.admit;
plot age*height;
Title "Age VS Height Relationship";
run;

proc plot data=sasuser.admit;
plot height*age;
Title "Age VS Height Relationship";
run;



data a;
set sasuser.admit;
run;

******Scatter Plot;
proc plot data=a;
plot height*age;
Title "Age VS Height Relationship";
run;



********Zeta Plot;
proc gplot data=a;
plot age*height;
Title "Height VS Age Relationship";
run;





**********GChart;
proc Gchart data=sasuser.cargorev;
vbar route;
run;

proc gchart data=sasuser.cargorev;
vbar3d route;
run;




*********If the X variable is continous ( numeric)****;
proc gchart data=sasuser.admit;
vbar3d age;
run;

proc gchart data=sasuser.admit;
hbar3d age;
run;


proc gchart data=sasuser.admit;
hbar3d age / sumvar=fee;
run;


proc gchart data=sasuser.admit;
hbar3d age / sumvar=fee subgroup=actlevel;
run;

proc gchart data=sasuser.admit;
hbar3d age / sumvar=fee subgroup=actlevel group=sex;
run;


proc gchart data=graph;
Title "City wise Analysis of spend stacked with type";
hbar3d spend /sumvar=spend subgroup=type group=city;
run;

proc gchart data=graph;
Title "City wise Analysis of spend stacked with type";
hbar3d spend /sumvar=spend subgroup=city group=type;
run;
/*************************************************************************/









									/*CLASS-32*/
data f;
set sasuser.europe;
run;

proc sql;
create table x as select dest, count(*) as cnt from sasuser.europe
group by dest;
quit;

proc gchart data=x;
title height=5 pct font='Georgia''market share of europe';
pie dest / sumvar=cnt
noheading
woutline=1
slice=arrow value=arrow percent=arrow coutline=arrow;
run;

data emp;
input city$ count;
cards;
G 120
N 30
D 78
F 56
CH 90
;
run;

proc gchart data=emp;
Title height=5 pct font='Georgia''citywise emp distribution';
pie3d city /sumvar=count
noheading
woutline=1
slice=arrow value=arrow percent=arrow coutline=arrow explode="CH";
run;


data emp;
input city$ count;
cards;
G 120
N 30
D 78
F 56
CH 90
;
run;
proc sql noprint;
select count(distinct city) into: n from emp ;
select distinct city  into: ct separated by "@" from emp;
quit;
%put **&n**&ct**;
%macro desti;
%do i=1 %to &n;
%let a=%scan(&ct,&i,"@");

proc gchart data=emp;
Title height=5 pct font='Georgia''city of the employee distribution of :&a';
pie3d city / sumvar=count
noheading
woutline=1
slice=arrow value=arrow percent=arrow coutline=arrow explode="&a";
run;
%end;
%mend desti;
%desti;



data sales;
input month $ TT TC JAG;
cards;
jan 15 20 34 
feb 25 29 40
mar 39 46 56
apr 96 98 80
may 60 87 65
june 37 60 40
;
run;
proc sgplot data=sales;
SERIES X = Month Y = TT /  LEGENDLABEL = 'Tata Tea' MARKERS LINEATTRS = (THICKNESS = 2);    
SERIES X=MONTH Y=TC / LEGENDLABEL='TATA CONSULTANCY' MARKERS LINEATTRS=(THICKNESS=2);
SERIES X = Month Y = JAG / LEGENDLABEL = 'Jaguar' MARKERS LINEATTRS = (THICKNESS = 2);    
TITLE 'SALES ANALYSIS';
RUN; 
PROC SGPLOT DATA = sales;    
SERIES X = Month Y = TT /  LEGENDLABEL = 'Tata Tea' datalabel=TT MARKERS LINEATTRS = (THICKNESS = 2);    
SERIES X = Month Y = TC / LEGENDLABEL = 'Tata Chemical' datalabel=TC  MARKERS LINEATTRS = (THICKNESS = 2);  
SERIES X = Month Y = JAG / LEGENDLABEL = 'Jaguar' datalabel=JAG MARKERS LINEATTRS = (THICKNESS = 2);    
TITLE 'Sales analysis'; 
YAXIS LABEL = 'sale in MM $' GRID VALUES = (0 TO 100 BY 10);  
RUN;




/* half yearly data: Time series data */
data sales;
input month $ TT TC JAG;
cards;
jan 15 20 34 
feb 25 29 40
mar 39 46 56
apr 96 98 80
may 60 87 65
june 37 60 40
;
run;

PROC SGPLOT DATA = sales;    
SERIES X = Month Y = TT /  LEGENDLABEL = 'Tata Tea' datalabel=TT MARKERS LINEATTRS = (THICKNESS = 2);    
SERIES X = Month Y = TC / LEGENDLABEL = 'Tata Chemical' datalabel=TC  MARKERS LINEATTRS = (THICKNESS = 2);  
SERIES X = Month Y = JAG / LEGENDLABEL = 'Jaguar' datalabel=JAG MARKERS LINEATTRS = (THICKNESS = 2);    
TITLE 'Sales analysis'; 
REFLINE  60 / TRANSPARENCY = 0.5   LABEL = ('cut off for incentives');  
RUN; 




data issue;
input category $ count;
cards;
WPS	600
PNO	100
PG	100
OTP	50
CR/DEB	50
Dup	50
Notfri	50
;
run;

proc pareto data=issue;
vbar category / freq = Count
scale = count;
run;

title 'Analysis of Integrated Circuit Failures';
proc pareto data=issue;
vbar category / freq = Count
scale = count
odstitle = title1r
markers;
run;
/**********************************************************************/



							/*CLASS-42*/

data emp;
input exp sal;
cards;
0 1250
1 5000
2 20000
3 80000
;
run;

proc reg data=emp;
model sal =exp;
run;

/*****************************************************/

/* 
Proc Report :- 
The Report procedure combines features of the PRINT, MEANS and TABULATE procedures with the features of the DATA step 
in a single report-writing tool that can produce a variety of reports. 


TYPICAL SYNTAX:
The REPORT procedure is made up of a PROC statement, a COLUMN statement, several DEFINE statements, and other optional 
statement that help with calculations and summarizations.


Proc REPORT data=SAS-data-set options;
COLUMNS variable_1 ... variable_n;
DEFINE variable_1;
DEFINE variable_2;
...
DEFINE variable_n;

COMPUTE blocks;
BREAK ;
RBREAK ;
run;

COLUMNS statement defines which columns appear in the report, and their order.
DEFINE statement declare how variables are to be used in the report.
COMPUTE block allow calculations to be performed in the report.
BREAK/RBREAK statement allow summarization and some kinds of formatting at certain places in the report.

*/ 

proc REPORT DATA=import_1;
column class gender score1 score2 score3 ;
define class / display;
define gender / display;
define score1 / display;
define score2 / display;
define score3 / display;
run;

/* NOTE:
Simple report doesn't have an OBS column.
The variable are listed in their order in the column statement.
The column headers are the labels not the variable names. 
*/





PROC FORMAT;
VALUE spend_color_fmt
LOW-<25000 = "RED"
25000-<40000 = "YELLOW"
40000-<60000 = "GREEN";
RUN; 
ods pdf file = "C:\Users\RAJ\Desktop\RawData_Project\ryg.pdf";
proc report data=spend;
DEFINE amount /
STYLE={BACKGROUND=spend_color_fmt.}; 
run;
ods pdf close;


proc report data=mnthly_sales nofs headline headskip;
title1 "Grouped Report (Group Type)"; 
column cty zip var sales; 
define cty / group width=6 ‘County/Name’; 
define var / group order=freq descending; 
define sales / display format=6.2 width=10; 
run;


proc report data=mnthly_sales nofs headline headskip;
title1 "Report with Row Sums (Computed Type)";
column cty zip var,sales row_sum;
define cty / group width=6 ‘County/Name’;
define zip / group;
define var / across order=freq descending '- Grape Variety -';
define sales / analysis sum format=6.2 width=10 'Revenue';
define row_sum / computed format=comma10.2 'Total';
break after cty / ol skip summarize suppress;
rbreak after / dol skip summarize;
compute row_sum;
row_sum = sum(_C3_,_C4_,_C5_,_C6_,_C7_,_C8_);
endcompute;
run;






***** How to size of any dataset through code;
proc sql;
title 'FileSize for Cars DataSet';
select libname, memname, filesize format=sizeKMG., fileSize format=sizek. from dictionary.tables
where lowcase(libname)="sasuser" and lowcase(memname)="cars" and lowcase(memtype)="data";
quit;

proc sql;
title 'FileSize for Admit DataSet';
select libname, memname, filesize format=sizeKMG., fileSize format=sizek. from dictionary.tables
where lowcase(libname)="sasuser" and lowcase(memname)="admit" and lowcase(memtype)="data";
quit;


/*****
I'm merging 2 datasets

count = 6,437,567 variables =  22   file size = 1.2 GB   page size =  65,536   # pages = 18,566
count = 2,276,587 variables = 917  file size = 2.4 GB   page size = 131,072  # pages = 19,726
The resulting dataset has:

     count = 6,437,567   variables = 924  file size = 21.8 GB  page size = 131,072  # pages = 170,379

 

I didn't expect to get 22 GB when merging 1GB with 2GB

 

This is a straight merge without any calculations (dropping/merging a few fields)

I get the same results with a data step merge as with SQL (left join)

None of the character fields are excessively long (the longest is 40 and only a few are that long)

All 3 datasets use CHAR compression;  no indexes yet

Dataset option REUSE = YES reduced the output from 23 GB to 22 GB

I'm using SAS-EG 9.0401M5 in Linux

Does it really make sense for the output dataset to be 22 GB ?
*********/




/* PROC UNIVARIATE */
/*
This tutorial explains how to explore data with PROC UNIVARIATE. It is one of the most powerful SAS procedure for running
descriptive statistics as well as checking important assumptions of various statistical techniques such as normality,
detecting outliers. Despite various powerful features supported by PROC UNIVARIATE, its popularity is low as compared to
PROC MEANS. Most of the SAS Analysts are comfortable running PROC MEANS to run summary statistics such as
count, mean, median, missing values etc, In reality, PROC UNIVARIATE surpass PROC MEANS in terms of options supported in
the procedure. See the main difference between the two procedures.

PROC UNIVARIATE vs. PROC MEANS

1. PROC MEANS can calculate various percentile points such as 1st, 5th, 10th, 25th, 50th, 75th, 90th, 95th, 99th percentiles but it cannot calculate custom percentiles such as 20th, 80th, 97.5th, 99.5th percentiles. Whereas, PROC UNIVARIATE can run custom percentiles.

2. PROC UNIVARIATE can calculate extreme observations - the five lowest and five highest values. Whereas, PROC MEANS can only calculate MAX value.

3. PROC UNIVARIATE supports normality tests to check normal distribution. Whereas, PROC MEANS does not support normality tests.

4. PROC UNIVARIATE generates multiple plots such as histogram, box-plot, steam leaf diagrams whereas PROC MEANS does not support graphics.
*/

data x;
set sasuser.cars;
run;

/* Basic PROC UNIVARIATE Code */
**In the example below. we would use sashelp.shoes dataset. SALES is the numeric (or measured) variable.;
proc univariate data=x;
var EngineSize;
run;

/* Example 1 : Analysis of Sales by Region */
**Suppose you are asked to calculate basic statistics of sales by region. In this case,
region is a grouping (or categorical) variable. The CLASS statement is used to define categorical variable.;
proc univariate data=x;
var EngineSize;
class type;
run;

/* 2. Generating only Percentiles in Output */
**Suppose you want only percentiles to be appeared in output window. By default,
PROC UNIVARIATE creates five output tables: Moments, BasicMeasures, TestsForLocation, Quantiles, and ExtremeObs.
The ODS SELECT can be used to select only one of the table. The Quantiles is the standard table name of PROC UNIVARIATE 
for percentiles which we want. ODS stands for Output Delivery System.;
ods select quantiles;
proc univariate data=x;
var EngineSize;
class type;
run;

/* How to know the table names generated by SAS procedure */
**The ODS TRACE ON produces name and label of tables that SAS Procedures generates in the log window.;
ods Trace on;
proc univariate data=x;
var EngineSize;
run;
ods Trace off;

/* How to write Percentile Information in SAS Dataset */
**The ODS OUTPUT statement is used to write output in results window to a SAS dataset. In the code below,
temp would be the name of the dataset in which all the percentile information exists.;
ods output quantiles=te;
proc univariate data=x;
var EngineSize;
run;
ods output close;


/* 3. Calculating Extreme Values */
**Like we generated percentiles in the previous example, we can generate extreme values with extremeobs option.
The ODS OUTPUT tells SAS to write the extreme values information to a dataset named outlier. The "extremeobs" is the
standard table name of PROC UNIVARIATE for extreme values. ;
ods output extremeobs = outlier;
proc univariate data = x;
var EngineSize;
class type;
run;
ods output close;

/* 4. Checking Normality */
/*
Most of the statistical techniques assumes data should be normally distributed. It is important to check this 
assumption before running a model.;
There are multiple ways to check Normality :
Plot Histogram and see the distribution
Calculate Skewness
Normality Tests
*/

/* I. Plot Histogram */
**Histogram shows visually whether data is normally distributed.;
proc univariate data=sashelp.shoes NOPRINT;
var sales;
HISTOGRAM / NORMAL (COLOR=RED);
run;
**It also helps to check whether there is an outlier or not.;


/* II. Skewness */
**Skewness is a measure of the degree of asymmetry of a distribution. If skewness is close to 0, it means data is normal.;
/*
A positive skewed data means that there are a few extreme large values which turns its mean to skew positively. It is also called right skewed.
Positive Skewness : If skewness > 0, data is positively skewed. Another way to see positive skewness : Mean is greater than median and median is greater than mode.
A negative skewed data means that there are a few extreme small values which turns its mean to skew negatively. It is also called left skewed.
Negative Skewness : If skewness < 0, data is negatively skewed. Another way to see negative skewness : Mean is less than median and median is less  than mode.
Rule :
If skewness < −1 or > +1, the distribution is highly skewed.
If skewness is between −1 and −0.5 or between 0.5 and +1, the distribution is moderately skewed.
If skewness > −0.5 and  <  0.5, the distribution is approximately symmetric or normal.
*/
ods select Moments;
proc univariate data = sashelp.shoes;
var sales;
run;
**if----> Since Skewness is greater than 1, it means data is highly skewed and non-normal.;


/* III. Normality Tests */
**The NORMAL keyword tells SAS to generate normality tests.;
ods select TestsforNormality;
proc univariate data = sashelp.shoes normal;
var sales;
run;
/*
The two main tests for normality are as follows :

1. Shapiro Wilk Test [Sample Size <= 2000]
It states that the null hypothesis - distribution is normal.
In the example above, p value is less that 0.05 so we reject the null hypothesis. It implies distribution is not normal. If p-value > 0.05, it implies distribution is normal.
This test performs well in small sample size up to 2000.

2. Kolmogorov-Smirnov Test [Sample Size > 2000]

In this test, the null hypothesis states the data is normally distributed.
If p-value > 0.05, data is normal. In the example above, p-value is less than 0.05, it means data is not normal.
This test can handle larger sample size greater than 2000.
*/


/* 5. Calculate Custom Percentiles */
**With PCTLPTS= option, we can calculate custom percentiles. Suppose you need to generate 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 percentiles.;
proc univariate data = sashelp.shoes noprint;
var sales;
output out = temp
pctlpts = 10 to 100 by 10 pctlpre = p_;
run;
**The OUTPUT OUT= statement is used to tell SAS to save the percentile information in TEMP dataset. The PCTLPRE= is used to
add prefix in the variable names for the variable that contains the PCTLPTS= percentile.;

* Suppose you want to calculate 97.5 and 99.5 percentiles.;
proc univariate data = sashelp.shoes noprint;
var sales;
output out = temp
pctlpts = 97.5,99.5 pctlpre = p_;
run; 

/* 6.  Calculate Winsorized and Trimmed Means */
/*
The Winsorized and Trimmed Means are insensitive to Outliers. They should be reported rather than mean when the data is highly skewed.

Trimmed Mean : Removing extreme values and then calculate mean after filtering out the extreme values. 10% Trimmed Mean means calculating 10th and 90th percentile values and removing values above these percentile values.

Winsorized Mean : Capping extreme values and then calculate mean after capping extreme values at kth percentile level. It is same as trimmed mean except removing the extreme values, we are capping at kth percentile level.

Winsorized Mean

In the example below, we are calculating 20% Winsorized Mean.
*/
ods select winsorizedmeans;
ods output winsorizedmeans=means;
proc univariate winsorized = 0.2 data=sashelp.shoes;
var sales;
run;
**Percent Winsorized in Tail : 20% of values winsorized from each tail (upper and lower side)
Number Winsorized in Tail : 79 values winsorized from each tail;


/*Trimmed Mean*/
**In the example below, we are calculating 20% trimmed Mean;
ods select trimmedmeans;
ods output trimmedmeans=means;
proc univariate trimmed = 0.2 data=sashelp.shoes;
var sales;
run;

/* 7. Calculate Sample T-test */
**It tests the null hypothesis that mean of the variable is equal to 0. The alternative hypothesis is that mean is not 
equal to 0. When you run PROC UNIVARIATE, it defaults generates sample t-test in 'Tests for Location' section of output.;
ods select TestsForLocation;
proc univariate data=sashelp.shoes;
var sales;
run;
**Since p-value is less than 0.05. we reject the null hypothesis. It concludes the mean value of the variable is 
significantly different from zero.;


/* 8. Generate Plots */
/*
PROC UNIVARIATE generates the following plots :
Histogram
Box Plot
Normal Probability Plot

The PLOT keyword is used to generate plots.
*/
proc univariate data=sashelp.shoes PLOT;
var sales;
run;
*****************************************END*********************************************************;





/* HOW DO I USE A SPSS DATA FILE IN SAS?  */
/*
1. Using SAS software
SAS 9.x supports SPSS data files (*.sav).  The following example shows how to use SAS proc import to read 
in a SPSS data file called hsb2.sav. It is advisable to check the log file and use proc contents to ensure 
the data have been read correctly. Notice that SAS recognizes the file type to be imported by file extension.
*/
proc import datafile = "c:\datahsb2.sav" out= work.hsb2;
run;
proc contents data=hsb2;
run;

/*
2. Using SPSS software
SPSS supports SAS data files and can easily save an SPSS file as a SAS file through the point and click interface or syntax.
Using the pull-down menus select File then Save As… and then for Save as type select an appropriate SAS format, 
e.g., select SAS v7+ Windows Long File Extension (*.sas7bdat) for Windows. Type the file name and click Save to save the SAS file.
To use SPSS syntax, use the save translate command as shown below.

save translate outfile='C:\datahsb2.sas7bdat'.
Data written to C:\datahsb2.sas7bdat.
11 variables and 200 cases written.
[output omitted for space]
Note that SPSS is also compatible with the following SAS extensions: (*.sd2), (*.sd7), (*.xpt) and (*.ssd01).

3. Stat/Transfer
Stat/Transfer can be used to convert SPSS data files into SAS data files, and doing this conversion is easy and straightforward.
*/




/* You can submit the X statement to exit your SAS session temporarily and gain access to the Windows command processor. 
The X statement has the following syntax: X <'command'>; The optional command argument is used either to issue an operating system command
 or to invoke a Windows application such as Notepad.  */

/* Data wrangling is the process of cleaning and unifying messy and complex data sets for easy access and analysis.  */





** PROC COMPARE **;
* Very useful to check database upgrade, data migration quality etc. **;
proc compare base=data1 comp=data2;
run;
**************************************;

/*
What is data _null_ in SAS?
In SAS, the reserved keyword _NULL_ specifies a SAS data set that has no observations and
 no variables. ... The _NULL_ data set is often used when you want to execute DATA step
 code that displays a result, defines a macro variable, writes a text file, or makes 
 calls to the EXECUTE subroutine.


A. The data _null_ does not produce a dataset.

It is used mainly for the following purposes :
1. To create macro variables with call symput
2. To create customized reports with PUT statements writing to external files.
*/




/* 6 ways to use the _NULL_ data set in SAS */
/*
In SAS, the reserved keyword _NULL_ specifies a SAS data set that has no observations and no variables. When you specify
_NULL_ as the name of an output data set, the output is not written. The _NULL_ data set is often used when you want to
execute DATA step code that displays a result, defines a macro variable, writes a text file, or makes calls to the
EXECUTE subroutine. In those cases, you are interested in the "side effect" of the DATA step and rarely want to write a
data set to disk. This article presents six ways to use the _NULL_ data set. Because the _NULL_ keyword is used, no data
set is created on disk.

#1. Use SAS as a giant calculator
You can compute a quantity in a DATA _NULL_ step and then use the PUT statement to output the answer to the SAS log.
For example, the following DATA step evaluates the normal density function at x-0.5 when μ=1 and σ=2. The computation
is performed twice: first using the built-in PDF function and again by using the formula for the normal density function.
The SAS log shows that the answer is 0.193 in both cases.
*/
data _NULL_;
mu = 1; sigma = 2; x = 0.5; 
pdf = pdf("Normal", x, mu, sigma);
y = exp(-(x-mu)**2 / (2*sigma**2)) / sqrt(2*constant('pi')*sigma**2);
put (pdf y) (=5.3);
run;

/*
#2. Display characteristics of a data set
You can use a null DATA step to display characteristics of a data set. For example, the following DATA step uses the
PUT statement to display the number of numeric and character variables in the Sashelp.Class data set. No data set is
created.
*/
data _NULL_;
set Sashelp.Class;
array char[*} $ _CHAR_;
array num[*} _NUMERIC_;
nCharVar  = dim(char);
nNumerVar = dim(num);
put "Sashelp.Class: " nCharVar= nNumerVar= ;
stop;   /* stop processing after first observation */
run;

/*
#3. Create a macro variable from a value in a data set
You can use the SYMPUT or SYMPUTX subroutines to create a SAS macro variable from a value in a SAS data set. For example,
suppose you run a SAS procedure that computes some statistic in a table. Sometimes the procedure supports an option to
create an output data that contains the statistic. Other times you might need to use the ODS OUTPUT statement to write
the table to a SAS data set. Regardless of how the statistic gets in a data set, you can use a DATA _NULL_ step to read
the data set and store the value as a macro variable.

The following statements illustrate this technique. PROC MEANS creates a table called Summary, which contains the means
of all numerical variables in the Sashelp.Class data. The ODS OUTPUT statement writes the Summary table to a SAS data set
called Means. The DATA _NULL_ step finds the row for the Height variable and creates a macro variable called MeanHeight
that contains the statistic. You can use that macro variable in subsequent steps of your analysis.
*/
proc means data=Sashelp.Class mean stackods;
   ods output Summary = Means;
run;
 
data _NULL_;
set Means;
/* use PROC CONTENTS to determine the columns are named Variable and Mean */
if Variable="Height" then             
   call symputx("MeanHeight", Mean);
run;
 
%put &=MeanHeight;

/*
#4. Create macro variable from a computational result
Sometimes there is no procedure that computes the quantity that you want, or you prefer to compute the quantity yourself.
The following DATA _NULL_ step counts the number of complete cases for the numerical variables in the Sashelp.Heart data.
It then displays the number of complete cases and the percent of complete cases in the data. You can obtain the same
results if you use PROC MI and look at the MissPattern table
*/
data _NULL_;
set Sashelp.Heart end=eof nobs=nobs;
NumCompleteCases + (nmiss(of _NUMERIC_) = 0); /* increment if all variables are nonmissing */
if eof then do;                               /* when all observations have been read ... */
   PctComplete = NumCompleteCases / nobs;     /* ... find the percentage */
   put NumCompleteCases= PctComplete= PERCENT7.1;
end;
run;

/*
#5. Edit a text file or ODS template "on the fly"
This is a favorite technique of Warren Kuhfeld, who is a master of writing a DATA _NULL_ step that modifies an ODS
template. In fact, this technique is at the heart of the %MODSTYLE macro and the SAS macros that modify the Kaplan-Meier
survival plot.

Although I am not as proficient as Warren, I wrote a blog post that introduces this template modification technique.
The DATA _NULL_ step is used to modify an ODS template. It then uses CALL EXECUTE to run PROC TEMPLATE to compile the
modified template.
*/


/*
#6. A debugging tool
All the previous tips use _NULL_ as the name of a data set that is not written to disk. It is a curious fact that you can
use the _NULL_ data set in almost every SAS statement that expects a data set name!

For example, you can read from the _NULL_ data set. Although reading zero observations is not always useful, one
application is to check the syntax of your SAS code. Another application is to check whether a procedure is installed
on your system. For example, you can run the statements PROC ARIMA data=_NULL_; quit; to check whether you have access
to the ARIMA procedure.

A third application is to use _NULL_ to suppress debugging output. During the development and debugging phase of your
development, you might want to use PROC PRINT, PROC CONTENTS, and PROC MEANS to ensure that your program is working as
intended. However, too much output can be a distraction, so sometimes I direct the debugging output to the _NULL_ data
set where, of course, it magically vanishes! For example, the following DATA step subsets the Sashelp.Cars data.
I might be unsure as to whether I created the subset correctly. If so, I can use PROC CONTENTS and PROC MEANS to
display information about the subset, as follows:
*/
data Cars;
set Sashelp.Cars(keep=Type _NUMERIC_);
if Type in ('Sedan', 'Sports', 'SUV', 'Truck'); /* subsetting IF statement */
run;
 
/* FOR DEBUGGING ONLY */
%let DebugName = Cars;  /* use _NULL_ to turn off debugging output */
proc contents data=&DebugName short;
run;
proc means data=&DebugName N Min Max;
run;

/*
If I don't want to this output (but I want the option to see it again later), I can modify the DebugName macro 
(%let DebugName = _NULL_;) so that the CONTENTS and MEANS procedures do not produce any output. If I do that and
rerun the program, the program does not create any debugging output. However, I can easily restore the debugging output
whenever I want.

Summary
In summary, the _NULL_ data set name is a valuable tool for SAS programmers. You can perform computations, create
macro variables, and manipulate text files without creating a data set on disk. Although I didn't cover it in this
article, you can use DATA _NULL_ in conjunction with ODS for creating customized tables and reports.
*/










/* Understanding functions like countW and scan. Creating microvariable, and also understanding array and do loop concept */
var="ab ac ad ae an go"; ************Input***;

var1="ab"; var2="ac"; var3="ad"; var4="ae"; var5="an"; var6="go";   **** Output needed**;


/* Scan Function */
data have;
name= "Smith John King Ring Ming";
run;

data want;
set have;
first_name=scan(name,1," ");
last_name=scan(name,2," ");
_2last=scan(name,4," ");
run;
proc print data=want;
run;


data have;
length string $50.;
input string & $;
datalines;
ab ac ad ae an go
ab ac
ab ac ad
ab ac ac ae
;
run;

data want;
set have;
count_of_words_by_delimiter= countW(string," ");
run;

proc print ;
run;

/* Macrovariable creation */
proc sql;
	select max(countW(string," ")) into :maxcount
	from have;
%put value with maximum words &maxcount;

proc sql;
	select cats("value", max(countw(string," "))) into :maxcountvar
	from have;
%put concatenated value is &maxcountvar;

/* Array and Do Loop */
data abc;
input num1 num2 num3;
datalines;
10 15 20
100 150 200
;
run;

data new;
set abc;
array new(3) num1 num2 num3;
do i=1 to 3;
new(i)=new(i) + 50;
end;
drop i;
run;

/* Array -just different way */
data new;
set abc;
array new(*) num1-num3;
do i=1 to dim(new);
new(i)=new(i) + 50;
end;
drop i;
run;


/* Array -creating new variables */
data define_Multi_columns;
array hum(*) $ char1-char10;
run;


/* Bringing it together -for dataset */
data have;
length idnum 8. string1 $100;
input idnum string1 & $;
datalines;
100 mangoes oranges apples
200 mangoes banana jackfruits apples Mulberry
300 Peach pear Pineapple plum Pomegranate Raisins Naseberry
400 Lychee mango Mangosteen Marionberry
500 Melon Cataloupe Honeydew Watermelon 
600 Miracle Honeydew
700 Mulberry
800 Nectarine
;
run;

/* First Step */
proc sql;
	select cats("fruit", max(countW(string1," "))) into: maxfruit
	from have;
%put &maxfruit;


/* Final Step */
data want;
set have;
length fruit-&maxfruit $15.;
array fruit[*] $ fruit1-&maxfruit;
do i = 1 to countw(string1, " "); 
fruit[i] = scan(string, i, " ");
end;
drop i string1;
run;
*****************************************************;






/* we have to create 10 variable of equal length by single variable which has longer length. */
data test (keep=words);
a="abcdefghijklmnopqrstuvxyzpqrs";
do j=1 to 30 by 3;
words=substr(a,j,3);
output;
end;
run;
proc print;
run;

proc transpose data=test prefix=var out=test1 (drop=_name_);
var word;
run;
proc print;
run;
**************************************************;





/*
INFILE is a data step statement. Like INPUT, PUT, IF, etc. You can use PROC IMPORT to 
convert data in various forms into SAS datasets. ... If you use PROC IMPORT to read a 
delimited file then the procedure will make decisions about how to interpret the file.
*/


/*
IF statement cannot be used outside data step whereas %IF can be used outside and inside
 data step but within the macro.
*/



/*
Both SYMPUT and SYMPUTX convert the value to character before assigning to a macro 
variable. SYMPUT gives you a message on the log about the conversion, while SYMPUTX 
does not. SYMPUTX takes the additional step of removing any leading blanks that were 
caused by the conversion.
*/


/*
MISSOVER Sets all empty vars to missing when reading a short line. However, it can also 
skip values. STOPOVER Stops the DATA step when it reads a short line. TRUNCOVER Forces 
the INPUT statement to stop reading when it gets to the end of a short line.
*/
/*
Missover- whenever reading short line its sets missing to empty vars and it can also skip 
values.
Turncover- it force the input statement to stop reading when it gets to the end of a 
short line.
*/


/* Replace Missing Values with Zero */
data Miss_Values;
input ID$ var1 var2 var3;
datalines;
1 . 3 4 
2 2 0 .
3 . . 3
4 . 8 .
5 5 . .
;
/* SAS Data Step Method Example */
data DataStepMethod;
   set Miss_Values;
   array NumVar _numeric_;
   do over NumVar;
      if NumVar=. then NumVar=0;
   end;
run;

/* PROC STDIZE Method Example */
proc stdize data=Miss_Values out=ProcStdizeMethod reponly missing=0;
run;
proc stdize data=Miss_Values out=StdizeMethod_Var reponly missing=0;
  var var1;
run;

/*
Difference between real time and CPU time.
Real Time is the actual, real world, time that the step takes to run and will be the 
same as if you timed it with a stopwatch (not possible as you won't know the precise 
moment the step starts and stops). CPU Time is the amount of time the step utilises CPU 
resources.
*/


/* With the %SYMDEL Statement  */
**we delete the macro variable with the %SYMDEL statement.;

%let my_macro_var = My Macro Variable;
%put &amp;=my_macro_var.;
 
%symdel my_macro_var;
 
%put &amp;=my_macro_var.;

/* With the CALL SYMDEL routine  */
**we use the CALL SYMDEL routine in a data_null_ step to delete this macro variable.;
%let my_macro_var = My Macro Variable;
%put &amp;=my_macro_var.;
 
data _null_;
	call symdel("my_macro_var");
run;
 
%put &amp;=my_macro_var.;




/*
*** PUTC AND PUTN ***
formatted-val=PUTC(char-val,format);
formatted-val=PUTN(num-val,format);

format
is the character format to apply with PUTC or the numeric format to apply with PUTN. Format can be an SCL variable or a character literal.

Example 1: Using the PUTC Function
Format the value that a user enters into the text entry control named VALUE:

MAIN:
   value=putc(value,'$QUOTE.');
   put value=;
return;
Entering SAS into the field displays "SAS" in the field and produces the following output:

VALUE="SAS"

Example 2: Using the PUTN Function
Format the variable NETPD using the DOLLAR12.2 format, and store the value in the variable SALARY.

INIT:
   netpd=20000;
   put netpd=;
   fmt='dollar12.2';
   salary=putn(netpd,fmt);
   put salary=;
return;
This program produces the following output:

NETPD=20000
SALARY=  $20,000.00

****************************;









************************************************************;
/*
- Diffrence between implicit and explicit pass through query?
explicit pass through query is nothing but when we connect to the data base the query 
which hits the database and make the required modifications in the db and imports the 
data. Here the total execution takes place in db.

when we code explicit pass through query the sas functions wont work. for example we are
connecting to oracle we have to write oracle functions only.
*/
Proc sql;
connect to oracle (user=XXX password=XXX);
select * from connection to oracle
(select * from table);
disconnect from oracle;
quit;

/*
in implicit pass through query the execution takes place in sas server itself and imports the data.
*/
proc sql;
select * from table
where condition;
quit;
/*
or
Libname libref "path";
*/



/*
**** SAS SQL : FIND RECORDS ONLY EXIST IN ONE TABLE BUT NOT OTHER ****
It is one of the most common data manipulation problem to find records that exist only in table 1 but not in table 2. This post includes 3 methods with PROC SQL and 1 method with data step to solve it. This problem statement is also called 'If a and not b' in SAS. It means pull records that exist only in Table A but not in Table B (Exclude the common records of both the tables).
*/
data dataset1;
input name $;
cards;
Dave
Ram
Sam
Matt
Priya
;
run;
data dataset2;
input name$;
cards;
Ram
Priya
;
run;


/*
Method I - NOT IN Operator

The simplest method is to write a subquery and use NOT IN operator, It tells system not to include records from dataset 2.
*/
proc sql;
select * from dataset1
where name not in (select name from dataset2);
quit;

/*
Method II - LEFT JOIN with NULL Operator

In this method, we are performing left join and telling SAS to include only rows from table 1 that do not exist in table 2.
*/
proc sql;
select a.name from dataset1 a
left join dataset2 b
on a.name = b.name
where b.name is null;
quit;

/*
How it works -
In the first step, it reads common column from the both the tables - a.name and b.name. At the second step, these columns are matched and then the b.name row will be set NULL or MISSING if a name exists in table A but not in table B. At the next step, WHERE statement with 'b,name is null' tells SAS to keep only records from table A.

Method III -  Not Exists Correlated SubQuery

NOT EXISTS subquery writes the observation to the merged dataset only when there is no matching rows of a.name in dataset2. This process is repeated for each rows of variable name.
*/
proc sql;
select a.name from
dataset1 a
where not exists (select name from dataset2 b
where a.name = b.name);
quit;
/*
How it works -

Step 1 - At the background, it performs left join of the tables -
*/
proc sql;
create table step1 as
select a.* from dataset1 a
left join dataset2 b
on a.name = b.name;
quit;

/*
Step 2 - At the next step, it checks common records by applying INNER JOIN
*/
proc sql;
create table step2 as
select a.name from dataset1 a, dataset2 b
where a.name = b.name;
quit;

/*
Step 3 - At the last step, it excludes common records.
*/
proc sql;
select * from step1
where name not in (select distinct name from step2) ;
quit;

/*
Method IV : SAS Data Step MERGE Statement

In SAS Data Step, it is required to sort tables by the common variable before merging them. Sorting can be done with PROC SORT.
*/
proc sort data = dataset1;
by name;
run;
proc sort data = dataset2;
by name;
run;
Data finaldata;
merge dataset1 (in=a) dataset2(in=b);
by name;
if a and not b;
run;
/*
The MERGE Statement joins the datasets dataset1 and dataset2 by the variable name.

Q. Which is the most efficient method?

To answer this question, let's create two larger datasets (tables) and compare the 4 methods as explained above.

Table1 - Dataset Name : Temp, Observations - 1 Million, Number of Variables - 1

Table2 - Dataset Name : Temp2, Observations - 10K, Number of Variables - 1

Result
SAS Dataset MERGE (Including prior sorting) took least time (1.3 seconds) to complete this operation, followed by NOT IN operator in subquery which took 1.4 seconds and then followed by LEFT JOIN with WHERE NULL clause (1.9 seconds). The NOT EXISTS took maximum time.
*/

***Proc Rank ****;
data temp;
input ID Gender $ Score;
cards;
1 M 33
2 M 94
3 M 66
4 M 46
5 F 92
6 F 95
7 F 18
8 F 11
;
run;
/*
Notes :  
1. The OUT option is used to store output of the rank procedure.
2. The VAR option is used to specify numeric variable (s) for which you want to calculate rank
3. The RANKS option tells SAS to name the rank variable
4. By default, it calculates rank in ascending order.

Reverse order of ranking (Descending)
*/
proc rank data= temp descending out = result;
var Score;
ranks ranking;
run;

/*
Percentile Ranking (Quartile Rank)

Suppose you need to split the variable into four parts, you can use the groups option in PROC RANK. It means you are telling SAS to assign only 4 ranks to a variable.
*/
proc rank data= temp descending groups = 4 out = result;
var Score;
ranks ranking;
run;

/*
Ranking within BY group (Gender)

Suppose you need to calculate rank by a grouping variable. To accomplish this task, you can use the by statement in proc rank. It is required to sort the data before using by statement.
*/
proc sort data = temp;
by gender;
run;
proc rank data= temp descending out = result;
var Score;
ranks ranking;
by Gender;
run;

/*
How to compute rank for same values

Let's create a sample dataset. See the variable score having same values (33 appearing twice).
*/
data temp2;
input ID Gender $ Score;
cards;
1 M 33
2 M 33
3 M 66
4 M 46
;
run;

**Specify option TIES = HIGH | LOW | MEAN | DENSE in PROC RANK.**;
proc rank data= temp2 ties = dense out = result;
var Score;
ranks rank_dense;
run;
*****************************************;



/*
Difference between + opereator and sum function?
What is the difference between '+' operator and SUM function? SUM function returns the 
sum of non-missing arguments whereas “+” operator returns a missing value if any of the 
arguments are missing.
*/


