generate_huffman_tree(SymbolsAndWeights, HuffmanTree) :- 
	initialize_tree(SymbolsAndWeights, SymbolsAndWeightsTree),
	generate_huffman_tree_aux(SymbolsAndWeightsTree, HuffmanTree).

initialize_tree([[Symbol, Weight]|SymbolsAndWeights], SymbolsAndWeightsTree) :-
	initialize_tree(SymbolsAndWeights, Temp),
	append([t([[Symbol], Weight], nil, nil)], Temp, SymbolsAndWeightsTree).
initialize_tree([],[]) :-!.

generate_huffman_tree_aux(SymbolsAndWeightsTree, HuffmanTree) :-
	insert_sort(SymbolsAndWeightsTree, Ordered),	
	generate_tree(Ordered, HuffmanTree).

generate_tree([A,B|Ordered], Tree) :-
	unite(A, B, United),
	append([United], Ordered, OrderedFinal),
	generate_huffman_tree_aux(OrderedFinal, Tree),
	!.
generate_tree([A|[]], A) :- !.

unite(t([SymbolA, WeightA], RightA, LeftA), t([SymbolB, WeightB], RightB, LeftB), t([SymbolAB, WeightAB], t([SymbolA, WeightA], RightA, LeftA), t([SymbolB, WeightB], RightB, LeftB))) :-
	append(SymbolA, SymbolB, SymbolAB),
	WeightAB is WeightA + WeightB.

sort_rule(Delta, t([SymbolA,WeightA],_,_), t([SymbolB, WeightB],_,_)) :-
	compare(Delta, WeightA, WeightB).

insert_sort(List,Sorted):-i_sort(List,[],Sorted).
i_sort([],Acc,Acc).
i_sort([H|T],Acc,Sorted):-insert(H,Acc,NAcc),i_sort(T,NAcc,Sorted).
   
insert(X,[Y|T],[Y|NT]):-sort_rule(>, X, Y),!,insert(X,T,NT).
insert(X,[Y|T],[X,Y|T]):-sort_rule(<, X, Y),!.
insert(X,[],[X]).

decode([0|Bits], HuffmanTree, Message) :-
	right_tree(HuffmanTree, t([Symbol, Weight],nil ,nil)),
	!,
	decode(Bits, HuffmanTree, PartialMessage),
	append(Symbol, PartialMessage, Message).
decode([0|Bits], HuffmanTree, Message) :-
	right_tree(HuffmanTree, RightTree),
	!,
	decode(Bits, RightTree, Message).
decode([1|Bits], HuffmanTree, Message) :-
	left_tree(HuffmanTree, t([Symbol, Weight],nil ,nil)),
	!,
	decode(Bits, HuffmanTree, PartialMessage),
	append(Symbol, PartialMessage, Message).
decode([1|Bits], HuffmanTree, Message) :-
	left_tree(HuffmanTree, LeftTree),
	!,
	decode(Bits, LeftTree, Message).
decode([], _, []) :- !.
decode(_, [], []) :- !.

right_tree(t(_,_,RightTree), RightTree).
left_tree(t(_,LeftTree,_), LeftTree).
	
