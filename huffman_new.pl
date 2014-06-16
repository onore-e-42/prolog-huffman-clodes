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

sort_rule(Delta, t([_,WeightA],_,_), t([_, WeightB],_,_)) :-
	compare(Delta, WeightA, WeightB).

insert_sort(List,Sorted):-i_sort(List,[],Sorted).
i_sort([],Acc,Acc).
i_sort([H|T],Acc,Sorted):-insert(H,Acc,NAcc),i_sort(T,NAcc,Sorted).
   
insert(X,[Y|T],[Y|NT]):-sort_rule(>, X, Y),!,insert(X,T,NT).
insert(X,[Y|T],[X,Y|T]):-sort_rule(<, X, Y),!.
insert(X,[],[X]).


decode(Bits, HuffmanTree, Message) :-
	decode_aux(Bits, HuffmanTree, Character, RemainingBits),
	decode(RemainingBits, HuffmanTree, Rest),
	append(Character, Rest, Message).
decode([], _, []).

decode_aux([0|Bits], HuffmanTree, Symbol, Bits) :-
	right_tree(HuffmanTree, t([Symbol, _],nil ,nil)), !.
decode_aux([0|Bits], HuffmanTree, Message, RemainingBits) :-
	right_tree(HuffmanTree, RightTree),
	!,
	decode_aux(Bits, RightTree, Message, RemainingBits).
decode_aux([1|Bits], HuffmanTree, Symbol, Bits) :-
	left_tree(HuffmanTree, t([Symbol, _],nil ,nil)), !.
decode_aux([1|Bits], HuffmanTree, Message, RemainingBits) :-
	left_tree(HuffmanTree, LeftTree),
	!,
	decode_aux(Bits, LeftTree, Message, RemainingBits).

encode([Char|RemainingMessage], HuffmanTree, Bits) :-
	encode_aux(Char, HuffmanTree, Code),
	encode(RemainingMessage, HuffmanTree, Rest),
	append(Code, Rest, Bits).
encode([], _, []).

encode_aux(Char, t(_,t([Symbol, Weight], LeftTree, RightTree),_), Code) :-
	member(Char, Symbol),
	!,
	encode_aux(Char, t([Symbol, Weight], LeftTree, RightTree), Rest),
	append([1], Rest, Code).
encode_aux(Char, t(_,_,t([Symbol, Weight], LeftTree, RightTree)), Code) :-
	member(Char, Symbol),
	!,
	encode_aux(Char, t([Symbol, Weight], LeftTree, RightTree), Rest),
	append([0], Rest, Code).
encode_aux(Char, t([[Char], _], nil, nil), []).

right_tree(t(_,_,RightTree), RightTree).
left_tree(t(_,LeftTree,_), LeftTree).

generate_symbol_bits_table(t([[Char|Symbol], Weight],LeftTree ,RightTree), SymbolBitsTable) :-
	encode([Char], t([[Char|Symbol], Weight],LeftTree ,RightTree), Code),
	!,
	generate_symbol_bits_table(t([Symbol, Weight],LeftTree ,RightTree), Rest),
	append([[Char, Code]], Rest, SymbolBitsTable).
generate_symbol_bits_table(t([[],_], _, _), []).
