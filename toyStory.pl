%TOY STORY

% Relaciona al dueño con el nombre del juguete
%y la cantidad de años que lo ha tenido
duenio(andy, woody, 8).
duenio(andy, buzz, 5).
duenio(sam, jessie, 3).
duenio(sam, woody, 1).
duenio(sam, soldados, 3).

% Relaciona al juguete con su nombre
% los juguetes son de la forma:
% deTrapo(tematica)
% deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes)
juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(seniorCaraDePapa,caraDePapa([original(pieIzquierdo),original(pieDerecho),original(nariz) ])).

% Dice si un juguete es raro
esRaro(deAccion(stacyMalibu, 1, [sombrero])).

% Dice si una persona es coleccionista
esColeccionista(sam).


%PUNTO1
tematica(deTrapo(Tematica),Tematica).
tematica(deAccion(Tematica,_),Tematica).
tematica(deAccion(Tematica,_,_),Tematica).  %por Stacy Malibu
tematica(miniFiguras(Tematica,_),Tematica).
tematica(caraDePapa(_),caraDePapa).

esDePlastico(miniFiguras(_,_)).
esDePlastico(caraDePapa(_)).

esDeColeccion(deTrapo(_)).
esDeColeccion(deAccion(_,_)):-
	esRaro(deAccion(_,_)).
esDeColeccion(deAccion(_,_,_)):-
	esRaro(deAccion(_,_,_)).
esDeColeccion(caraDePapa(_)):-
	esRaro(caraDePapa(_)).

%PUNTO2
% entendi nombre del juguete que no es de plastico y que tiene hace 
% mas tiempo de todos los que no son de plastico.
 amigoFiel(Duenio,NombreJuguete):-
	juguete(NombreJuguete,Juguete),
	not(esDePlastico(Juguete)),
	duenio(Duenio,NombreJuguete,Anio),
	forall(juguetesNoPlasticoDeDuenio(Duenio,Anio2,NombreJuguete),Anio>Anio2).  

juguetesNoPlasticoDeDuenio(Duenio,Anio2,NombreJuguete):-
	duenio(Duenio,NombreJuguete2,Anio2),
	juguete(NombreJuguete2,Juguete2),
	not(esDePlastico(Juguete2)),
	NombreJuguete2\=NombreJuguete. 

%PUNTO3
superValioso(NombreJuguete):-
	juguete(NombreJuguete,Juguete),
	esDeColeccion(Juguete),
	tieneTodasPiezasOriginales(Juguete),
	duenio(Duenio,NombreJuguete,_),
	not(esColeccionista(Duenio)).

tieneTodasPiezasOriginales(deAccion(_,Partes)):-
	forall(member(Parte,Partes),Parte=original(_)).	
tieneTodasPiezasOriginales(caraDePapa(Partes)):-
	forall(member(Parte,Partes),Parte=original(_)).	

%PUNTO4
duoDinamico(Duenio,NombreJuguete1,NombreJuguete2):-
	ambosJuguetesPertenecenAlDuenio(Duenio,NombreJuguete1,NombreJuguete2),
	buenaPareja(NombreJuguete1,NombreJuguete2).

ambosJuguetesPertenecenAlDuenio(Duenio,NombreJuguete1,NombreJuguete2):-
	duenio(Duenio,NombreJuguete1,_),
	duenio(Duenio,NombreJuguete2,_),
	NombreJuguete1\=NombreJuguete2.

buenaPareja(NombreJuguete1,NombreJuguete2):-
	juguete(NombreJuguete1,Juguete1),
	juguete(NombreJuguete2,Juguete2),
	mismaTematica(Juguete1,Juguete2).
buenaPareja(woody,buzz).
buenaPareja(buzz,woody).

mismaTematica(Juguete1,Juguete2):-
	tematica(Juguete1,Tematica),
	tematica(Juguete2,Tematica).

%PUNTO5
felicidad(Duenio,FelicidadTotal):-
	duenio(Duenio,_,_),
	findall(Felicidad,tieneDuenio(Duenio,Felicidad),ListaFelicidadesPorJuguete),
	sumlist(ListaFelicidadesPorJuguete,FelicidadTotal).
	
tieneDuenio(Duenio,Felicidad):-
	duenio(Duenio,NombreJuguete,_),
	juguete(NombreJuguete,Juguete),
	not(tematica(Juguete,deAccion)),
	calculoFelicidad(Juguete,Felicidad).
tieneDuenio(Duenio,Felicidad):-
	duenio(Duenio,NombreJuguete,_),
	juguete(NombreJuguete,Juguete),
	tematica(Juguete,deAccion),
	calculoFelicidad(Duenio,NombreJuguete,Juguete,Felicidad).

calculoFelicidad(minifigura(_,CantidadFiguras),Felicidad):-
	Felicidad is CantidadFiguras*20.
calculoFelicidad(caraDePapa(Partes),Felicidad):-
	findall(ParteOriginal,piezasOriginales(Partes,ParteOriginal),ListaOriginales)
	length(ListaOriginales,CantidadOriginales),
	length(Partes,CantidadTotal),
	Felicidad is (CantidadTotal-CantidadOriginales)*8+CantidadOriginales*5.  %si solo existen originales y repuestos
calculoFelicidad(deTrapo(_),100).
calculoFelicidad(Duenio,NombreJuguete,Juguete,120):-
	coleccionYDuenioColeccionista(Duenio,NombreJuguete,Juguete).
calculoFelicidad(Duenio,NombreJuguete,Juguete,100):-
	not(coleccionYDuenioColeccionista(Duenio,NombreJuguete,Juguete)).

coleccionYDuenioColeccionista(Duenio,NombreJuguete,Juguete)
	esDeColeccion(Juguete),
	duenio(Duenio,NombreJuguete,_),
	esColeccionista(Duenio).
	
piezasOriginales(Partes,ParteOriginal):-
	member(original(ParteOriginal),Partes).

%PUNTO6
puedeJugarCon(Alguien,NombreJuguete):-
	duenio(Alguien,NombreJuguete,_).
puedeJugarCon(Alguien,NombreJuguete):-
	puedePrestar(_,Alguien,NombreJuguete). 

puedePrestar(ElQuePresta,Alguien,NombreJuguete):-
	duenio(ElQuePresta,NombreJuguete,_),	
	duenio(Alguien,_,_),
	cantJuguetes(ElQuePresta,CantJuguetesPrestador),
	cantJuguetes(Alguien,CantJuguetesAlguien),
	CantJuguetesPrestador>CantJuguetesAlguien.

cantJuguetes(Persona,CantJuguetes):-
	findall(Juguete,duenio(Persona,Juguete,_),ListaJuguetes),
	length(ListaJuguetes,CantJuguetes).