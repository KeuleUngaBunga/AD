%for MODULE_NAME.erl
-module(radixS).
-compile(export_all).

%cd("C:/Users/pfeif/Documents/HAW/S3/AD 2/code/AD_Aufg2/Ad_Aufg2").

radixS([], _) -> [];
radixS(List, 1) ->
    Buckets = make_buckets(),
    SortedBuckets=radixS_distribute(List, Buckets, 1),
    radixS_collect(SortedBuckets);

%Digit erst auf 1 reduzieren, dann Ziffer holen und in den entsprechenden Bucket packen
radixS(List, Digit) when Digit > 1 ->
    SortedList = radixS(List, Digit-1),
    Buckets = make_buckets(),
    SortedBuckets=radixS_distribute(SortedList, Buckets, Digit),
    radixS_collect(SortedBuckets).%sortierte Buckets zu Liste machen

%leere Liste der Buckets zurueckgeben (am ende)
radixS_distribute([], Buckets, _) -> Buckets;
radixS_distribute([H|T], Buckets, Digit) ->
    D = get_digit(H, Digit),
    NewBuckets = update_bucket(Buckets, D, H),
    radixS_distribute(T, NewBuckets, Digit).

%Buckets initialisieren
make_buckets() -> [[],[],[],[],[],[],[],[],[],[]].

%Digit an der entsprechenden Stelle holen
get_digit(Number, Digit) ->
    skip_digits(Number, Digit - 1).
% Skip the first (Digit-1) positions by dividing by 10
skip_digits(Number, 0) -> Number rem 10;
skip_digits(Number, Pos) -> skip_digits(Number div 10, Pos - 1).

%-------------------------------------
%Einsortieren der Zahlen in die richtigen Buckets mit iteration
%eig wollte ich hier ein case machen, aber das hat nicht funktioniert
update_bucket([Bucket|Rest], 0, H) ->
    [[H | Bucket] | Rest];
update_bucket([Bucket|Rest], Pos, H) ->
    [Bucket | update_bucket(Rest, Pos - 1, H)].
%-------------------------------------

%-------------------------------------
%Äußere Schleife
%Liste der Buckets zu einer Liste nach einem digit sortierter Liste machen
radixS_collect([]) -> [];
radixS_collect([H|T]) ->
    append_bucket(H, radixS_collect(T)).
%Innere Schleife
%Inhalte der Buckets aneinanderhaengen in reverse Reihenfolge, aufgrund von vorheriger SOrtierung
append_bucket([], Rest) -> Rest;
append_bucket([H|T], Rest) ->
    append_bucket(T, [H | Rest]).
%-------------------------------------

% Funktion zum Testen - gibt die sortierte Liste explizit aus
%redundant für große Listen
radixS_test(List, Digit) ->
    Result = radixS(List, Digit),
    io:format("Sorted: ~w~n", [Result]),
    Result.
%end for MODULE_NAME.erl