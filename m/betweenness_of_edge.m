function bs = betweenness_of_edge(edge, directed)
%BETWEENNESS_OF_EDGE calculate the betweenness of each edge.
%
%Syntax: 
% bs = BETWEENNESS_OF_EDGE(edge, directed)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst] or [src dst weight] 
%           where 'src', 'dst', 'weight' stand for the node, end nodes, 
%           weight of an edge respectively. The node point is zero.    
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%
%       bs: [src, dst, betweenness]
%
%Example:
%
%Ref:
%
%Other m-file required: check_idcontinuous4edge
%Subfunctions: None
%MAT-file required: None
%
%See also: betweenness_of_node

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: July 31 15:25 2012 created

%--------------------------------------------------------------------------

if size(edge, 2) < 2
    error('The edge must contain 2 columns at least');
end

if directed ~= 0 && directed ~= 1
    error('The value of "directed" can only be 0 or 1');
end

edge = check_idcontinuous4edge(edge, 0);
edge = edge(:, 1:2);

error('Not implemented');
%--------------------------------------------------------------------------
end