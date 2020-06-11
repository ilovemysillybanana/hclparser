Nonterminals
blocks block array list attrs attr value.

Terminals
number float string bool equal comma open_curly close_curly open_array close_array identifier.

Rootsymbol blocks.

value -> block      : '$1'.
value -> array      : '$1'.
value -> number     : unwrap('$1').
value -> float      : unwrap('$1').
value -> string     : unwrap('$1').
value -> bool       : unwrap('$1').

% providers and variables, and other objects that only have
% one identifier 

% nested block code 
block -> open_curly attrs close_curly                   : '$2'.
block -> open_curly close_curly                         : #{}.

% single name block code, i.e "variables" or "providers"
blocks -> block blocks : block_processor('$1', '$2').
blocks -> block : block_processor('$1').
block -> identifier string open_curly close_curly              : #{ unwrap('$1') => #{ unwrap('$2') => {} } }.
block -> identifier string open_curly attrs close_curly        : #{ unwrap('$1') => #{ unwrap('$2') => '$4'}}.
block -> identifier string string open_curly close_curly       : #{ unwrap('$1') => #{ unwrap('$2') => #{ unwrap('$3') => {} } } }.

attrs -> attr attrs : put_tuple('$1', '$2').
attrs -> attr : put_tuple('$1').
attr -> identifier equal identifier :  {unwrap('$1'), unwrap('$3')}.
attr -> identifier equal string     :  {unwrap('$1'), unwrap('$3')}.
attr -> identifier equal number     :  {unwrap('$1'), unwrap('$3')}.
attr -> identifier equal float      :  {unwrap('$1'), unwrap('$3')}.
attr -> identifier equal bool       :  {unwrap('$1'), unwrap('$3')}.
attr -> identifier equal array      :  {unwrap('$1'), '$3'}.
attr -> identifier block            :  {unwrap('$1'), '$2'}.

array -> open_array list close_array : '$2'.
array -> open_array close_array : [].

list -> value comma list : [ '$1' | '$3'].
list -> value : ['$1'].

Erlang code.
unwrap_2({Value}) -> Value.
unwrap({_, _, Value}) -> Value.
put_tuple({Key, Value}) -> maps:put(Key, Value, #{}).
put_tuple({Key, Value}, Other) -> maps:merge(maps:put(Key, Value, #{}), Other).
block_processor(Block) -> Block.
block_processor(Block, OtherBlocks) ->
    maps:fold(fun(Key,Value,AccIn) -> merge_block(Key,Value,AccIn,maps:get(Key,AccIn,undefined)) end, Block, OtherBlocks).
merge_block(Key,Value,Acc,undefined) ->
    maps:put(Key, Value, Acc);
merge_block(Key,Value1,Acc,Value2) ->
    maps:put(Key,block_processor(Value1,Value2),Acc).