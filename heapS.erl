-module(introS).
-author("2734017, 2746759").
-export([introS/3]).
%-compile(export_all).

introS(PivotMethod, List, SwitchNum) -> introS(PivotMethod, List, SwitchNum, 1).

% wählt bei N < SwitchNum insertionS aus, bei RecursionDepth > 2*log2(N) wird heapS ausgewählt, sonst wird qsort benutzt und RecursionDepth inkrementiert
introS(PivotMethod, List, SwitchNum, RecursionDepth) -> 
    N = getListLength(List),
    case N < SwitchNum of                           %(Entwurf: AF1)
	    true -> insertionS:insertionS(List);        %(Entwurf: A1)
		
		false -> 
		    case RecursionDepth > (2* util:floor(math:log2(N))) of         %(Entwurf: AF2)
			    true -> heapS:heapS(List);                                 %(Entwurf: A2)
				
				false -> qsort(List, PivotMethod, RecursionDepth +1, SwitchNum) %(Entwurf: A3)
			end
	end.

% wähle zuerst je nach Methode das Pivotelement aus
% danach wird die Liste in zwei kleinere Listen aufgeteilt: alle Zahlen < Pivot links und alle Zahlen >= Pivot rechts
% ruft zum Schluss introS für beide Teillisten erneut auf
qsort(List, PivotMethod, RecursionDepth, SwitchNum) -> 
    [H|_T] = List,
    Pivot =                             %(Entwurf: A4)
        case PivotMethod of
	        left -> H;
		    middle -> getMiddleElement(List, (getListLength(List) div 2));
		    right -> getLastElement(List);
		    median -> getMedianElement(List);
		    rand -> getRandomElement(List, getListLength(List))
        end,
	{LeftList, RightList} = sortAroundPivot(List, Pivot, [], []),
	Left = introS(PivotMethod, LeftList, SwitchNum, RecursionDepth),           %(Entwurf: A6)
	Right = introS(PivotMethod, RightList, SwitchNum, RecursionDepth),
	collect(Left, Right).
	%Left ++ Right. %-> kopieren der Listen langsamer?
	
collect([], RightList) -> RightList;
collect([H|T], RightList) -> [H|collect(T, RightList)].

%(Entwurf: A5)
sortAroundPivot([], _Pivot, LeftList, RightList) -> {LeftList, RightList};
sortAroundPivot([H|T], Pivot, LeftList, RightList) -> 
    case H < Pivot of
	    true -> sortAroundPivot(T, Pivot, [H|LeftList], RightList);
		false -> sortAroundPivot(T, Pivot, LeftList, [H|RightList])
	end.

getMiddleElement([H|_T], 0) -> H;
getMiddleElement([_H|T], HalfListLength) -> getMiddleElement(T, HalfListLength -1). 
	
getLastElement([H|[]]) -> H;
getLastElement([_H|T]) -> getLastElement(T).

% wählt als Median das Element, das zwischen den anderen beiden liegt aus den Elementen: links, mitte, rechts -> zb [2,8,6] wählt 6 aus
getMedianElement([H|T]) ->
    Left = H,
	Middle = getMiddleElement([H|T], (getListLength([H|T]) div 2)),
	Right = getLastElement([H|T]),
	[_E1, E2, _E3] = insertionS:insertionS([Left, Middle, Right]),
	E2.

getRandomElement(List, NumberOfElements) -> 
    [N] = util:randomliste(1, 1, NumberOfElements),
	getElementN(List, N).

%Aufrufer muss sicherstellen, dass N Inbound der Liste ist
getElementN([H|_T], 1) -> H;
getElementN([_H|T], N) -> getElementN(T, N -1).

% List Comprehensions erlaubt?
%qsort([]) -> [];
%qsort([Pivot|T]) -> qsort([X || X <- T, X < Pivot])
%++ [Pivot] ++
%qsort([X || X <- T, X >= Pivot]).

getListLength(List) -> getListLength(List, 0).
getListLength([], Length) -> Length;
getListLength([_H|T], Length) -> getListLength(T, Length +1).
