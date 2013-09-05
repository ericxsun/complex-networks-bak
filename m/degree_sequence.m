function deg_seq = degree_sequence(edge, directed)
%DEGREE_SEQUENCE calculate the degree of all nodes in a graph. If the graph
%is directed, the in- and out- degree will be calculated.
%
%Syntax: 
% deg_seq = DEGREE_SEQUENCE(edge, directed)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst weight] where 'src',
%           'dst', 'weight' stand for the start, end nodes, weight of an 
%           edge respectively. The start point is zero.      
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%
%  deg_seq: degree sequence.
%           for undirected graph: col-1 for node id, col-2 for degree
%           for directed graph:   col-1 for node id, col-2 for out-degree, 
%                                 col-3 for in-degree
%
%Example:
%
%Ref:
%
%Other m-file required: check_idcontinuous4edge
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
    error('The edge must contain 2 columns at least');
end

if directed ~= 0 && directed ~= 1
    error('The value of "directed" can only be 0 or 1');
end

% edge = check_idcontinuous4edge(edge, directed); %node id starts at 0
edge = edge(:, 1:2);

nodes = unique(edge(:));

deg_seq = nodes;

if directed == 0
    x = edge(:);
    x = sort(x);
    
    d  = diff([x; max(x)+1]);
    cnt= diff(find([1; d]));
    
    deg_seq(ismember(deg_seq(:, 1), x(d~=0)), 2) = cnt;
elseif directed == 1
    %out-degree
    x = edge(:, 1);
    x = sort(x);
    
    d  = diff([x; max(x)+1]);
    cnt= diff(find([1; d]));
    
    deg_seq(ismember(deg_seq(:, 1), x(d~=0)), 2) = cnt;
    
    %in-degree
    x = edge(:, 2);
    x = sort(x);
    
    d  = diff([x; max(x)+1]);
    cnt= diff(find([1; d]));
    
    deg_seq(ismember(deg_seq(:, 1), x(d~=0)), 3) = cnt;
end
%--------------------------------------------------------------------------
end