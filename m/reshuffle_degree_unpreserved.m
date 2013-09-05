function new_edge = reshuffle_degree_unpreserved(edge, p)
%RESHUFFLE_DEGREE_UNPRESERVED randomise a graph without preserving its 
%degree sequence
%
%Note:
% Only for undirected and unweigted graph.
%
%Syntax: 
% new_edge = RESHUFFLE_DEGREE_UNPRESERVED(edge)
% new_edge = RESHUFFLE_DEGREE_UNPRESERVED(edge, p)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst] or [src dst weight] 
%           where 'src', 'dst', 'weight' stand for the node, end nodes, 
%           weight of an edge respectively. The node point is zero.
%
%        p: rewire probability.
%
% new_edge: see edge.
%
%Example:
%
%Ref:
%
%
%Other m-file required: check_idcontinuous4edge.m
%Subfunctions: spanning_tree
%MAT-file required: None
%
%See also: reshuffle_degree_unpreserved, reshuffle_degree_preserved, 
%          reshuffle_degree_preserved_BFS

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: Dec 19, 2012 created

%--------------------------------------------------------------------------

if nargin == 1
    p = 0.5;
end

if size(edge, 2) < 2
    error('The edge must contain 2 columns at least');
end

edge = check_idcontinuous4edge(edge, 0);
edge = edge(:, 1:2);

if min(min(edge)) == 0
    edge = edge + 1;
end

nodes  = unique(edge(:));
n_nodes= length(nodes);

old_neighbors = cell(n_nodes, 1);

for i = 1 : n_nodes
    old_neighbors{i} = (sort([edge(edge(:, 1) == nodes(i), 2);
                              edge(edge(:, 2) == nodes(i), 1)]))';
end

%rewire
k = 1;
while 1
    fprintf('REWIRING: %d\n', k);
    k = k + 1;
    
    neighbors = old_neighbors;
    
    for i = 1 : n_nodes
        n_i_neighbors = length(neighbors{i});

        disconnect = neighbors{i}((rand(1, n_i_neighbors) <= p) == 1);

        n_disconnect = length(disconnect);
        if n_disconnect <= 0
            continue;
        end

        while 1
            new_connect = randperm(n_nodes, n_disconnect);
            new_connect = setdiff(new_connect, [nodes(i), neighbors{i}]);

            if length(new_connect) == n_disconnect
                break;
            end
        end

        %add and del
        neighbors{i} = [setdiff(neighbors{i}, disconnect), new_connect];
        
        for j = 1 : length(new_connect)
            id = new_connect(j);
            neighbors{id} = union(neighbors{id}, nodes(i));
        end
        for j = 1 : n_disconnect
            id = disconnect(j);
            neighbors{id} = setdiff(neighbors{id}, nodes(i));
        end
    end
    
    %connectivity check
    if length(spanning_tree(neighbors, 1)) == n_nodes
        break;
    end    
end

%form edge
new_edge = [];
for i = 1 : n_nodes
    gt_neighbors = neighbors{i}(neighbors{i} > nodes(i));

    new_edge = [new_edge; repmat(i, length(gt_neighbors), 1), gt_neighbors'];
end

new_edge = new_edge - 1;

new_edge = check_idcontinuous4edge(new_edge, 0);
%--------------------------------------------------------------------------
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

Tnodes = (find(visited ~= 0) - 1);
end