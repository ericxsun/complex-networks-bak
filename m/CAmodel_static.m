function edge = CAmodel_static(m0, m, n_nodes)
%CAMODEL_STATIC generate an undirected connected graph according to the 
%clustering preferencial attachment model with fixed size.
%
%Syntax: 
% edge = CAMODEL_STATIC(m0, m, n_nodes)
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
%
%
%Other m-file required: degree_sequence.m
%Subfunctions: None
%MAT-file required: None
%
%See also: ERmodel, Regularmodel, WSmodel, BAmodel

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: Sept 02 11:02 2013 created

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


%--------------------------------------------------------------------------
end