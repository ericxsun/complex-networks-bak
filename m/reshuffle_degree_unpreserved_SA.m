function new_edge = reshuffle_degree_unpreserved_SA(edge, p)
%RESHUFFLE_DEGREE_UNPRESERVED randomise a graph without preserving its 
%degree sequence by using simulated annealing algorithm.
%
%Note:
% Only for undirected and unweigted graph.
%
%Syntax: 
% new_edge = RESHUFFLE_DEGREE_UNPRESERVED(edge)
% new_edge = RESHUFFLE_DEGREE_UNPRESERVED(edge, p)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst] or [src dst weight] 
%           where 'src', 'dst', 'weight' stand for the node, end nodes, 
%           weight of an edge respectively. The node point is zero.
%
%        p: rewire probability.
%
% new_edge: see edge.
%
%Example:
%
%Ref:
%
%
%Other m-file required: check_idcontinuous4edge, connectivity
%Subfunctions: None
%MAT-file required: None
%
%See also: reshuffle_degree_preserved

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: Dec 19, 2012 created

%--------------------------------------------------------------------------
narginchk(1, 2);

error('Not implemented');

%--------------------------------------------------------------------------
end