classdef InInAssortativity < Measure
    % InInAssortativity In-In-Assortativity measure
    % InInAssortativity provides the in-in-assortativity coefficient of a 
    % graph for binary directed (BD) and weighted directed (WD) graphs.  
    %
    % It is calculated as the correlation coefficient between the
    % degrees/strengths of all nodes on two opposite ends of an edge 
    % within a layer. The corresponding coefficient for directed and
    % weighted networks is calculated by using the weighted and directed
    % variants of in-degree/in-strength.
    % 
    % InInAssortativity methods:
    %   InInAssortativity           - constructor 
    % 
    % InInAssortativity descriptive methods (Static)
    %   getClass                    - returns the in-in-assortativity class
    %   getName                     - returns the name of in-in-assortativity measure
    %   getDescription              - returns the description of in-in-assortativity measure
    %   getAvailableSettings        - returns the settings available to the class
    %   getMeasureFormat            - returns the measure format
    %   getMeasureScope             - returns the measure scope
    %   getParametricity            - returns the parametricity of the measure   
    %   getMeasure                  - returns the in-in-assortativity class
    %   getCompatibleGraphList      - returns a list of compatible graphs
    %   getCompatibleGraphNumber    - returns the number of compatible graphs
    %
    % See also Measure, InDegree, InStrength, GraphBD, GraphWD, MultiplexGraphBD, MultiplexGraphWD.
    
    methods
        function m = InInAssortativity(g, varargin)           
            % ININASSORTATIVITY(G) creates in-in-assortativity with default measure properties.
            % G is a graph (e.g, an instance of GraphBU, GraphWU,
            % MultiplexGraphBU, MultiplexGraphWU). 
            %   
            % See also Measure, InDegree, InStrength, GraphBD, GraphWD, MultiplexGraphBD, MultiplexGraphWD.
              
            m = m@Measure(g, varargin{:});
        end
    end
    methods (Access=protected)
        function in_in_assortativity = calculate(m)
            % CALCULATE calculates the in-in-assortativity value of a graph
            %
            % ININASSORTATIVITY = CALCULATE(M) returns the value of the in-in-assortativity 
            % of a graph.
            %
            % See also Measure, InDegree, InStrength, GraphBD, GraphWD, MultiplexGraphBD, MultiplexGraphWD.
            
            g = m.getGraph();  % graph from measure class
            A = g.getA();  % adjacency matrix (for graph) or 2D-cell array (for multiplex)
            L = g.layernumber();

            in_in_assortativity = cell(L, 1);
            connectivity_type =  g.getConnectivityType(g.layernumber());
            for li = 1:1:L
                
                if g.is_graph(g)
                    Aii = A;
                    connectivity_layer = connectivity_type;
                else
                    Aii = A{li, li};
                    connectivity_layer = connectivity_type(li, li);
                end
                
                [i, j] = find(Aii ~= 0);  % nodes [i, j]
                M = length(i);  % Number of edges
                k_i = zeros(M, L);
                k_j = zeros(length(j), L);
            
                if connectivity_layer == Graph.WEIGHTED  % weighted graphs
                    
                    if g.is_measure_calculated('InStrength')
                        in_strength = g.getMeasureValue('InStrength');
                    else
                        in_strength = InStrength(g, g.getSettings()).getValue();
                    end                   
                    d = in_strength{li};


                else  % binary graphs
                    
                    if g.is_measure_calculated('InDegree')
                        in_degree = g.getMeasureValue('InDegree');
                    else
                        in_degree = InDegree(g, g.getSettings()).getValue();
                    end
                    d = in_degree{li};
                    
                end
                k_i(:, li) = d(i);  % in-degree/in-strength node i
                k_j(:, li) = d(j);  % in-degree/in-strength node j
                % compute assortativity
                assortativity_layer = (sum(k_i(:, li) .* k_j(:, li)) / M - (sum(0.5 * (k_i(:, li) + k_j(:, li))) / M)^2)...
                    / (sum(0.5 * (k_i(:, li).^2 + k_j(:, li).^2)) / M - (sum(0.5 * (k_i(:, li) + k_j(:, li))) / M)^2);           
                assortativity_layer(isnan(assortativity_layer)) = 0;  % Should return zeros, not NaN    
                in_in_assortativity(li) = {assortativity_layer};  
            end  
        end
    end
    methods (Static)  % descriptive
        function measure_class = getClass()
            % GETCLASS returns the measure class 
            %            
            % MEASURE_CLASS = GETCLASS() returns the class of the in-in-assortativity measure.
            %
            % See also getName(), getDescription(). 
            
            measure_class = 'InInAssortativity';
        end
        function name = getName()
            % GETNAME returns the measure name
            %
            % NAME = GETNAME() returns the name of the in-in-assortativity measure.
            %
            % See also getClass(), getDescription(). 
            
            name = 'In-In-Assortativity';
        end
        function description = getDescription()
            % GETDESCRIPTION returns the in-in-assortativity description 
            %
            % DESCRIPTION = GETDESCRIPTION() returns the description of the
            % in-in-assortativity measure.
            %
            % See also getList(), getCompatibleGraphList().
            
            description = [ ...
                'The in-in-assortativity coefficient of a graph is ' ...
                'the correlation coefficient between the degrees/strengths ' ...
                'of all nodes on two opposite ends of an edge within a layer.' ...
                'The corresponding coefficient for directed and '...
                'weighted networks is calculated by using the weighted '...
                'and directed variants of in-degree/in-strength.'...
                ];
        end
        function available_settings = getAvailableSettings()
            % GETAVAILABLESETTINGS returns the setting available to InInAssortativity
            %
            % AVAILABLESETTINGS = GETAVAILABLESETTINGS() returns the
            % settings available to InInAssortativity. Empty Array in this case.
            % 
            % See also getCompatibleGraphList()
            
            available_settings = {};
        end
       function measure_format = getMeasureFormat()
            % GETMEASUREFORMAT returns the measure format of InInAssortativity
            %
            % MEASURE_FORMAT = GETMEASUREFORMAT() returns the measure format
            % of in-in-assortativity measure (GLOBAL).
            %
            % See also getMeasureScope.
            
            measure_format = Measure.GLOBAL;
        end
        function measure_scope = getMeasureScope()
            % GETMEASURESCOPE returns the measure scope of InInAssortativity
            %
            % MEASURE_SCOPE = GETMEASURESCOPE() returns the
            % measure scope of in-in-assortativity measure (UNILAYER).
            %
            % See also getMeasureFormat.
            
            measure_scope = Measure.UNILAYER;
        end
                function parametricity = getParametricity()
            % GETPARAMETRICITY returns the parametricity of InInAssortativity
            %
            % PARAMETRICITY = GETPARAMETRICITY() returns the
            % parametricity of in-in-assortativity measure (NONPARAMETRIC).
            %
            % See also getMeasureFormat, getMeasureScope.
            
            parametricity = Measure.NONPARAMETRIC;
        end
        function list = getCompatibleGraphList()
            % GETCOMPATIBLEGRAPHLIST returns the list of compatible graphs
            % with InInAssortativity 
            %
            % LIST = GETCOMPATIBLEGRAPHLIST() returns a cell array 
            % of compatible graph classes to in-in-assortativity. 
            % The measure will not work if the graph is not compatible. 
            %
            % See also getCompatibleGraphNumber(). 
            
            list = { ...
                'GraphBD', ...
                'GraphWD', ...
                'MultiplexGraphBD', ...
                'MultiplexGraphWD' ...
                };
        end
        function n = getCompatibleGraphNumber()
            % GETCOMPATIBLEGRAPHNUMBER returns the number of compatible
            % graphs with InInAssortativity 
            %
            % N = GETCOMPATIBLEGRAPHNUMBER() returns the number of
            % compatible graphs to in-in-assortativity.
            % 
            % See also getCompatibleGraphList().
            
            n = Measure.getCompatibleGraphNumber('InInAssortativity');
        end
    end
end