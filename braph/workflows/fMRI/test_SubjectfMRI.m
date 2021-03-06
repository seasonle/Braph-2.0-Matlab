% test SubjectfMRI
br1 = BrainRegion('BR1', 'brain region 1', 1, 11, 111);
br2 = BrainRegion('BR2', 'brain region 2', 2, 22, 222);
br3 = BrainRegion('BR3', 'brain region 3', 3, 33, 333);
br4 = BrainRegion('BR4', 'brain region 4', 4, 44, 444);
br5 = BrainRegion('BR5', 'brain region 5', 5, 55, 555);
atlas = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

%% Test 1: Instantiation
sub = SubjectfMRI(atlas);

%% Test 2: Save and Load cohort from XLS 
% setup
sub_class = 'SubjectfMRI';
input_rule = 'fMRI';
input_data = rand(atlas.getBrainRegions().length(), 10);
save_dir_rule = 'RootDirectory';
save_dir_path = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased'];
sub1 = Subject.getSubject(sub_class, atlas, 'SubjectID', '1', input_rule, input_data);
sub2 = Subject.getSubject(sub_class, atlas, 'SubjectID', '2', input_rule, input_data);
sub3 = Subject.getSubject(sub_class, atlas, 'SubjectID', '3', input_rule, input_data);
sub4 = Subject.getSubject(sub_class, atlas, 'SubjectID', '4', input_rule, input_data);
sub5 = Subject.getSubject(sub_class, atlas, 'SubjectID', '5', input_rule, input_data);
group = Group(sub_class, {sub1, sub2, sub3}, 'GroupName', 'TestGroup1');
group2 = Group(sub_class, {sub4, sub5}, 'GroupName', 'TestGroup2');

cohort = Cohort('cohorttest', sub_class, atlas, {sub1, sub2, sub3, sub4, sub5});
cohort.getGroups().add(group.getName(), group);
cohort.getGroups().add(group2.getName(), group2);

% act
SubjectfMRI.save_to_xls(cohort, save_dir_rule, save_dir_path);

load_cohort = SubjectfMRI.load_from_xls(sub_class, atlas, 'Directory', save_dir_path);

% assert
assert(isequal(cohort.getSubjects().length(), load_cohort.getSubjects().length()), ...
    'BRAPH:SubjectfMRI:SaveLoadXLS', ...
    'Problems saving or loading a cohort.')
assert(isequal(cohort.getGroups().length(), load_cohort.getGroups().length()), ...
    'BRAPH:SubjectfMRI:SaveLoadXLS', ...
    'Problems saving or loading a cohort.')
for i = 1:1:max(cohort.getSubjects().length(), load_cohort.getSubjects().length())
    sub = cohort.getSubjects().getValue(i);
    sub_loaded = load_cohort.getSubjects().getValue(i);
    data = sub.getData(input_rule);
    data_loaded = sub_loaded.getData(input_rule);
    assert( ...
        isequal(sub.getID(), sub_loaded.getID()) & ...
        isequal(data.getValue(), data_loaded.getValue()), ...
        'BRAPH:SubjectfMRI:SaveLoadXLS', ...
        'Problems saving or loading a cohort.')
end

rmdir(save_dir_path, 's')

%% Test 3: Save and load cohort TXT
% setup
sub_class = 'SubjectfMRI';
input_rule = 'fMRI';
input_data = rand(atlas.getBrainRegions().length(), 10);
save_dir_rule = 'RootDirectory';
save_dir_path = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased'];
sub1 = Subject.getSubject(sub_class, atlas, 'SubjectID', '1', input_rule, input_data);
sub2 = Subject.getSubject(sub_class, atlas, 'SubjectID', '2', input_rule, input_data);
sub3 = Subject.getSubject(sub_class, atlas, 'SubjectID', '3', input_rule, input_data);
group = Group(sub_class, {sub1, sub2, sub3}, 'GroupName', 'TestGroup1');

cohort = Cohort('cohorttest', sub_class, atlas, {sub1, sub2, sub3});
cohort.getGroups().add(group.getName(), group);

% act
SubjectfMRI.save_to_txt(cohort, save_dir_rule, save_dir_path);

load_cohort = SubjectfMRI.load_from_txt(sub_class, atlas, 'Directory', [save_dir_path filesep() group.getName()]);

% assert
assert(isequal(cohort.getSubjects().length(), load_cohort.getSubjects().length()), ...
    'BRAPH:SubjectfMRI:SaveLoadTXT', ...
    'Problems saving or loading a cohort.')
assert(isequal(cohort.getGroups().length(), load_cohort.getGroups().length()), ...
    'BRAPH:SubjectfMRI:SaveLoadTXT', ...
    'Problems saving or loading a cohort.')
for i = 1:1:max(cohort.getSubjects().length(), load_cohort.getSubjects().length())
    sub = cohort.getSubjects().getValue(i);
    sub_loaded = load_cohort.getSubjects().getValue(i);
    data = sub.getData(input_rule);
    data_loaded = sub_loaded.getData(input_rule);
    assert( ...
        isequal(sub.getID(), sub_loaded.getID()) & ...
        isequal(round(data.getValue(),3), round(data_loaded.getValue(),3)), ...
        'BRAPH:SubjectfMRI:SaveLoadTXT', ...
        'Problems saving or loading a cohort.')
end

rmdir(save_dir_path, 's')

%% Test 4: Save and load cohort JSON
% setup
sub_class = 'SubjectfMRI';
input_rule = 'fMRI';
input_data = rand(atlas.getBrainRegions().length(), 10);
save_dir_rule = 'RootDirectory';
save_dir_path = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased'];
sub1 = Subject.getSubject(sub_class, atlas, 'SubjectID', '1', input_rule, input_data);
sub2 = Subject.getSubject(sub_class, atlas, 'SubjectID', '2', input_rule, input_data);
sub3 = Subject.getSubject(sub_class, atlas, 'SubjectID', '3', input_rule, input_data);
group = Group(sub_class, {sub1, sub2, sub3}, 'GroupName', 'TestGroup1');

cohort = Cohort('cohorttest', sub_class, atlas, {sub1, sub2, sub3});
cohort.getGroups().add(group.getName(), group);

% act
SubjectfMRI.save_to_json(cohort, save_dir_rule, save_dir_path);

load_cohort = SubjectfMRI.load_from_json(sub_class, atlas, 'Directory', [save_dir_path filesep() group.getName()]);

% assert
assert(isequal(cohort.getSubjects().length(), load_cohort.getSubjects().length()), ...
    'BRAPH:SubjectfMRI:SaveLoadTXT', ...
    'Problems saving or loading a cohort.')
assert(isequal(cohort.getGroups().length(), load_cohort.getGroups().length()), ...
    'BRAPH:SubjectfMRI:SaveLoadTXT', ...
    'Problems saving or loading a cohort.')
for i = 1:1:max(cohort.getSubjects().length(), load_cohort.getSubjects().length())
    sub = cohort.getSubjects().getValue(i);
    sub_loaded = load_cohort.getSubjects().getValue(i);
    data = sub.getData(input_rule);
    data_loaded = sub_loaded.getData(input_rule);
    assert( ...
        isequal(sub.getID(), sub_loaded.getID()) & ...
        isequal(round(data.getValue(),3), round(data_loaded.getValue(),3)), ...
        'BRAPH:SubjectfMRI:SaveLoadTXT', ...
        'Problems saving or loading a cohort.')
end

rmdir(save_dir_path, 's')