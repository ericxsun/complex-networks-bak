function edge = Regularmodel(mean_k, n_nodes)
%REGULARMODEL generate an undirected connected regular random graph(each
%node with degree mean_k).
%
%Syntax: 
% edge = REGULARMODEL(mean_k, n_nodes)
%
%  mean_k: the average degree
% n_nodes: number of nodes
%
%    edge: (matrix) The edge list of the graph defined by the adjacent
%          matrix. Each line is expressed as [src dst weight] where 'src', 
%          'dst', 'weight' stand for the start, end nodes, weight of an 
%          edge respectively. The start point is zero.
%   
%Example:
%
%Ref:
%
%Other m-file required: None
%Subfunctions: None
%MAT-file required: None
%
%See also: BAmodel, ERmodel, WSmodel

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: Dec 06 17:29 2012 created

%--------------------------------------------------------------------------

if mean_k <= 0
    error('The average degree should be greater than 0.');
end
 
if mod(mean_k, 2) ~= 0
    warning('the average degree is not even, reset as %d', ...
            mean_k-1);
    mean_k = mean_k - 1;
end

if mean_k >= n_nodes
    warning('the average degree is greater than %d, reset as %d',...
            n_nodes-1, n_nodes-1);
    mean_k = n_nodes - 1;
end

nodes = 0 : 1 : n_nodes-1;

%contruct a regular ring lattice
mean_k = mean_k / 2;
neighbors = cell(n_nodes, 1);

for i = 1 : n_nodes
    id = nodes(i);
    right = mod((id+1 :  1 : id+mean_k), n_nodes);
    left  = mod((id-1 : -1 : id-mean_k), n_nodes);
    
    neighbors{i} = unique([right, left]);
end

%form edge
edge = [];
for i = 1 : n_nodes
    gt_neighbors = neighbors{i}(neighbors{i} > nodes(i));

    edge = [edge; repmat(i-1, length(gt_neighbors), 1), gt_neighbors'];
end
edge(:, 3) = 1;

edge = sortrows(edge);

%--------------------------------------------------------------------------
end