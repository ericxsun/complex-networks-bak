function [mean_cc, cc] = node_clustering_coefficient(edge, directed)
%NODE_CLUSTERING_COEFFICIENT calculate the clustering coefficient of a graph.
%
%Syntax: 
% cc = NODE_CLUSTERING_COEFFICIENT(edge, directed)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst] or [src dst weight] 
%           where 'src', 'dst', 'weight' stand for the node, end nodes, 
%           weight of an edge respectively. The node point is zero.   
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%  mean_cc: average clustering coefficient
%       cc: [node id, the clustering coefficient]
%
%Example:
%
%Ref:
%
%Other m-file required: check_idcontinuous4edge
%Subfunctions: None
%MAT-file required: None
%
%See also:

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: July 31 15:25 2012 created

%--------------------------------------------------------------------------

if size(edge, 2) < 2
    error('The edge list must contain 2 columns at least.');
end

if directed ~= 0 && directed ~= 1
    error('The value of "directed" can only be 0 or 1.');
end

if directed == 1
    error('For directed graph, not implemented.');
end

edge = check_idcontinuous4edge(edge, directed);
edge = edge(:, 1:2);

nodes  = unique(edge(:));
n_nodes= length(nodes);

cc = nodes;

for i = 1 : n_nodes
    u = nodes(i);
    
    neigh = [edge(edge(:, 1) == u, 2); edge(edge(:, 2) == u, 1)];
    
    edges_max = size(neigh, 1) * (size(neigh, 1) - 1) / 2;
    
    if edges_max > 0
        idx1 = ismember(edge(:, 1), neigh);
        idx2 = ismember(edge(:, 2), neigh);
        
        edges_real = sum(bitand(idx1, idx2));
        
        cc(i, 2) = edges_real / edges_max;
    end
end
mean_cc = mean(cc(:, 2));
%--------------------------------------------------------------------------
end