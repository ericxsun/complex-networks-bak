function info_seq = information_sequence(graph, directed, src, L, mode)
%INFORMATION_SEQUENCE returns the information sequence of node 'src',
%defined in Ref.
%
%Syntax: 
% info_seq = INFORMATION_SEQUENCE(graph, directed, src, L)
% info_seq = INFORMATION_SEQUENCE(graph, directed, src, L, mode)
%
%   graph: (matrix)edges list or adjacency matrix or 2D-lattice edges list,
%          determined by mode default: edges list.
%directed: (integer, 0/1)0-undirected, 1-directed
%     src: (integer)the starting node, 
%          in [0~N-1](edges list),
%          in [1~N](adjacent matrix).
%          in (1, 1) ~ (N, N) (2D-lattice)
%       L: distance from src
%    mode: (string)'edges'-graph is represented by edges list, 
%                  'adj'-by adjacency matrix.
%
%info_seq: information sequence.
%
%Example:
%
%Ref:
%Hu Y, Wang Y, Li D, et al. Possible origin of efficient navigation in 
%small worlds[J]. Physical review letters, 2011, 106(10): 108701.
%
%Other m-file required: None
%Subfunctions: None
%MAT-file required: None
%
%See also:

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: Sept 12 20:00 2013 created

%--------------------------------------------------------------------------

if nargin == 4
    mode = 'edges';
end

msg = strcat('The value of ''mode'' can only be ''edges'' or ''adj''', ...
             'or ''2D-lattice-edges''');
assert(strcmp(mode, 'edges') == 1 || ...
       strcmp(mode, 'adj')   == 1 || ...
       strcmp(mode, '2D-lattice-edges') == 1, msg);

if strcmp(mode, 'edges') == 1
    N = max(max(graph(:, 1:2))) - min(min(graph(:, 1:2))) + 1;
    
    msg = sprintf('The value of ''src'' should be in [0, %d]', N-1);
    assert(src > -1 && src < N, msg);
        
    neighbors = cell(L, 1);

    if directed == 0
        shl_idx = 1;
        nodes = unique([graph(graph(:, 1) == src, 2);
                        graph(graph(:, 2) == src, 1)]);
        neighbors{shl_idx} = nodes;
        all_nodes = [nodes; src];

        info_seq = nodes;
        
        while ~isempty(nodes) && shl_idx < L
            shl_idx = shl_idx + 1;
            nodes = unique([graph(ismember(graph(:, 1), nodes), 2);
                            graph(ismember(graph(:, 2), nodes), 1)]);
            neighbors{shl_idx} = setdiff(nodes, all_nodes);
            all_nodes = union(all_nodes, nodes);            
        end
        
        %infor seq
        for shl_idx = 1 : L-1
            nodes = neighbors{shl_idx};
            for i = 1 : size(nodes, 1)
                node = nodes(i);
                
                neighbor = unique([graph(graph(:, 1) == node, 2);
                               graph(graph(:, 2) == node, 1)]);
                info_seq = [info_seq; neighbor];
            end
        end
    elseif directed == 1
        shl_idx = 1;
        nodes = unique(graph(graph(:, 1) == src, 2));
        neighbors{shl_idx} = nodes;
        all_nodes = [nodes; src];

        info_seq = nodes;
        
        while ~isempty(nodes) && shl_idx < L
            shl_idx = shl_idx + 1;
            
            nodes = unique(graph(ismember(graph(:, 1), nodes), 2));
            neighbors{shl_idx} = setdiff(nodes, all_nodes);
            all_nodes = union(all_nodes, nodes);
        end
        
        %infor seq
        for shl_idx = 1 : L-1
            nodes = neighbors{shl_idx};
            for i = 1 : length(nodes)
                node = nodes(i);
                
                neighbor = unique(graph(graph(:, 1) == node, 2));
                info_seq = [info_seq; neighbor];
            end
        end
    end

    info_seq(info_seq == src) = [];
    
elseif strcmp(mode, 'adj') == 1
    [n, m] = size(graph);
    error('Not Implemented');
elseif strcmp(mode, '2D-lattice-edges') == 1
    assert(max(size(src)) == 2, 'src should be a 2d coordinate');

    if directed == 0
        shl_idx = 1;
        nodes = unique([graph(graph(:, 1) == src(1) & ...
                              graph(:, 2) == src(2), 3:4);
                        graph(graph(:, 3) == src(1) & ...
                              graph(:, 4) == src(2), 1:2)], 'rows');
        neighbors{shl_idx} = nodes;
        all_nodes = [nodes; src];

        info_seq = nodes;
        
        while ~isempty(nodes) && shl_idx < L
            shl_idx = shl_idx + 1;
            nodes = [graph(ismember(graph(:, 1:2), nodes, 'rows'), 3:4);
                     graph(ismember(graph(:, 3:4), nodes, 'rows'), 1:2)];
            nodes = unique(nodes, 'rows');
            neighbors{shl_idx} = setdiff(nodes, all_nodes, 'rows');
            all_nodes = union(all_nodes, nodes, 'rows');            
        end
        
        %info seq
        for shl_idx = 1 : L-1
            nodes = neighbors{shl_idx};
            for i = 1 : size(nodes, 1)
                node = nodes(i, :);

                neighbor = [graph(graph(:, 1) == node(1) & ...
                                  graph(:, 2) == node(2), 3:4);
                            graph(graph(:, 3) == node(1) & ...
                                  graph(:, 4) == node(2), 1:2)];
                neighbor = unique(neighbor, 'rows');
                info_seq = [info_seq; neighbor];
            end
        end
    elseif directed == 1
        shl_idx = 1;
        nodes = unique(graph(graph(:, 1) == src(1) & ...
                             graph(:, 2) == src(2), 3:4), 'rows');
        neighbors{shl_idx} = nodes;
        all_nodes = [nodes; src];

        info_seq = nodes;
        
        while ~isempty(nodes) && shl_idx < L
            shl_idx = shl_idx + 1;
            
            nodes = graph(ismember(graph(:, 1:2), nodes, 'rows'), 3:4);
            nodes = unqiue(nodes);
            neighbors{shl_idx} = setdiff(nodes, all_nodes, 'rows');
            all_nodes = union(all_nodes, nodes, 'rows');
        end
        
        %info seq
        for shl_idx = 1 : L-1
            nodes = neighbors{shl_idx};
            for i = 1 : size(nodes, 1)
                node = nodes(i, :);

                neighbor = graph(graph(:, 1) == node(1) & ...
                                 graph(:, 2) == node(2), 3:4);
                neighbor = unique(neighbor, 'rows');
                info_seq = [info_seq; neighbor];
            end
        end
    end
        
    info_seq(info_seq(:, 1) == src(1) & info_seq(:, 2) == src(2), :) = [];    
end

%--------------------------------------------------------------------------
end
