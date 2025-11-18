%Start for introS.erl
%@author Tjark Pfeiffer
%@version 1.0
-module(introS).
-compile(export_all).

%cd("C:/Users/pfeif/Documents/HAW/S3/AD 2/code/AD_Aufg2/Ad_Aufg2").
introS(Pivot_method, [], _) -> [];
introS(Pivot_method, List, Switch_num) ->
    Maxdepth = calculate_maxdepth(length(List)),
    introS_helper(Pivot_method, List, Maxdepth, Switch_num).

%maxdepth berechnen
calculate_maxdepth(N) ->
    2 * trunc(math:log2(N)).


%introS 
introS_helper(_, [], _, _) -> [];
%zu insertionS wechseln, wenn Größe von der Liste kleiner als Switch_num ist
introS_helper(Pivot_method, List, _, Switch_num) -> when Switch_num >= length(List) ->
    insertionS(List);
%TODO: zu Heap sort wechseln, wenn maxdepth erreicht ist//grade noch radix sort
introS_helper(_, List, 0, _) ->
    MaxDigit = max_digit(List),
    radixS(List, MaxDigit);
%continue with quicksort
introS_helper(Pivot_method, List, Maxdepth, Switch_num) ->
    {Less, Greater,_} = partition(List, determine_pivot_element(Pivot_method, List)),
    concat_lists(introS_helper(Pivot_method, Less, Maxdepth - 1, Switch_num), %beide sortierte Hälften zusammenfügen
                    introS_helper(Pivot_method, Greater, Maxdepth - 1, Switch_num)).

%partition function
partition([], _) -> {[], [], 0};
partition([H|T], Pivot) ->  
    {Less, Greater, Alt} = partition(T, Pivot),%Alt to distribute equal Elements evenly
    if
        H <= Pivot -> {[H | Less], Greater, Alt};
        H == Pivot when Alt == 0 -> {[H|Less], Greater, 1};
        H == Pivot when Alt == 1 -> {Less, [H|Greater], 0};
        H > Pivot -> {Less, [H | Greater], Alt}
    end.

%determine pivot element based on 5 possible method
determine_pivot_element(median, List) ->
    First = determine_pivot_element(left, List),
    Last = determine_pivot_element(right, List),
    Middle = determine_pivot_element(middle, List),
    if 
    left < right, left < middle, right < middle ->
        right;
    left < right, left < middle, middle < right ->
        middle;
    right < left, right < middle, left < middle ->
        left;%what if some are equal?

%TODO: bib Funktionen austauschen
determine_pivot_element(middle, List) ->
    MiddleIndex = length(List) div 2,
    lists:nth(MiddleIndex + 1, List);
determine_pivot_element(random, List) ->
    random_pivot(List);
determine_pivot_element(left, List) ->
    hd(List);
determine_pivot_element(right, List) ->
    lists:last(List).   

%random pivot function
random_pivot(List) ->
    RandomIndex = random:uniform(length(List)),
    lists:nth(RandomIndex, List).

%concat two lists without ++ or lists module
concat_lists([], List2) -> List2;
concat_lists([H|T], List2) -> [H | concat_lists(T, List2)].

%-----------------------------------------------------
%nutzlos, wenn Heap fertig
max_digit(List) ->
    MaxNumber = lists:max(List),
    count_digits(MaxNumber).