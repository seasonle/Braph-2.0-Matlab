classdef OutPathLength < Measure
    % OutPathLength < Measure: Out Path Length measure
    % OutPathLength provides the out-path length of a node for binary directed (BD) and 
    % weighted directed (WD) graphs. It is calculated as average shortest
    % in path length from one node to another node.
    % 
    % OutPathLength methods:
    %   OutPathLength                  - constructor.
    %
    % OutPathLength methods (Access=protected):
    %   calculate                   - calculates the out-path length of a node.
    % 
    % OutPathLength methods (Static)
    %   getClass                    - returns the out-path length class.
    %   getName                     - returns the name of out-path length measure.
    %   getDescription              - returns the description of out-path length measure.
    %   getAvailableSettings        - returns the settings available to the class.
    %   is_global                   - boolean, checks if out-path length measure is global.
    %   is_nodal                    - boolean, checks if out-path length measure is nodal.
    %   is_binodal                  - boolean, checks if out-path length measure if binodal.
    %   getMeasure                  - returns the out-path length class.
    %   getCompatibleGraphList      - returns a list of compatible graphs.
    %   getCompatibleGraphNumber    - returns the number of compatible graphs.
    %
    % See also Measure, Graph, Strength, Distance, Degree.
    methods
        function m = OutPathLength(g, varargin) 
            % OUTPATHLENGTH(G) creates out-path length with default measure properties.
            % G is a graph (e.g, an instance of GraphBU, Graph WU). 
            %   
            % OUTPATHLENGTH(G, 'Settings', SETTINGS) creates out-path length measure and
            % initializes the property settings with SETTINGS. OUTPATHLENGTH
            % available SETTINGS are: 
            % subgraphs     -   Calculates OUTPATHLENGTH of all subgraphs
            % harmonic      -   Calculates OUTPATHLENGTH with harmonic average
            % default       -   Calculates OUTPATHLENGTH with normal average
            %
            % OUTPATHLENGTH(G, 'VALUE', VALUE) creates out-path length, and sets the value
            % to VALUE. G is a graph (e.g, an instance of GraphBD, GraphBU,
            % GraphWD, Graph WU).
            %   
            % See also Measure, Graph, Strength, Distance, GlobalEfficiency.
       
            m = m@Measure(g, varargin{:});
        end
    end
    methods (Access = protected)
        function out_path_length =  calculate(m)
            % CALCULATE calculates the out-path length value of a node
            %
            % PATHLENGTH = CALCULATE(M) returns the value of the out-path length
            % of a node.
            
            g = m.getGraph();  % graph from measure class          

            if g.is_measure_calculated('Distance')
                distance = g.getMeasureValue('Distance');
            else
                distance = Distance(g, g.getSettings()).getValue();
            end
            
            N = g.nodenumber();
            out_path_length = zeros(N, 1);
            
            pathLength_rule = get_from_varargin('default', 'OutPathLengthAvRule', m.getSettings());
            switch lower(pathLength_rule)
                case {'subgraphs'}
                    for u = 1:1:N
                        Du = distance(u, :);
                        out_path_length(u) = mean(Du(Du~=0 & Du~=Inf));
                    end
                    out_path_length(isnan(out_path_length)) = 0;  % node Nan corresponds to isolated nodes, pathlength is 0
                case {'harmonic'}
                    for u = 1:1:N
                        Du = distance(u, :);
                        out_path_length(u) = harmmean(Du(Du~=0));
                    end
                otherwise
                    for u = 1:1:N
                        Du = distance(u, :);
                        out_path_length(u) = mean(Du(Du~=0));
                    end
            end
        end
    end
    methods (Static)
        function measure_class = getClass()
            % GETCLASS returns the measure class 
            %            
            % MEASURE_CLASS = GETCLASS() returns the class of the out-path length measure.
            %
            % See also getName(), getDescription().
            
            measure_class = 'OutPathLength';
        end
        function name = getName()
            % GETNAME returns the measure name
            %
            % NAME = GETNAME() returns the name of the out-path length measure.
            %
            % See also getClass(), getDescription().
            name = 'Out-Path Length';
        end
        function description = getDescription()
            % GETDESCRIPTION returns the out-path length description 
            %
            % DESCRIPTION = GETDESCRIPTION() returns the description of the
            % out-path length measure.
            %
            % See also getList(), getCompatibleGraphList().
            
            description = [ ...
                'The out path length is the average shortest ' ...
                'out path lengths of one node to all other nodes.' ...
                ];
        end
        function available_settings = getAvailableSettings() 
            % GETAVAILABLESETTINGS returns the setting available to OutPathLength
            %
            % AVAILABLESETTINGS = GETAVAILABLESETTINGS() returns the
            % settings available to OutPathLength. 
            % OUTPATHLENGTHAVRULE = 'default' (default) - calculates out-path length of nodal graph.
            %                    'subgraphs' - calculates out-path length of each subgraph.
            %                    'harmonic'  - calculates the out-path length using harmonic mean.
            % 
            % See also getCompatibleGraphList()
            
            available_settings = {
                'OutPathLengthAvRule', Constant.STRING, 'default', {'default', 'subgraphs', 'harmonic'};
                };
        end
        function bool = is_global()
            % IS_GLOBAL checks if out-path length measure is global (false)
            %
            % BOOL = IS_GLOBAL() returns false.
            %
            % See also is_nodal, is_binodal.
            
            bool = false;
        end
        function bool = is_nodal()
            % IS_NODAL checks if out-path length measure is nodal (true)
            %
            % BOOL = IS_NODAL() returns true.
            %
            % See also is_global, is_binodal.
            bool = true;
        end
        function bool = is_binodal()
            % IS_BINODAL checks if out-path length measure is binodal (false)
            %
            % BOOL = IS_BINODAL() returns false.
            %
            % See also is_global, is_nodal.
            
            bool = false;
        end
        function list = getCompatibleGraphList()
            % GETCOMPATIBLEGRAPHLIST returns the list of compatible graphs
            % to OutPathLength
            %
            % LIST = GETCOMPATIBLEGRAPHLIST() returns a cell array 
            % of compatible graph classes to OutPathLength. 
            % The measure will not work if the graph is not compatible. 
            %
            % See also getCompatibleGraphNumber().
            
            list = { ...
                'GraphBD', ...
                'GraphWD' ...
                };
        end
        function n = getCompatibleGraphNumber()
            % GETCOMPATIBLEGRAPHNUMBER returns the number of compatible
            % graphs to OutPathLength
            %
            % N = GETCOMPATIBLEGRAPHNUMBER() returns the number of
            % compatible graphs to OutPathLength.
            % 
            % See also getCompatibleGraphList().
            
            n = Measure.getCompatibleGraphNumber('OutPathLength');
        end
    end
end