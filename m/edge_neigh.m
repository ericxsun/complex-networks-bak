function neigh = edge_neigh(edge, directed, src, dst)
%NODE_NEIGH find the neighbors of node 'start' in the graph defined by edge.
%
%Syntax: 
% neigh = NODE_NEIGH(edge, directed, start)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst weight] where 'src', 
%           'dst', 'weight' stand for the node, end nodes, weight of an 
%           edge respectively. The node point is zero.
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%  src/dst: (integer)the end point of one edge.
%
%    neigh: (vector)neighbors of edge 'src-dst'.
%
%Example:
%
%Ref:
%
%Other m-file required: None
%Subfunctions: None
%MAT-file required: None
%
%See also: node_neigh

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: July 31 16:15 2012 created

%--------------------------------------------------------------------------

if size(edge, 2) < 2
    error('The edge must contain 2 columns at least.');
end

if directed ~= 0 && directed ~= 1
    error('The value of "directed" can only be 0 or 1.');
end

edge = check_idcontinuous4edge(edge, directed); %node in edge node at 0
edge = edge(:, 1:2);

node_max_idx = max(max(edge));
node_min_idx = min(min(edge));

if src < node_min_idx || src > node_max_idx || ...
   dst < node_min_idx || dst > node_max_idx
    error('The node-%d is not in this graph. Please check.', node);
end

error('Not implimented.');
%--------------------------------------------------------------------------
end