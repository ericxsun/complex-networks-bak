function Cnodes = cover(edge, directed)
%COVER find the cover nodes. Once same candidates emerge, one node will be
%choosed at random. For the directed graph, cover nodes will be found
%according to the out-degree.
%
%Syntax: 
% Cnodes = COVER(edge, directed)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst weight] where 'src',
%           'dst', 'weight' stand for the start, end nodes, weight of an 
%           edge respectively. The start point is zero.      
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%
%   Cnodes: The cover nodes, in range [0 n_nodes-1].
%
%Example:
%
%Ref:
%
%Other m-file required: check_idcontinuous4edge.m, degree_sequence.m
%Subfunctions: None
%MAT-file required: None
%
%See also:

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: June 13 11:03 2012 created

%--------------------------------------------------------------------------

if size(edge, 2) < 2
    error('The edge must contain 2 columns at least.');
end

if directed ~= 0 && directed ~= 1
    error('The value of "directed" can only be 0 or 1.');
end

edge = check_idcontinuous4edge(edge, directed);
edge = edge(:, 1:2);
if min(min(edge)) == 0
    edge = edge + 1;
end

degree = degree_sequence(edge, directed);
nodes  = degree(:, 1);
n_nodes= length(nodes);

degree = degree(:, 2);

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

Cnodes = [];
while sum(degree) ~= 0
    max_deg = max(degree);
    candidates = find(degree == max_deg);
    
    node = candidates(randi(length(candidates)));
    
    degree(node) = 0;
    degree(neigh{node}) = 0;
    
    nodes(node) = 1;
    nodes(neigh{node}) = 0;
    
    Cnodes = [Cnodes; node];
end

Cnodes = Cnodes - 1;
%--------------------------------------------------------------------------
end