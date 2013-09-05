function comp = components(edge, directed)
%COMPONENTS find all the connected subgraph of a given graph using an
%algorithm similar to things in Disjoint-set data structure.
%
%Syntax: 
% comp = COMPONENTS(edge, directed)
%
%     edge: (matrix) The edge list of the graph defined by the adjacent
%           matrix. Each line is expressed as [src dst] or [src dst weight] 
%           where 'src', 'dst', 'weight' stand for the node, end nodes, 
%           weight of an edge respectively. The node point is zero.     
% directed: (0/1) The type of graph, 0 for undirected graph, 1 for the
%           directed one.
%
%     comp: all the subgraph, comp{i} records the i-th connected subgraph.
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
%History: Jul. 23 09:30 2013 created

%--------------------------------------------------------------------------
narginchk(2, 2);

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

m_edges = size(edge, 1);

%index of nodes start at 0
nodes   = edge(:, 1:2);
nodes   = unique(nodes(:));
n_nodes = length(nodes);

idx = zeros(n_nodes, 1);	%index of group of each node 
grp = cell(n_nodes, 1);		%group, grp{i}  records the nodes in same tree
szg = zeros(n_nodes, 1);	%size of each group

for i = 1 : n_nodes
	idx(i) = i;
	grp{i} = i-1;
end

for i = 1 : m_edges
	ii = edge(i, 1);
	ij = edge(i, 2);

	idx_ii = idx(ii + 1);
	idx_ij = idx(ij + 1);

	if idx_ii == idx_ij
		continue;
	end

	grp{idx_ii} = [grp{idx_ii}, grp{idx_ij}];
	idx(grp{idx_ij}+1) = idx_ii;
	grp{idx_ij} = [];

	szg(idx_ii) = length(grp{idx_ii});
	szg(idx_ij) = length(grp{idx_ij});
end

gt0   = find(szg > 0);
n_gt0 = length(gt0);

comp = cell(n_gt0, 1);
for i = 1 : n_gt0
	nodes = grp{gt0(i)};
	comp{i} = edge(ismember(edge(:, 1), nodes) | ismember(edge(:, 2), nodes), :);
end