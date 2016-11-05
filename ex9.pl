:- dynamic([flechas/1],[wvivo/1]).

start :-
    configinicial(5),
    assert(wvivo(1)).

configuraflechas(X) :-
    imprime_antes,
    nl,
    retractall(flechas(_)),
    assert(flechas(X)),
    imprime_depois.

atira :-
    wvivo(0),
    flechas(X),
    X > 0,
    imprime_antes,
    nl,
    writeln('voce atirou com sucesso'),
    Y is X - 1,
    atiraflecha(Y),
    imprime_depois.

atira :-
    wvivo(1),
    flechas(X),
    X > 0,
    imprime_antes,
    nl,
    writeln('voce atirou com sucesso'),
    random_between(1,10,R),
    mata(R),
    Y is X - 1,
    atiraflecha(Y),
    imprime_depois.

atira :-
    flechas(X),
    X  = 0,
    imprime_antes,
    nl,
    writeln('voce nao conseguio atirar').

imprime_antes :-
    flechas(X),
    write('voce tinha '),
    write(X),
    write(' flecha(s).').

imprime_depois :-
    flechas(X),
    write('voce tem agora '),
    write(X),
    write(' flechas.').

atiraflecha(X) :-    
    retractall(flechas(_)),
    assert(flechas(X)).

configinicial(X) :-
    retractall(flechas(_)),
    assert(flechas(X)).

mata(X) :-
    X =< 3,
    retractall(wvivo(_)),
    assert(wvivo(0)),
    write('voce matou o wumpus'),
    nl.

mata(X) :-
    X >= 4,
    write('voce nao matou o wumpus'),
    nl.
