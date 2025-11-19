%Start for insertionS.erl
-module(insertionS).
-author("Tjark Pfeiffer").
-export([insertionS/1]).

%cd("C:/Users/pfeif/Documents/HAW/S3/AD 2/code/AD_Aufg2/Ad_Aufg2").

%aus iterativem Entwurf eine rekursive Funktion gemacht, deshalb schwer die Parallelen zu erkennen
insertionS([]) -> [];
insertionS([H|T]) -> insert(H, insertionS(T)).%erstmal Liste auseinanderbauen, dann einsortieren
insert(X, []) -> [X];%Letztes Element erreicht, einfuegen | Entwurf 11, aber umgekehrt
insert(X, [H|T]) when X =< H -> [X, H | T];%Liste sortiert wieder zusamenfügen | Entwurf 5,10
insert(X, [H|T]) -> [H | insert(X, T)].% Entwurf 6,7,8
%end for insertionS.erl