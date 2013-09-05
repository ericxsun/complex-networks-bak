function edge = BAmodel_growing(m0, m, n_nodes)
%BAMODEL_GROWING generate an undirected connected scale-free graph 
%according to the Barabasi-Albert model.
%
%Syntax: 
% edge = BAMODEL_GROWINGL(m0, m, n_nodes)
%
%      m0: number of nodes of an initial graph(m0 >= 2).
%       m: number of new nodes to be added at each iteration.
% n_nodes: number of nodes.
%
%    edge: (matrix) The edge list of the graph defined by the adjacent
%          matrix. Each line is expressed as [src dst weight] where 'src', 
%          'dst', 'weight' stand for the start, end nodes, weight of an 
%          edge respectively. The start point is zero.
%   
%Example:
%
%Ref:
%Albert-László Barabási & Réka Albert (October 1999). "Emergence of 
%scaling in random networks". Science 286 (5439): 509–512.
%
%Each new node is connected to  existing nodes with a probability that is 
%proportional to the number of links that the existing nodes already have.
%
%Other m-file required: degree_sequence.m
%Subfunctions: None
%MAT-file required: None
%
%See also: ERmodel, Regularmodel, WSmodel

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: Dec 06 17:29 2012 created

%--------------------------------------------------------------------------
 
if m0 < 2
    error(strcat('The number(m0) of nodes of an initial graph should ', ...
                 'be greater than 1.'));
end

if m > m0
    error('The number(m) of new nodes should be less than %d\n', m0);
end

directed = 0;
edge = [];

%initialization
for i = 1 : m0
    i_neighbors = i : m0-1;
    
    edge = [edge; repmat(i-1, length(i_neighbors), 1), i_neighbors'];
end

%growth
for i = m0 : (n_nodes - 1)    
    degreeseq = degree_sequence(edge, directed); %col 1-id, col 2-degree
    sum_deg   = sum(degreeseq(:,2));
    
    n_cur_nodes = length(degreeseq);
    deg_prob    = zeros(n_cur_nodes, 2);
    
    deg_prob(:, 1) = degreeseq(:, 1);
    deg_prob(:, 2) = degreeseq(:, 2) ./ sum_deg;
    
    %accumulated 
    for j = 2 : length(degreeseq)
        deg_prob(j, 2) = sum(deg_prob(j-1:j, 2));
    end
            
    %add
    p = rand(1, m);
    for j = 1 : m
        while 1        
            candidats = deg_prob((p(j) < deg_prob(:, 2)), :);
            selected = candidats(1, 1);
        
            %check duplicate edge
            res = sum(ismember(edge(edge(:, 1) == i, 2), selected));
            res = (res | sum(ismember(edge(edge(:, 2) == i, 1), selected)));
            if 0 == res;
                break;
            end
            
            p(j) = rand(1);
        end
        
        if i < selected   
            edge = [edge; i, selected];
        else
            edge = [edge; selected, i];
        end
    end
    
end

edge(:, 3) = 1;
edge = sortrows(edge);
%--------------------------------------------------------------------------
end