function edge = verify_integrity4edge(edge, directed)
%VERIFY_INTEGRITY4EDGE verify the integrity of edge.(remove self-circle,
%duplicate edges)
%
%Syntax: 
% edge = VERIFY_INTEGRITY4EDGE(edge, directed)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst] or [src dst weight] 
%           where 'src', 'dst', 'weight' stand for the start, end nodes, 
%           weight of an edge respectively. 
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%
%     edge: The checked edge, subjects to the rules as follows:
%           1. format same as input edge.
%           2. arranged in ascending order with respect to the first column.
%           3. duplicated edges and self-circles are removed.
%
%Example:
%
%Ref:
%
%Other m-file required: None
%Subfunctions: None
%MAT-file required: None
%
%See also: check_idcontinuous4edge

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: May 26 17:00 2012 created

%--------------------------------------------------------------------------

if size(edge, 2) < 2
    error('The edge must contain 2 columns at least');
end

if directed == 0
    gt = (edge(:, 1) > edge(:, 2));
    edge(gt, 1:2) = [edge(gt, 2), edge(gt, 1)];
elseif directed ~= 1
    error('The value of "directed" can only be 0 or 1');
end

edge(edge(:, 1) == edge(:, 2), :) = []; %delete the self-circle
edge = unique(edge, 'rows');            %delete the duplicated edges

edge = sortrows(edge);
%--------------------------------------------------------------------------
end