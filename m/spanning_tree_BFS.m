function Tnode = spanning_tree_BFS(neigh, start, directed)
%SPANNING_TREE_BFS find the maximum tree from the start point.
%
%Syntax: 
% Tnode = SPANNING_TREE_BFS(neigh, start, directed)
%
%    neigh: (cell, nx1)neighbors of each node, neigh{i} represents the 
%           neighbors of node i - 1. The nodes in neigh{i} start at 0.
%    start: (numeric) the start point in range [0, length(neigh) - 1].
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%
%    Tnode: the nodes in the spanning tree of the 'start'.
%
%Example:
%
%Ref:
%
%Other m-file required: None
%Subfunctions: None
%MAT-file required: None
%
%See also:

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: July 31 15:25 2012 created

%--------------------------------------------------------------------------
narginchk(3, 3);

if directed ~= 0 && directed ~= 1
    error('The value of "directed" can only be 0 or 1.');
end

if directed == 1
    error('For directed graph, not implemented.');
end

n_nodes = size(neigh, 1);
visited = zeros(n_nodes, 1);
to_visit= start;

while ~isempty(to_visit)
    from = to_visit(end);
    to_visit(end) = [];
    
    visited(from+1) = 1;
    
    neigh_from = neigh{from};
    neigh_from(visited(neigh_from) == 1) = [];
    
    to_visit = union(to_visit, neigh_from);
end

Tnode = (find(visited ~= 0) - 1);
%--------------------------------------------------------------------------
end