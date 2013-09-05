function write_edge2pajek(edge, directed, file_name, vcolor, ecolor)
%WRITE_EDGE2PAJEK write the edge list to pajek format.
%
%Syntax: 
% WRITE_EDGE2PAJEK(edge, directed, file_name, vcolor, ecolor)
%
%      edge: (matrix) The edge list of the graph defined by the adjacent
%            matrix. Each line is expressed as [src dst] or [src dst weight] 
%            where 'src', 'dst', 'weight' stand for the node, end nodes, 
%            weight of an edge respectively. The node point is zero.    
%  directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%            directed one.
%
% file_name: 
%
%    vcolor: color of nodes
%
%    ecolor: color of edges
%
%Example:
%
%Ref:
%
%Other m-file required: check_idcontinuous4edge
%Subfunctions: None
%MAT-file required: None
%
%See also: read_pajek, read_gml, write_edge2gml

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: July 31 15:25 2012 created

%--------------------------------------------------------------------------
narginchk(3, 5);

if size(edge, 2) < 2
    error('The edge must contain 2 columns at least');
end

if directed ~= 0 && directed ~= 1
    error('The value of "directed" can only be 0 or 1');
end

edge = check_idcontinuous4edge(edge, 0);
edge = edge(:, 1:2);

if min(min(edge)) == 0
    edge = edge + 1;
end

error('not implemented');
%--------------------------------------------------------------------------
end