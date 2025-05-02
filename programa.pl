% 1) Modelar lo necesario para representar los jugadores, las civilizaciones y las tecnologías, 
% de la forma mas conveniente para resolver los siguientes puntos.

jugador(ana).
jugador(beto).
jugador(carola).
jugador(dimitri).

civilizacion(romanos).
civilizacion(incas).

juegaCon(ana, romanos).
juegaCon(carola, romanos).
juegaCon(dimitri, romanos).
juegaCon(beto, incas).

tecnologia(herreria).
tecnologia(molino).
tecnologia(emplumado).
tecnologia(forja).
tecnologia(laminas).
tecnologia(punzon).
tecnologia(fundicion).
tecnologia(horno).
tecnologia(malla).
tecnologia(placas).
tecnologia(collera).
tecnologia(arado).

desarrollo(ana, herreria).
desarrollo(ana, forja).
desarrollo(ana, emplumado).
desarrollo(ana, laminas).
desarrollo(beto, herreria).
desarrollo(beto, fundicion).
desarrollo(beto, forja).
desarrollo(carola, herreria).
desarrollo(dimitri, herreria).
desarrollo(dimitri, fundicion).

% 2) Saber si un jugador es experto en metales, que sucede cuando desarrolló las tecnologías de herrería, forja y
% o bien desarrolló fundición, o bien juega con los romanos. 

esExpertoEnMetales(Jugador):-
    desarrollo(Jugador, herreria),
    desarrollo(Jugador, forja),
    desarrollo(Jugador, fundicion).

esExpertoEnMetales(Jugador):-
    desarrollo(Jugador, herreria),
    desarrollo(Jugador, forja),
    juegaCon(Jugador, romanos).

% 3) Saber si una civilización es popular, que se cumple cuando la eligen varios jugadores (mas de uno).

esPopular(Civilizacion):-
    civilizacion(Civilizacion),
    juegaCon(Jugador1, Civilizacion),
    juegaCon(Jugador2, Civilizacion),
    Jugador1 \= Jugador2.

% 4) Saber si una tecnología tiene alcance global, que sucede cuando a nadie le falta desarrollarla.

tieneAlcanceGlobal(Tecnologia):-
    tecnologia(Tecnologia),
    forall(jugador(Jugador), desarrollo(Jugador, Tecnologia)).

% 5) Saber cuándo una civilización es líder. Se cumple cuando esa civilización alcanzó todas las tecnologías que
% alcanzaron las demás. Una civilización alcanzó una tecnología cuando algún jugador de esa civilización la desarrolló.

tecnologiaAlcanzada(Tecnologia):-
    desarrollo(_, Tecnologia).

esLider(Civilizacion):-
    civilizacion(Civilizacion),
    forall(tecnologiaAlcanzada(Tecnologia), (juegaCon(Jugador, Civilizacion), desarrollo(Jugador, Tecnologia))).

% SEGUNDA ENTREGA

% 6) Modelar lo necesario para representar las distintas unidades de cada jugador de la forma mas conveniente para 
% resolver los siguientes puntos. Incluir los siguientes ejemplos:

unidadDeJugador(ana, jinete(caballo)).
unidadDeJugador(beto, jinete(camello)).
unidadDeJugador(beto, campeon(100)).
unidadDeJugador(beto, campeon(80)).
unidadDeJugador(ana, piquero(1, conEscudo)).
unidadDeJugador(ana, piquero(2, sinEscudo)).
unidadDeJugador(beto, piquero(1, conEscudo)).
unidadDeJugador(carola, piquero(3, sinEscudo)).
unidadDeJugador(carola, piquero(2, conEscudo)).

unidadesDe(Jugador, Unidad) :- 
    unidadDeJugador(Jugador, Unidad).

% 7) Conocer la unidad con mas vida:

vidaPiquero(1, sinEscudo, 50).
vidaPiquero(2, sinEscudo, 65).
vidaPiquero(3, sinEscudo, 70).

vidaPiquero(Nivel, conEscudo, Vida):-
    vidaPiquero(Nivel, sinEscudo, VidaSinEscudo),
    Vida is VidaSinEscudo * (1.1).

vidaJinete(caballo, 90).
vidaJinete(camello, 80).

vidaUnidad(campeon(Vida), Vida).
vidaUnidad(jinete(Tipo), Vida) :-
    vidaJinete(Tipo, Vida).
vidaUnidad(piquero(Nivel, Escudo), Vida) :-
    vidaPiquero(Nivel, Escudo, Vida).

unidadConMasVida(Jugador, UnidadMax) :-
    unidadesDe(Jugador, Unidad),
    vidaUnidad(Unidad, VidaMax),
    forall((unidadesDe(Jugador, OtraUnidad), Unidad \= OtraUnidad), (vidaUnidad(OtraUnidad, Vida), Vida =< VidaMax)),
    UnidadMax = Unidad.
    
% 8) Queremos saber si una unidad le gana a otra:

gana(jinete(_), campeon(_)).
gana(campeon(_), piquero(_,_)).
gana(piquero(_,_), jinete(_)).
gana(jinete(camello), jinete(caballo)).

leGana(Unidad1, Unidad2):-
    gana(Unidad1, Unidad2).

leGana(Unidad1, Unidad2):-
    gana(Unidad2, Unidad1),
    vidaUnidad(Unidad1, Vida1),
    vidaUnidad(Unidad2, Vida2),
    Vida1 > Vida2.

% 9) Saber si un jugador puede sobrevivir a un asedio. Esto ocurre si tiene mas piqueros con escudo que sin escudo.

sobreviveAsedio(Jugador):-
    jugador(Jugador),
    cantidadPiqueros(Jugador, conEscudo, CantPiquerosConEscudo),
    cantidadPiqueros(Jugador, sinEscudo, CantPiquerosSinEscudo),
    CantPiquerosConEscudo > CantPiquerosSinEscudo.

cantidadPiqueros(Jugador, Tipo, Cantidad):-
    unidadesDe(Jugador, _),
    findall(Unidad, (unidadesDe(Jugador, Unidad), Unidad = piquero(_, Tipo)), Unidades),
    length(Unidades, Cantidad).
    
% 10) Árbol de tecnologías
% a) Se sabe que existe un árbol de tecnologías, que indica dependencias entre ellas. Hasta no desarrollar una, 
% no se puede desarrollar la siguiente. Modelar el árbol.

% Dependencias entre tecnologías:

requiereDirecto(emplumado, herreria).
requiereDirecto(forja, herreria).
requiereDirecto(laminas, herreria).
requiereDirecto(punzon, emplumado).
requiereDirecto(fundicion, forja).
requiereDirecto(malla, laminas).
requiereDirecto(horno, fundicion).
requiereDirecto(placas, malla).
requiereDirecto(collera, molino).
requiereDirecto(arado, collera).

requiere(Tec1, Tec2) :- requiereDirecto(Tec1, Tec2).
requiere(Tec1, Tec3) :-
    requiereDirecto(Tec1, Tec2),
    requiere(Tec2, Tec3).

arbol(Tecnologia, Dependencias):-
    tecnologia(Tecnologia),
    findall(Dependencia, requiere(Tecnologia, Dependencia), Dependencias).

% b) Saber si un jugador puede desarrollar una tecnología, que se cumple cuando ya desarrolló todas sus dependencias 
% (las directas y las indirectas). Considerar que pueden existir árboles de cualquier tamaño.

puedeDesarrollar(Jugador, Tecnologia):-
    jugador(Jugador),
    tecnologia(Tecnologia),
    not(desarrollo(Jugador, Tecnologia)),
    forall(requiere(Tecnologia, Dependencia), desarrollo(Jugador, Dependencia)).
