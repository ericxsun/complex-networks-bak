function comp = components_BFS(edge, directed)
%COMPONENTS_BFS find all the connected subgraph of a given graph using 
%breadth first searching.
%
%Syntax: 
% comp = COMPONENTS_BFS(edge, directed)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst] or [src dst weight] 
%           where 'src', 'dst', 'weight' stand for the node, end nodes, 
%           weight of an edge respectively. The node point is zero.     
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%
%     comp: all the subgraph, comp{i} records the i-th connected subgraph.
%
%Example:
%
%Ref:
%
%Other m-file required: check_idcontinuous4edge
%Subfunctions: spanning_tree
%MAT-file required: None
%
%See also:

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: Dec. 8 10:45 2012 created

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

nodes   = edge(:, 1:2);
nodes   = unique(nodes(:));
n_nodes = length(nodes);

%
if directed == 0
    neighbor = cell(n_nodes, 1);
    for i = 1 : n_nodes
        neighbor{i} = [edge(edge(:, 1) == nodes(i), 2); 
                       edge(edge(:, 2) == nodes(i), 1)];
    end
    
    to_visited_node = nodes;

    i_comp = 0;

    %spaning tree to find the components
    while ~isempty(to_visited_node)
        fprintf('find comp: remain-%d\n', length(to_visited_node));

        start = to_visited_node(1);

        to_visited_node(1) = [];

        Tnodes = spanning_tree(neighbor, start);

        i_comp = i_comp + 1;
        comp{i_comp} = edge(ismember(edge(:, 1), Tnodes) | ...
                            ismember(edge(:, 2), Tnodes), :);    

        to_visited_node = setdiff(to_visited_node, Tnodes); 
    end
    
elseif directed == 1
    error('For directed graph, not implemented.');
end

%--------------------------------------------------------------------------
end

function Tnodes = spanning_tree(neighbor, start)
%index of node starts at 0 in neighbor list
%neighbor{i}: the neighbors of node i-1

n_node = size(neighbor, 1);

visited = zeros(n_node, 1);

to_visit = start;

while ~isempty(to_visit)
    from = to_visit(end);
    to_visit(end) = [];
    
    visited(from+1) = 1;
    
    neigh_from = neighbor{from+1};
    
    neigh_from(visited(neigh_from+1) == 1) = [];
    
    to_visit = union(to_visit, neigh_from);
end

Tnodes = (find(visited ~= 0) - 1);
end