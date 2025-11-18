-module(heapS).
-author("Soheil Samar").
%-compile(export_all).
-export([heapS/1,calcPath/1]).

%%-----------------------------------------------------------------
% Heapsort

% Kodierung des Feldes: Nachfolger von Position i ist 2*i links und 2*i+1 rechts
% berechnet den Pfad zur ersten leeren Position
% l steht fuer links, r fuer rechts
% Beispiel: sort:calcPath(1). --> []
% 		heapS:calcPath(2). --> [l]
% 		heapS:calcPath(3). --> [r]
% 		heapS:calcPath(4). --> [l,l]
% 		heapS:calcPath(5). --> [l,r]
% 		heapS:calcPath(6). --> [r,l] 
% 		heapS:calcPath(7). --> [r,r] 
calcPath(Number) -> calcPath(Number,[]).
% aktuelle Position ist Wurzel
calcPath(1,Akku) -> Akku;
% aktuelle Position ist gerade
calcPath(Number,Akku) when Number rem 2 =:= 0 -> calcPath(Number div 2,[l|Akku]);
% aktuelle Position ist ungerade
calcPath(Number,Akku) when Number rem 2 =/= 0 -> calcPath((Number-1) div 2,[r|Akku]).				  

heapS([]) -> [];
heapS(List) -> heapS2(createHeap(List)).
heapS2({Heap, NodeCounter}) -> destroyHeap(Heap, NodeCounter).

%Input: List, Output: {Heap, NumberOfNodes} ; -> bringt die Element der Liste in eine MaxHeap-Struktur 
createHeap(List) -> createHeap(List, {}, 1).
createHeap([], Heap, PathNumber) -> {Heap, PathNumber -1};
createHeap([H|T], Heap, PathNumber) -> createHeap(T, addElemToHeap(H, Heap, calcPath(PathNumber)), PathNumber +1).

%Input: (Element, Heap, Path zur nächsten freien Stelle), Output: Heap ; -> fügt Element in Heap an der nächsten freien Stelle ein
% -> beim Suchen nach der nächsten freien Stelle, werden die Values der Nodes verglichen und mit dem kleineren Value weitergesucht
addElemToHeap(Element, _Heap, []) -> {Element, {}, {}};
addElemToHeap(Element, {Value, LCN, RCN}, [H|T]) ->
    case Element < Value of
        true ->
            case H of
                r -> {Value, LCN, addElemToHeap(Element, RCN, T)};
                l -> {Value, addElemToHeap(Element, LCN, T), RCN}
            end;

        false -> 
            case H of
                r -> {Element, LCN, addElemToHeap(Value, RCN, T)};
                l -> {Element, addElemToHeap(Value, LCN, T), RCN}
            end
    end.

%Input: (Heap, NumberOfNodes in Heap), Output: sorted List ; -> entfernt Wurzelelement des Heaps und schreibt dessen Value in sorted List, sortiert den Heap erneut und wiederholt
% calcPath(NodeCounter) gibt den Path zur LastNode an
destroyHeap(Heap, NodeCounter) -> destroyHeap(Heap, NodeCounter, []).
destroyHeap({Value, {}, {}}, _NodeCounter, Akku) -> [Value|Akku]; 
destroyHeap({Value, LCN, RCN}, NodeCounter, Akku) ->  destroyHeap(reHeap({Value, LCN, RCN}, calcPath(NodeCounter)), NodeCounter -1, [Value|Akku]). 

%Input: (Heap, Path zur LN), Output: Heap ; -> ersetzt Wurzel mit LNV, entfernt Verweis auf LN und sortiert den Heap erneut 
reHeap(Heap, Path) -> 
    {{_Value, LCN, RCN}, LastNodeValue} = removeLastNode(Heap, Path),
    makeMaxHeap({LastNodeValue, LCN, RCN}).
	

%Nach unten laufen und LastNode-Value holen, Verweis auf LastNode in dessen Parent muss entfernt werden!

%Input: (Heap, Path zur LN), Output: {Heap, LNV} ; -> entfernt die LastNode und extrahiert dessen Value
removeLastNode({Value, LCN, RCN}, [H|[]]) -> 
    case H of
	    r -> {{Value, LCN, {}}, getNodeValue(RCN)};
		l -> {{Value, {}, RCN}, getNodeValue(LCN)}
    end;
removeLastNode({Value, LCN, RCN}, [H|T]) -> 
    case H of
	    r -> {UpdatedRCN, LastNodeValue} = removeLastNode(RCN, T),         %Pattern matcher nutzen, um LNV zu extrahieren
		     {{Value, LCN, UpdatedRCN}, LastNodeValue};
			 
		l -> {UpdatedLCN, LastNodeValue} = removeLastNode(LCN, T),         %Pattern matcher nutzen, um LNV zu extrahieren
		     {{Value, UpdatedLCN, RCN}, LastNodeValue}
	end.

getNodeValue({Value, _LCN, _RCN}) -> Value.

%Input: Heap, Output: Heap ; -> stellt MaxHeap-Struktur wieder her 
makeMaxHeap({ParentValue, {}, {}}) -> {ParentValue, {}, {}};
makeMaxHeap({ParentValue, LCN, {}}) ->
    {ValueLCN, LLCN, LRCN} = LCN,
	case ParentValue > ValueLCN of
	    true -> {ParentValue, LCN, {}};
		false -> {ValueLCN, makeMaxHeap({ParentValue, LLCN, LRCN}), {}}
	end;
%Struktur {Value,{},RCN} sollte nie vorkommen
%makeMaxHeap({ParentValue, {}, RCN}) ->
%    {ValueRCN, RLCN, RRCN} = RCN,
%	case ParentValue > ValueRCN of
%	    true -> {ParentValue, {}, RCN};
%		false -> {ValueRCN, {}, makeMaxHeap({ParentValue, RLCN, RRCN})}
%	end;
makeMaxHeap({ParentValue, LCN, RCN}) ->
    {ValueLCN, LLCN, LRCN} = LCN, 
	{ValueRCN, RLCN, RRCN} = RCN,
    case ValueLCN > ValueRCN of
	    true -> 
		    case ParentValue > ValueLCN of
			    true -> {ParentValue, LCN, RCN};
				false -> {ValueLCN, makeMaxHeap({ParentValue, LLCN, LRCN}), RCN}
			end;
			
		false ->
		    case ParentValue > ValueRCN of
			    true -> {ParentValue, LCN, RCN};
				false -> {ValueRCN, LCN, makeMaxHeap({ParentValue, RLCN, RRCN})} 
			end
	end.
