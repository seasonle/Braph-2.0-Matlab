classdef GlobalEfficiency < Measure
    % GlobalEfficiency < Measure: Global Efficiency measure
    % GlobalEfficiency provides the global efficiency of a node for binary undirected (BU) and 
    % weighted undirected (WU) graphs. It is calculated as average inverse
    % shortest path length in the graph. 
    % 
    % GlobalEfficiency methods:
    %   GlobalEfficiency            - constructor with Measure properties.
    %
    % GlobalEfficiency methods (Access=protected):
    %   calculate                   - calculates the global efficiency of a node.
    % 
    % GlobalEfficiency methods (Static)
    %   getClass                    - returns the global efficiency class.
    %   getName                     - returns the name of global efficiency measure.
    %   getDescription              - returns the description of global efficiency measure.
    %   getAvailableSettings        - returns the settings available to the class.
    %   is_global                   - boolean, checks if global efficiency measure is global.
    %   is_nodal                    - boolean, checks if global efficiency measure is nodal.
    %   is_binodal                  - boolean, checks if global efficiency measure if binodal.
    %   getMeasure                  - returns the global efficiency class.
    %   getCompatibleGraphList      - returns a list of compatible graphs.
    %   getCompatibleGraphNumber    - returns the number of compatible graphs.
    %
    % See also Measure, Graph, PathLength, InGlobalEfficiency, OutGlobalEfficiency, LocalEfficiency.
    
    methods
        function m = GlobalEfficiency(g, varargin)
            % GLOBALEFFICIENCY(G) creates global efficiency with default measure properties.
            % G is a graph (e.g, an instance of GraphBU, Graph WU). 
            %   
            % GLOBALEFFICIENCY(G, 'VALUE', VALUE) creates global efficiency, and sets the value
            % to VALUE. G is a graph (e.g, an instance of  GraphBU, Graph WU).
            %   
            % See also Measure, Graph, PathLength, InGlobalEfficiency, OutGlobalEfficiency, LocalEfficiency.
            
            m = m@Measure(g, varargin{:});
        end
    end
    methods (Access = protected)
        function global_efficiency = calculate(m)
            % CALCULATE calculates the global efficiency value of a node
            %
            % GLOBALEFFICIENCY = CALCULATE(M) returns the value of the global efficiency of a
            % node.
            
            g = m.getGraph();  % graph from measure class
            N = g.nodenumber();            
           
            if g.is_measure_calculated('Distance')
                D = g.getMeasure('Distance').getValue();
            else
                D = Distance(g, g.getSettings()).getValue();
            end
            
            Di = D.^-1;  % inverse distance
            Di(1:N+1:end) = 0;            
            global_efficiency = (sum(Di, 2) / (N-1));    
        end
    end
    methods (Static)
        function measure_class = getClass()
            % GETCLASS returns the measure class 
            %            
            % MEASURE_CLASS = GETCLASS() returns the class of the global efficiency measure.
            %
            % See also getName(), getDescription().
            
            measure_class = 'GlobalEfficiency';
        end
        function name = getName()
            % GETNAME returns the measure name
            %
            % NAME = GETNAME() returns the name of the global efficiency measure.
            %
            % See also getClass(), getDescription(). 
            
            name = 'Global-Efficiency';
        end
        function description = getDescription()
            % GETDESCRIPTION returns the global efficiency description 
            %
            % DESCRIPTION = GETDESCRIPTION() returns the description of the
            % global efficiency measure.
            %
            % See also getList(), getCompatibleGraphList().
            
            description = [ ...
                'The global efficiency is the average inverse ' ...
                'shortest path length in the graph. ' ...
                'It is inversely related to the characteristic path length.';
                ];
        end
        function available_settings = getAvailableSettings()
            % GETAVAILABLESETTINGS returns the setting available to GlobalEfficiency.
            %
            % AVAILABLESETTINGS = GETAVAILABLESETTINGS() returns the
            % settings available to GlobalEfficiency. Empty Array in this case.
            % 
            % See also getCompatibleGraphList()
            
            available_settings = {};
        end
        function bool = is_global()
            % IS_GLOBAL checks if global efficiency measure is global (false)
            %
            % BOOL = IS_GLOBAL() returns false.
            %
            % See also is_nodal, is_binodal.
            
            bool = false;
        end
        function bool = is_nodal()
            % IS_NODAL checks if global efficiency measure is nodal (true)
            %
            % BOOL = IS_NODAL() returns true.
            %
            % See also is_global, is_binodal. 
            
            bool = true;
        end
        function bool = is_binodal()
            % IS_BINODAL checks if global efficiency measure is binodal (false)
            %
            % BOOL = IS_BINODAL() returns false.
            %
            % See also is_global, is_nodal.
            
            bool = false;
        end
        function list = getCompatibleGraphList()
            % GETCOMPATIBLEGRAPHLIST returns the list of compatible graphs
            % to GlobalEfficiency 
            %
            % LIST = GETCOMPATIBLEGRAPHLIST() returns a cell array 
            % of compatible graph classes to GlobalEfficiency. 
            % The measure will not work if the graph is not compatible. 
            %
            % See also getCompatibleGraphNumber(). 
            
            list = { ...               
                'GraphBU', ...           
                'GraphWU' ...
                };
        end
        function n = getCompatibleGraphNumber()
            % GETCOMPATIBLEGRAPHNUMBER returns the number of compatible
            % graphs to GlobalEfficiency 
            %
            % N = GETCOMPATIBLEGRAPHNUMBER() returns the number of
            % compatible graphs to GlobalEfficiency.
            % 
            % See also getCompatibleGraphList().
            
            n = Measure.getCompatibleGraphNumber('GlobalEfficiency');
        end
    end
end