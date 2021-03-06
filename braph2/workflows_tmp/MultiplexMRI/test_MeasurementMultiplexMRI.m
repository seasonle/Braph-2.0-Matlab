% test MeasurementMultiplexMRI

br1 = BrainRegion('BR1', 'brain region 1', 'notes 1', 1, 1.1, 1.11);
br2 = BrainRegion('BR2', 'brain region 2', 'notes 2', 2, 2.2, 2.22);
br3 = BrainRegion('BR3', 'brain region 3', 'notes 3', 3, 3.3, 3.33);
br4 = BrainRegion('BR4', 'brain region 4', 'notes 4', 4, 4.4, 4.44);
br5 = BrainRegion('BR5', 'brain region 5', 'notes 5', 5, 5.5, 5.55);
atlas = BrainAtlas('BA', 'brain atlas', 'notes', 'BrainMesh_ICBM152.nv', {br1, br2, br3, br4, br5});

subject_class = Measurement.getSubjectClass('MeasurementMultiplexMRI');

sub1 = Subject.getSubject(subject_class, 'id1', 'label 1', 'notes 1', atlas);
sub2 = Subject.getSubject(subject_class, 'id2', 'label 2', 'notes 2', atlas);
sub3 = Subject.getSubject(subject_class, 'id3', 'label 3', 'notes 3', atlas);
sub4 = Subject.getSubject(subject_class, 'id4', 'label 4', 'notes 4', atlas);
sub5 = Subject.getSubject(subject_class, 'id5', 'label 5', 'notes 5', atlas);

group = Group(subject_class, 'id', 'label', 'notes', {sub1, sub2, sub3, sub4, sub5});

% TODO: get graph type from Analysis
graph_type = 'MultiplexGraphWU';
%graph_type = AnalysisMultiplexMRI.getGraphType();
measures = Graph.getCompatibleMeasureList(graph_type);

%% Test 1: Instantiation
for i = 1:1:numel(measures)
    measurement = MeasurementMultiplexMRI('m1', 'label', 'notes', atlas, measures{i}, group);
end

%% Test 2: Correct size defaults
for i = 1:1:numel(measures)
    measurement = MeasurementMultiplexMRI('m1', 'label', 'notes', atlas, measures{i}, group);
    
    value = measurement.getMeasureValue();
    
    if Measure.is_superglobal(measures{i})
        num_elements = 1;
    elseif Measure.is_unilayer(measures{i})
        num_elements = 2;
    elseif Measure.is_bilayer(measures{i})
        num_elements = 4;
    end
    if Measure.is_global(measures{i})
        assert(iscell(value) & ...
            isequal(numel(value), num_elements) & ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), value)), ...
            [BRAPH2.STR ':MeasurementMultiplexMRI:' BRAPH2.BUG_FUNC], ...
            'MeasurementMultiplexMRI does not initialinumelze correctly with global measures.')
    elseif Measure.is_nodal(measures{i})
        assert(iscell(value) & ...
            isequal(numel(value), num_elements) & ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), value)), ...
            [BRAPH2.STR ':MeasurementMultiplexMRI:' BRAPH2.BUG_FUNC], ...
            'MeasurementMultiplexMRI does not initialize correctly with global measures')
    elseif Measure.is_binodal(measures{i})
        assert(iscell(value) & ...
            isequal(numel(value), num_elements) & ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), value)), ...
            [BRAPH2.STR ':MeasurementMultiplexMRI:' BRAPH2.BUG_FUNC], ...
            'MeasurementMultiplexMRI does not initialize correctly with global measures')
    end

end

%% Test 3: Initialize with value
for i=1:1:numel(measures)
    % setup
    
    B = rand(5);
    A = {B, B; B, B};
    g = Graph.getGraph('MultiplexGraphWU', A);
    m  = Measure.getMeasure(measures{i}, g);
    
    % act
    measurement = MeasurementMultiplexMRI('m1', 'label', 'notes', atlas, measures{i}, group, ...
        'MeasurementMultiplexMRI.Value', m.getValue() ...
        );
    
    % assert
    if Measure.is_superglobal(measures{i})
        num_elements = 1;
        rows = 1;
        columns = 1;
    elseif Measure.is_unilayer(measures{i})
        num_elements = 2;
        rows = 2;
        columns = 1;
    elseif Measure.is_bilayer(measures{i})
        num_elements = 4;
        rows = 2;
        columns = 2;
    end
    if Measure.is_global(measures{i})
        assert(iscell(measurement.getMeasureValue()) & ...
            isequal(numel(measurement.getMeasureValue()), num_elements) & ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), measurement.getMeasureValue())) ...
            & isequal(size(measurement.getMeasureValue()), size(m.getValue())), ...
            [BRAPH2.STR ':MeasurementMultiplexMRI:' BRAPH2.BUG_FUNC], ...
            'MeasurementMultiplexMRI does not initialize correctly with global measures.')
    elseif Measure.is_nodal(measures{i})
        assert(iscell(measurement.getMeasureValue()) & ...
            isequal(numel(measurement.getMeasureValue()), num_elements) & ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), measurement.getMeasureValue()) ...
            & isequal(size(measurement.getMeasureValue()), size(m.getValue()))), ...
            [BRAPH2.STR ':MeasurementMultiplexMRI:' BRAPH2.BUG_FUNC], ...
            'MeasurementMultiplexMRI does not initialize correctly with global measures.')
    elseif Measure.is_binodal(measures{i})
        assert(iscell(measurement.getMeasureValue()) & ...
            isequal(numel(measurement.getMeasureValue()), num_elements) & ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), measurement.getMeasureValue()) ...
            & isequal(size(measurement.getMeasureValue()), size(m.getValue()))), ...
            [BRAPH2.STR ':MeasurementMultiplexMRI:' BRAPH2.BUG_FUNC], ...
            'MeasurementMultiplexMRI does not initialize correctly with global measures.')
    end
end