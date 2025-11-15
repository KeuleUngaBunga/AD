%Start for insertionS.erl
%@author Tjark Pfeiffer
%@version 1.0
-module(insertionS).
-compile(export_all).

%cd("C:/Users/pfeif/Documents/HAW/S3/AD 2/code/AD_Aufg2/Ad_Aufg2").

insertionS([]) -> [];
insertionS([H|T]) -> insert(H, insertionS(T)).%erstmal Liste auseinanderbauen, dann einsortieren
insert(X, []) -> [X];%Letztes Element erreicht, einfuegen
insert(X, [H|T]) when X =< H -> [X, H | T];%Liste sortiert wieder zusamenfügen
insert(X, [H|T]) -> [H | insert(X, T)].
%end for insertionS.erl