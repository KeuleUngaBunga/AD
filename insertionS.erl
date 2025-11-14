%for MODULE_NAME.erl
-module(insertionS).
-compile(export_all).

%cd("C:/Users/pfeif/Documents/HAW/S3/AD 2/code/AD_Aufg2/Ad_Aufg2").

insertionS([]) -> [];
insertionS([H|T]) -> insert(H, insertionS(T)).
insert(X, []) -> [X];
insert(X, [H|T]) when X =< H -> [X, H | T];
insert(X, [H|T]) -> [H | insert(X, T)].
%end for MODULE_NAME.erl