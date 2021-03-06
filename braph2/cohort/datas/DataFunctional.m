classdef DataFunctional < Data
    % DataFunctional A data functional matrix
    % DataFunctional implements Data and serves as a container for matrix
    % type data.
    % It is a subclass of Data.
    %
    % DataFunctional implements Data and serves as a container for matrix
    % type data. It checks if the value of the data being saved is numeric
    % and has the same number of rows as the Brain Atlas.
    %
    % DataFunctional methods:
    %   DataFunctional          - Constructor
    %   setValue                - set value
    %   getDataPanel            - returns data panel
    %
    % DataFunctional static mehtods
    %   getClass                - returns the class
    %   getName                 - returns the name of the class
    %   getDescription          - returns the description of the class
    %   getAvailableSettings    - returns the available settings
    %
    % See also Data, DataConnectivity, DataScalar, DataStructural.
    
    methods
        function d = DataFunctional(atlas, value, varargin)
            % DATAFUNCTIONAL(ATLAS, VALUE) creates DataFunctional object
            % and calls for the superclass.
            %
            % See also Data, DataConnectivity, DataScalar, DataStructural.
            
            if nargin < 2
                value = zeros(atlas.getBrainRegions().length(), 10);
            end
            
            d = d@Data(atlas, value, varargin{:});
        end
        function setValue(d, value)
            % SETVALUE sets the value of the data into the object
            %
            % SETVALUE(D, VALUE) checks that the value of the data is
            % numeric and that it has the same number of rows as the atlas.
            % If incorrect it throws and error, if correct it sets the
            % value to the object.
            %
            % See also getValue, getDataPanel.
            
            regionnumber = d.getBrainAtlas().getBrainRegions().length();
            assert(isnumeric(value) && size(value, 1)==regionnumber, ...
                [BRAPH2.STR ':DataFunctional:' BRAPH2.WRONG_INPUT], ...
                [ ...
                'The value of DataFunctional must be a matrix ' ...
                'with the same number of rows as the BrainAtlas, ' ...
                'in this case ' int2str(regionnumber) ' rows' ...
                ])
            
            d.value = value;
        end
        function h = getDataPanel(d, ui_parent)
            % GETDATAPANEL creates a uitable and returns it
            %
            % GETDATAPANEL(D, UIPARENT) creates a uitable with D values and
            % sets the uitable to the UIPARENT.
            %
            % See also setValue.
            
            value_holder = d.value;
            h_panel = uitable('Parent', ui_parent);
            
            % rownames
            atlas = d.atlas;
            brs = atlas.getBrainRegions().getValues();
            for j = 1:1:length(brs)
                br = brs{j};
                RowName{j} = br.getID(); %#ok<AGROW>
            end
            
            set(h_panel, 'Units', 'normalized')
            set(h_panel, 'Position', [0 0 1 1])
            set(h_panel, 'ColumnFormat', {'numeric'})
            set(h_panel, 'ColumnEditable', true)
            set(h_panel, 'RowName', RowName)
            set(h_panel, 'Data', value_holder)
            set(h_panel, 'CellEditCallback', {@cb_data_table})
            
            function cb_data_table(~, event)
                m = event.Indices(1);
                col = event.Indices(2);
                newdata = event.NewData;
                d.value(m, col) = newdata;
            end
            
            if nargout > 0
                h = h_panel;
            end
        end
    end
    methods (Static)
        function data_class = getClass()
            % GETCLASS returns the class of the data
            %
            % DATA_CLASS = GETCLASS() returns the class of the data.
            %
            % See also  getName, getDescription, getAvailableSettings.
            
            data_class = 'DataFunctional';
        end
        function name = getName()
            % GETNAME returns the name of the data
            %
            % NAME = GETNAME(D) returns the name of the data.
            %
            % See also getClass, getDescription, getAvailableSettings.
            
            name = 'Functional Brain Data';
        end
        function description = getDescription()
            % GETDESCRIPTION returns the description of the data
            %
            % DESCRIPTION = GETDESCRIPTION(D) returns the description of
            % the data.
            %
            % See also getClass, getName, getAvailableSettings.
            
            description = [ ...
                'A series of functional data corresponding ' ...
                'to one timeseries per brain region.' ...
                ];
        end
        function available_settings = getAvailableSettings(d) %#ok<INUSD>
            % GETAVAILABLESETTINGS returns the available settings of the data
            %
            % AVAILABLE_SETTINGS = GETAVAILABLESETTINGS(D) returns the
            % available settings of the data.
            %
            % See also getClass, getName, getDescription.
            
            available_settings = {};
        end
    end
end