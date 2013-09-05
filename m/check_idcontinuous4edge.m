function edge = check_idcontinuous4edge(edge, directed)
%CHECK_IDCONTINUOUS4EDGE check whether the id of nodes is continuous or not.
%If not, the id will be reassigned to be continuous(the start point is 0)
%
%Syntax: 
% edge = CHECK_IDCONTINUOUS4EDGE(edge, directed)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst weight] where 'src',
%           'dst', 'weight' stand for the start, end nodes, weight of an 
%           edge respectively. 
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%
%     edge: The checked edge, subjects to the rules as follows:
%           1. in [src, dst, weight] format.
%           2. arranged in ascending order with respect to the first column.
%           3. duplicated edges are removed.
%           4. the id is continuous from 0 to n_nodes-1
%
%Example:
%
%Ref:
%
%Other m-file required: verify_integrity4edge.m
%Subfunctions: None
%MAT-file required: None
%
%See also: verify_integrity4edge

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: June 7 10:06 2012 created

%--------------------------------------------------------------------------

col = size(edge, 2);

if col < 2
    error('The edge must contain 2 columns at least');
end

if directed ~= 1 && directed ~= 0
    error('The value of "directed" can only be 0 or 1');
end

edge = verify_integrity4edge(edge, directed);

min_id = min(min(edge(:, 1:2)));
if min_id ~= 0
    edge(:, 1:2) = edge(:, 1:2) - min_id;
end

nodes = edge(:, 1:2);
nodes = sort(unique(nodes(:)));

n_nodes = length(nodes);

if sum(diff(nodes)) ~= (n_nodes-1)
    for i = 2 : n_nodes
    
        last_id = nodes(i-1);
        cur_id  = nodes(i);
    
        if cur_id ~= last_id + 1
            nodes(i) = last_id + 1;
        
            edge(edge(:, 1) == cur_id, 1) = nodes(i);
            edge(edge(:, 2) == cur_id, 2) = nodes(i);
        end
    end
end
%--------------------------------------------------------------------------
end