prolog-huffman-clodes
=====================

Huffman tree encoder/decoder written in Prolog.

generate_huffman_tree(SymbolsAndWeight, HuffmanTree): true if HuffmanTree is the tree generated from SymbolsAndWeights.

decode(Bits, HuffmanTree, Message): true if Bits is Message encoded following HuffmanTree.

encode(Message, HuffmanTree, Bits): true if Message is Bits decoded following HuffmanTree.

generate_symbol_bits_table(HuffmanTree, SymbolBitsTable): true if SymbolBitsTable is a list coupling characters from 
HuffmanTree with the relative code.

SymbolsAndWeight syntax:
e.g.
[[a,5],[b,2],[c,23],[d,55],[f,1]]

HuffmanTree syntax:
e.g.
t([[f, b, a, c, d], 86], t([[f, b, a, c], 31], t([[f, b, a], 8], t([[f, b], 3], t([[f], 1], nil, nil), t([[b], 2], nil, nil)), 
t([[a], 5], nil, nil)), t([[c], 23], nil, nil)), t([[d], 55], nil, nil))

Bits syntax:
e.g.
[1, 1, 0, 1, 1, 1, 1]

Message syntax:
e.g.
[a, f]

SymbolBitsTable syntax:
e.g.
[[f, [1, 1, 1, 1]], [b, [1, 1, 1, 0]], [a, [1, 1, 0]], [c, [1, 0]], [d, [0]]]
