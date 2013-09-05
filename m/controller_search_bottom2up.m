function [ctrlr, ctrld] = controller_search_bottom2up(edge, directed)
%CONTROLLER_SEARCH_BOTTOM2UP find the controller and controlled nodes of a
%graph using the greedy algorithm 'bottom-up' controller search. For the
%directed graph, only the in-degree is considered.
%
%
%Syntax: 
% [ctrlr, ctrld] = CONTROLLER_SEARCH_BOTTOM2UP(edge, directed)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst weight] where 'src',
%           'dst', 'weight' stand for the start, end nodes, weight of an 
%           edge respectively. The start point is zero.      
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%
%    ctrlr: the set of controlling nodes, value in range [0 n_nodes-1].
%    ctrld: the set of controlled nodes, value in range [0 n_nodes-1].
%
%Example:
%
%Ref:
% controlling centrality in complex networks by V. Nicosia...
%
%Iteratively do:
%   M -the set M containing all the vertices with minimum in-degree(or
%   degree in undirected graph)   
%   for each vertex(i) in M
%       select the vertices j with the maximum out-degree(or degree in
%       undirected graph) in the set of vertices which point to i, then
%       makr j as controller, and the vertices which j points to(or j's
%       neighbors in undirected graph) as controlled, remove all the
%       controller and controlled vertices and links associated with them
%       from the graph.
%
%Other m-file required: check_idcontinuous4edge.m, degree_sequence.m
%Subfunctions: None
%MAT-file required: None
%
%See also: ctroller_search_top2down

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: June 13 16:03 2012 created

%--------------------------------------------------------------------------

col = size(edge, 2);

if col < 2
    error('The edge must contain 2 columns at least');
end

if directed ~= 0 && directed ~= 1
    error('The value of "directed" can only be 0 or 1');
end

edge = check_idcontinuous4edge(edge, directed);
edge = edge(:, 1:2);
if min(min(edge)) == 0
    edge = edge + 1;
end

nodes   = sort(unique(edge(:)));
n_nodes = length(nodes);

nodes(:, 2) = 0;    %0-controller, 1-controlled


%neighbors
neigh = cell(n_nodes, 1);

if directed == 0
    for i = 1 : n_nodes
        neigh{i} = [edge(edge(:, 1) == i, 2); edge(edge(:, 2) ==i, 1)];
    end
elseif directed == 1
    for i = 1 : n_nodes
        neigh{i} = edge(edge(:, 1) == i, 2);
    end
end

while 1
    %all links are deleted
    if size(edge, 1) == 0
        break;
    end
    
    %choose node from the nodes with minimum degree at random.
    deg_seq = degree_sequence(edge, directed);
    min_deg = min(deg_seq(:, 2));
    
    candidates = find(deg_seq(:, 2) == min_deg);
    node = candidates(randi(length(candidates)));
    
    nodes(ismember(nodes(:, 1), neigh{node}), 2) = 1;
    
    %delete links
    edge(edge(:, 1) == node | edge(:, 2) == node, :) = [];
    edge(ismember(edge(:, 1), neigh{node}), :) = [];
    edge(ismember(edge(:, 2), neigh{node}), :) = [];
end

ctrlr = sort(nodes(nodes(:, 2) == 0, 1) - 1);
ctrld = sort(nodes(nodes(:, 2) == 1, 1) - 1);
%--------------------------------------------------------------------------
end