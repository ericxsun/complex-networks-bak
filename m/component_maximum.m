function comp_max = component_maximum(edge, directed, components_func)
%COMPONENT_MAXIMUM find the maximum connected subgraph of a given graph.
%
%Syntax: 
% comp = COMPONENT_MAXIMUM(edge, directed)
% comp = COMPONENT_MAXIMUM(edge, directed, components_func)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst] or [src dst weight] 
%           where 'src', 'dst', 'weight' stand for the node, end nodes, 
%           weight of an edge respectively. The node point is zero.     
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%
%components_func: function handle for components solving.
%
% comp_max: the maximum connected subgraph.(The id will be checked. please use
%           check_idcontinuous4edge to do that.)
%
%Example:
%
%Ref:
%
%Other m-file required: check_idcontinuous4edge, components
%Subfunctions: None
%MAT-file required: None
%
%See also:

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: Dec. 8 10:45 2012 created

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
n_comp = size(comp, 1);

max_n_nodes = 0;
for i = 1 : n_comp
	comp_i = comp{i};
	n_nodes = length(comp_i);

	if max_n_nodes < n_nodes
		max_n_nodes = n_nodes;
		comp_max = comp_i;
	end
end