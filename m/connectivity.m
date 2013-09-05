function conn = connectivity(edge, directed, components_func)
%CONNECTIVITY check whether the graph is connected or not.
%
%Syntax: 
% conn = CONNECTIVITY(edge, directed)
% conn = CONNECTIVITY(edge, directed, components_func)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst] or [src dst weight] 
%           where 'src', 'dst', 'weight' stand for the node, end nodes, 
%           weight of an edge respectively. The node point is zero.     
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%
% components_func: function handle for components solving.
%
%     conn: 1 for connected, 0 otherwise
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
%History: Dec. 8 11:13 2012 created

%--------------------------------------------------------------------------
if nargin < 3
    components_func = @components;
end

if size(edge, 2) < 2
    error('The edge list must contain 2 columns at least.');
end

if directed ~= 0 && directed ~= 1
    error('The value of "directed" can only be 0 or 1.');
end

if directed == 1
    error('For directed graph, not implemented.');
end

comp = components_func(edge, directed);
if max(size(comp)) > 1
	conn = 0;
else
	conn = 1;
end