% test Richness

%% Test 1: GraphBU
A = [
    0  1  1  0; 
    1  0  1  1; 
    1  1  0  0;
    0  1  0  0
    ];

known_richness = {[1 0 1 1]'};

g = GraphBU(A);
richness = Richness(g);

assert(isequal(richness.getValue(), known_richness), ...
    [BRAPH2.STR ':Richness:' BRAPH2.BUG_ERR], ...
    'Richness is not being calculated correctly for GraphBU.')

%% Test 2: GraphBD
A = [
    0  1  1  1; 
    1  0  1  1; 
    1  1  0  0;
    0  1  0  0
    ];

known_richness = {[1 0 2 3/2]'};

g = GraphBD(A);
richness = Richness(g);

assert(isequal(richness.getValue(), known_richness), ...
    [BRAPH2.STR ':Richness:' BRAPH2.BUG_ERR], ...
    'Richness is not being calculated correctly for GraphBD.')

%% Test 3: GraphWU
A = [
    0   .1  1  0; 
    .1  0   1  .8; 
    1   1   0  0;
    0   .8  0  0
    ];

known_richness = {[.1 0 1 .8]'};

g = GraphWU(A);
richness = Richness(g);

assert(isequal(richness.getValue(), known_richness), ...
    [BRAPH2.STR ':Richness:' BRAPH2.BUG_ERR], ...
    'Richness is not being calculated correctly for GraphWU.')

%% Test 4: GraphWD
A = [
    0   1   1  .1; 
    .2  0   1  1; 
    1   1   0  0;
    0   .3  0  0
    ];

known_richness = {[.6 0 2 .7]'};

g = GraphWD(A);
richness = Richness(g);
r = richness.getValue();
assert(isequal(round(r{1}, 10), round(known_richness{1}, 10)), ...
    [BRAPH2.STR ':Richness:' BRAPH2.BUG_ERR], ...
    'Richness is not being calculated correctly for GraphWD.')

%% Test 5: MultiplexGraphBU
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

known_richness = {
                 [1 0 1 1]'
                 [0 0 2 2]'
                 };      

g = MultiplexGraphBU(A);
richness = Richness(g);

assert(isequal(richness.getValue(), known_richness), ...
    [BRAPH2.STR ':Richness:' BRAPH2.BUG_ERR], ...
    'Richness is not being calculated correctly for MultiplexGraphBU.')

%% Test 6: MultiplexGraphBD
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
             
known_richness = {
                 [1 0 2 3/2]'
                 [1 0 1 2]'
                 };    

g = MultiplexGraphBD(A);
richness = Richness(g);

assert(isequal(richness.getValue(), known_richness), ...
    [BRAPH2.STR ':Richness:' BRAPH2.BUG_ERR], ...
    'Richness is not being calculated correctly for MultiplexGraphBD.')

%% Test 7: MultiplexGraphWU
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

known_richness = {
                 [.1 0 1 .8]'
                 [0  0 2 1.8]'
                 };      

g = MultiplexGraphWU(A);
richness = Richness(g);

assert(isequal(richness.getValue(), known_richness), ...
    [BRAPH2.STR ':Richness:' BRAPH2.BUG_ERR], ...
    'Richness is not being calculated correctly for MultiplexGraphWU.')

%% Test 8: MultiplexGraphWD
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

known_richness = {
                 [.6 0 2 .7]'
                 [.6 0 1 21/20]'
                 };   

g = MultiplexGraphWD(A);
richness = Richness(g);
richness = richness.getValue();
richness = cellfun(@(s) round(s, 4), richness, 'UniformOutput', false);

assert(isequal(richness, known_richness), ...
    [BRAPH2.STR ':Richness:' BRAPH2.BUG_ERR], ...
    'Richness is not being calculated correctly for MultiplexGraphWD.')
