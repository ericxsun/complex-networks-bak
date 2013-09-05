function edge = WSmodel(p, mean_k, n_nodes)
%WSMODEL generate an undirected connected small-world graph according to 
%the Watss-Strogatz model(short average path length and high clustering 
%coefficient)
%
%Syntax: 
% edge = WSMODEL(p, mean_k, n_nodes)
%
%       p: (doulbe)rewire probability 
% n_nodes: (integer)number of node
%
%    edge: (matrix) The edge list of the graph defined by the adjacent
%          matrix. Each line is expressed as [src dst weight] where 'src', 
%          'dst', 'weight' stand for the start, end nodes, weight of an 
%          edge respectively. The start point is zero.
%   
%Example:
%
%Ref:
%Watts, D.J.; Strogatz, S.H. (1998). "Collective dynamics of 'small-world' 
%networks.". Nature 393 (6684): 409–10.
%
%i) Start with order: start with a ring lattice with N nodes in which every
% node is connected to its first K neighbors(K/2, on either side). In order
% to have a sparse but connected network at all times, consider
% N>>K>>ln(N)>>1
%ii) Randomize: randomly rewire each edge of the lattice with probability p
% such that self-connections and duplicate edges are excluded.
%
%Other m-file required: None
%Subfunctions: spanning_tree
%MAT-file required: None
%
%See also: BAmodel, ERmodel, Regularmodel

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: Dec. 6 17:29 2012 created

%--------------------------------------------------------------------------

if mean_k <= 0
    error('the average degree should be greater than 0.');
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
old_neighbors = cell(n_nodes, 1);

for i = 1 : n_nodes
    id = nodes(i);
    right = mod((id+1 :  1 : id+mean_k), n_nodes);
    left  = mod((id-1 : -1 : id-mean_k), n_nodes);
    
    old_neighbors{i} = unique([right, left]);
end

%rewire
while 1
    neighbors = old_neighbors;
    
    for i = 1 : n_nodes
        n_i_neighbors = length(neighbors{i});

        disconnect = neighbors{i}((rand(1, n_i_neighbors) <= p) == 1);

        n_disconnect = length(disconnect);
        if n_disconnect <= 0
            continue;
        end

        while 1
            new_connect = randperm(n_nodes, n_disconnect) - 1;
            new_connect = setdiff(new_connect, [nodes(i), neighbors{i}]);

            if length(new_connect) == n_disconnect
                break;
            end
        end

        %add and del
        neighbors{i} = [setdiff(neighbors{i}, disconnect), new_connect];
        
        for j = 1 : length(new_connect)
            id = new_connect(j) + 1;
            neighbors{id} = sort([neighbors{id}, nodes(i)]);
        end
        for j = 1 : n_disconnect
            id = disconnect(j) + 1;
            neighbors{id} = setdiff(neighbors{id}, nodes(i));
        end
    end
    
    %connectivity check
    if length(spanning_tree(neighbors, 0)) == n_nodes
        break;
    end    
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

function Tnodes = spanning_tree(neighbors, start)
%index of node starts at 0 in neighbor list
%neighbors{i}: the neighbors of node i-1

n_node = size(neighbors, 1);

visited = zeros(n_node, 1);

to_visit = start;

while ~isempty(to_visit)
    from = to_visit(end);
    to_visit(end) = [];
    
    visited(from+1) = 1;
    
    neighbor_from = neighbors{from+1};
    
    neighbor_from(visited(neighbor_from+1) == 1) = [];
    
    to_visit = union(to_visit, neighbor_from);
end

Tnodes = (find(visited ~= 0) - 1);
end