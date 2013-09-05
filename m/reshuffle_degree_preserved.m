function edge = reshuffle_degree_preserved(edge, directed, n_step, p)
%RESHUFFLE_DEGREE_PRESERVED randomise a graph with preserving its degree 
%sequence
%
%Note:
% Only for undirected and unweigted graph.
%
%Syntax: 
% new_edge = RESHUFFLE_DEGREE_PRESERVED(edge, directed)
% new_edge = RESHUFFLE_DEGREE_PRESERVED(edge, directed, n_step)
% new_edge = RESHUFFLE_DEGREE_PRESERVED(edge, directed, n_step, p)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst] or [src dst weight] 
%           where 'src', 'dst', 'weight' stand for the node, end nodes, 
%           weight of an edge respectively. The node point is zero.
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%   n_step: (integer, optional)number of rewiring steps.
%           (if none, n_step=4*m_edge)
%        p: (double, optional)rewire probability.(if none, p=0.5)
%
%Example:
%
%Ref:
%
%Other m-file required: check_idcontinuous4edge.m, components.m
%Subfunctions: None
%MAT-file required: None
%
%See also: reshuffle_degree_unpreserved

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: Dec 19, 2012 created

%--------------------------------------------------------------------------

if size(edge, 2) < 2
    error('The edge must contain 2 columns at least');
end

if directed ~= 0 && directed ~= 1
    error('The value of "directed" can only be 0 or 1');
end

edge = check_idcontinuous4edge(edge, 0);
edge = edge(:, 1:2);

%Note: the node in edge starts at 0
m_edge = length(edge);

if nargin == 2
	n_step = 4*m_edge;
    p = 0.5;
end
if nargin == 3
    p = 0.5;
end

%
if directed == 0    
    k = 1;
    fprintf('REWIRING: 0%%');
    for i = 1 : n_step
        if i == n_step * k / 10
            fprintf('==>%2d%%', k*10);
            k = k + 1;
        end

        %1. choose two edges at random
        id_s    = randperm(m_edge, 2);
        edges_s = edge(id_s, :);
        nodes_s = unique(edges_s(:));

        if length(nodes_s) ~= 4
            continue;
        end

        %2. rewire & check
        if rand() > p
            continue;
        end

        id1 = edges_s(1, 1);
        id2 = edges_s(1, 2);
        id3 = edges_s(2, randi(2));
        id4 = setdiff(edges_s(2, :), id3);

        exist13 = sum(edge(:, 1) == id1 & edge(:, 2) == id3);
        exist31 = sum(edge(:, 1) == id3 & edge(:, 2) == id1);
        exist24 = sum(edge(:, 1) == id2 & edge(:, 2) == id4);
        exist42 = sum(edge(:, 1) == id4 & edge(:, 2) == id2);

        if (exist13 + exist31 + exist24 + exist42) ~= 0
            continue;
        end

        %3. new edges
        edges_n_1 = [id1, id3];
        edges_n_2 = [id2, id4];

        edge(id_s, :) = [edges_n_1; edges_n_2];  

        %4. check connectivity
        conn = connectivity(edge, directed);

        %5. discard
        if conn == 0
            edge(id_s, :) = edges_s;
            continue;
        end
    end
elseif directed == 1
    error('Not Implemented.');    
end

fprintf('\n');

edge = check_idcontinuous4edge(edge, directed); 
%--------------------------------------------------------------------------
end