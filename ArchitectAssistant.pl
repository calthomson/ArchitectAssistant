prop(master_bedroom, type, bedroom).
prop(master_bedroom, walls, [((1,1),(2,2)),((2,2),(3,3)),((3,3),(1,1))]).

% wall((X1,Y1),(X2,Y2)) returns true if the corners (X1,Y1) and (X2,Y2) form a valid wall:
% A valid wall is one where X1,Y1,X2,Y2 are all numbers and (X1,Y1) and (X2,Y2) are not the same points
% TODO: Loose comparisons for zero?
wall((X1,Y1),(X2,Y2)) :- number(X1), number(Y1), number(X2), number(Y2),
	wlength(((X1,Y1),(X2,Y2)), L), L \= 0.0.

% wlength returns true when L, the length between two points, is equal to the result
% of the pythagoras theorem
wlength(((X1,Y1),(X2,Y2)), L) :- L is sqrt((X1-X2)^2 + (Y1-Y2)^2).

% room(W) returns true when W is a list of walls that forms a valid room R
% A valid room has 3 or more walls, where each wall is connected to the preceeding wall, and the
% first wall is connected to the last
room([H,I|T]):- length(T,L), L>0,connectedFirstLast(H,[I|T]), connectedrest([H,I|T]).
connectedrest([H,I|T]):- connected(H,I), connectedrest([I|T]).
connectedrest([H]).

% connected(W1,W2) returns true when walls W1 and W2 intersect
% Walls W1 and W2 intersect return true when the second point of W1 and the first point of
% W2 are the same and both W1 and W2 are valid walls
connected(((X1,Y1),(X2,Y2)), ((X2,Y2),(X4,Y4))) :- number(X1), number(Y1), number(X2), number(Y2),
	wlength(((X1,Y1),(X2,Y2)), L), L \= 0.0.

% connectedFirstLast(W1, W2) returns true when the first wall W1 and the last wall W2 intersect
% Base case: Walls W1 and W2 intersect when the first point of W1 intersects with the last point of W2
% and W1 and W2 are both valid walls.
connectedFirstLast(((X1,Y1),_), [((X2,Y2),(X1,Y1))]) :- number(X2), number(Y2), number(X1), number(Y1),
	wlength(((X2,Y2),(X1,Y1)), L), L \= 0.0. 
% Loop: Iterate through the list of walls until we reach the last wall so that we may compare it to the first
connectedFirstLast(F, [_|T]) :- connectedFirstLast(F,T).

% valid(X) returns true when room X is valid. First we get the type of X, then we check if X is valid
% member of this type.
valid(X) :- prop(X,type, Y), valid(X, Y).

%valid(X,Y) returns true when X is a valid member of type Y.
valid(X, room) :- prop(X, walls, R), room(R).
valid(X, bedroom) :- room(X).

// Room subclasses
prop(X, type, room) :- prop(X, type, bathroom).
prop(X, type, room) :- prop(X, type, bedroom).
prop(X, type, room) :- prop(X, type, kitchen).
prop(X, type, room) :- prop(X, type, living_room).