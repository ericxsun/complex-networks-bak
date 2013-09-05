function edge = BAmodel_static(m0, m, n_nodes)
%BAMODEL_STATIC generate an undirected connected scale-free graph according
%to the Barabasi-Albert model with fixed size.
%
%Syntax: 
% edge = BAMODEL_STATIC(m0, m, n_nodes)
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

error('not implemented');

%--------------------------------------------------------------------------
end