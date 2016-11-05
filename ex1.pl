homem(john).
homem(eduardo).
homem(sandro).
homem(eduardof).
homem(rodrigo).
homem(rogerio).
homem(daniel).
homem(matheus).
homem(rodrigof).
homem(rogeriof).

mulher(graca).
mulher(regina).
mulher(karen).
mulher(deborah).
mulher(claudia).
mulher(nicole).
mulher(giovana).

pai(john,karen).
pai(john,deborah).
pai(eduardo,eduardof).
pai(eduardo,rodrigo).
pai(eduardo,claudia).
pai(sandro,daniel).
pai(sandro,nicole).
pai(eduardof,matheus).
pai(eduardof,giovana).
pai(rogerio,rodrigof).
pai(rogerio,rogeriof).

mae(graca,karen).
mae(graca,deborah).
mae(regina,eduardof).
mae(regina,rodrigo).
mae(regina,claudia).
mae(karen,daniel).
mae(karen,nicole).
mae(deborah,matheus).
mae(deborah,giovana).
mae(claudia,rodrigof).
mae(claudia,rogeriof).

casado(sandro,karen).
casado(karen,sandro).
casado(deborah,eduardof).
casado(eduardof,deborah).
casado(claudia,rogerio).
casado(rogerio,claudia).

filho(A,B) :-
    homem(A),
    pai(B,A).
filho(A,B) :-
    homem(A),
    mae(B,A).
filha(A,B) :-
    mulher(A),
    pai(B,A).
filha(A,B) :-
    mulher(A),
    mae(B,A).
irmao(A,B) :-
    dif(A,B),
    homem(A),
    pai(C,A),
    pai(C,B).
irmao(A,B) :-
    dif(A,B),
    homem(A),
    mae(C,A),
    mae(C,B).
irma(A,B) :-
    dif(A,B),
    mulher(A),
    pai(C,A),
    pai(C,B).
irma(A,B) :-
    dif(A,B),
    mulher(A),
    mae(C,A),
    mae(C,B).
avoo(A,B) :-
    homem(A),
    pai(A,C),
    pai(C,B).
avoo(A,B) :-
    homem(A),
    pai(A,C),
    mae(C,B).
avoa(A,B) :-
    mulher(A),
    mae(A,C),
    pai(C,B).
avoa(A,B) :-
    mulher(A),
    mae(A,C),
    mae(C,B).
tio(A,B) :-
    homem(A),
    irmao(C,A),
    pai(C,B).
tio(A,B) :-
    homem(A),
    irma(C,A),
    mae(C,B).
tio(A,B) :-
    homem(A),
    casado(A,C),
    irma(C,D),
    mae(D,B).
tio(A,B) :-
    homem(A),
    casado(A,C),
    irma(C,D),
    pai(D,B).
tia(A,B) :-
    mulher(A),
    irmao(C,A),
    pai(C,B).
tia(A,B) :-
    mulher(A),
    irma(C,A),
    mae(C,B).
tia(A,B) :-
    mulher(A),
    casado(A,C),
    irmao(C,D),
    mae(D,B).
tia(A,B) :-
    mulher(A),
    casado(A,C),
    irmao(C,D),
    pai(D,B).
primo(A,B) :-
    homem(A),
    pai(C,A),
    pai(D,B),
    irmao(C,D).
primo(A,B) :-
    homem(A),
    mae(C,A),
    mae(D,B),
    irma(C,D).
primo(A,B) :-
    homem(A),
    mae(C,A),
    pai(D,B),
    irma(C,D).
primo(A,B) :-
    homem(A),
    pai(C,A),
    mae(D,B),
    irmao(C,D).
prima(A,B) :-
    mulher(A),
    pai(C,A),
    pai(D,B),
    irmao(C,D).
prima(A,B) :-
    mulher(A),
    mae(C,A),
    mae(D,B),
    irma(C,D).
prima(A,B) :-
    mulher(A),
    mae(C,A),
    pai(D,B),
    irma(C,D).
prima(A,B) :-
    mulher(A),
    pai(C,A),
    mae(D,B),
    irmao(C,D).
sobrinho(A,B) :-
    homem(A),
    tio(B,A).
sobrinho(A,B) :-
    homem(A),
    tia(B,A).
sobrinha(A,B) :-
    mulher(A),
    tio(B,A).
sobrinha(A,B) :-
    mulher(A),
    tia(B,A).
neto(A,B) :-
    homem(A),
    pai(C,A),
    pai(B,C).
neto(A,B) :-
    homem(A),
    mae(C,A),
    pai(B,C).
neto(A,B) :-
    homem(A),
    mae(C,A),
    mae(B,C).
neto(A,B) :-
    homem(A),
    pai(C,A),
    mae(B,C).
neta(A,B) :-
    mulher(A),
    pai(C,A),
    pai(B,C).
neta(A,B) :-
    mulher(A),
    mae(C,A),
    pai(B,C).
neta(A,B) :-
    mulher(A),
    mae(C,A),
    mae(B,C).
neta(A,B) :-
    mulher(A),
    pai(C,A),
    mae(B,C).
