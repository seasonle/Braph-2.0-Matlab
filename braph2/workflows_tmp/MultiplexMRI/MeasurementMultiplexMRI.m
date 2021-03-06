classdef MeasurementMultiplexMRI < Measurement
    % single group of  2 layers multiplex mri subjects
    properties
        value  % value of the measure for the group
    end
    methods  % Constructor
        function m =  MeasurementMultiplexMRI(id, label, notes, atlas, measure_code, group, varargin)
            
% TODO: Add assert that the measure_code is in the measure list. The code
% below can be useful but must be modified.
%             graph_type = AnalysisMRI.getGraphType();
%             measure_list = Graph.getCompatibleMeasureList(graph_type);
%             available_settings = {
%                 'MeasurementMRI.MeasureCode', BRAPH2.STRING, measure_list{1}, measure_list;
%                 };

            m = m@Measurement(id, label, notes, atlas, measure_code, group, varargin{:});
        end
    end
    methods  % Get functions
        function value = getMeasureValue(m)
            value = m.value;
        end
    end
    methods (Access=protected)
        function initialize_data(m, varargin)
            atlases = m.getBrainAtlases();
            atlas = atlases{1};
            
            measure_code = m.getMeasureCode();
            
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
                m.value = get_from_varargin( ...
                    repmat({0}, rows, columns), ...  % 1 measure per group
                    'MeasurementMultiplexMRI.Value', ...
                    varargin{:});
                assert(iscell(m.getMeasureValue()) & ...
                    isequal(size(m.getMeasureValue()), [rows, columns]) & ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), m.getMeasureValue())), ...
                    [BRAPH2.STR ':MeasurementMultiplexMRI:' BRAPH2.WRONG_INPUT], ...
                    'Data not compatible with MeasurementMultiplexMRI')
            elseif Measure.is_nodal(measure_code)  % nodal measure
                m.value = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, rows, columns), ...
                    'MeasurementMultiplexMRI.Value', ...
                    varargin{:});
                assert(iscell(m.getMeasureValue()) & ...
                    isequal(size(m.getMeasureValue()), [rows, columns]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), m.getMeasureValue())), ...
                    [BRAPH2.STR ':MeasurementMultiplexMRI:' BRAPH2.WRONG_INPUT], ...
                    'Data not compatible with MeasurementMultiplexMRI')
            elseif Measure.is_binodal(measure_code)  % binodal measure
                m.value = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, rows, columns), ...
                    'MeasurementMultiplexMRI.Value', ...
                    varargin{:});
                assert(iscell(m.getMeasureValue()) & ...
                    isequal(size(m.getMeasureValue()), [rows, columns]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), m.getMeasureValue())), ...
                    [BRAPH2.STR ':MeasurementMultiplexMRI:' BRAPH2.WRONG_INPUT], ...
                    'Data not compatible with MeasurementMultiplexMRI')
            end
        end
    end
    methods (Static)
        function class = getClass()
            class = 'MeasurementMultiplexMRI';
        end
        function name = getName()
            name = 'Measurement multiplex MRI';
        end
        function description = getDescription()
            description = 'Multiplex MRI measurement.';
        end
        function atlas_number = getBrainAtlasNumber()
            atlas_number =  1;
        end
        function analysis_class = getAnalysisClass()
            % measurement analysis class
            analysis_class = 'AnalysisMultiplexMRI';
        end
        function subject_class = getSubjectClass()
            % measurement subject class
            subject_class = 'SubjectMultiplexMRI';
        end        
        function available_settings = getAvailableSettings()
            available_settings = {};
        end
        function m = getMeasurement(measurement_class, id, label, notes, atlas, measure_code, group, varargin) %#ok<INUSD>
            m = eval([measurement_class '(id, label, notes, atlas, measure_code, group, varargin{:})']);
        end
    end
end