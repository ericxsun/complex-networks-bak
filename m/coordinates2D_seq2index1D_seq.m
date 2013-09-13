function seq_1D = coordinates2D_seq2index1D_seq(seq_2D)
%COORDINATES2D_SEQ2INDEX1D_SEQ transforms 2D coordinates sequence to 1D
%index sequence.
%
%Syntax: 
% seq_1D = COORDINATES2D_SEQ2INDEX1D_SEQ(seq_2D)
%
% seq_2D: (matrix, *x2)2D coordinates sequence. col-1: x, col-2: y
%         [x1, y1; x2, y2; x3, y3; ....]'
%
% seq_1D: (vector, *x1)1D index sequence.
%
%Example:
% coordinates2D_seq2index1D_seq([1 1; 1 2; 2 2; 2 1; 1 1]')
% 
% returns:
% [1 2 3 4 1]'
%
%Ref:
%
%Other m-file required: None
%Subfunctions: None
%MAT-file required: None
%
%See also:

% Author: x.s.
%  Email: followyourheart1211@gmail.com
%WebSite: http://followyourheart.github.io/
%History: Sept 13 08:25 2013 created

%--------------------------------------------------------------------------

[n, m] = size(seq_2D);

if m > n
    seq_2D = seq_2D';
end

seq_2D_U = unique(seq_2D, 'rows');

n_seq_2D_U = size(seq_2D_U, 1);

for i = 1 : n_seq_2D_U
    seq_2D(seq_2D(:, 1) == seq_2D_U(i, 1) & ...
           seq_2D(:, 2) == seq_2D_U(i, 2), 3) = i;
end

seq_1D = seq_2D(:, 3);
%--------------------------------------------------------------------------
end