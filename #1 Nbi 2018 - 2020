
/* 
A continuación, comparto la sintaxis para estimar las necesidades básicas insatisfechas (NBI) utilizando la 
Encuesta Nacional de Hogares (ENAHO) de los años 2017, 2018 y 2021 en el software STATA. Las NBI se basan en un conjunto 
de indicadores que evalúan las condiciones de los hogares en términos de necesidades básicas estructurales, 
como vivienda, educación, salud e infraestructura pública.
*/
*===================================================================================

global ruta "C:\Users\JOSE\Downloads\Graficos Nbi\BD"

/*
nbi1: Poblacion en Viviendas con Características Físicas Inadecuadas

nbi2: Poblacion en Viviendas con Hacinamiento

nbi3: Poblacion en Viviendas sin Desagüe de ningún Tipo

nbi4: Poblacion en hogares con Niños (6 a 12 años) que No Asisten a la Escuela

nbi5: Poblacion en hogares con Alta Dependencia Económica

Las variables ya se encuentran elaboradas en el modulo 100 de la ENAHO. 
*/

* Se usa el modulo 1 y modulo 34

*2018
cd "$ruta\2018"
use enaho01-2018-100.dta, clear

*2019
cd "$ruta\2019"
use enaho01-2019-100.dta, clear

*2020
cd "$ruta\2020"
use enaho01-2020-100.dta, clear


/* result: resultado final de la encuesta 
1: completa 
2: incompleta 
3: rechazo 
4: ausente 
5: vivienda desocupada 
6: otro 
*/

*Se trabaja solo con las encuestas completas e incompletas (>2)
drop if result>2

*NECESIDADES BASICAS INSATISFECHAS (ya se encuentran en el modulo 100)
sum nbi*

collapse (mean) nbi1 nbi2 nbi3 nbi4 nbi5, by(conglome vivienda hogar) 


*Juntamos el modulo 100 con el modulo sumaria 
*(ambas bases presentan informacion a nivel del hogar)

*2018
merge 1:1  conglome vivienda hogar using  sumaria-2018.dta, nogenerate

*2019
merge 1:1  conglome vivienda hogar using  sumaria-2019.dta, nogenerate

*2020
merge 1:1  conglome vivienda hogar using  sumaria-2020.dta, nogenerate



*Creamos la variable factor de expansion de la poblacion
gen    facpob=factor07*mieperho

*Establecemos las caracteristicas de la encuesta 
*usando las variable factor de expansion, conglomerado y estrato
svyset [pweight=facpob], psu(conglome) strata(estrato)


gen        nbihog=nbi1 + nbi2 + nbi3 + nbi4 + nbi5

gen    		 NBI1_POBRE=.
replace 	 NBI1_POBRE=1 if nbihog>0
replace		 NBI1_POBRE=0 if nbihog==0

label define NBI1_POBRE 0 "ninguna NBI" 1 "al menos un NBI"
label value  NBI1_POBRE NBI1_POBRE
label var    NBI1_POBRE "Con al menos una NBI"

tab          NBI1_POBRE 

gen    		 NBI2_POBRE=.
replace		 NBI2_POBRE=1 if nbihog>1
replace		 NBI2_POBRE=0 if nbihog<2

label define NBI2_POBRE 0 "menos de dos NBI" 1 "al menos dos NBI"
label value  NBI2_POBRE NBI2_POBRE
label var    NBI2_POBRE "Con al menos dos NBI"
tab          NBI2_POBRE


*VARIABLES GEOGRAFICAS

* Area
gen                area=estrato
recode           area (1/5=1) (6/8=2)
label define   area 1 "urbano" 2 "rural"
label values   area area

* Region Natural
gen     regnat=1 if dominio<=3 | dominio==8
replace regnat=2 if dominio>=4 & dominio<=6
replace regnat=3 if dominio==7

lab var regnat "Region natural"
lab def regnat 1 "Costa" 2 "Sierra" 3 "Selva"
lab val regnat regnat

* Departamento
destring ubigeo, generate(dpto)
replace dpto=dpto/10000
replace dpto=round(dpto)
recode dpto (7=15) //Juntamos Lima y Callao
label variable dpto "Departamento"
label define dpto 1 "Amazonas"
label define dpto 2 "Ancash", add
label define dpto 3 "Apurimac", add
label define dpto 4 "Arequipa", add
label define dpto 5 "Ayacucho", add
label define dpto 6 "Cajamarca", add
*label define dpto 7 "callao", add
label define dpto 8 "Cusco", add
label define dpto 9 "Huancavelica", add
label define dpto 10 "Huanuco", add
label define dpto 11 "Ica", add
label define dpto 12 "Junin", add
label define dpto 13 "La_Libertad", add
label define dpto 14 "Lambayeque", add
label define dpto 15 "Lima", add
label define dpto 16 "Loreto", add
label define dpto 17 "Madre_de_Dios", add
label define dpto 18 "Moquegua", add
label define dpto 19 "Pasco", add
label define dpto 20 "Piura", add
label define dpto 21 "Puno", add
label define dpto 22 "San_Martin", add
label define dpto 23 "Tacna", add
label define dpto 24 "Tumbes", add
label define dpto 25 "Ucayali", add
label values dpto dpto


*Cambiamos el nombre de la variable año a anio para evitar errores
rename a*o anio

* 
label var nbi1 "Poblacion en viviendas con caracteristicas fisicas inadecuadas"
label var nbi2 "Poblacion en viviendas con hacinamiento"
label var nbi3 "Poblacion en viviendas sin desague de ningun tipo"
label var nbi4 "Poblacion en hogares con ninos (6 a 12) que no asisten a la escuela"
label var nbi5 "Poblacion en hogares con alta dependencia economica"
label var NBI1_POBRE "Con al menos una NBI"
label var NBI2_POBRE "De 2 a 5 NBI"


*outreg

svy: mean nbi1 nbi2 nbi3 nbi4 nbi5

svy: mean NBI1_POBRE 

svy: mean NBI1_POBRE , over(area)

svy: mean NBI1_POBRE , over(regnat)

*** % DE POBLACION CON AL MENOS UNA NBI POR DEPARTAMENTO

svy: mean NBI1_POBRE , over(dpto)



* ###########################################
* ###########################################
* ###########################################

* GRAFICOS

* ###########################################
* ###########################################
* ###########################################



* GRAFICO DE PERDIDA DE BIENESTAR CON NBI POR REGIONES
/*
AMAZONAS		AMZ
ANCASH			ANC
APURIMAC		APC
AREQUIPA		AQP
AYACUCHO		AYA
CAJAMARCA		CJM
CUSCO			CUS
HUANCAVELICA	HVC
HUANUCO			HCO
ICA				ICA
JUNIN			JUN
LA LIBERTAD		LAL
LAMBAYEQUE		LBY
LIMA			LIM
LORETO			LOR
MADRE DE DIOS	MDD
MOQUEGUA		MOQ
PASCO			PAS
PIURA			PIU
PUNO			PUN
SAN MARTIN		SNM
TACNA			TAC
TUMBES			TUM
UCAYALI			UCY
*/


***************************
** ESTANDARIZADO
***************************
* Tema de los graficos
net install gr0070.pkg  
set scheme plotplainblind

*************************** TMV
***********************************************

*Directorio

global ruta_graf "C:\Users\JOSE\Downloads\Graficos Nbi"

cd "$ruta_graf"

import excel "$ruta_graf\Cuadros_estandarizado_pasado.xlsx", sheet("Cuadro3_TMV Regiones") firstrow clear


keep ID_reg ID_reg2 C  Per_dif2018 Per_dif2019 Per_dif2020 acum_dif acum_dif_s

save E_tmv_reg.dta , replace

use E_tmv_reg.dta ,clear
merge 1:1 ID_reg2 using "nbi.dta"


***2018

g Per_dif2018_i=int(Per_dif2018/1000)   // En miles de soles

scatter Per_dif2018_i nbi_2018 , mcolor(eltblue) msize(0.5) ///
mlabel(C) mlabcolor(eltblue) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(20)140 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) ///
ytitle("Cuantifiacion de la perdida de bienestar" "(en miles de soles)",size(*0.8))	///
title("Grafico por regiones TMV estandarizado por diez mil lineas" "2018", size(*0.8))

** 2019

g Per_dif2019_i=int(Per_dif2019/1000)   // En miles de soles

scatter Per_dif2019_i nbi_2019 , mcolor(eltblue) msize(0.5) /// 
mlabel(C) mlabcolor(eltblue) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(20)200 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en miles de soles)",size(*0.8))														///
title("Grafico por regiones TMV estandarizado por diez mil lineas" "2019", size(*0.8))

**2020
g Per_dif2020_i=int(Per_dif2020/1000)   // En miles de soles

scatter Per_dif2020_i nbi_2020 , mcolor(eltblue) msize(0.5) /// 
mlabel(C) mlabcolor(eltblue) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(50)450 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en miles de soles)",size(*0.8))														///
title("Grafico por regiones TMV estandarizado por diez mil lineas" "2020", size(*0.8))



*************************** TMI 
***********************************************
import excel "$ruta_graf\Cuadros_estandarizado_pasado.xlsx", sheet("Cuadro7_TMI Regiones") firstrow clear




keep ID_reg ID_reg2 C  Per_dif2018 Per_dif2019 Per_dif2020 acum_dif acum_dif_s

save E_tmi_reg.dta , replace

use E_tmi_reg.dta ,clear
merge 1:1 ID_reg2 using "nbi.dta"



***2018

g Per_dif2018_i=int(Per_dif2018/1000)   // En miles de soles

scatter Per_dif2018_i nbi_2018 , mcolor(orange) msize(0.5) /// 
mlabel(C) mlabcolor(orange) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(20)120 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en miles de soles)",size(*0.8))														///
title("Grafico por regiones TMI estandarizado por diez mil lineas" "2018", size(*0.8))

** 2019

g Per_dif2019_i=int(Per_dif2019/1000)   // En miles de soles

scatter Per_dif2019_i nbi_2019 , mcolor(orange) msize(0.5) /// 
mlabel(C) mlabcolor(orange) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(20)100 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en miles de soles)",size(*0.8))														///
title("Grafico por regiones TMI estandarizado por diez mil lineas" "2019", size(*0.8))

**2020
g Per_dif2020_i=int(Per_dif2020/1000)   // En miles de soles

scatter Per_dif2020_i nbi_2020 , mcolor(orange) msize(0.5) /// 
mlabel(C) mlabcolor(orange) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(50)400 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en miles de soles)",size(*0.8))														///
title("Grafico por regiones TMI estandarizado por diez mil lineas" "2020", size(*0.8))


*************************** IF
***********************************************

import excel "$ruta_graf\Cuadros_estandarizado_pasado.xlsx", sheet("Cuadro11_IF Regiones") firstrow clear




keep ID_reg ID_reg2 C  Per_dif2018 Per_dif2019 Per_dif2020 acum_dif acum_dif_s

save E_if_reg.dta , replace

use E_if_reg.dta ,clear
merge 1:1 ID_reg2 using "nbi.dta"




***2018

g Per_dif2018_i=int(Per_dif2018/1000)   // En miles de soles

scatter Per_dif2018_i nbi_2018 , mcolor(blue) msize(0.5) /// 
mlabel(C) mlabcolor(blue) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(100)1550 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en miles de soles)",size(*0.8))														///
title("Grafico por regiones IF estandarizado por mil conexiones" "2018", size(*0.8))

** 2019
g Per_dif2019_i=int(Per_dif2019/1000)   // En miles de soles

scatter Per_dif2019_i nbi_2019 , mcolor(blue) msize(0.5) /// 
mlabel(C) mlabcolor(blue) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(10)40 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en miles de soles)",size(*0.8))														///
title("Grafico por regiones IF estandarizado por mil conexiones" "2019", size(*0.8))

**2020
destring Per_dif2020 ,g (Per_dif2020_)
g Per_dif2020_i=int(Per_dif2020_/1000)   // En miles de soles

scatter Per_dif2020_i nbi_2020 , mcolor(blue) msize(0.5) /// 
mlabel(C) mlabcolor(blue) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(20)160 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en miles de soles)",size(*0.8))														///
title("Grafico por regiones IF estandarizado por mil conexiones" "2020", size(*0.8))



***************************
** SIN ESTANDARIZAR
***************************

*************************** TMV
***********************************************

import excel "$ruta_graf\Cuadros_sinestandaruzar.xlsx", sheet("Cuadro3_TMV Regiones") firstrow clear

keep ID_reg ID_reg2 C  Per_dif2018 Per_dif2019 Per_dif2020 acum_dif acum_dif_s

save SE_tmv_reg.dta , replace

use SE_tmv_reg.dta ,clear
merge 1:1 ID_reg2 using "nbi.dta"


***2018

g Per_dif2018_i=int(Per_dif2018/10000)   // En ciento de miles de soles

scatter Per_dif2018_i nbi_2018 , mcolor(eltblue) msize(0.5) /// 
mlabel(C) mlabcolor(eltblue) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(20)220 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en __ de soles)",size(*0.8))														///
title("Grafico por regiones TMV sin estandarizar" "2018", size(*0.8))


** 2019

g Per_dif2019_i=int(Per_dif2019/10000)   // En diez mil soles

scatter Per_dif2019_i nbi_2019 , mcolor(eltblue) msize(0.5) /// 
mlabel(C) mlabcolor(eltblue) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(40)380 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en __ de soles)",size(*0.8))														///
title("Grafico SE por regiones TMV sin estandarizar" "2019", size(*0.8))



**2020
g Per_dif2020_i=Per_dif2020/1000000  // En diez cien  soles

scatter Per_dif2020_i nbi_2020 , mcolor(eltblue) msize(0.5) /// 
mlabel(C) mlabcolor(eltblue) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(5)50 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en millones de soles)",size(*0.8))														///
title("Grafico SE por regiones TMV sin estandarizar" "2020", size(*0.8))



**************** TELEFONIA MOVIL INTERNET **************

import excel "$ruta_graf\Cuadros_sinestandaruzar.xlsx", sheet("Cuadro7_TMI Regiones") firstrow clear


keep ID_reg ID_reg2 C  Per_dif2018 Per_dif2019 Per_dif2020 acum_dif acum_dif_s

save SE_tmi_reg.dta , replace

use SE_tmi_reg.dta ,clear
merge 1:1 ID_reg2 using "nbi.dta"



***2018

g Per_dif2018_i=Per_dif2018/10000   // En miles de soles


scatter Per_dif2018_i nbi_2018 , mcolor(orange) msize(0.5) /// 
mlabel(C) mlabcolor(orange) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(20)200 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en diez mil soles)",size(*0.8))														///
title("Grafico SE por regiones TMI sin estandarizar" "2018", size(*0.8))



** 2019

g Per_dif2019_i=Per_dif2019/10000   // En diez mil soles


scatter Per_dif2019_i nbi_2019 , mcolor(orange) msize(0.5) /// 
mlabel(C) mlabcolor(orange) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(20)170 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en diez mil soles)",size(*0.8))														///
title("Grafico SE por regiones TMI sin estandarizar" "2019", size(*0.8))



**2020

g Per_dif2020_i=Per_dif2020/100000   // En cien mil de soles

scatter Per_dif2020_i nbi_2020 , mcolor(orange) msize(0.5) /// 
mlabel(C) mlabcolor(orange) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(50)450 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en cien mil soles)",size(*0.8))														///
title("Grafico SE por regiones TMI sin estandarizar" "2020", size(*0.8))



*********INTERNET FIJO **********************

import excel "$ruta_graf\Cuadros_sinestandaruzar.xlsx", sheet("Cuadro11_IF Regiones") cellrange(A1:L25) firstrow clear


keep  ID_reg ID_reg2 C Per_dif2018 Per_dif2019 Per_dif2020 acum_dif acum_dif_s

save SE_if_reg.dta , replace

use SE_if_reg.dta ,clear
merge 1:1 ID_reg2 using "nbi.dta"


***2018

g Per_dif2018_i=Per_dif2018/100000   // En cien mil soles

scatter Per_dif2018_i nbi_2018 , mcolor(blue) msize(0.5) /// 
mlabel(C) mlabcolor(blue) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(20)200 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en cien mil soles)",size(*0.8))														///
title("Grafico SE por regiones IF sin estandarizar" "2018", size(*0.8))


** 2019

g Per_dif2019_i=Per_dif2019/100000  // En cien mil soles


scatter Per_dif2019_i nbi_2019 , mcolor(blue) msize(0.5) /// 
mlabel(C) mlabcolor(blue) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(10)100 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en cien mil soles)",size(*0.8))														///
title("Grafico SE por regiones IF sin estandarizar" "2019", size(*0.8))


**2020
destring Per_dif2020 ,g (Per_dif2020_)
g Per_dif2020_i=Per_dif2020_/100000   // En cien mil soles


scatter Per_dif2020_i nbi_2020 , mcolor(blue) msize(0.5) /// 
mlabel(C) mlabcolor(blue) mlabsize(*0.7) 				///
xlabel(0(10)60,  grid labsize(*0.5)) 					///
ylabel(0(10)80 , grid labsize(*0.5)) 					///
xtitle("Tasa de la poblacion con al menos una necesidad basica insastifecha" "(en porcentaje)", size(*0.8 )) 						///
ytitle("Cuantifiacion de la perdida de bienestar" "(en cien mil soles)",size(*0.8))														///
title("Grafico SE por regiones IF sin estandarizar" "2020", size(*0.8))





******************** FIN :D









