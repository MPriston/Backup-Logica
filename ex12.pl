%Coordenadas Proximas
%Aluno: Matheus Priston

coordenadas(X,Y) :-
    X =< 0,
    write('Erro Coordenadas incorretas'),
    !;
    Y =< 0,
    write('Erro Coordenadas incorretas'),
    !.

coordenadas(X,Y) :-
    X1 is X + 1,
    X2 is X - 1,
    Y1 is Y + 1,
    Y2 is Y - 1,
    append([[X1,Y],[X2,Y]],[[X,Y1],[X,Y2]],A),
    delete(A,[_,0],B),
    delete(B,[0,_],P),
    write('As Coordenadas proximas sao : '),
    write(P).
