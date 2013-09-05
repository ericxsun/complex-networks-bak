function edge = ERmodel(p, n_nodes)
%ERMODEL generate an undirected connected random graph according to the 
%Erdos-Renyi model.
%
%Syntax: 
% edge = ERMODEL(p, n_nodes)
%
%       p: rewire probability 
% n_nodes: number of node
%
%    edge: (matrix) The edge list of the graph defined by the adjacent
%          matrix. Each line is expressed as [src dst weight] where 'src', 
%          'dst', 'weight' stand for the start, end nodes, weight of an 
%          edge respectively. The start point is zero.
%   
%Example:
%
%Ref:
%Erdős, Paul; A. Rényi (1960). "On the evolution of random graphs". 
%Publications of the Mathematical Institute of the Hungarian Academy of 
%Sciences 5: 17–61.
%
%All possible pairs of nodes are connected with probability p.
%
%Other m-file required: None
%Subfunctions: spanning_tree
%MAT-file required: None
%
%See also: BAmodel, Regularmodel, WSmodel

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: Dec. 6 17:29 2012 created

%--------------------------------------------------------------------------

if p < 0 || p > 1
    error('The value of "p" can only be in [0, 1].');
end

if n_nodes < 0
    error('The value of "n_nodes" must be positive.');
end

k = 1;
while 1
    fprintf('I am trying: %d--', k);
    k = k+1;
    neighbors = cell(n_nodes, 1);
    
    for i = 1 : n_nodes
        fprintf('[%d-%d]\n', n_nodes, i);
        i_neighbors = (rand(1, n_nodes - i) <= p);
        
        i_neighbors = find(i_neighbors > 0) +i;
        
        neighbors{i} = unique([neighbors{i}, i_neighbors]);
        
        for j = 1 : length(i_neighbors)
            neighbors{i_neighbors(j)} = unique([neighbors{i_neighbors(j)}, i]);
        end  
    end
    
    %connectivity check
%     if length(spanning_tree(neighbors, 1)) == n_nodes
%         break;
%     end
    edge = neighbors2edge(neighbors, n_nodes);
    conn = connectivity(edge, 0);
    if conn == 1
        break;
    end
end

%form edge
% edge = [];
% for i = 1 : n_nodes
%     gt_neighbors = neighbors{i}(neighbors{i} > i);
%     edge = [edge; repmat(i, length(gt_neighbors), 1), gt_neighbors'];
% end
% 
% edge(:, 3) = 1;
% edge(:, 1:2) = edge(:, 1:2) - 1;
% edge = neighbors2edge(neighbors, n_nodes);
edge = check_idcontinuous4edge(edge, 0);
%--------------------------------------------------------------------------
end

function edge = neighbors2edge(neighbors, n_nodes)
%neighbors{i} represents the neighbors of node i
%

edge = [];

for i = 1 : n_nodes
    gt = neighbors{i}(neighbors{i} > i);
    
    edge = [edge; repmat(i, length(gt), 1), gt'];
end
edge = edge - 1;
end

function Tnodes = spanning_tree(neighbors, start)
%index of node starts at 1 in neighbor list
%neighbors{i}: the neighbors of node i

n_node = size(neighbors, 1);

visited = zeros(n_node, 1);

to_visit = start;

while ~isempty(to_visit)
    from = to_visit(end);
    to_visit(end) = [];
    
    visited(from) = 1;
    
    neighbor_from = neighbors{from};
    
    neighbor_from(visited(neighbor_from) == 1) = [];
    
    to_visit = union(to_visit, neighbor_from);
end

Tnodes = find(visited ~= 0);
end