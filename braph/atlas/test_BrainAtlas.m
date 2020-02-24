% test BrainAtlas
br1 = BrainRegion('BR1', 'brain region 1', 1, 11, 111);
br2 = BrainRegion('BR2', 'brain region 2', 2, 22, 222);
br3 = BrainRegion('BR3', 'brain region 3', 3, 33, 333);
br4 = BrainRegion('BR4', 'brain region 4', 4, 44, 444);
br5 = BrainRegion('BR5', 'brain region 5', 5, 55, 555);
br6 = BrainRegion('BR6', 'brain region 6', 6, 66, 666);
br7 = BrainRegion('BR7', 'brain region 7', 7, 77, 777);
br8 = BrainRegion('BR8', 'brain region 8', 8, 88, 888);
br9 = BrainRegion('BR9', 'brain region 9', 9, 99, 999);

%% Test 1: Instantiation
ba = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

%% Test 2: Basic functionalities
ba = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

assert(ba.brainregionnumber()==5, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
assert(ba.contains_brain_region(1), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.contains_brain_region does not work')
assert(~ba.contains_brain_region(6), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.contains_brain_region does not work')
assert(isequal(ba.getBrainRegion(1).getLabel(), 'BR1'), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')

%% Test 3: Add
ba = BrainAtlas('brain atlas', {br1, br2, br4, br5});
ba.addBrainRegion(br3, 3)

assert(ba.brainregionnumber()==5, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
assert(isequal(ba.getBrainRegion(3).getLabel(), 'BR3'), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')

ba.addBrainRegion(br6)

assert(ba.brainregionnumber()==6, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
assert(isequal(ba.getBrainRegion(6).getLabel(), 'BR6'), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')

%% Test 4: Remove
ba = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

ba.removeBrainRegion(3)

assert(ba.brainregionnumber()==4, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
assert(isequal(ba.getBrainRegion(2).getLabel(), 'BR2'), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')
assert(isequal(ba.getBrainRegion(3).getLabel(), 'BR4'), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')

ba.removeBrainRegion(1)

assert(ba.brainregionnumber()==3, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
assert(isequal(ba.getBrainRegion(1).getLabel(), 'BR2'), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')

%% Test 5: Replace
ba = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

ba.replaceBrainRegion(3, br9)

assert(ba.brainregionnumber()==5, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
assert(isequal(ba.getBrainRegion(3).getLabel(), 'BR9'), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')

%% Test 6: Invert
ba = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

ba.invertBrainRegions(2, 4)

assert(ba.brainregionnumber()==5, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
assert(isequal(ba.getBrainRegion(2).getLabel(), 'BR4'), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')
assert(isequal(ba.getBrainRegion(4).getLabel(), 'BR2'), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')

%% Test 7: MoveTo
ba = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

ba.movetoBrainRegion(4, 2)

assert(ba.brainregionnumber()==5, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
assert(isequal(ba.getBrainRegion(2).getLabel(), 'BR4'), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')

ba.movetoBrainRegion(1, 5)

assert(ba.brainregionnumber()==5, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
assert(isequal(ba.getBrainRegion(5).getLabel(), 'BR1'), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')

%% Test 8: Remove All
ba = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

selected = ba.removeBrainRegions([2, 4]);

assert(ba.brainregionnumber()==3, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
assert(isequal(ba.getBrainRegion(3).getLabel(), 'BR5'), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')
assert(isempty(selected), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')

%% Test 9: Add Above
ba = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

[selected, added] = ba.addaboveBrainRegions([1 3 5]);

assert(ba.brainregionnumber()==8, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
for i = [1 4 7]
    assert(isequal(ba.getBrainRegion(i).getLabel(), 'BR'), ...
        'BRAPH:BrainAtlas:Bug', ...
        'BrainAtlas.getBrainRegion does not work')
end
assert(isequal(selected, [2 5 8]), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')
assert(isequal(added, [1 4 7]), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')

%% Test 9: Add Below
ba = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

[selected, added] = ba.addbelowBrainRegions([1 3 5]);

assert(ba.brainregionnumber()==8, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
for i = [2 5 8]
    assert(isequal(ba.getBrainRegion(i).getLabel(), 'BR'), ...
        'BRAPH:BrainAtlas:Bug', ...
        'BrainAtlas.getBrainRegion does not work')
end
assert(isequal(selected, [1 4 7]), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')
assert(isequal(added, [2 5 8]), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')

%% Test 10: Move Up
ba = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

selected = ba.moveupBrainRegions([1 3 5]);

assert(ba.brainregionnumber()==5, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
assert(isequal(selected, [1 2 4]), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')

%% Test 11: Move Down
ba = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

selected = ba.movedownBrainRegions([1 3 5]);

assert(ba.brainregionnumber()==5, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
assert(isequal(selected, [2 4 5]), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')

%% Test 12: Move to Top
ba = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

selected = ba.move2topBrainRegions([1 3 5]);

assert(ba.brainregionnumber()==5, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
assert(isequal(selected, [1 2 3]), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')

%% Test 12: Move to Bottom
ba = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

selected = ba.move2bottomBrainRegions([1 3 5]);

assert(ba.brainregionnumber()==5, ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.brainregionnumber does not work')
assert(isequal(selected, [3 4 5]), ...
    'BRAPH:BrainAtlas:Bug', ...
    'BrainAtlas.getBrainRegion does not work')