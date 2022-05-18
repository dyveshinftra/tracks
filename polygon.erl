% a closed circuit
%
% TODOS:
%   eunit
%   performance improvement

-module(polygon).
-export([from_list/1, join/2, join_test/0]).

from_list(L) -> {polygon, L}.

% join two polygons which share one common vertex or two neighbouring common
% vertices
join({polygon, L1}, {polygon, L2}) ->
    from_list(lists:reverse(join(L1, L2, [], first, undefined))).

% both polygons consumed, all done, return accumulated polygon
join([], [], A, _, _) ->
    A;

% consume (tail of) first polygon
join([H|T], [], A, first, V) ->
    join(T, [], [H|A], first, V);

% single common vertex and second polygon is consumes,
% insert common vertex again and switch back to first polygon
join(P1, [], A, second, V) ->
    join(P1, [], [V|A], first, V);

% common vertex found, switch between polygons, remember common vertex
join([H|T1], [H|T2], A, first, _) -> join(T1, T2, [H|A], second, H);
join([H|T1], [H|T2], A, second, V) -> join(T1, T2, [H|A], first, V);

% when polygon vertices differ, take from either first or second polygon
join([H1|T1], [H2|T2], A, first, V) -> join(T1, [H2|T2], [H1|A], first, V);
join([H1|T1], [H2|T2], A, second, V) -> join([H1|T1], T2, [H2|A], second, V).

join_test() ->
    {polygon, [1, 2, 4, 3]} = join(from_list([1, 2, 3]), from_list([2, 4, 3])),
    {polygon, [1, 2, 4, 3, 5]} = join(from_list([1, 2, 3, 5]), from_list([2, 4, 3])),
    {polygon, [1, 2, 4, 5, 2, 3]} = join(from_list([1, 2, 3]), from_list([2, 4, 5])),
    ok.
