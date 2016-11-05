fibon(0,0).
fibon(1,1).

fibon(X,Y) :-
    X > 1,
    X2 is X - 2,fibon(X2,Y2),
    X1 is X - 1,fibon(X1,Y1),
    Y is Y1 + Y2.

fibot(N,_,N).

fibot(N1,N2,N) :-
    N3 is N1 + N2,
    fibot(N2,N3,N).

fibos(X) :-
    fibot(0,1,N),
    member(X,N).
