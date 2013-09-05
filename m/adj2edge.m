function edge = adj2edge(adj, directed)
%ADJ2EDGE transforms the adjacent matrix of a graph into the edge list.
%
%Syntax: 
%   edge = ADJ2EDGE(adj, directed)
%
%      adj: (sparse format) The adjacent matrix of the graph.
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst weight] where 'src', 
%           'dst', 'weight' stand for the start, end nodes, weight of each 
%           edge respectively. The start point is zero. If the graph is an 
%           unweighted, the 'weight' is set at 1.
%
%Example:
%
%Ref:
%
%Other m-file required: None
%Subfunctions: None
%MAT-file required: None
%
%See also: edge2adj

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: May 26 20:26 2012 created

%--------------------------------------------------------------------------

[row, col] = size(adj);

if row ~= col
    error('adj is not squared');
end

if directed == 0
    adj = sparse(triu(adj));
elseif directed ~= 1
    error('The value of "directed" can only be 0 or 1');
end

[row, col, val] = find(adj);

edge = [row, col, val];

edge = sortrows(edge);

if min(min(edge(:, 1:2))) ~= 0
    edge(:, 1:2) = edge(:, 1:2) - 1;
end
%--------------------------------------------------------------------------
end