function [shlidx, shells, cores] = shell_index(edge, directed)
%SHELL_INDEX k shell
%
%Syntax: 
% [shlidx, shells, cores] = SHELL_INDEX(edge, directed)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst] or [src dst weight] 
%           where 'src', 'dst', 'weight' stand for the node, end nodes, 
%           weight of an edge respectively. The node point is zero.   
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%
%   shlidx: shell index of each node.
%   shells: the all exist shell index.
%    cores: the set of nodes with same shell index.
%
%Example:
%
%Ref:
%
%Other m-file required: check_idcontinuous4edge.m, degree_sequence.m
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

degree = degree_sequence(edge, directed);
sum_deg= sum(degree(:, 2));

shlidx = degree(:, 1);  %1-id
shlidx(:, 2) = 0;       %shell index

kidx    = 1;
visited = [];

while sum_deg > 0
    lt_k = degree(degree(:, 2) < kidx, 1);
    if isempty(lt_k)
        kidx = kidx + 1;
    else
        not_visited = setdiff(lt_k, visited);
        
        shlidx(ismember(shlidx(:, 1), not_visited), 2) = kidx - 1;
        degree(ismember(degree(:, 1), not_visited), :) = [];
        
        %neighbors degree decreased
        neigh = [edge(ismember(edge(:, 1), not_visited), 2);
                 edge(ismember(edge(:, 2), not_visited), 1)];
        neigh(ismember(neigh, [not_visited; visited])) = [];
        
        if ~isempty(neigh)
            d   = sort(neigh);
            d   = diff([d; max(d) + 1]);
            cnt = diff(find([1; d]));
            
            neigh = unique(neigh);
            
            degree(ismember(degree(:, 1), neigh), 2) = ...
                degree(ismember(degree(:, 1), neigh), 2) - cnt;
        end
        
        visited = [visited; not_visited];
        sum_deg = sum(degree(:, 2));
    end
end

shells  = unique(shlidx(:, 2));
n_shells= size(shells, 1);

cores = cell(1, n_shells);

for i = 1 : n_shells
    cores{i} = shlidx(shlidx(:, 2) >= shells(i), 1);
end
%--------------------------------------------------------------------------
end