function edges = Kleinberg_small_world(N, alpha, p, q, w)
%KLEINBERG_SMALL_WORLD generate a network based on a NxN lattice according 
%to Kleinberg.
%
%Syntax: 
% OUT = KLEINBERG_SMALL_WORLD(N, alpha, p, q, w)
%
%     N: (integer) the size of lattice(NxN).
% alpha:
%     p: (integer) local contacts: a node is connected with every node 
%        within lattic distance p.
%     q: (integer) number of long-range contacts.
%     w: (NxN, integer vector)the finite energy of each node
%        sum_v( r(u,v) ) = w(u)
%
% edges:(?x4) col 1-2, the coordinate of src, col 3-4, for dst.
%
%Example:
%
%Ref:
%Kleinberg J M. Navigation in a small world[J]. Nature, 2000, 406(6798): 
%845-845. 
%
%The network model is derived from an LxL lattice. Each node is connected
%with every other node within lattice distance p. And construct edges from
%u to q other nodes using independent random trials, the probability 
%proportional to r^-alpha.
%
%in practice:
%1. construct a NxN lattice, {(i,j): i=1,2,3,...,N; j=1,2,3,...,N}
%2. local contacts: connect nodes v to u, subject to d(u,v)=p
%3. long range contacts: for each node u, q times independent random trials
%       randomly choose a node v, calculate d(u, v)
%       find all nodes m, where d(u, m) = d(u, v)
%       calculate the pc = [d(u,v)]-^alpha / sum([d(u,m)]^-alpha)
%       construct edge from u to v with probability pc.
%
%Note: avoid self-loop, duplicated edges
%
%Other m-file required: None
%Subfunctions: None
%MAT-file required: None
%
%See also:

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: Sept 6 08:30 2013 created

%--------------------------------------------------------------------------

if q == inf
    %constraints
    edges = []; %*x4, (1,2)-id1, (3,4)-id2
   
    for i = 1 : N
        for j = 1 : N
            fprintf('[%d-%d]-[%d-%d]\n', N, i, N, j);
            
            u = [i, j];
            
            %distance-sum_v([d(u,v)]^-alpha), u=[i,j]
            Dij = sum_Dr_neg_alpha(alpha, N, u);
            
            %local contacts
            vs = find_d_neighbors(N, u, p);
            n_vs = size(vs, 1);
            
            edges = [edges; repmat(u, n_vs, 1), vs];
            
            w(i, j) = w(i, j) - 1;
            
            %long-range contacts
            while w(i, j) > 0
                v = randi(N, [1, 2]);
                d = bsxfun(@minus, u, v);
                d = abs(d(:, 1)) + abs(d(:, 2));
                
                P = d^(-alpha) / Dij;
                pr=rand();
                ok_idx = find(pr < P);
                
                if isempty(ok_idx)
                    continue;
                end
                
                edges = [edges; u, v];
                w(i, j) = w(i, j) - d;
            end
        end
    end   
else
    %no constraints
    edges = []; %*x4, (1,2)-id1, (3,4)-id2
    
    for i = 1 : N
        for j = 1 : N
            fprintf('[%d-%d]-[%d-%d]\n', N, i, N, j);
            
            u = [i, j];
            
            %distance-sum_v([d(u,v)]^-alpha), u=[i,j]
            Dij = sum_Dr_neg_alpha(alpha, N, u);
            
            %local contacts
            vs= find_d_neighbors(N, u, p);
            n_vs = size(vs, 1);
            edges = [edges; repmat(u, n_vs, 1), vs];
            
            %long-range contacts
            v = [(randperm(N, q))', (randperm(N, q))'];
            
            d = bsxfun(@minus, u, v);
            d = abs(d(:, 1)) + abs(d(:, 2));
            
            P = bsxfun(@power, d, -alpha) / Dij;
            pr= rand(size(P));
            
            ok=find(pr < p);
            n_ok = length(ok);
            
            if n_ok == 0
                continue;
            end
            
            edges = [edges; repmat(u, n_ok, 1), v(n_ok, :)];            
        end
    end   
end

%--------------------------------------------------------------------------
end

function show_edges(edges)
d = abs(edges(:, 1) - edges(:, 3)) + abs(edges(:, 2) - edges(:, 4));

edges_deq1 = edges(d==1, :);
edges_dgt1 = edges(d>1, :);

row_deq1 = size(edges_deq1, 1);
row_dgt1 = size(edges_dgt1, 1);

figure;
for i = 1 : row_deq1
    hold on;
    line([edges_deq1(i, 1), edges_deq1(i, 3)], ...
         [edges_deq1(i, 2), edges_deq1(i, 4)], 'color', 'b');
end

for i = 1 : row_dgt1
    hold on;
    line([edges_dgt1(i, 1), edges_dgt1(i, 3)], ...
         [edges_dgt1(i, 2), edges_dgt1(i, 4)], 'color', 'r');
end

axis equal;

end

function D = sum_Dr_neg_alpha(alpha, N, u)
%D = sum_v [d(u,v)]^-alpha
%         x x+1
%         ||
%         ||
%--y+1----||
%---------+------------y
%        ||------------y-1
%        ||
%        ||
%        ||
%      x-1 x
%
%bounds: 
%quandrant 1: x+r<=N,   y+r<=N+1
%quandrant 1: x-r>=1-1, y+r<=N
%quandrant 1: x-r>=1,   y-r>=1-1
%quandrant 1: x+r<=N+1, y-r>=1

x = u(1);
y = u(2);

D = 0;

%quadrant 1
r_max = N-x + N-y;
if r_max > 0
    r = (1 : r_max)';
    kr= zeros(size(r));    %r-nearest neighbors of u
    
    kr(r) = r + (x+r>N).*(N-x-r) + (y+r>N+1).*(N+1-y-r);
        
    r_alpha = bsxfun(@power, r, -alpha);
    D = D + kr' * r_alpha;
end

%quadrant 2
r_max = x-1 + N-y;
if r_max > 0
    r = (1 : r_max)';
    kr= zeros(size(r));
    
    kr(r) = r + (x-r<1-1).*(x-r-1+1) + (y+r>N).*(N-y-r);
    
    r_alpha = bsxfun(@power, r, -alpha);
    D = D + kr' * r_alpha;
end

%quadrant 3
r_max = x-1 + y-1;
if r_max > 0
    r = (1 : r_max)';
    kr= zeros(size(r));
    
    kr(r) = r + (x-r<1).*(x-r-1) + (y-r<1-1).*(y-r-1+1);
    
    r_alpha = bsxfun(@power, r, -alpha);
    D = D + kr' * r_alpha;
end

%quadrant 4
r_max = N-x + y-1;
if r_max > 0
    r = (1 : r_max)';
    kr= zeros(size(r));
    
    kr(r) = r + (x+r>N+1).*(N+1-x-r) + (y-r<1).*(y-r-1);
    
    r_alpha = bsxfun(@power, r, -alpha);
    D = D + kr' * r_alpha;
end

end

function vs = find_d_neighbors(N, u, d)
%
%u = [x0, y0]
%
%find all coordinates (x,y) subject to |x-x0| + |y-y0| = d

x0 = u(1);
y0 = u(2);

vs = [];

%quadrant 1
dx = (1   :  1 : d)';
dy = (d-1 : -1 : 0)';

x = x0 + dx;
y = y0 + dy;

ok_flag = bitand(~(x>N), ~(y>N));
x = x .* ok_flag;
y = y .* ok_flag;

vs = [vs; x, y];

%quadrant 2
dx = (0 :  1 : d-1)';
dy = (d : -1 : 1)';

x = x0 - dx;
y = y0 + dy;

ok_flag = bitand(~(x<1), ~(y>N));
x = x .* ok_flag;
y = y .* ok_flag;

vs = [vs; x, y];

%quadrant 3
dx = (1   :  1 : d)';
dy = (d-1 : -1 : 0)';

x = x0 - dx;
y = y0 - dy;

ok_flag = bitand(~(x<1), ~(y<1));
x = x .* ok_flag;
y = y .* ok_flag;

vs = [vs; x, y];

%quadrant 4
dx = (0 :  1 : d-1)';
dy = (d : -1 : 1)';

x = x0 + dx;
y = y0 - dy;

ok_flag = bitand(~(x>N), ~(y<1));
x = x .* ok_flag;
y = y .* ok_flag;

vs = [vs; x, y];
vs(vs(:, 1) == 0 | vs(:, 2) == 0, :) = [];
end
