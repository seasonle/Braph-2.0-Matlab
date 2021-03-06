% test SubjectCON

br1 = BrainRegion('BR1', 'brain region 1', 'notes 1', 1, 1.1, 1.11);
br2 = BrainRegion('BR2', 'brain region 2', 'notes 2', 2, 2.2, 2.22);
br3 = BrainRegion('BR3', 'brain region 3', 'notes 3', 3, 3.3, 3.33);
br4 = BrainRegion('BR4', 'brain region 4', 'notes 4', 4, 4.4, 4.44);
br5 = BrainRegion('BR5', 'brain region 5', 'notes 5', 5, 5.5, 5.55);
atlas = BrainAtlas('BA', 'brain atlas', 'notes', 'BrainMesh_ICBM152.nv', {br1, br2, br3, br4, br5});

%% Test 1: Instantiation
sub = SubjectCON('id', 'label', 'notes', atlas);

%% Test 2: Save and Load Cohort XLS
% setup
sub_class = 'SubjectCON';
input_rule = 'CON';
input_data = rand(atlas.getBrainRegions().length(), atlas.getBrainRegions().length());
save_dir_rule = 'RootDirectory';
save_dir_path = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased'];
sub1 = Subject.getSubject(sub_class, 'SubjectID1', 'label1', 'notes1', atlas, input_rule, input_data);
sub2 = Subject.getSubject(sub_class, 'SubjectID2', 'label2', 'notes2', atlas, input_rule, input_data);
sub3 = Subject.getSubject(sub_class, 'SubjectID3', 'label3', 'notes3', atlas, input_rule, input_data);
sub4 = Subject.getSubject(sub_class, 'SubjectID4', 'label4', 'notes4', atlas, input_rule, input_data);
sub5 = Subject.getSubject(sub_class, 'SubjectID5', 'label5', 'notes5', atlas, input_rule, input_data);
group = Group(sub_class, 'GroupName1', 'TestGroup1', 'notes1', {sub1, sub2, sub3});
group2 = Group(sub_class, 'GroupName2', 'TestGroup2', 'notes2', {sub4, sub5});

cohort = Cohort('cohorttest', 'label1', 'notes1', sub_class, atlas, {sub1, sub2, sub3, sub4, sub5});
cohort.getGroups().add(group.getID(), group);
cohort.getGroups().add(group2.getID(), group2);

% act
SubjectCON.save_to_xls(cohort, save_dir_rule, save_dir_path);

load_cohort = SubjectCON.load_from_xls(atlas, 'Directory', save_dir_path);

% assert
assert(isequal(cohort.getSubjects().length(), load_cohort.getSubjects().length()), ...
    'BRAPH:SubjectCON:SaveLoadXLS', ...
    'Problems saving or loading a cohort.')
assert(isequal(cohort.getGroups().length(), load_cohort.getGroups().length()), ...
    'BRAPH:SubjectCON:SaveLoadXLS', ...
    'Problems saving or loading a cohort.')
for i = 1:1:max(cohort.getSubjects().length(), load_cohort.getSubjects().length())
    sub = cohort.getSubjects().getValue(i);
    sub_loaded = load_cohort.getSubjects().getValue(i);
    data = sub.getData(input_rule);
    data_loaded = sub_loaded.getData(input_rule);
    assert( ...
        isequal(sub.getID(), sub_loaded.getID()) & ...
        isequal(data.getValue(), data_loaded.getValue()), ...
        'BRAPH:SubjectCON:SaveLoadXLS', ...
        'Problems saving or loading a cohort.')
end

rmdir(save_dir_path, 's')

%% Test 3: Save and load cohort TXT
% setup
sub_class = 'SubjectCON';
input_rule = 'CON';
input_data = rand(atlas.getBrainRegions().length(), atlas.getBrainRegions().length());
save_dir_rule = 'RootDirectory';
save_dir_path = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased'];
sub1 = Subject.getSubject(sub_class, 'SubjectID1', 'label1', 'notes1', atlas, input_rule, input_data);
sub2 = Subject.getSubject(sub_class, 'SubjectID2', 'label2', 'notes2', atlas, input_rule, input_data);
sub3 = Subject.getSubject(sub_class, 'SubjectID3', 'label3', 'notes3', atlas, input_rule, input_data);
group = Group(sub_class, 'GroupName1', 'TestGroup1', 'notes1', {sub1, sub2, sub3});

cohort = Cohort('cohorttest', 'label1', 'notes1', sub_class, atlas, {sub1, sub2, sub3});
cohort.getGroups().add(group.getID(), group);

% act
SubjectCON.save_to_txt(cohort, save_dir_rule, save_dir_path);

load_cohort = SubjectCON.load_from_txt(atlas, 'Directory', [save_dir_path filesep() group.getID()]);

% assert
assert(isequal(cohort.getSubjects().length(), load_cohort.getSubjects().length()), ...
    'BRAPH:SubjectCON:SaveLoadTXT', ...
    'Problems saving or loading a cohort.')
assert(isequal(cohort.getGroups().length(), load_cohort.getGroups().length()), ...
    'BRAPH:SubjectCON:SaveLoadTXT', ...
    'Problems saving or loading a cohort.')
for i = 1:1:max(cohort.getSubjects().length(), load_cohort.getSubjects().length())
    sub = cohort.getSubjects().getValue(i);
    sub_loaded = load_cohort.getSubjects().getValue(i);
    data = sub.getData(input_rule);
    data_loaded = sub_loaded.getData(input_rule);
    assert( ...
        isequal(sub.getID(), sub_loaded.getID()) & ...
        isequal(round(data.getValue(),3), round(data_loaded.getValue(),3)), ...
        'BRAPH:SubjectCON:SaveLoadTXT', ...
        'Problems saving or loading a cohort.')
end

rmdir(save_dir_path, 's')

%% Test 4: Save and load cohort JSON
% setup
sub_class = 'SubjectCON';
input_rule = 'CON';
input_data = rand(atlas.getBrainRegions().length(), atlas.getBrainRegions().length());
save_dir_rule = 'File';
save_dir_path = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased'];
sub1 = Subject.getSubject(sub_class, 'SubjectID1', 'label1', 'notes1', atlas, input_rule, input_data);
sub2 = Subject.getSubject(sub_class, 'SubjectID2', 'label2', 'notes2', atlas, input_rule, input_data);
sub3 = Subject.getSubject(sub_class, 'SubjectID3', 'label3', 'notes3', atlas, input_rule, input_data);
sub4 = Subject.getSubject(sub_class, 'SubjectID4', 'label4', 'notes4', atlas, input_rule, input_data);
sub5 = Subject.getSubject(sub_class, 'SubjectID5', 'label5', 'notes5', atlas, input_rule, input_data);
sub6 = Subject.getSubject(sub_class, 'SubjectID6', 'label6', 'notes6', atlas, input_rule, input_data);

group = Group(sub_class, 'GroupName1', 'TestGroup1', 'notes1', {sub1, sub2, sub3});
group_2 = Group(sub_class, 'GroupName2', 'TestGroup2', 'notes2', {sub4, sub5, sub6});

cohort = Cohort('cohorttest', 'label1', 'notes1', sub_class, atlas, {sub1, sub2, sub3, sub4, sub5, sub6});
cohort.getGroups().add(group.getID(), group);
cohort.getGroups().add(group_2.getID(), group_2);

% act
JSON.Serialize(SubjectCON.save_to_json(cohort), save_dir_rule, save_dir_path);

load_cohort = SubjectCON.load_from_json(atlas, save_dir_rule, save_dir_path);

% assert
assert(isequal(cohort.getSubjects().length(), load_cohort.getSubjects().length()), ...
    'BRAPH:SubjectCON:SaveLoadTXT', ...
    'Problems saving or loading a cohort.')
assert(isequal(cohort.getGroups().length(), load_cohort.getGroups().length()), ...
    'BRAPH:SubjectCON:SaveLoadTXT', ...
    'Problems saving or loading a cohort.')
for i = 1:1:max(cohort.getSubjects().length(), load_cohort.getSubjects().length())
    sub = cohort.getSubjects().getValue(i);
    sub_loaded = load_cohort.getSubjects().getValue(i);
    data = sub.getData(input_rule);
    data_loaded = sub_loaded.getData(input_rule);
    assert( ...
        isequal(sub.getID(), sub_loaded.getID()) & ...
        isequal(round(data.getValue(),3), round(data_loaded.getValue(),3)), ...
        'BRAPH:SubjectCON:SaveLoadTXT', ...
        'Problems saving or loading a cohort.')
end

delete(save_dir_path)