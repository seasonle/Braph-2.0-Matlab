% test Multirichness

%% Test 1: MultiplexGraphBU
A11 = [
    0  1  1  0; 
    1  0  1  1; 
    1  1  0  0;
    0  1  0  0
    ];
A12 = eye(4);
A21 = eye(4);
A22 = [
    0  1  1  1; 
    1  0  1  1; 
    1  1  0  0;
    1  1  0  0
    ];
A = {
    A11     A12
    A21     A22
    };

known_multirichness = {[1/2 0 3/2 3/2]'};      

g = MultiplexGraphBU(A);
multirichness = Multirichness(g);

assert(isequal(multirichness.getValue(), known_multirichness), ...
    [BRAPH2.STR ':Multirichness:' BRAPH2.BUG_ERR], ...
    'Multirichness is not being calculated correctly for MultiplexGraphBU.')

%% Test 2: MultiplexGraphBD
A11 = [
    0  1  1  1; 
    1  0  1  1; 
    1  1  0  0;
    0  1  0  0
    ];
A12 = eye(4);
A21 = eye(4);
A22 = [
    0  1  1  1; 
    1  0  1  1; 
    1  1  0  0;
    0  1  1  0
    ];
A = {
    A11     A12
    A21     A22
    };

known_multirichness = {[1 0 5/3 5/3]'};

g = MultiplexGraphBD(A);
multirichness = Multirichness(g, 'MultirichnessCoefficients', [2/3, 1/3]);
multirichness = multirichness.getValue();

assert(isequal(round(multirichness{1}, 10), round(known_multirichness{1}, 10)), ...
    [BRAPH2.STR ':Multirichness:' BRAPH2.BUG_ERR], ...
    'Multirichness is not being calculated correctly for MultiplexGraphBD.')

%% Test 3: MultiplexGraphWU
A11 = [
    0   .1  1  0; 
    .1  0   1  .8; 
    1   1   0  0;
    0   .8  0  0
    ];
A12 = eye(4);
A21 = eye(4);
A22 = [
    0   .1  1  1; 
    .1  0   1  .8; 
    1   1   0  0;
    1   .8  0  0
    ];
A = {
    A11     A12
    A21     A22
    };   

known_multirichness = {[3/40 0 5/4 21/20]'};      

g = MultiplexGraphWU(A);
multirichness = Multirichness(g, 'MultirichnessCoefficients', [3/4, 1/4]);
multirichness = multirichness.getValue();

assert(isequal(round(multirichness{1}, 10), round(known_multirichness{1}, 10)), ...
    [BRAPH2.STR ':Multirichness:' BRAPH2.BUG_ERR], ...
    'Multirichness is not being calculated correctly for MultiplexGraphWU.')

%% Test 4: MultiplexGraphWD
A11 = [
    0   1   1  .1; 
    .2  0   1  1; 
    1   1   0  0;
    0   .3  0  0
    ];
A12 = eye(4);
A21 = eye(4);
A22 = [
    0   1   1   .1; 
    .2  0   1   1; 
    1   1   0   0;
    0   .3  .7  0
    ];
A = {
    A11     A12
    A21     A22
    };    

known_multirichness = {[3/5 0 3/2 7/8]'};

g = MultiplexGraphWD(A);
multirichness = Multirichness(g, 'MultirichnessCoefficients', [2/4, 2/4]);

assert(isequal(multirichness.getValue(), known_multirichness), ...
    [BRAPH2.STR ':Multirichness:' BRAPH2.BUG_ERR], ...
    'Multirichness is not being calculated correctly for MultiplexGraphWD.')