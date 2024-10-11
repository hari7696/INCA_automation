% comments
clc, clearvars
x = 10;
y = 20;
z = x + y;

x = 1:10;

x' ;% transpose

x = linspace(20,50, 10);

y = [1,2,15];

% matrix
A = [1,2; 3,4];
A + 2 ;

A.^2; % elements wise operations

% indexing starts at 1 not 0
A(1,1);

% last index
A(end);
A(end);

a = [1,2,3];
if sum(a) == 6
    disp("hari")
end 

%%

% for loop
num_iters = 0;
for i = 1:10
    disp(i)
    num_iters = num_iters +1;
end

disp(num_iters)






