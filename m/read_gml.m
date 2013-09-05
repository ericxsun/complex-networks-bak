function [edge, directed] = read_gml(file_name)
%READ_GML read edge from the gml format file.
%
%Syntax: 
% [edge, directed] = READ_GML(file_name)
%
% file_name: 
%
%      edge: (matrix) The edge list of the graph defined by the adjacent
%            matrix. Each line is expressed as [src dst weight] where 'src',
%            'dst', 'weight' stand for the start, end nodes, weight of an 
%            edge respectively. The start point is zero.      
%  directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%            directed one.
%
%Example:
%
%Ref:
%
%Other m-file required: None
%Subfunctions: None
%MAT-file required: None
%
%See also: read_pajek, write_edge2pajek, write_edge2gml

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: July 31 15:25 2012 created

%--------------------------------------------------------------------------

error('not implemented');
%--------------------------------------------------------------------------
end