%Start for introS.erl
-module(introS).
-author("Tjark Pfeiffer").
-export([introS/3]).
-import(heapS, [heapS/1]).
-import(insertionS, [insertionS/1]).

%cd("C:/Users/pfeif/Documents/HAW/S3/AD 2/code/AD_Aufg2/Ad_Aufg2").
introS(_, [], _) -> [];
introS(Pivot_method, List, Switch_num) ->
    Maxdepth = calculate_maxdepth(length(List)),
    introS_helper(Pivot_method, List, Maxdepth, Switch_num).

%maxdepth berechnen
calculate_maxdepth(N) ->%Entwurf B1
    2 * trunc(math:log2(N)).

%introS 
introS_helper(_, [], _, _) -> [];%Entwurf A1/A2
%zu insertionS wechseln, wenn Größe von der Liste kleiner als Switch_num ist
introS_helper(_, List, _, Switch_num) when Switch_num >= length(List) ->
    insertionS(List);
%zu Heap sort wechseln, wenn maxdepth erreicht ist
introS_helper(_, List, 0, _) -> heapS(List);%Entwurf B1/B2
%continue with quicksort
introS_helper(Pivot_method, List, Maxdepth, Switch_num) ->%Entwurf C1
    {Less, Greater,_} = partition(List, determine_pivot_element(Pivot_method, List)),
    concat_lists(introS_helper(Pivot_method, Less, Maxdepth - 1, Switch_num), %beide sortierte Hälften zusammenfügen
                    introS_helper(Pivot_method, Greater, Maxdepth - 1, Switch_num)).

%partition function
partition([], _) -> {[], [], 0};%Entwurf C1
partition([H|T], Pivot) ->  
    {Less, Greater, Alt} = partition(T, Pivot),%Alt to distribute equal Elements evenly
    if
        H < Pivot -> {[H | Less], Greater, Alt};
        H == Pivot, Alt == 0 -> {[H|Less], Greater, 1};
        H == Pivot, Alt == 1 -> {Less, [H|Greater], 0};
        H > Pivot -> {Less, [H | Greater], Alt}
    end.

%determine pivot element based on 5 possible method
determine_pivot_element(median, List) ->
    First = determine_pivot_element(left, List),
    Last = determine_pivot_element(right, List),
    Middle = determine_pivot_element(middle, List),
    if 
    First < Last, First < Middle, Last < Middle ->
        Last;
    First < Last, First < Middle, Middle < Last ->
        Middle;
    Last < First, Last < Middle, First < Middle ->
        First;
    %gleiche Elemente
    Last == First, Last < Middle ->
        Last;
    Middle == First, Middle < Last ->
        Middle;
    true ->
        First%wenn alle gleich sind, dann irgendeines zurueckgeben
    end;

determine_pivot_element(middle, List) ->
    MiddleIndex = length(List) div 2,
    get_middle(MiddleIndex-1, List);
determine_pivot_element(random, List) ->
    random_pivot(List);
determine_pivot_element(left, [H|_]) ->
    H;
determine_pivot_element(right, List) ->
    get_last(List).


%random pivot function
random_pivot(List) ->
    RandomIndex = rand:uniform(length(List)),
    lists:nth(RandomIndex, List).

%middle Element aus Liste holen
get_middle(0, [H|_]) -> H;
get_middle(N, [_|T]) when N > 0 -> get_middle(N -1, T).
%right(letztes) Element aus Liste holen
get_last([H]) -> H;
get_last([_|T]) -> get_last(T).
%Listen aneinanderhängen 
concat_lists([], List2) -> List2;
concat_lists([H|T], List2) -> [H | concat_lists(T, List2)].

% end for introS.erl