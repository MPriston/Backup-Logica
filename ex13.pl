caminho([X,Y],A,[X1,Y1],Acao):-
    X2 is X1 - X,
    Y2 is Y1 - Y,
    angulo(X2,Y2,A1),
    acao(A,A1,Acao),
    !.

acao(A,A1,X) :- %para quando o agente tem que ir a 0 graus%
    A = 0,
    A1 =< 45,
    A1 >= 0,
    X = goforward,
    !;
    A = 270,
    A1 =< 45,
    A1 >= 0,
    X = turnleft,
    !;
    A = 180,
    A1 =< 45,
    A1 >= 0,
    X = turnleft,
    !;
    A = 90,
    A1 =< 45,
    A1 >= 0,
    X = turnright,
    !;
    A = 0,
    A1 =< 360,
    A1 >= 315,
    X = goforward,
    !;
    A = 270,
    A1 =< 360,
    A1 >= 315,
    X = turnleft,
    !;
    A = 180,
    A1 =< 360,
    A1 >= 315,
    X = turnleft,
    !;
    A = 90,
    A1 =< 360,
    A1 >= 315,
    X = turnright,
    !.

acao(A,A1,X) :- %para quando o agente tem que ir a 90 graus%
    A = 90,
    A1 >= 45,
    A1 =< 135,
    X = goforward,
    !;
    A = 180,
    A1 >= 45,
    A1 =< 135,
    X = turnright,
    !;
    A = 270,
    A1 >= 45,
    A1 =< 135,
    X = turnright,
    !;
    A = 0,
    A1 >= 45,
    A1 =< 135,
    X = turnleft,
    !.

acao(A,A1,X) :- %para quando o agente tem que ir a 180 graus%
    A = 180,
    A1 >= 135,
    A1 =< 225,
    X = goforward,
    !;
    A = 270,
    A1 >= 135,
    A1 =< 225,
    X = turnright,
    !;
    A = 0,
    A1 >= 135,
    A1 =< 225,
    X = turnright,
    !;
    A = 90,
    A1 >= 135,
    A1 =< 225,
    X = turnleft,
    !.

acao(A,A1,X) :- %para quando o agente tem que ir a 180 graus%
    A = 270,
    A1 >= 225,
    A1 =< 315,
    X = goforward,
    !;
    A = 0,
    A1 >= 225,
    A1 =< 315,
    X = turnright,
    !;
    A = 90,
    A1 >= 225,
    A1 =< 315,
    X = turnright,
    !;
    A = 180,
    A1 >= 225,
    A1 =< 315,
    X = turnleft,
    !.

angulo(X,Y,A) :-
    X > 0,
    Y > 0,
    H is sqrt((X*X)+(Y*Y)),
    A is round((acos(X/H))*(180/pi)).

angulo(X,Y,A) :-
    X < 0,
    Y > 0,
    X1 is X*(-1), 
    H is sqrt((X1*X1)+(Y*Y)),
    A1 is round((acos(X1/H))*(180/pi)),
    A is A1 + 90.

angulo(X,Y,A) :-
    X > 0,
    Y < 0,
    Y1 is Y*(-1),
    H is sqrt((X*X)+(Y1*Y1)),
    A1 is round((acos(X/H))*(180/pi)),
    A is A1 + 270.

angulo(X,Y,A) :-
    X < 0,
    Y < 0,
    X1 is X*(-1),
    Y1 is Y*(-1),
    H is sqrt((X1*X1)+(Y1*Y1)),
    A1 is round((acos(X1/H))*(180/pi)),
    A is A1 + 180.

angulo(X,Y,A) :-
    X = 0,
    Y > 0,
    A = 90,
    !.

angulo(X,Y,A) :-
    X = 0,
    Y < 0,
    A = 270,
    !.

angulo(X,Y,A) :-
    X > 0,
    Y = 0,
    A = 0,
    !.

angulo(X,Y,A) :-
    X < 0,
    Y = 0,
    A = 180,
    !.

