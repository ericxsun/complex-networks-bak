function ra = assortativity_coefficent(edge, directed)
%ASSORTATIVITY_COEFFICENT calculate the assortativity coefficient of a graph
%
%Syntax: 
% ra = ASSORTATIVITY_COEFFICENT(edge, directed)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst] or [src dst weight] 
%           where 'src', 'dst', 'weight' stand for the node, end nodes, 
%           weight of an edge respectively. The node point is zero.    
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%
%       ra: (double) the assortativity coefficient.
%
%Example:
%
%Ref:
%Newman M E J. Assortative mixing in networks[J]. Physical review letters, 
%2002, 89(20): 208701.
%
%Other m-file required: degree_sequence.m, check_idcontinuous4edge
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

if min(min(edge)) == 0
    edge = edge + 1;
end

m_edges = size(edge, 1);

degree = degree_sequence(edge, directed);

jk       = 0;
jkmean   = 0;
jksquare = 0;

for i = 1 : m_edges
    u = edge(i, 1);
    v = edge(i, 2);
    
    deg_u = degree(u, 2);
    deg_v = degree(v, 2);
    
    jk       = jk + deg_u * deg_v;
    jkmean   = jkmean + deg_u + deg_v;
    jksquare = jksquare + deg_u^2 + deg_v^2;
end

ra = (4*m_edges*jk - jkmean^2) / (2*m_edges*jksquare - jkmean^2);
%--------------------------------------------------------------------------
end