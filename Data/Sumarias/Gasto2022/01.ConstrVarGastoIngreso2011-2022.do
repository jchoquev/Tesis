clear all
*********
cd "d:\gasto2022\bases"
set more off
use sumaria-2022, clear
append using sumaria-2021
append using sumaria-2020
append using sumaria-2019
append using sumaria-2018
append using sumaria-2017
append using sumaria-2016
append using sumaria-2015
append using sumaria-2014
append using sumaria-2013
append using sumaria-2012
append using sumaria-2011

replace a�o=a�o if a�o=="" & a�o!=""
tab mes a�o

recode g01hd ig0* insedthd1 paesechd1 ing* *gru* gas* tipocuesti* tipoentre* estrsocial lin* pobrezav ld estratosocio pobreza (.=0)

misstable sum

gen aniorec=real(a�o)
gen dpto= real(substr(ubigeo,1,2))
replace dpto=15 if (dpto==7)
label define dpto 1"Amazonas" 2"Ancash" 3"Apurimac" 4"Arequipa" 5"Ayacucho" 6"Cajamarca" 8"Cusco" 9"Huancavelica" 10"Huanuco" 11"Ica" /*
*/12"Junin" 13"La Libertad" 14"Lambayeque" 15"Lima" 16"Loreto" 17"Madre de Dios" 18"Moquegua" 19"Pasco" 20"Piura" 21"Puno" 22"San Martin" /*
*/23"Tacna" 24"Tumbes" 25"Ucayali" 
lab val dpto dpto 

sort aniorec dpto
merge aniorec dpto using "d:\gasto2022\bases\deflactores_base2022_new.dta"
tab _m
drop if _merge==2
drop _m

*�mbito urbano/rural
replace estrato = 1 if dominio ==8 
gen area = estrato <6
replace area=2 if area==0
label define area 2 rural 1 urbana
label val area area

*dominios geogr�ficos
gen domin02=1 if dominio>=1 & dominio<=3 & area==1
replace domin02=2 if dominio>=1 & dominio<=3 & area==2
replace domin02=3 if dominio>=4 & dominio<=6 & area==1
replace domin02=4 if dominio>=4 & dominio<=6 & area==2
replace domin02=5 if dominio==7 & area==1
replace domin02=6 if dominio==7 & area==2
replace domin02=7 if dominio==8

label define domin02 1 "Costa_urbana" 2 "Costa_rural" 3 "Sierra_urbana" 4 "Sierra_rural" 5 "Selva_urbana" 6 "Selva_rural" 7 "Lima_Metropolitana"
label value domin02 domin02

gen     dominioA=1 if dominio==1 & area==1
replace dominioA=2 if dominio==1 & area==2
replace dominioA=3 if dominio==2 & area==1
replace dominioA=4 if dominio==2 & area==2
replace dominioA=5 if dominio==3 & area==1
replace dominioA=6 if dominio==3 & area==2
replace dominioA=7 if dominio==4 & area==1
replace dominioA=8 if dominio==4 & area==2
replace dominioA=9 if dominio==5 & area==1
replace dominioA=10 if dominio==5 & area==2
replace dominioA=11 if dominio==6 & area==1
replace dominioA=12 if dominio==6 & area==2
replace dominioA=13 if dominio==7 & area==1
replace dominioA=14 if dominio==7 & area==2
replace dominioA=15 if dominio==7 & (dpto==16 | dpto==17 | dpto==25) & area==1
replace dominioA=16 if dominio==7 & (dpto==16 | dpto==17 | dpto==25) & area==2
replace dominioA=17 if dominio==8 & area==1
replace dominioA=17 if dominio==8 & area==2

label define dominioA 1 "Costa norte urbana" 2 "Costa norte rural" 3 "Costa centro urbana" 4 "Costa centro rural" /*
*/ 5 "Costa sur urbana" 6 "Costa sur rural"	7 "Sierra norte urbana"	8 "Sierra norte rural"	9 "Sierra centro urbana" /* 
*/ 10 "Sierra centro rural"	11 "Sierra sur urbana" 12 "Sierra sur rural" 13 "Selva alta urbana"	14 "Selva alta rural" /*
*/ 15 "Selva baja urbana" 16 "Selva baja rural" 17"Lima Metropolitana"
lab val dominioA dominioA 

drop ld

sort  dominioA

merge dominioA using "d:\gasto2022\bases\despacial_ldnew.dta"
tab _m
drop _m

gen factornd07=round(factor07*mieperho,1)

gen p = 12 //periodo anual

svyset [pweight = factornd07], psu(conglome)


****************************************************
******Gasto por 8  grupos de la canastas************
****************************************************

gen 		gpcrg3= (gru11hd + gru12hd1 + gru12hd2 + gru13hd1 + gru13hd2 + gru13hd3 )/(p*mieperho*ld*i01) 
gen 		gpcrg6 = ((g05hd + g05hd1 + g05hd2 + g05hd3 + g05hd4 + g05hd5 +g05hd6 +ig06hd)/(p*mieperho*ld*i01)) 
gen 		gpcrg8= ((sg23 + sig24)/(p*mieperho*ld*i01)) 
gen 		gpcrg9= ((gru14hd + gru14hd1 +  gru14hd2 + gru14hd3 + gru14hd4 + gru14hd5 + sg25 + sig26)/(p*mieperho*ld*i01)) 
gen    		gpcrg10= ((gru21hd + gru22hd1 + gru22hd2 + gru23hd1 + gru23hd2 + gru23hd3 + gru24hd)/(p*mieperho*ld*i02)) 
gen     	gpcrg12= ((gru31hd + gru32hd1 + gru32hd2 + gru33hd1 + gru33hd2 + gru33hd3 + gru34hd)/(p*mieperho*ld*i03)) 
gen     	gpcrg14= ((gru41hd + gru42hd1 + gru42hd2 + gru43hd1 + gru43hd2 + gru43hd3 + gru44hd + sg421 + sg42d1 + sg423 + sg42d3)/(p*mieperho*ld*i04)) 
gen    		gpcrg16= ((gru51hd + gru52hd1 + gru52hd2 + gru53hd1 + gru53hd2 + gru53hd3 + gru54hd)/(p*mieperho*ld*i05)) 
gen     	gpcrg18= ((gru61hd + gru62hd1 + gru62hd2 + gru63hd1 + gru63hd2 + gru63hd3 + gru64hd + g07hd + ig08hd + sg422 + sg42d2)/(p*mieperho*ld*i06)) 
gen     	gpcrg19= ((gru71hd + gru72hd1 + gru72hd2 + gru73hd1 + gru73hd2 + gru73hd3 + gru74hd + sg42 + sg42d)/(p*mieperho*ld*i07)) 
gen     	gpcrg21= ((gru81hd + gru82hd1 + gru82hd2 + gru83hd1 + gru83hd2 + gru83hd3 + gru84hd)/(p*mieperho*ld*i08)) 

label var gpcrg3	"Preparados dentro del hogar"
label var gpcrg6	"Adquiridos Fuera del hogar 559"
label var gpcrg8	"Adquiridos de instituciones beneficas 602a "
label var gpcrg9	"Adquiridos fuera del hogar item 47 y 50 y 602"
label var gpcrg10	"Vestido y calzado"
label var gpcrg12	"Gasto Alquiler de vivienda y combustible"
label var gpcrg14	"Muebles y enseres"
label var gpcrg16	"Cuidados de la salud"
label var gpcrg18	"Transporte y comunicaciones"
label var gpcrg19	"Esparcimiento diversi�n y cultura"
label var gpcrg21	"Otros gastos de bienes y servicios"

*RECODIFICANDO POR grupo de gastos
**********************************
gen 	gpgru2= gpcrg3
gen		gpgru3= gpcrg6 + gpcrg8 + gpcrg9
gen		gpgru4 = gpcrg10
gen		gpgru5 = gpcrg12
gen		gpgru6 = gpcrg14
gen		gpgru7= gpcrg16
gen		gpgru8 = gpcrg18
gen		gpgru9 = gpcrg19
gen		gpgru10 = gpcrg21 
gen 	gpgru1 = gpgru2 + gpgru3
gen  	gpgru0 = gpgru1 + gpgru4 + gpgru5 + gpgru6 + gpgru7 + gpgru8 + gpgru9 + gpgru10 

label var gpgru1 "G01.Total en Alimentos real"
label var gpgru2 "G011.Alimentos dentro del hogar real"
label var gpgru3 "G012.Alimentos fuera del hogar real"
label var gpgru4 "G02.Vestido y calzado real"
label var gpgru5 "G03.Alquiler de Vivienda y combustible real"
label var gpgru6 "G04.Muebles y enseres real"
label var gpgru7 "G05.Cuidados de la salud real"
label var gpgru8 "G06.Transportes y comunicaciones real"
label var gpgru9 "G07.Esparcimiento diversion y cultura real"
label var gpgru10 "G08.otros gastos en bienes y servicios real"

*******************************
*TIPOS DE ADQUISICION DE GASTOS

gen   	  	gpcnr1 =(((gru11hd +gru14hd + sg23 + g05hd + g05hd1 + g05hd2 + g05hd3 + g05hd4 + g05hd5 + g05hd6  +sg25)/(p*mieperho *  ld*i01))/*
					*/ + (gru21hd/(p*mieperho *  ld*i02)) + /*
                    */ (gru31hd/(p*mieperho *  ld*i03)) + ((gru41hd + sg421 + sg423)/(p*mieperho *  ld*i04)) + /*
                    */ (gru51hd/(p*mieperho *  ld*i05)) + ((gru61hd + g07hd + sg422)/(p*mieperho *  ld*i06)) + /*
                    */ ((gru71hd + sg42)/(p*mieperho *  ld*i07)) + (gru81hd/(p*mieperho *  ld*i08))) 

gen     	gpcnr2 =(((gru12hd1 + gru14hd1)/(p*mieperho *  ld*i01)) + (gru22hd1/(p*mieperho *  ld*i02)) + /*
                    */ (gru32hd1/(p*mieperho *  ld*i03)) + (gru42hd1/(p*mieperho *  ld*i04)) + /*
                    */ (gru52hd1/(p*mieperho *  ld*i05)) + (gru62hd1/(p*mieperho *  ld*i06)) + /*
                    */ (gru72hd1/(p*mieperho *  ld*i07)) + (gru82hd1/(p*mieperho *  ld*i08)))  
					
gen     	gpcnr3 = (((gru12hd2 + gru14hd2)/(p*mieperho *  ld*i01)) + (gru22hd2/(p*mieperho *  ld*i02)) + /*
                    */ (gru32hd2/(p*mieperho *  ld*i03)) + (gru42hd2/(p*mieperho *  ld*i04)) + /*
                    */ (gru52hd2/(p*mieperho *  ld*i05)) + (gru62hd2/(p*mieperho *  ld*i06)) + /*
                    */ (gru72hd2/(p*mieperho *  ld*i07)) + (gru82hd2/(p*mieperho *  ld*i08)))   
					
gen    		gpcnr4 =(((gru13hd1 + gru14hd3+ sig24 +sig26)/(p*mieperho *  ld*i01)) + (gru23hd1/(p*mieperho *  ld*i02)) + /*
                    */ (gru33hd1/(p*mieperho *  ld*i03)) + (gru43hd1/(p*mieperho *  ld*i04)) + /*
                    */ (gru53hd1/(p*mieperho *  ld*i05)) + (gru63hd1/(p*mieperho *  ld*i06)) + /*
                    */ (gru73hd1/(p*mieperho *  ld*i07)) + (gru83hd1/(p*mieperho *  ld*i08)))  
					
gen     	gpcnr5 =(((gru13hd2 + gru14hd4 + ig06hd)/(p*mieperho *  ld*i01)) + (gru23hd2/(p*mieperho *  ld*i02)) + /*
                    */ (gru33hd2/(p*mieperho *  ld*i03)) + ((gru43hd2 + sg42d1 + sg42d3)/(p*mieperho *  ld*i04)) + /*
                    */ (gru53hd2/(p*mieperho *  ld*i05)) + ((gru63hd2 +ig08hd + sg42d2)/(p*mieperho *  ld*i06)) + /*
                     */ ((gru73hd2 + sg42d)/(p*mieperho *  ld*i07)) + (gru83hd2/(p*mieperho *  ld*i08)))  
				
gen   		  gpcnr6 =(((gru13hd3 + gru14hd5)/(p*mieperho *  ld*i01)) + (gru23hd3/(p*mieperho *  ld*i02)) + /*
                    */ (gru33hd3/(p*mieperho *  ld*i03)) + (gru43hd3/(p*mieperho *  ld*i04)) + /*
                    */ (gru53hd3/(p*mieperho *  ld*i05)) + (gru63hd3/(p*mieperho *  ld*i06)) + /*
                    */ (gru73hd3/(p*mieperho *  ld*i07)) + (gru83hd3/(p*mieperho *  ld*i08))) 
					
gen   		 gpcnr7 =((gru24hd/(p*mieperho *  ld*i02)) + (gru34hd/(p*mieperho *  ld*i03)) + /*
                    */ (gru44hd/(p*mieperho *  ld*i04)) + (gru54hd/(p*mieperho *  ld*i05)) + /*
                    */ (gru64hd/(p*mieperho *  ld*i06)) + (gru74hd/(p*mieperho *  ld*i07)) + /*
                    */ (gru84hd/(p*mieperho *  ld*i08))) 

					
gen gpcnr0 = gpcnr1 + gpcnr2 + gpcnr3 + gpcnr4 + gpcnr5 + gpcnr6 + gpcnr7

label var gpcnr0 "gasto nueva metodologia"
label var gpcnr1 "Compra"
label var gpcnr2 "Autoconsumo"
label var gpcnr3 "Pago en especie"
label var gpcnr4 "gasto donaciones publicas"
label var gpcnr5 "gasto donaciones privadas"
label var gpcnr6 "gasto otro grupo"	
label var gpcnr7 "gasto imputado"


****************************************************/
**************  POR  GRUPO  Y  Tipo  ***************/
****************************************************/
* Comprado
gen        gpctg1= gpcnr1
gen        gpctg2= (gru11hd + gru14hd + sg23 + g05hd + g05hd1 + g05hd2 + g05hd3 + g05hd4 + g05hd5 + g05hd6  +sg25)/(p*mieperho*ld*i01) 
gen        gpctg3= (gru21hd)/(p*mieperho*ld*i02) 
gen        gpctg4= (gru31hd)/(p*mieperho*ld*i03) 
gen        gpctg5= (gru41hd + sg421 + sg423)/(p*mieperho*ld*i04) 
gen        gpctg6= (gru51hd)/(p*mieperho*ld*i05) 
gen        gpctg7= (gru61hd + g07hd + sg422)/(p*mieperho*ld*i06) 
gen        gpctg8= (gru71hd + sg42)/(p*mieperho*ld*i07) 
gen        gpctg9= (gru81hd)/(p*mieperho*ld*i08) 

recode gpctg2 gpctg3 gpctg4 gpctg5 gpctg5 gpctg6 gpctg7 gpctg7 gpctg8 gpctg9(.=0)


*Autoconsumo (ajustado alquiler de vivienda)
gen        gpctg10= gpcnr2
gen        gpctg11= (gru12hd1 + gru14hd1)/(p*mieperho*ld*i01) 
gen        gpctg12= (gru22hd1)/(p*mieperho*ld*i02) 
gen        gpctg13= (gru32hd1)/(p*mieperho*ld*i03) 
gen        gpctg14= (gru42hd1)/(p*mieperho*ld*i04) 
gen        gpctg15= (gru52hd1)/(p*mieperho*ld*i05) 
gen        gpctg16= (gru62hd1)/(p*mieperho*ld*i06) 
gen        gpctg17= (gru72hd1)/(p*mieperho*ld*i07) 
gen        gpctg18= (gru82hd1)/(p*mieperho*ld*i08) 

* Pago en especie
gen        gpctg19= gpcnr3
gen        gpctg20= (gru12hd2 + gru14hd2)/(p*mieperho*ld*i01) 
gen        gpctg21= (gru22hd2)/(p*mieperho*ld*i02) 
gen        gpctg22= (gru32hd2)/(p*mieperho*ld*i03) 
gen        gpctg23= (gru42hd2)/(p*mieperho*ld*i04) 
gen        gpctg24= (gru52hd2)/(p*mieperho*ld*i05) 
gen        gpctg25= (gru62hd2)/(p*mieperho*ld*i06) 
gen        gpctg26= (gru72hd2)/(p*mieperho*ld*i07) 
gen        gpctg27= (gru82hd2)/(p*mieperho*ld*i08) 

* Donacion P�blica
gen        gpctg28= gpcnr4
gen        gpctg29= (gru13hd1 + gru14hd3+ sig24 +sig26)/(p*mieperho*ld*i01) 
gen        gpctg30= (gru23hd1)/(p*mieperho*ld*i02) 
gen        gpctg31= (gru33hd1)/(p*mieperho*ld*i03) 
gen        gpctg32= (gru43hd1)/(p*mieperho*ld*i04) 
gen        gpctg33= (gru53hd1)/(p*mieperho*ld*i05) 
gen        gpctg34= (gru63hd1)/(p*mieperho*ld*i06) 
gen        gpctg35= (gru73hd1)/(p*mieperho*ld*i07) 
gen        gpctg36= (gru83hd1)/(p*mieperho*ld*i08) 

* Donaci�n privada
gen		gpctg37= gpcnr5
gen     gpctg38= (gru13hd2 + gru14hd4 + ig06hd)/(p*mieperho*ld*i01) 
gen     gpctg39= (gru23hd2)/(p*mieperho*ld*i02) 
gen     gpctg40= (gru33hd2)/(p*mieperho*ld*i03) 
gen     gpctg41= (gru43hd2 + sg42d1 + sg42d3)/(p*mieperho*ld*i04) 
gen     gpctg42= (gru53hd2)/(p*mieperho*ld*i05) 
gen     gpctg43= (gru63hd2 + ig08hd + sg42d2)/(p*mieperho*ld*i06) 
gen     gpctg44= (gru73hd2 + sg42d)/(p*mieperho*ld*i07) 
gen     gpctg45= (gru83hd2)/(p*mieperho*ld*i08) 

* Otro grupo
gen		gpctg46= gpcnr6
gen     gpctg47= (gru13hd3 + gru14hd5)/(p*mieperho*ld*i01) 
gen     gpctg48= (gru23hd3)/(p*mieperho*ld*i02) 
gen     gpctg49= (gru33hd3)/(p*mieperho*ld*i03) 
gen     gpctg50= (gru43hd3)/(p*mieperho*ld*i04) 
gen     gpctg51= (gru53hd3)/(p*mieperho*ld*i05) 
gen     gpctg52= (gru63hd3)/(p*mieperho*ld*i06) 
gen     gpctg53= (gru73hd3)/(p*mieperho*ld*i07) 
gen     gpctg54= (gru83hd3)/(p*mieperho*ld*i08) 


* Imputado ajustado alquiler vivienda (gru34hd)
gen         gpctg55= gpcnr7
gen         gpctg56= (gru24hd)/(p*mieperho*ld*i02) 

* Alquiler vivienda (gru34hd)
gen		gpctg57= (gru34hd)/(p*mieperho*ld*i03) 
gen     gpctg58= (gru44hd)/(p*mieperho*ld*i04) 
gen     gpctg59= (gru54hd)/(p*mieperho*ld*i05) 
gen     gpctg60= (gru64hd)/(p*mieperho*ld*i06) 
gen     gpctg61= (gru74hd)/(p*mieperho*ld*i07) 
gen     gpctg62= (gru84hd)/(p*mieperho*ld*i08) 
gen     gpctg0 = gpctg1 + gpctg10 + gpctg19 + gpctg28 + gpctg37 + gpctg46 + gpctg55



************* Ingresos ****************************************************************.

gen ipcr_2 = (ingbruhd +ingindhd)/(p*mieperho*ld*i00) 
gen ipcr_3 = (insedthd + ingseihd + insedthd1)/(p*mieperho*ld*i00) 
gen ipcr_4 = (pagesphd + paesechd + ingauthd + isecauhd + paesechd1)/(p*mieperho*ld*i00) 
gen ipcr_5 = (ingexthd)/(p*mieperho*ld*i00) 
gen ipcr_1 = (ipcr_2 + ipcr_3 + ipcr_4 + ipcr_5)

gen ipcr_7 = (ingtrahd)/(p*mieperho*ld*i00) 
gen ipcr_8 = (ingtexhd)/(p*mieperho*ld*i00) 
gen ipcr_6 = (ipcr_7 + ipcr_8)

gen ipcr_9  = (ingtprhd)/(p*mieperho*ld*i00) 
gen ipcr_10 = (ingtpuhd)/(p*mieperho*ld*i00) 
gen ipcr_11 = (ingtpu01)/(p*mieperho*ld*i00) 
gen ipcr_12 = (ingtpu03)/(p*mieperho*ld*i00) 
gen ipcr_13 = (ingtpu05)/(p*mieperho*ld*i00) 
gen ipcr_14 = (ingtpu04)/(p*mieperho*ld*i00) 
gen ipcr_15 = (ingtpu02 + ingtpu06 + ingtpu07 + ingtpu08 + ingtpu09 + ingtpu10 + ingtpu11 + ingtpu12 + ingtpu13 + ingtpu14 + ingtpu15 + ingtpu16)/(p*mieperho*ld*i00)
gen ipcr_16 = (ingrenhd)/(p*mieperho*ld*i00) 
gen ipcr_17 = (ingoexhd + gru13hd3 + gru23hd3 + gru33hd3 + gru43hd3 + gru53hd3 + gru63hd3 + gru73hd3 + /*
*/  gru83hd3 + gru24hd +gru44hd + gru54hd + gru74hd + gru84hd + gru14hd5)/(p*mieperho*ld*i00) /*
*/

*ajuste por el alquiler imputado
gen ipcr_18 =(ia01hd +gru34hd - ga04hd + gru64hd)/(p*mieperho*ld*i00) 

gen ipcr_19 = (gru13hd1 + sig24 + gru23hd1 + gru33hd1 + gru43hd1 + gru53hd1 + gru63hd1 + gru73hd1 + gru83hd1 /* 
*/+ gru14hd3 + sig26)/(p*mieperho*ld*i00) 

gen ipcr_20 = (gru13hd2 + ig06hd + gru23hd2 + gru33hd2 + gru43hd2 + gru53hd2 + gru63hd2 + ig08hd + gru73hd2 + /*
*/ gru83hd2 + gru14hd4 + sg42d + sg42d1 + sg42d2 + sg42d3)/(p*mieperho*ld*i00)/*
*/ 

gen  ipcr_0= ipcr_2 + ipcr_3 + ipcr_4 + ipcr_5+ ipcr_7 + ipcr_8 + ipcr_16 + ipcr_17 + ipcr_18 + ipcr_19 + ipcr_20

label var ipcr_0 "Ingreso percapita mensual a precios de Lima monetario "

label var ipcr_1 "Ingreso percapita mensual a precios de Lima monetario por trabajo"
label var ipcr_2 "Ingreso percapita mensual a precios de Lima monetario por trabajo principal"
label var ipcr_3 "Ingreso percapita mensual a precios de Lima monetario por trabajo secundario"
label var ipcr_4 "Ingreso percapita mensual a precios de Lima pago en especie y autocon"
label var ipcr_5 "Ingreso percapita mensual a precios de Lima pago extraordinario por trabajo"
label var ipcr_6 "Ingreso percapita mensual a precios de Lima transferencia corriente"
label var ipcr_7 "Ingreso percapita mensual a precios de Lima transferencia monetaria del pais"
label var ipcr_8 "Ingreso percapita mensual a precios de Lima transferencia monetaria extranjero"
label var ipcr_9  "Ingreso percapita mensual a precios de Lima transferencia monetaria privada"
label var ipcr_10 "Ingreso percapita mensual a precios de Lima transferencia monetaria Publica total"
label var ipcr_11 "Ingreso percapita mensual a precios de Lima transferencia monetaria Publica Juntos"
label var ipcr_12 "Ingreso percapita mensual a precios de Lima transferencia monetaria Publica Pensi�n65"
label var ipcr_13 "Ingreso percapita mensual a precios de Lima transferencia monetaria Bono Gas"
label var ipcr_14 "Ingreso percapita mensual a precios de Lima transferencia monetaria Beca 18"
label var ipcr_15 "Ingreso percapita mensual a precios de Lima transferencia monetaria Otros Publica"
label var ipcr_16 "Ingreso percapita mensual a precios de Lima renta"
label var ipcr_17 "Ingreso percapita mensual a precios de Lima extraordinario"
label var ipcr_18 "Ingreso percapita mensual a precios de Lima alquiler imputado"
label var ipcr_19 "Ingreso percapita mensual a precios de Lima donacion publica"
label var ipcr_20 "Ingreso percapita mensual a precios de Lima donacion privada"

*** Salidas ***

*** Gasto real promedio percapita mensual***
table area aniorec [iw=factornd07], c(mean gpgru0) row
table domin02 aniorec [iw=factornd07], c(mean gpgru0) row
table dpto aniorec [iw=factornd07], c(mean gpgru0) row


*** Ingreso real promedio percapita mensual ***
table area aniorec [iw=factornd07], c(mean ipcr_0) row
table domin02 aniorec [iw=factornd07], c(mean ipcr_0) row
table dpto aniorec [iw=factornd07], c(mean ipcr_0) row


*** fin ***
