classdef OutOutAssortativity < Measure
    % OutOutAssortativity Out-Out-Assortativity measure
    % OutOutAssortativity provides the out-out-assortativity coefficient of a 
    % graph for binary directed (BD) and weighted directed (WD) graphs. 
    %
    % It is calculated as the correlation coefficient between the
    % degrees/strengths of all nodes on two opposite ends of an edge 
    % within a layer. The corresponding coefficient for directed and
    % weighted networks is calculated by using the weighted and directed
    % variants of out-degree/out-strength.
    % 
    % OutOutAssortativity methods:
    %   OutOutAssortativity         - constructor 
    % 
    % OutOutAssortativity descriptive methods (Static)
    %   getClass                    - returns the out-out-assortativity class
    %   getName                     - returns the name of out-out-assortativity measure
    %   getDescription              - returns the description of out-out-assortativity measure
    %   getAvailableSettings        - returns the settings available to the class
    %   getMeasureFormat            - returns the measure format
    %   getMeasureScope             - returns the measure scope
    %   getParametricity            - returns the parametricity of the measure   
    %   getMeasure                  - returns the out-out-assortativity class
    %   getCompatibleGraphList      - returns a list of compatible graphs
    %   getCompatibleGraphNumber    - returns the number of compatible graphs
    %
    % See also Measure, OutDegree, OutStrength, GraphBD, GraphWD, MultiplexGraphBD, MultiplexGraphWD.
    
    methods
        function m = OutOutAssortativity(g, varargin)           
            % OUTOUTASSORTATIVITY(G) creates out-out-assortativity with default measure properties.
            % G is a graph (e.g, an instance of GraphBU, GraphWU,
            % MultiplexGraphBU, MultiplexGraphWU). 
            %   
            % See also Measure, OutDegree, OutStrength, GraphBD, GraphWD, MultiplexGraphBD, MultiplexGraphWD.
              
            m = m@Measure(g, varargin{:});
        end
    end
    methods (Access=protected)
        function out_in_assortativity = calculate(m)
            % CALCULATE calculates the out-out-assortativity value of a graph
            %
            % OUTOUTASSORTATIVITY = CALCULATE(M) returns the value of the out-out-assortativity 
            % of a graph.
            %
            % See also Measure, OutDegree, OutStrength, GraphBD, GraphWD, MultiplexGraphBD, MultiplexGraphWD.
            
            g = m.getGraph();  % graph from measure class
            A = g.getA();  % adjacency matrix (for graph) or 2D-cell array (for multiplex)
            L = g.layernumber();

            out_in_assortativity = cell(L, 1);
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
 
                    if g.is_measure_calculated('OutStrength')
                        out_strength = g.getMeasureValue('OutStrength');
                    else
                        out_strength = OutStrength(g, g.getSettings()).getValue();
                    end
                    d = out_strength{li};


                else  % binary graphs
                    
                    if g.is_measure_calculated('OutDegree')
                        out_degree = g.getMeasureValue('OutDegree');
                    else
                        out_degree = OutDegree(g, g.getSettings()).getValue();
                    end
                    d = out_degree{li};
                    
                end
                k_i(:, li) = d(j);  % out-degree/out-strength node i
                k_j(:, li) = d(i);  % out-degree/out-strength node j
                % compute assortativity
                assortativity_layer = (sum(k_i(:, li) .* k_j(:, li)) / M - (sum(0.5 * (k_i(:, li) + k_j(:, li))) / M)^2)...
                    / (sum(0.5 * (k_i(:, li).^2 + k_j(:, li).^2)) / M - (sum(0.5 * (k_i(:, li) + k_j(:, li))) / M)^2);           
                assortativity_layer(isnan(assortativity_layer)) = 0;  % Should return zeros, not NaN    
                out_in_assortativity(li) = {assortativity_layer};  
            end  
        end
    end
    methods (Static)  % descriptive
        function measure_class = getClass()
            % GETCLASS returns the measure class 
            %            
            % MEASURE_CLASS = GETCLASS() returns the class of the out-out-assortativity measure.
            %
            % See also getName(), getDescription(). 
            
            measure_class = 'OutOutAssortativity';
        end
        function name = getName()
            % GETNAME returns the measure name
            %
            % NAME = GETNAME() returns the name of the out-out-assortativity measure.
            %
            % See also getClass(), getDescription(). 
            
            name = 'Out-Out-Assortativity';
        end
        function description = getDescription()
            % GETDESCRIPTION returns the out-out-assortativity description 
            %
            % DESCRIPTION = GETDESCRIPTION() returns the description of the
            % out-out-assortativity measure.
            %
            % See also getList(), getCompatibleGraphList().
            
            description = [ ...
                'The out-out-assortativity coefficient of a graph is ' ...
                'the correlation coefficient between the degrees/strengths ' ...
                'of all nodes on two opposite ends of an edge within a layer.' ...
                'The corresponding coefficient for directed and '...
                'weighted networks is calculated by using the weighted '...
                'and directed variants of out-degree/out-strength.'...
                ];
        end
        function available_settings = getAvailableSettings()
            % GETAVAILABLESETTINGS returns the setting available to OutOutAssortativity
            %
            % AVAILABLESETTINGS = GETAVAILABLESETTINGS() returns the
            % settings available to OutInAssortativity. Empty Array in this case.
            % 
            % See also getCompatibleGraphList()
            
            available_settings = {};
        end
       function measure_format = getMeasureFormat()
            % GETMEASUREFORMAT returns the measure format of OutOutAssortativity
            %
            % MEASURE_FORMAT = GETMEASUREFORMAT() returns the measure format
            % of out-out-assortativity measure (GLOBAL).
            %
            % See also getMeasureScope.
            
            measure_format = Measure.GLOBAL;
        end
        function measure_scope = getMeasureScope()
            % GETMEASURESCOPE returns the measure scope of OutOutAssortativity
            %
            % MEASURE_SCOPE = GETMEASURESCOPE() returns the
            % measure scope of out-out-assortativity measure (UNILAYER).
            %
            % See also getMeasureFormat.
            
            measure_scope = Measure.UNILAYER;
        end
                function parametricity = getParametricity()
            % GETPARAMETRICITY returns the parametricity of OutOutAssortativity
            %
            % PARAMETRICITY = GETPARAMETRICITY() returns the
            % parametricity of out-out-assortativity measure (NONPARAMETRIC).
            %
            % See also getMeasureFormat, getMeasureScope.
            
            parametricity = Measure.NONPARAMETRIC;
        end
        function list = getCompatibleGraphList()
            % GETCOMPATIBLEGRAPHLIST returns the list of compatible graphs
            % with OutOutAssortativity 
            %
            % LIST = GETCOMPATIBLEGRAPHLIST() returns a cell array 
            % of compatible graph classes to out-out-assortativity. 
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
            % graphs with OutOutAssortativity 
            %
            % N = GETCOMPATIBLEGRAPHNUMBER() returns the number of
            % compatible graphs to out-out-assortativity.
            % 
            % See also getCompatibleGraphList().
            
            n = Measure.getCompatibleGraphNumber('OutOutAssortativity');
        end
    end
end