function adj = edge2adj(edge, directed)
%EDGE2ADJ transforms the edge list of a graph into the adjacent matrix.
%
%Syntax: 
% adj = EDGE2ADJ(edge, directed)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst weight] where 'src',
%           'dst', 'weight' stand for the start, end nodes, weight of an 
%           edge respectively. The start point is zero.      
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%
%      adj: (sparse format) The adjacent matrix of the graph.
%   
%Example:
%
%Ref:
%
%Other m-file required: check_idcontinuous4edge
%Subfunctions: None
%MAT-file required: None
%
%See also: adj2edge

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: May 26 20:06 2012 created

%--------------------------------------------------------------------------
 
col = size(edge, 2);

if col < 2
    error('The edge must contain 2 columns at least');
elseif col == 2
    edge(:, 3) = 1;
end

if directed ~= 0 && directed ~= 1
    error('The value of "directed" can only be 0 or 1');
end

edge = check_idcontinuous4edge(edge, directed);

min_id = min(min(edge(:, 1:2)));
if min_id == 0
    edge(:, 1:2) = edge(:, 1:2) + 1;
end

nodes  = edge(:, 1:2);
nodes  = unique(nodes(:));
n_nodes= length(nodes);

clear nodes;

adj = sparse(n_nodes, n_nodes);

row = size(edge, 1);
for i = 1 : row
    ii = edge(i, 1);
    ij = edge(i, 2);
    is = edge(i, 3);
    
    adj = sparse(adj + sparse(ii, ij, is, n_nodes, n_nodes));
end

if directed == 0
    adj = sparse(triu(adj) + triu(adj)');
end
%--------------------------------------------------------------------------
end