
/*
Comparto mi sintaxis en el manejo de la Encuesta Nacional de Hogares (ENAHO) modulo 1,2,3, 5 y Sumaria. 
*/



* Ruta
*-------------
global ruta "C:\Users\JOSE\Desktop\Daniel OSIPTEL\Doc_trabajo\Bases"
cd "$ruta"


*------------------------
* A nivel personas
*------------------------

*- Mod 1 (Hogares)
use enaho01-2021-100.dta , clear
rename a*o anio

*- Merge con el mod sumaria
merge 1:1 conglome vivienda hogar using sumaria-2021.dta
keep if _m==3
drop _merge

*- Merge con el mod 2 (Personas)
merge 1:m conglome vivienda hogar using "enaho01-2021-200.dta" 
drop _merge

*- Eliminamos a las personas "PANEL"
drop if p203==0

*- Merge mod 3 (Educacion)
merge 1:1 conglome vivienda hogar  codperso using "enaho01a-2021-300.dta" 
drop _merge

*- Merge mod 5 (Empleo e ingresos)
merge 1:1 conglome vivienda hogar  codperso using "enaho01a-2021-500.dta" 
drop _merge


*- Save

save "enaho2021_personas.dta" , replace

*----------------------------- Variables sociodemograficas

use "enaho2021_personas.dta" , clear


*Area

gen            area=estrato
recode         area (1/5=1) (6/8=0)
lab def        area 1 "Urbana" 0 "Rural", modify
lab val        area area
lab var        area "Area de residencia"


*Departamanto  (Sin Callao)

gen     dpto= real(substr(ubigeo,1,2))
replace dpto=15 if (dpto==7)
label define dpto 1"Amazonas" 2"Ancash" 3"Apurimac" 4"Arequipa" 5"Ayacucho" 6"Cajamarca" 8"Cusco" 9"Huancavelica" 10"Huanuco" 11"Ica" 12"Junin" 13"La_Libertad" 14"Lambayeque" 15"Lima" 16"Loreto" 17"Madre_de_Dios" 18"Moquegua" 19"Pasco" 20"Piura" 21"Puno" 22"San_Martin" 23"Tacna" 24"Tumbes" 25"Ucayali" 
lab val dpto dpto 


* Genero
recode p207 (1=1 "Hombre") (2=0 "Mujer") , g(gender)


* Edad 
gen age=p208a

* Edad 12 - 32
gen age_12_32=0 if age!=.
replace age_12_32=1 if age>=12 & age<=32

* Edad 33 - 64
gen age_33_64=0 if age!=.
replace age_33_64=1 if age>=33 & age<=64

* Edad 65 a mas
gen age_65_over=0 if age!=.
replace age_65_over=1 if age>=65 & age<=200


* Studen (ENAHO Mod3 : Este ultimo año esta matriculado en algun cnetro o programa de educacion basica o superior)

recode p306 (1=1 "Si") (2=0 "No") , g(student)


* Categoria ocupacional

recode p507 (1=1 "Empleador") (2=2 "Trabajador cuenta propia") (3/4=3 "Dependiente") (5/7=4 "Trabajador del hogar") , g(cate_ocup)


* Trabajador dependiente

gen trab_depen=0 if p507!=.
replace trab_depen=1 if cate_ocup==3


* Trabajador Independiente
gen trab_indepen=0 if p507!=.
replace trab_indepen=1 if cate_ocup==2

**** Nivel educativo

gen education=0 if p301a!=.

replace education=1 if p301a==1 | p301a==2 | p301a==3 | p301a==12 | p301a==4
replace education=2 if p301a==5 | p301a==6 
replace education=3 if p301a==7 | p301a==8	
replace education=4 if p301a==9 | p301a==10 | p301a==11

lab def        education 1 "Primaria" 2 "Secundaria" 3 "Superior no universitaria" 4 "Superior universitaria", modify

lab val        education education
lab var        education "Nivel educativo"

*--

g educ_primary=0 if education!=.
replace educ_primary=1 if education==1

g educ_secondary=0 if education!=.
replace educ_secondary=1 if education==2

g educ_technical_or_more=0 if education!=.
replace educ_technical=1 if education==3 | education==4

*--- Numero de miembros por hogar

recode p204 (2=0 "No") (1=1 "Si") , g(member)
egen num_member=total(member) , by(conglome vivienda hogar)

*----Numero de miembros del hogar menores de edad (<18)

clonevar member_kid=member 
replace member_kid=0 if age>17

egen num_member_kid=total(member_kid) , by(conglome vivienda hogar)

*----Numero de miembros del hogar ancianos (64>)

clonevar member_old=member 
replace member_old=0 if age<65

egen num_member_old=total(member_old) , by(conglome vivienda hogar)

*----- Lengua materna

gen      lengua=1 if p300a==4
replace  lengua=2 if p300a<4
replace  lengua=3 if p300a>5
lab def  lengua 1 "Castellano" 2 "Indígena" 3 "Otros", modify
lab val  lengua lengua

*-- Lengua indigena
 
gen leng_indige=0 if  lengua!=.
replace leng_indige=1 if lengua==2

*-- Numero de habitaciones (Sin contar baño y cocina)

clonevar num_habitaciones=p104 

*-- Genero del jefe de hogar

by conglome vivienda hogar : g gender_jh=1 if p207==1 & p203==1

by conglome vivienda hogar : replace gender_jh=2 if p207==2 & p203==1

replace gender_jh=gender_jh[_n-1] if missing(gender_jh) 

*-- Año de educacion de los individuos

gen años_educ=p301b

replace años_educ=0 if p301a==1 | p301a==2
recode  años_educ (1=1) (2=2) (3=3) (4=4)               if p301a==3
recode  años_educ (5=5) (6=6)                           if p301a==4
recode  años_educ (1=7) (2=8) (3=9) (4=10)              if p301a==5
recode  años_educ (5=11)(6=12)                          if p301a==6
recode  años_educ (1=12)(2=13)(3=14)(4=15)              if p301a==7
recode  años_educ (3=14)(4=15)(5=16)                    if p301a==8
recode  años_educ (1=12)(2=13)(3=14)(4=15)(5=16)(6=17) if p301a==9
recode  años_educ (4=15)(5=16)(6=17)(7=18)              if p301a==10
recode  años_educ (1=17)(2=18)                          if p301a==11

g      educ_grade=p301c
recode educ_grade (0=1)
replace años_educ=educ_grade if p301b==0 & p301a!=2

label value años_educ años_educ
label variable años_educ "Año de educacion"

*- Años de educacion del Jefe de hogar

by conglome vivienda hogar : g años_educ_jh=años_educ if p203==1

replace años_educ_jh=años_educ_jh[_n-1] if missing(años_educ_jh) 


*- Estado civil del jefe de hogar

recode p209 (1/2=1 "Unidas-Unidos") (3/5=3 "Alguna vez unidas-unidos") (6=2 "Solteras-Solteros") ,  g(estado_conyugal)

*- Segun INEI
by conglome vivienda hogar : g estado_conyugal_jh=estado_conyugal if p203==1

replace estado_conyugal_jh=estado_conyugal_jh[_n-1] if missing(estado_conyugal_jh) 


*- Segun paper

by conglome vivienda hogar : g estado_conyugal_jh_paper=estado_conyugal if p203==1 & p209==2 // Casado

by conglome vivienda hogar : replace estado_conyugal_jh_paper=0 if p203==1 & p209!=2 // Otro


replace estado_conyugal_jh_paper=estado_conyugal_jh_paper[_n-1] if missing(estado_conyugal_jh_paper) 


*- Region (Costa, sierra, Selva)

gen     region=1 if dominio>=1 & dominio<=3 
replace region=1 if dominio==8
replace region=2 if dominio>=4 & dominio<=6 
replace region=3 if dominio==7 
label define region 1 "Costa" 2 "Sierra" 3 "Selva"

*- Costa
gen costa=0 if region!=.
replace costa=1 if region==1

*- Sierra
gen sierra=0 if region!=.
replace sierra=1 if region==2

*- Selva
gen selva=0 if region!=.
replace selva=1 if region==3

save "calc_enaho2021_personas.dta" , replace



*============================
*============================
*============================
*============================




*============================
*--- A  nivel de hogares
*===========================

use "calc_enaho2021_personas.dta" , clear

*- Nos quedamos con el Jefe de hogar

keep if p203==1

save "calc_enaho2021_hogares.dta" , replace

use calc_enaho2021_hogares.dta  , clear
gen identh= anio+ conglome+ vivienda+ hogar
merge 1:1 identh using base_pobre_multi2021.dta


*Base de datos por Hogares
*llevar hogares a personas
gen facpobmie=factor07*mieperho


*- Pobreza multi dimensional
tab pobreza_multi [iw=facpobmie]
tab dpto pobreza_multi [iw=facpobmie]
tab dpto pobreza_multi [iw=facpobmie], nofreq row

*usando el comando svyset para obtener el error estandar y el intervalo de confianza

svyset [pweight=facpobmie], psu(conglome) strata(estrato)
svy:mean pobreza_multi


***************************************** FIN :D
