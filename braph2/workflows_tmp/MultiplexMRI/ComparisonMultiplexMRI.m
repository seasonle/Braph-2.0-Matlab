classdef ComparisonMultiplexMRI < Comparison
    properties
        value_1  % array with the value_1 of the measure for each subject of group 1
        value_2  % array with the value_1 of the measure for each subject of group 1
        difference  % difference
        all_differences  % all differences obtained through the permutation test
        p1  % p value single tailed
        p2  % p value double tailed
        confidence_interval_min  % min value of the 95% confidence interval
        confidence_interval_max  % max value of the 95% confidence interval
    end
    methods  % Constructor
        function c =  ComparisonMultiplexMRI(id, label, notes, atlas, measure_code, group_1, group_2, varargin)

% TODO: Add assert that the measure_code is in the measure list.

            c = c@Comparison(id, label, notes, atlas, measure_code, group_1, group_2, varargin{:});
        end
    end
    methods  % Get functions
        function [value_1, value_2] = getGroupValues(c)
            value_1 = c.value_1;
            value_2 = c.value_2;
        end
        function value = getGroupValue(c, group_index)
            if group_index == 1
                value = c.value_1;
            else
                value = c.value_2;
            end
        end
        function difference = getDifference(c)
            difference = c.difference;
        end
        function all_differences = getAllDifferences(c)
            all_differences = c.all_differences;
        end
        function p1 = getP1(c)
            p1 = c.p1;
        end
        function p2 = getP2(c)
            p2 = c.p2;
        end
        function confidence_interval_min = getConfidenceIntervalMin(c)
            confidence_interval_min = c.confidence_interval_min;
        end
        function confidence_interval_max = getConfidenceIntervalMax(c)
            confidence_interval_max = c.confidence_interval_max;
        end
    end
    methods (Access=protected)  % Initialize data
        function initialize_data(c, varargin)
            atlases = c.getBrainAtlases();
            atlas = atlases{1};       
            
            measure_code = c.getMeasureCode();
            
            number_of_permutations = c.getSettings('ComparisonMultiplexMRI.PermutationNumber');
            
            if Measure.is_superglobal(measure_code)  % superglobal measure
                rows = 1;
                columns = 1;
            elseif Measure.is_unilayer(measure_code)  % unilayer measure
                rows = 2;
                columns = 1;
            elseif Measure.is_bilayer(measure_code)  % bilayer measure
                rows = 2;
                columns = 2;
            end
            
            if Measure.is_global(measure_code)  % global measure
                c.value_1 = get_from_varargin( ...
                    repmat({0}, rows, columns), ...  % 1 measure per group
                    'ComparisonMultiplexMRI.value_1', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(1)) && ...
                    isequal(size(c.getGroupValue(1)), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getGroupValue(1))), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2.WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')

                c.value_2 = get_from_varargin( ...
                    repmat({0}, rows, columns), ...  % 1 measure per group
                    'ComparisonMultiplexMRI.value_2', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(2)) && ...
                    isequal(size(c.getGroupValue(2)), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getGroupValue(2))), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2.WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')

                c.difference = get_from_varargin( ...
                    repmat({0}, rows, columns), ...  
                    'ComparisonMultiplexMRI.difference', ...
                    varargin{:});
                assert(iscell(c.getDifference()) && ...
                    isequal(size(c.getDifference()), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getDifference())), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
                c.all_differences = get_from_varargin( ...
                    repmat({0}, rows*columns, number_of_permutations), ...
                    'ComparisonMultiplexMRI.all_differences', ...
                    varargin{:});
                assert(iscell(c.getAllDifferences()) && ...
                    isequal(size(c.getAllDifferences()), [rows*columns, number_of_permutations]) && ...
                    all(all(cellfun(@(x) isequal(size(x), [1, 1]), c.all_differences))), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
                c.p1 = get_from_varargin( ...
                    repmat({0}, rows, columns), ...  
                    'ComparisonMultiplexMRI.p1', ...
                    varargin{:});
                assert(iscell(c.getP1()) && ...
                    isequal(size(c.getP1()), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.p1)), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
                c.p2 = get_from_varargin( ...
                    repmat({0}, rows, columns), ...  
                    'ComparisonMultiplexMRI.p2', ...
                    varargin{:});
                assert(iscell(c.getP2()) && ...
                    isequal(size(c.getP2()), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.p2)), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
                c.confidence_interval_min = get_from_varargin( ...
                    repmat({0}, rows, columns), ...  
                    'ComparisonMultiplexMRI.confidence_interval_min', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMin()) && ...
                    isequal(size(c.getConfidenceIntervalMin()), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getConfidenceIntervalMin())), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
                c.confidence_interval_max = get_from_varargin( ...
                    repmat({0}, rows, columns), ...  
                    'ComparisonMultiplexMRI.confidence_interval_max', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMax()) && ...
                    isequal(size(c.getConfidenceIntervalMax()), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getConfidenceIntervalMax())), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                                
            elseif Measure.is_nodal(measure_code)  % nodal measure
                c.value_1 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, rows, columns), ...
                    'ComparisonMultiplexMRI.value_1', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(1)) && ...
                    isequal(size(c.getGroupValue(1)), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getGroupValue(1))), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')

                c.value_2 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, rows, columns), ...
                    'ComparisonMultiplexMRI.value_2', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(2)) && ...
                    isequal(size(c.getGroupValue(2)), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getGroupValue(2))), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')

                c.difference = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, rows, columns), ...
                    'ComparisonMultiplexMRI.difference', ...
                    varargin{:});
                assert(iscell(c.getDifference()) && ...
                    isequal(size(c.getDifference()), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getDifference())), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
                c.all_differences = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, rows*columns, number_of_permutations), ...
                    'ComparisonMultiplexMRI.all_differences', ...
                    varargin{:});
                assert(iscell(c.getAllDifferences()) && ...
                    isequal(size(c.getAllDifferences()), [rows*columns, number_of_permutations]) && ...
                    all(all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.all_differences))), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
                c.p1 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, rows, columns), ...
                    'ComparisonMultiplexMRI.p1', ...
                    varargin{:});
                assert(iscell(c.getP1()) && ...
                    isequal(size(c.getP1()), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.p1)), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
                c.p2 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, rows, columns), ...
                    'ComparisonMultiplexMRI.p2', ...
                    varargin{:});
                assert(iscell(c.getP2()) && ...
                    isequal(size(c.getP2()), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.p2)), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
                c.confidence_interval_min = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, rows, columns), ...
                    'ComparisonMultiplexMRI.confidence_interval_min', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMin()) && ...
                    isequal(size(c.getConfidenceIntervalMin()), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getConfidenceIntervalMin())), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')

                c.confidence_interval_max = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, rows, columns), ...
                    'ComparisonMultiplexMRI.confidence_interval_max', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMax()) && ...
                    isequal(size(c.getConfidenceIntervalMax()), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getConfidenceIntervalMax())), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
            elseif Measure.is_binodal(measure_code)  % binodal measure
                c.value_1 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, rows, columns), ...
                    'ComparisonMultiplexMRI.value_1', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(1)) && ...
                    isequal(size(c.getGroupValue(1)), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getGroupValue(1))), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
                c.value_2 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, rows, columns), ...
                    'ComparisonMultiplexMRI.value_2', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(2)) && ...
                    isequal(size(c.getGroupValue(2)), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getGroupValue(2))), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
                 c.difference = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, rows, columns), ...
                    'ComparisonMultiplexMRI.difference', ...
                    varargin{:});
                assert(iscell(c.getDifference()) && ...
                    isequal(size(c.getDifference()), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getDifference())), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')

                c.all_differences = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, rows*columns, number_of_permutations), ...
                    'ComparisonMultiplexMRI.all_differences', ...
                    varargin{:});
                assert(iscell(c.getAllDifferences()) && ...
                    isequal(size(c.getAllDifferences()), [rows*columns, number_of_permutations]) && ...
                    all(all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.all_differences))), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
                c.p1 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, rows, columns), ...
                    'ComparisonMultiplexMRI.p1', ...
                    varargin{:});
                assert(iscell(c.getP1()) && ...
                    isequal(size(c.getP1()), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.p1)), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
                c.p2 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, rows, columns), ...
                    'ComparisonMultiplexMRI.p2', ...
                    varargin{:});
                assert(iscell(c.getP2()) && ...
                    isequal(size(c.getP2()), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.p2)), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
                c.confidence_interval_min = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, rows, columns), ...
                    'ComparisonMultiplexMRI.confidence_interval_min', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMin()) && ...
                    isequal(size(c.getConfidenceIntervalMin()), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getConfidenceIntervalMin())), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
                
                c.confidence_interval_max = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, rows, columns), ...
                    'ComparisonMultiplexMRI.confidence_interval_max', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMax()) && ...
                    isequal(size(c.getConfidenceIntervalMax()), [rows, columns]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getConfidenceIntervalMax())), ...
                    [BRAPH2.STR ':ComparisonMultiplexMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMultiplexMRI')
            end
        end
    end
    methods (Static)  % Descriptive functions
        function class = getClass()
            class = 'ComparisonMultiplexMRI';
        end
        function name = getName()
            name = 'Comparison multiplex MRI';
        end
        function description = getDescription()
            description = 'Multiplex MRI comparison.';
        end
        function atlas_number = getBrainAtlasNumber()
            atlas_number =  1;
        end
        function analysis_class = getAnalysisClass()
            analysis_class = 'AnalysisMultiplexMRI';
        end
        function subject_class = getSubjectClass()
            subject_class = 'SubjectMultiplexMRI';
        end
        function available_settings = getAvailableSettings()
            available_settings = {
                'ComparisonMultiplexMRI.PermutationNumber', BRAPH2.NUMERIC, 1000, {};
                };
        end
        function sub = getComparison(comparisonClass, id, label, notes, atlas, group_1, group_2, varargin) %#ok<INUSD>
            sub = eval([comparisonClass '(id, label, notes, atlas, group_1, group_2, varargin{:})']);
        end
    end
end