% a closed circuit
-module(polygon).

% TODO join_test: convert to eunit
-export([from_list/1, join/2, join_test/0]).

from_list(L) -> {polygon, L}.

% Join two polygons on common vertices; follow first polygon until a common
% vertex is found, then follow second polygon until the first polygon is hit
% again.
join({polygon, L1}, {polygon, L2}) ->
    from_list(lists:reverse(join_p1(L1, L2, []))).
join_p1([X|T1], [X|T2], L3) -> join_p2(T1, T2, [X|L3]);
join_p1([H1|T1], [H2|T2], L3) -> join_p1(T1, [H2|T2], [H1|L3]).
join_p2([X], [X], L3) -> [X|L3];
join_p2([H1|T1], [H2|T2], L3) -> join_p2([H1|T1], T2, [H2|L3]).

join_test() ->
    {polygon, [1, 2, 4, 3]} = join(from_list([1, 2, 3]), from_list([2, 4, 3])),
    ok.
