function neigh = node_neigh(edge, directed, node)
%NODE_NEIGH find the neighbors of node 'node' in the graph defined by edge.
%
%Syntax: 
% neigh = NODE_NEIGH(edge, directed, node)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst] or [src dst weight] 
%           where 'src', 'dst', 'weight' stand for the node, end nodes, 
%           weight of an edge respectively. The node point is zero.
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%     node: (numeric) the node, in range [0, length(neigh) - 1].
%
%    neigh: (vector)neighbors of node 'node' for undirected graph. (cell,
%           2x1){1}out neighbors and {2}in neighbors for directed graph.
%
%Example:
%
%Ref:
%
%Other m-file required: None
%Subfunctions: None
%MAT-file required: None
%
%See also: edge_neigh

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

if node < node_min_idx || node > node_max_idx
    error('The node-%d is not in this graph. Please check.', node);
end

if directed == 0
    neigh = unique([edge(edge(:, 1) == node, 2); edge(edge(:, 2) == node, 1)]);
else
    neigh{1} = unique(edge(edge(:, 1) == node, 2));
    neigh{2} = unique(edge(edge(:, 2) == node, 1));
end
%--------------------------------------------------------------------------
end