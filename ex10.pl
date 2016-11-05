start :-
    Li=1,
    Ci=1,
    Lf=8,
    Cf=5,
    lab(La),
    imprime(La),
    tenta(Li,Ci,Lf,Cf,La).

lab(La) :=
La = ["##########",
      "#        #",
      "# # # #  #",
      "# # # ## #",
      "# # # #  #",
      "# # # ## #",
      "# # # #  #",
      "# ###### #",
      "#   #    #",
      "##########"].

imprime([]) :-
    nl, !.   

imprime(La) :-
    La=[H|Lb],
    format("~s~n", [H]),
    imprime(Lb).

tenta(Li,Ci,Li,Ci,Labi) :-
    ocupa(Li,Ci,Labi,Labf),
    imprime(Labf),
    writeln('Cheguei').

tenta(Li,Ci,Lf,Cf,Labi) :-
    livre(Li,Ci,Labi),
    ocupa(Li,Ci,Labi,Labf),
    imprime(Labf),
    tentaD(Li,Ci,Lj,Cj,Labf),
    tenta(Lj,Cj,Lf,Cf,Labf).

tentaD(Li,Ci,Lf,Cf,Labi) :-
    tentaS(Li,Ci,Lf,Cf,Labi).

tentaD(Li,Ci,Lf,Cf,Labi) :-
    tentaL(Li,Ci,Lf,Cf,Labi).

tentaD(Li,Ci,Lf,Cf,Labi) :-
    tentaO(Li,Ci,Lf,Cf,Labi).
                               
tentaD(Li,Ci,Lf,Cf,Labi) :-
    tentaN(Li,Ci,Lf,Cf,Labi).

tentaS(Li,Ci,Lf,Ci,Labi) :-
    Lf is Li + 1,
    livre(Lf,Ci,Labi).

tentaL(Li,Ci,Li,Cf,Labi) :-
    Cf is Ci + 1,
    livre(Li,Cf,Labi).

tentaO(Li,Ci,Li,Cf,Labi) :-
    Cf is Ci - 1,
    livre(Li,Cf,Labi).

tentaN(Li,Ci,Lf,Ci,Labi) :-
    Lf is Li -1,
    livre(Lf,Ci,Labi). 

livre(L,C,Lab) :-
    nth0(L,Lab,Ls),
    string_codes(" ", [S]),
    nth0(C,Ls,S).

ocupa(L,C,Labi,Labf) :-
    nth0(L,Labi,Lx),
    string_codes("x",[X]),
    ocupaX(C,X,Lx,Lr),
    ocupax(L,Lr,Labi,Labf).

ocupax(0,X,[_|Ti]) :-
    !.

ocupaX(I,X,[H|T],[H|R]) :-
    I >0,
    I1 is I -1,
    ocupax(I1,X,T,R). 
