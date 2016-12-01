%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Hunt The Wumpus - World Simulator                                          %
%    Copyright (C) 2012 - 2016  Ruben Carlo Benante <rcb at beco dot cc>        %
%                                                                               %
%    This program is free software; you can redistribute it and/or modify       %
%    it under the terms of the GNU General Public License as published by       %
%    the Free Software Foundation; version 2 of the License.                    %
%                                                                               %
%    This program is distributed in the hope that it will be useful,            %
%    but WITHOUT ANY WARRANTY; without even the implied warranty of             %
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              %
%    GNU General Public License for more details.                               %
%                                                                               %
%    You should have received a copy of the GNU General Public License along    %
%    with this program; if not, write to the Free Software Foundation, Inc.,    %
%    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Special thanks to:
%     - Gregory Yob
%     - Larry Holder 
%     - Walter Nauber
%
% A Prolog implementation of the Wumpus world invented by Gregory Yob (1972)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To allow an agent to run with the Wumpus Simulator you need to define:
%   init_agent : 
%       It will be called only once, at the start. Put here definitions and
%       other start code you need (asserts, retracts, and so on)
%   run_agent :
%       It will be called each turn by the simulator.
%       Input: perceptions from the world.
%       Expected output: an action for the agent to perform.
%   world_setup([Size, Type, Move, Gold, Pit, Bat, [RandS, RandA]]):
%       This is a fact. It will be consulted only once at the beginning,
%       even before init_agent. It will configure the world as you say,
%       or use a default in case of conflicts or mistakes.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lista de Percepcao: [Stench, Breeze, Glitter, Bump, Scream, Rustle]
% Traducao: [Fedor, Vento, Brilho, Trombada, Grito, Ruido]
% Acoes possiveis (abreviacoes):
% goforward (go)                - andar
% turnright (turn, turnr ou tr) - girar sentido horario
% turnleft (turnl ou tl)        - girar sentido anti-horario
% grab (gr)                     - pegar o ouro
% climb (cl)                    - sair da caverna
% shoot (sh)                    - atirar a flecha
% sit (si)                      - sentar (nao faz nada, passa a vez)
%
% Costs (Custos):
% Actions: -1 (Andar/Girar/Pegar/Sair/Atirar/Sentar)
% Die: -1000 (morrer no buraco, wumpus ou de fadiga)
% Killing the Wumpus: +1000 (matar Wumpus)
% Climbing alive with golds: +500 for each gold (sair com ouro)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To run the example, start PROLOG with (rode o exemplo iniciando o prolog com):
% swipl -s agenteXXX.pl
% then do the query (faca a consulta):
% ?- start.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% world_setup([Size, Type, Move, Gold, Pit, Bat, Adv])
%
% Size and Type: - fig62, 4
%                - grid, [2-9] (default 4)
%                - dodeca, 20
%       +--------+-----------+
%       |  Type  |    Size   |
%       +--------+-----------+
%       | fig62  | 4 (fixed) |
%       | grid   | 2 ... 9   |
%       | dodeca | 20 (fixed)|
%       +--------+-----------+
%
% Configuration:
%    1.   Size: 0,2..9,20, where: grid is [2-9] or 0 for random, dodeca is 20, fig62 is 4.
%    2.   Type: fig62, grid or dodeca
%    3.   Move: stander, walker, runner (wumpus movement)
%    4.   Gold: Integer is deterministic number, float from 0.0<G<1.0 is probabilistic
%    5.   Pits: Idem, 0 is no pits.
%    6.   Bats: Idem, 0 is no bats.
%    7.   Adv: a list with advanced configuration in the form [RandS, RandA]:
%       - RandS - yes or no, random agent start position
%       - RandA - yes or no, random agent start angle of orientation
%
% examples: 
% * default:
%      world_setup([4, grid, stander, 0.1, 0.2, 0.1, [no, no]]).
% * size 5, 1 gold, 3 pits, some bats prob. 0.1, agent randomly positioned
%      world_setup([5, grid, stander, 1, 3, 0.1, [yes]]). 
%
%   Types of Wumpus Movement
%       walker    : original: moves when it hears a shoot, or you enter its cave
%       runner    : go forward and turn left or right on bumps, maybe on pits
%       wanderer  : arbitrarily choses an action from [sit,turnleft,turnright,goforward]
%       spinner   : goforward, turnright, repeat.
%       hoarder   : go to one of the golds and sit
%       spelunker : go to a pit and sit
%       stander   : do not move (default)
%       trapper   : goes hunting agent as soon as it leaves [1,1]; goes home otherwise
%       bulldozer : hunt the agent as soon as it smells him
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% agente007.pl:
%
% Strategy: goes only forward, do not turn, do not grab gold, do not come back
% Performance: it does not go very well as you can imagine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- use_module(wumpus, [start/0]). % agente usa modulo simulador

% Mundo: 
%    Tamanho (size) 5x5, quadrado
%    Wumpus anda ao acaso mas vai para cima se proximo
%    1 ouro, 3 buracos e 1 morcego
%    agente inicia em casa aleatoria
%    Maximo de acoes antes de morrer de fome: Size^2x4 = 5x5x4 = 100
world_setup([0, grid, walker, 0.1, 0.2, 1, [no]]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Inicie aqui seu programa.

:-dynamic([ultacao/1,       %Fatos Dinâmicos
    ouro/1,
    aposicao/1,
    angulo/1,
    casas_visitadas/1,
    visitadas/1,
    cont_acoes/1,
    flechas/1,
    wumpus/1,
    listaacao/1,
    voltando/1,
    voltandox/1]).

init_agent :-
    retractall(listaacao(_)),
    retractall(voltando(_)),
    retractall(voltandox(_)),
    retractall(ultacao(_)),
    retractall(ouro(_)),
    retractall(aposicao(_)),
    retractall(casas_visitadas(_)),    
    retractall(visitadas(_)),
    retractall(angulo(_)),
    retractall(cont_acoes(_)),   
    retractall(flechas(_)),
    retractall(wumpus(_)),
    assert(listaacao([climb])),
    assert(voltando(0)),
    assert(voltandox(0)),
    assert(aposicao([[1,1]])),             %casa inicial
    assert(ouro(0)),                    %Quantidade inicial de ouro
    assert(casas_visitadas([[1,1]])),   %casas visitadas
    assert(angulo(0)),                  %Orientacao inicial do agente
    assert(visitadas([[1,1]])),          %casas visitadas
    assert(cont_acoes(0)),             % conta a quantidade de acoes
    assert(flechas(1)),                %Quantidade de flechas
    assert(wumpus(vivo)).

run_agent(Percepcao, Acao) :-
    acao(Percepcao, Acao),
    listando(Percepcao),
    morto(Percepcao),
    %Fatos%
    aposicao(Posicao),    %Posicao inicial
    ouro(Quantidade),     %Quantidade de ouro
    cont_acoes(Qacoes),   %quantidade de acoes
    wumpus(Estado),       %Vivo/Morto
    %Predicados
    cria_casasvi,         %Cria casas visitadas
    visitadas(Visitadas), 
    verifica(Acao),
    atualiza_cont_acoes,  %Quantidade de acoes do a
    %   casa_frente(Posicao,Sentido,Frente),
    %Impressao
    write('Quantidade de acoes: '),
    writeln(Qacoes),
    write('Quantidade de ouro: '),
    writeln(Quantidade),
    write('Minha posicao: '),
    writeln(Posicao),
    write('Casas visitadas'),
    writeln(Visitadas),
    write('Estado do Wumpus :'),
    writeln(Estado).


listando(P) :-
    voltando(0),
    listaacao([Y]),
    assert(listaacao([P|Y])).
listando(_).

acao(_,X) :-
    ouro(G),
    G > 0,
    voltandox(Y),
    Y < 3,
    Z is Y + 1,
    retractall(voltando(_)),
    retractall(voltandox(_)),
    assert(voltando(1)),
    assert(voltandox(Z)),
    X = turnright;
    wumpus(morto),
    voltandox(Y),
    Y < 3,
    Z is Y + 1,
    retractall(voltando(_)),
    retractall(voltandox(_)),
    assert(voltando(1)),
    assert(voltandox(Z)),
    X = turnright.

acao(_,X) :-
    voltando(1),
    ouro(G),
    G > 0,
    listaacao([Y|F]),
    retractall(listaacao(_)),
    assert(listaacao([F])),
    Y = turnleft,
    X = turnright;
    voltando(1),
    ouro(G),
    G > 0,
    listaacao([Y|F]),
    retractall(listaacao(_)),
    assert(listaacao([F])),
    Y = turnright,
    X = turnleft;
    voltando(1),
    ouro(G),
    G > 0,
    listaacao([Y|F]),
    retractall(listaacao(_)),
    assert(listaacao([F])),
    X = Y. 
     
acao(_,X) :-
    voltando(1),
    wumpus(morto),
    listaacao([Y|F]),
    retractall(listaacao(_)),
    assert(listaacao([F])),
    Y = turnleft,
    X = turnright;
    voltando(1),
    wumpus(morto),
    listaacao([Y|F]),
    retractall(listaacao(_)),
    assert(listaacao([F])),
    Y = turnright,
    X = turnleft;
    voltando(1),
    wumpus(morto),
    listaacao([Y|F]),
    retractall(listaacao(_)),
    assert(listaacao([F])),
    X = Y. 
 
acao([_,_,yes|_],grab):-
    ouro(X),
    retractall(ouro(_)),
    Xf is X+1,
    assert(ouro(Xf)),
    write('Estou rico!'),
    nl.

acao([_,yes|_],X) :- %Vento
    listaacao(Y|_),
    Y = turnleft,
    X = goforward.

acao([_,yes|_],turnleft). %Vento

acao([_,_,_,_,_,yes],X) :- %Ruido
    ultacao(Y),
    Y = turnright,
    X = goforward.

acao([_,_,_,_,_,yes],turnright). %Ruido

acao([_,_,_,yes,_,_],turnleft).  %Trombada

acao([yes,yes,_,_,_,_],shoot):-  %fedor   / caso o agente sinta fedor/vento e wumpus vivo, ele atira
    wumpus(vivo),                 
    flechas(F),
    F>0,
    atira.

acao([yes,_,_,_,_,_],turnright). %fedor

acao(_,X) :-   %Andar aleatoriamente
    random_between(1,10,Y),
    andar(Y,X).


%predicado que vai atualizando a quantidade de acoes
atualiza_cont_acoes :-
    cont_acoes(Qacoes),
    Qacoes1 is Qacoes+1,
    retractall(cont_acoes(_)),
    assert(cont_acoes(Qacoes1)).


%adjacentes(X,Y,Z):-
%    aposicao[[X,Y]],
%    X1 is X + 1,
%    X2 is X - 1,
%    Y1 is Y + 1,
%    Y2 is Y - 1,
%    Z = [[X, Y1],[X, Y2],[X1, Y],[X2, Y]],
%    write('Casas adjacentes'),
%    writeln(Z).    

verifica(Ac) :-
    Ac == goforward,
    salvapos,
    aposicao(X),
    addvisitadas(X).

verifica(Ac) :-
    Ac == turnleft,
    salvaangulo(Ac).

verifica(Ac) :-
    Ac == turnright,
    salvaangulo(Ac).

verifica(_).

morto([_,_,_,_,yes]):- %declara o wumpus como morto
    retractall(wumpus(_)),
    assert(wumpus(morto)).

morto(_).


andar(Y,X) :-
    Y =< 8,
    X = goforward;
    Y =:= 9,
    X = turnright;
    Y =:= 10,
    X = turnleft.

salvapos :-
    angulo(A),
    A =:= 0,
    aposicao([[X,Y]]),
    Xf is X+1,
    retractall(aposicao(_)),
    assert(aposicao([[Xf,Y]])).

salvapos :-
    angulo(A),
    A =:= 180,
    aposicao([[X,Y]]),
    Xf is X-1,
    retractall(aposicao(_)),
    assert(aposicao([[Xf,Y]])).

salvapos :-
    angulo(A),
    A =:= 90,
    aposicao([[X,Y]]),
    Yf is Y+1,
    retractall(aposicao(_)),
    assert(aposicao([[X,Yf]])).

salvapos :-
    angulo(A),
    A =:= 270,
    aposicao([[X,Y]]),
    Yf is Y-1,
    retractall(aposicao(_)),
    assert(aposicao([[X,Yf]])).

salvaangulo(turnright) :-
    angulo(A),
    A1 is A - 90,
    convencao(A1, A2),
    retractall(angulo(_)),
    assert(angulo(A2)).

salvaangulo(turnleft) :-
    angulo(A),
    A1 is A + 90,
    convencao(A1, A2),
    retractall(angulo(_)),
    assert(angulo(A2)).

convencao(-90, 270).
convencao(360, 0).
convencao(A, A).

addvisitadas(X) :-
    visitadas(A),
    W = [X],
    union(W,A,C),
    retractall(visitadas(_)),
    assert(visitadas(C)).

%Predicado para criar casas visitadas

cria_casasvi:-
    aposicao(Posicao),
    casas_visitadas(Cvi),
    append(Posicao, Cvi, Lista1),
    list_to_set(Lista1, Lista),
    retractall(casas_visitadas(_)),
    assert(casas_visitadas(Lista)),
    write('Casas seguras: '),
    writeln(Lista).


%acoes para o agente voltar pelas casas visitadas
%acao(_, Acao):-
%   casas_visitadas(CasasVisitadas),
%    minhacasa(Posicao),
%   angulo(Sentido),
%   casa_frente(Posicao, 0, Frente), %qual a casa da frente com sentido 0
%   member(Frente, casas_visitadas),
%   acao(Sentido, 0, Acao).

%acoes para o agente voltar pelas casas visitadas
%acao(_, Acao):-
%   casas_visitadas(CasasVisitadas),
%    minhacasa(Posicao),
%   angulo(Sentido),
%   casa_frente(Posicao, 90, Frente), %qual a casa da frente com sentido 90
%   member(Frente, casas_visitadas),
%   acao(Sentido, 90, Acao).

%acoes para o agente voltar pelas casas visitadas
%acao(_, Acao):-
%   casas_visitadas(CasasVisitadas),
%    minhacasa(Posicao),
%   angulo(Sentido),
%   casa_frente(Posicao, 180, Frente), %qual a casa da frente com sentido 180
%   member(Frente, casas_visitadas),
%   acao(Sentido, 180, Acao).

%acoes para o agente voltar pelas casas visitadas
%acao(_, Acao):-
%   casas_visitadas(CasasVisitadas),
%    minhacasa(Posicao),
%   angulo(Sentido),
%   casa_frente(Posicao, 270, Frente), %qual a casa da frente com sentido 270
%   member(Frente, casas_visitadas),
%   acao(Sentido, 270, Acao).

atira :-  %agente com flecha e capaz de atirar no wumpus e flecha e decrementada%
    flechas(X),
    X>0,
    X1 is X-1,
    retractall(agente_flecha(_)),
    assert(agente_flecha(X1)).


salvaseguras :-
    aposicao(X,Y),  %Vejo a posição onde ele se encontra
    Sx is X + 1,  %Somo 1 a X para salvar a casa do lado direito    
    Dx is X - 1,  %Diminuo 1 a X para salvar a casa do lado esquerdo
    Sy is Y + 1,  %Somo 1 a Y para salvar a casa de cima
    Dy is Y - 1,  %Diminuo 1 a Y para salvar a casa de baixo
    visitadas(E),
    seguraw(W),
    union([[X,Dy]],W,P),
    union([[Dx,Y]],P,Q),
    union([[X,Sy]],Q,R),
    union([[Sx,Y]],R,S),
    intersection(S,E,I),
    subtract(S,I,T),
    retractall(seguras(_)), %limpa o que tiver em seguras
    assert(seguras(T)).
/* ----------------------------------------------------------------------- */
/* vi: set ai et ts=4 sw=4 tw=0 wm=0 fo=croql : PL config for Vim modeline */
