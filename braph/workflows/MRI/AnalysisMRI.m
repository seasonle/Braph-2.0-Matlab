classdef AnalysisMRI < Analysis
    methods
        function analysis = AnalysisMRI(cohort, measurements, randomcomparisons, comparisons, varargin)
            
            analysis = analysis@Analysis(cohort, measurements, randomcomparisons, comparisons, varargin{:});
        end
    end
    methods
        function measurement_id = getMeasurementID(analysis, measure_code, group, varargin)
            is_random = get_from_varargin(0, 'is_randomMRI', varargin{:});
            if is_random
                measurement_id = [ ...
                    tostring(analysis.getMeasurementClass()) ' ' ...
                    tostring(measure_code) ' RandomGroup' ...
                    ];
            else
                measurement_id = [ ...
                    tostring(analysis.getMeasurementClass()) ' ' ...
                    tostring(measure_code) ' ' ...
                    tostring(analysis.cohort.getGroups().getIndex(group)) ...
                    ];
            end
        end
        function randomcomparison_id = getRandomComparisonID(analysis, measure_code, group, varargin)
            randomcomparison_id = [ ...
                tostring(analysis.getRandomComparisonClass()) ' ' ...
                tostring(measure_code) ' ' ...
                tostring(analysis.cohort.getGroups().getIndex(group)) ...
                ];
        end
        function comparison_id = getComparisonID(analysis, measure_code, groups, varargin)
            comparison_id = [ ...
                tostring(analysis.getComparisonClass()) ' ' ...
                tostring(measure_code) ' ' ...
                tostring(analysis.cohort.getGroups().getIndex(groups{1})) ' ' ...
                tostring(analysis.cohort.getGroups().getIndex(groups{2})) ...
                ];
        end
    end
    methods (Access = protected)
        function measurement = calculate_measurement(analysis, measure_code, group, varargin)
            subjects = group.getSubjects();
            atlases = analysis.cohort.getBrainAtlases();
            atlas = atlases{1};
            data = zeros(group.subjectnumber(), atlas.getBrainRegions().length());
            
            for i = 1:1:group.subjectnumber()
                subject = subjects{i};
                data(i, :) = subject.getData('MRI').getValue();  % MRI data
            end
            
            correlation_rule = analysis.getSettings('AnalysisMRI.CorrelationRule');
            negative_weight_rule = analysis.getSettings('AnalysisMRI.NegativeWeightRule');
            A = Correlation.getAdjacencyMatrix(data, correlation_rule, negative_weight_rule);
            
            graph_type = analysis.getSettings('AnalysisMRI.GraphType');
            g = Graph.getGraph(graph_type, A, varargin{:});
            
            measure = Measure.getMeasure(measure_code, g, varargin{:});
            measurement_value = {measure.getValue()};
            
            measurement = Measurement.getMeasurement('MeasurementMRI', ...
                analysis.getMeasurementID(measure_code, group, varargin{:}), ...
                analysis.getCohort().getBrainAtlases(), group,  ...
                'MeasurementMRI.measure_code', measure_code, ...
                'MeasurementMRI.value', measurement_value ...
                );
        end
        function randomcomparison = calculate_random_comparison(analysis, measure_code, group, varargin)
            % rules
            attemptsPerEdge = analysis.getSettings('AnalysisMRI.AttemptsPerEdge');
            numerOfWeights = analysis.getSettings('AnalysisMRI.NumberOfWeights');
            graph_type = analysis.getSettings('AnalysisMRI.GraphType');
            verbose = analysis.getSettings('AnalysisMRI.ComparisonVerbose');
            interruptible = analysis.getSettings('AnalysisMRI.ComparionInterruptible');
            correlation_rule = analysis.getSettings('AnalysisMRI.CorrelationRule');
            negative_weight_rule = analysis.getSettings('AnalysisMRI.NegativeWeightRule');
            is_longitudinal = analysis.getSettings('AnalysisMRI.Longitudinal');
            M = get_from_varargin(1e+3, 'NumerOfPermutations', varargin{:});
            
            % get info from subjects
            subjects = group.getSubjects();
            subject_class = group.getSubjectClass();
            atlases = analysis.getCohort().getBrainAtlases();
            A = zeros(atlases{1}.getBrainRegions().length());
            for i = 1:1:numel(subjects)
                subject = subjects{i};
                A(i, :) = subject.getData('MRI').getValue();
            end
            
            % get randomize graphs of subjects
            g = Graph.getGraph(graph_type, A);
            [permuted_A, ~] = g.randomize_graph('AttemptsPerEdge', attemptsPerEdge, 'NumberOfWeights', numerOfWeights);
            
            % create subjects with new data
            for i = 1:1:numel(subjects)
                info_subject =  permuted_A(i, :);
                permuted_subjects{i} = Subject.getSubject(subject_class, atlases{1}, 'MRI', info_subject'); %#ok<AGROW>
            end
            

            permuted_group = Group(subject_class, permuted_subjects, 'GroupName', ['RandomGroup_' group.getName()]);
            
            % create Measurements
            measurement_group = analysis.calculate_measurement(measure_code, group, varargin{:});
            measurement_random = analysis.calculate_measurement(measure_code, permuted_group, 'is_randomMRI', 1, varargin{:});
            
            value_group = measurement_group.getMeasureValue();
            value_random = measurement_random.getMeasureValue();
            
                        
            for i = 1:1:group.subjectnumber()
                subject = subjects{i};
                subjects_data_1(:, i) = subject.getData('MRI').getValue();  %#ok<AGROW> % MRI data % here we swaps dimensions to be compatible with permutation
            end
            
            for i = 1:1:permuted_group.subjectnumber()
                subject = permuted_subjects{i};
                subjects_data_2(:, i) = subject.getData('MRI').getValue(); %#ok<AGROW>
            end
            
            % compare
            all_permutations_1 = cell(1, M);
            all_permutations_2 = cell(1, M);
            
            start = tic;
            for i = 1:1:M
                if verbose
                    disp(['** PERMUTATION TEST - sampling #' int2str(i) '/' int2str(M) ' - ' int2str(toc(start)) '.' int2str(mod(toc(start),1)*10) 's'])
                end
                
                if is_longitudinal
                    [permutation_1, permutation_2] = Permutation.permute(subjects_1, subjects_2, is_longitudinal);
                else
                    [permutation_1, permutation_2] = Permutation.permute(subjects_data_1, subjects_data_2, is_longitudinal);
                end
                
                A_permutated_1 = Correlation.getAdjacencyMatrix(permutation_1', correlation_rule, negative_weight_rule);  % swap dimensions again
                graph_permutated_1 = Graph.getGraph(graph_type, A_permutated_1, varargin{:});
                measure_permutated_1 = Measure.getMeasure(measure_code, graph_permutated_1, varargin{:});
                measure_permutated_value_1 = measure_permutated_1.getValue();
                
                A_permutated_2 = Correlation.getAdjacencyMatrix(permutation_2', correlation_rule, negative_weight_rule);
                graph_permutated_2 = Graph.getGraph(graph_type, A_permutated_2, varargin{:});
                measure_permutated_2 = Measure.getMeasure(measure_code, graph_permutated_2, varargin{:});
                measure_permutated_value_2 = measure_permutated_2.getValue();
                
                
                all_permutations_1(1, i) = {measure_permutated_value_1};
                all_permutations_2(1, i) = {measure_permutated_value_2};
                
                difference_all_permutations{1, i} = measure_permutated_value_2 - measure_permutated_value_1; %#ok<AGROW>
                if interruptible
                    pause(interruptible)
                end
            end
            
            difference_mean = cell2mat(value_random) - cell2mat(value_group);  % difference of the mean values of non permuted random group minus the non permuted group 
            difference_all_permutations = cellfun(@(x) [x], difference_all_permutations, 'UniformOutput', false);  %#ok<NBRAK> % permutated group 1 - permutated group 2
            
            p1 = pvalue1(difference_mean, difference_all_permutations);  % singe tail,
            p2 = pvalue2(difference_mean, difference_all_permutations);  % double tail
            percentiles = quantiles(difference_all_permutations, 100);
            if size(percentiles) == [1 1] %#ok<BDSCA>
                ci_lower = percentiles{1}(2);
                ci_upper = percentiles{1}(40); % 95 percent
            elseif size(percentiles) == [size(difference_mean, 1) 1] %#ok<BDSCA>
                for i = 1:1:length(percentiles)
                    percentil = percentiles{i};
                    ci_lower{i, 1} = percentil(2);  %#ok<AGROW>
                    ci_upper{i, 1} = percentil(40); %#ok<AGROW>
                end
            else
                for i = 1:1:size(percentiles, 1)
                    for j = 1:1:size(percentiles, 2)
                        percentil = percentiles{i, j};
                        ci_lower{i, j} = percentil(2); %#ok<AGROW>
                        ci_upper{i, j} = percentil(40); %#ok<AGROW>
                    end
                end
            end
            
            % create randomComparisonClass
            randomcomparison = RandomComparison.getRandomComparison('RandomComparisonMRI', ...
                analysis.getRandomComparisonID(measure_code, group, varargin{:}), ...
                analysis.getCohort().getBrainAtlases(), group, ...
                'RandomComparisonMRI.measure_code', measure_code, ...
                'RandomComparisonMRI.values_group', value_group, ...
                'RandomComparisonMRI.values_random', value_random, ...
                'RandomComparisonMRI.difference', difference_mean, ...
                'RandomComparisonMRI.all_differences', difference_all_permutations, ...
                'RandomComparisonMRI.p1', p1, ...
                'RandomComparisonMRI.p2', p2, ....
                'RandomComparisonMRI.confidence_min', ci_lower, ...
                'RandomComparisonMRI.confidence_max', ci_upper, ...
                'RandomComparisonMRI.number_of_permutations', M ...
                );
        end
        function comparison = calculate_comparison(analysis, measure_code, groups, varargin)
            verbose = analysis.getSettings('AnalysisMRI.ComparisonVerbose');
            interruptible = analysis.getSettings('AnalysisMRI.ComparionInterruptible');
            is_longitudinal = analysis.getSettings('AnalysisMRI.Longitudinal');
            M = get_from_varargin(1e+3, 'NumerOfPermutations', varargin{:});
            correlation_rule = analysis.getSettings('AnalysisMRI.CorrelationRule');
            negative_weight_rule = analysis.getSettings('AnalysisMRI.NegativeWeightRule');
            graph_type = analysis.getSettings('AnalysisMRI.GraphType');
            
            group_1 = groups{1};
            group_2 = groups{2};
            
            measurements_1 = analysis.calculateMeasurement(measure_code, group_1, varargin{:});
            value_1 = measurements_1.getMeasureValue();
            
            measurements_2 = analysis.calculateMeasurement(measure_code, group_2, varargin{:});
            value_2 = measurements_2.getMeasureValue();
            
            all_permutations_1 = cell(1, M);
            all_permutations_2 = cell(1, M);
            
            subjects_1 = group_1.getSubjects();
            subjects_2 = group_2.getSubjects();
            
            for i = 1:1:group_1.subjectnumber()
                subject = subjects_1{i};
                subjects_data_1(:, i) = subject.getData('MRI').getValue();  %#ok<AGROW> % MRI data % here we swaps dimensions to be compatible with permutation
            end
            
            for i = 1:1:group_2.subjectnumber()
                subject = subjects_2{i};
                subjects_data_2(:, i) = subject.getData('MRI').getValue(); %#ok<AGROW>
            end
            
            start = tic;
            for i = 1:1:M
                if verbose
                    disp(['** PERMUTATION TEST - sampling #' int2str(i) '/' int2str(M) ' - ' int2str(toc(start)) '.' int2str(mod(toc(start),1)*10) 's'])
                end
                
                if is_longitudinal
                    [permutation_1, permutation_2] = Permutation.permute(subjects_1, subjects_2, is_longitudinal);
                else
                    [permutation_1, permutation_2] = Permutation.permute(subjects_data_1, subjects_data_2, is_longitudinal);
                end
                
                A_permutated_1 = Correlation.getAdjacencyMatrix(permutation_1', correlation_rule, negative_weight_rule);  % swap dimensions again
                graph_permutated_1 = Graph.getGraph(graph_type, A_permutated_1, varargin{:});
                measure_permutated_1 = Measure.getMeasure(measure_code, graph_permutated_1, varargin{:});
                measure_permutated_value_1 = measure_permutated_1.getValue();
                
                A_permutated_2 = Correlation.getAdjacencyMatrix(permutation_2', correlation_rule, negative_weight_rule);
                graph_permutated_2 = Graph.getGraph(graph_type, A_permutated_2, varargin{:});
                measure_permutated_2 = Measure.getMeasure(measure_code, graph_permutated_2, varargin{:});
                measure_permutated_value_2 = measure_permutated_2.getValue();
                
                
                all_permutations_1(1, i) = {measure_permutated_value_1};
                all_permutations_2(1, i) = {measure_permutated_value_2};
                
                difference_all_permutations{1, i} = measure_permutated_value_2 - measure_permutated_value_1; %#ok<AGROW>
                if interruptible
                    pause(interruptible)
                end
            end
            
            difference_mean = cell2mat(value_2) - cell2mat(value_1);  % difference of the mean values of the non permutated groups
            difference_all_permutations = cellfun(@(x) [x], difference_all_permutations, 'UniformOutput', false);  %#ok<NBRAK> % permutated group 1 - permutated group 2
            
            p1 = pvalue1(difference_mean, difference_all_permutations);  % singe tail,
            p2 = pvalue2(difference_mean, difference_all_permutations);  % double tail
            percentiles = quantiles(difference_all_permutations, 100);
            if size(percentiles) == [1 1] %#ok<BDSCA>
                ci_lower = percentiles{1}(2);
                ci_upper = percentiles{1}(40); % 95 percent
            elseif size(percentiles) == [size(difference_mean, 1) 1] %#ok<BDSCA>
                for i = 1:1:length(percentiles)
                    percentil = percentiles{i};
                    ci_lower{i, 1} = percentil(2);  %#ok<AGROW>
                    ci_upper{i, 1} = percentil(40); %#ok<AGROW>
                end
            else
                for i = 1:1:size(percentiles, 1)
                    for j = 1:1:size(percentiles, 2)
                        percentil = percentiles{i, j};
                        ci_lower{i, j} = percentil(2); %#ok<AGROW>
                        ci_upper{i, j} = percentil(40); %#ok<AGROW>
                    end
                end
            end
            
            comparison = Comparison.getComparison('ComparisonMRI', ...
                analysis.getComparisonID(measure_code, groups, varargin{:}), ...
                analysis.getCohort().getBrainAtlases(), groups, ...
                'ComparisonMRI.measure_code', measure_code, ...
                'ComparisonMRI.difference', difference_mean, ...
                'ComparisonMRI.all_differences', num2cell(difference_all_permutations, 1), ...
                'ComparisonMRI.p1', p1, ...
                'ComparisonMRI.p2', p2, ...
                'ComparisonMRI.confidence_min', ci_lower, ...
                'ComparisonMRI.confidence_max', ci_upper, ...
                'ComparisonMRI.value_1', value_1, ...
                'ComparisonMRI.value_2', value_2, ...
                'ComparisonMRI.number_of_permutations', M ....
                );
        end
    end
    methods (Static)
        function analysis_class = getClass()
            analysis_class = 'AnalysisMRI';
        end
        function name = getName()
            name = 'Analysis Structural MRI';
        end
        function subject_class = getSubjectClass()
            subject_class = 'SubjectMRI';
        end
        function description = getDescription()
            description = [ ...
                'Analysis based on structural MRI data, ' ...
                'such as cortical thickness for each brain region' ...
                ];
        end
        function measurement_class = getMeasurementClass()
            measurement_class =  'MeasurementMRI';
        end
        function randomcomparison_class = getRandomComparisonClass()
            randomcomparison_class = 'RandomComparisonMRI';
        end
        function comparison_class = getComparisonClass()
            comparison_class = 'ComparisonMRI';
        end
        function available_settings = getAvailableSettings(m) %#ok<INUSD>
            available_settings = {
                {'AnalysisMRI.GraphType', Constant.STRING, 'GraphWU', {'GraphWU'}}, ...
                {'AnalysisMRI.CorrelationRule', Constant.STRING, 'pearson', Correlation.CORRELATION_RULE_LIST}, ...
                {'AnalysisMRI.NegativeWeightRule', Constant.STRING, 'default', Correlation.NEGATIVE_WEIGHT_RULE_LIST}, ...
                {'AnalysisMRI.ComparisonVerbose', Constant.LOGICAL, false, {false, true}}, ...
                {'AnalysisMRI.ComparionInterruptible', Constant.LOGICAL, false, {false, true}}, ...
                {'AnalysisMRI.Longitudinal', Constant.LOGICAL, false, {false, true}}, ...
                {'AnalysisMRI.AttemptsPerEdge', Constant.NUMERIC, 1, {}}, ...
                {'AnalysisMRI.NumberOfWeights', Constant.NUMERIC, 1, {}} ...
                };
        end
    end
end