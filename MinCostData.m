classdef MinCostData < handle
    %% Contains data for minimum cost.
 
    %  Copyright 2021 The MathWworks, Inc.
 
    properties
        MinCost
        MinFis
    end
 
    methods
        function h = MinCostData
            reset(h)
        end
 
        function reset(h)
            h.MinCost = Inf;
            h.MinFis = [];
        end
    end
 
end