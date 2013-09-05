function new_edge = reshuffle_degree_unpreserved_adj(adj, p)
%RESHUFFLE_DEGREE_UNPRESERVED_ADJ randomise a graph without preserving its 
%degree sequence
%
%Note:
% Only for undirected and unweigted graph.
%
%Syntax: 
% new_edge = RESHUFFLE_DEGREE_UNPRESERVED_ADJ(edge)
% new_edge = RESHUFFLE_DEGREE_UNPRESERVED_ADJ(edge, p)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst] or [src dst weight] 
%           where 'src', 'dst', 'weight' stand for the node, end nodes, 
%           weight of an edge respectively. The node point is zero.
%
%        p: rewire probability.
%
% new_edge: see edge.
%
%Example:
%
%Ref:
%
%
%Other m-file required: check_idcontinuous4edge.m
%Subfunctions: spanning_tree
%MAT-file required: None
%
%See also: reshuffle_degree_unpreserved, reshuffle_degree_preserved, 
%          reshuffle_degree_preserved_BFS

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: Dec 19, 2012 created

%--------------------------------------------------------------------------
narginchk(1, 2);

if nargin == 1
    p = 0.5;
end

[row, col] = size(adj);

if row ~= col
    error('The matrix adj shoule be squared');
end

n_nodes = row;

%rewire
k = 1;
while 1
    fprintf('REWIRING: %d\n', k);
    k = k + 1;
    
    for i = 1 : n_nodes
        neigh   = find(adj(i, :) > 0);
        disconn = find((rand(1, length(neigh)) <= p) > 0);
    end
end


%--------------------------------------------------------------------------
end
