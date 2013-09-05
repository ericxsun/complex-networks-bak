function edge = ERmodel_adj(p, n_nodes)
%ERMODEL_ADJ generate an undirected connected random graph according to the 
%Erdos-Renyi model.
%
%Syntax: 
% edge = ERMODEL_ADJ(p, n_nodes)
%
%       p: rewire probability 
% n_nodes: number of node
%
%    edge: (matrix) The edge list of the graph defined by the adjacent
%          matrix. Each line is expressed as [src dst weight] where 'src', 
%          'dst' stand for the start, end nodes of an edge respectively. 
%          The start point is zero.
%   
%Example:
%
%Ref:
%Erdős, Paul; A. Rényi (1960). "On the evolution of random graphs". 
%Publications of the Mathematical Institute of the Hungarian Academy of 
%Sciences 5: 17–61.
%
%All possible pairs of nodes are connected with probability p.
%
%Other m-file required: None
%Subfunctions: spanning_tree
%MAT-file required: None
%
%See also: BAmodel, Regularmodel, WSmodel

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: Dec. 6 17:29 2012 created

%--------------------------------------------------------------------------

if p < 0 || p > 1
    error('The value of "p" can only be in [0, 1].');
end

if n_nodes < 0
    error('The value of "n_nodes" must be positive.');
end

while 1  
    adj = sparse(n_nodes, n_nodes);

    for i = 1 : n_nodes                
        rnd = rand(1, n_nodes - i);
        idx = find(rnd < p) + i;
        adj(i, idx) = 1;
        adj(idx, i) = 1;
    end
        
    edge = adj2edge(adj, 0);
    edge = edge(:, 1:2);
    conn = connectivity(edge, 0);
    N = length(unique(edge(:)));
    if conn == 1 && N == n_nodes
        break;
    end
end

edge = check_idcontinuous4edge(edge, 0);
%--------------------------------------------------------------------------
end
