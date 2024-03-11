classdef cycleBreaker < matlab.System
    % untitled6 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    % Public, tunable properties
    properties

    end

    properties(Access = private)
        PreviousInput;
    end

    % Pre-computed constants
    properties (Access = private)

    end

    methods (Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end
% 
%         function y = stepImpl(obj,u)
%             % Implement algorithm. Calculate y as a function of input u and
%             % discrete states.
%             y = u;
%         end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            obj.PreviousInput = cast([],propagatedInputDataType(obj,1));
        end


        function [y] = outputImpl(obj,~)
            y = obj.PreviousInput;
        end

        function updateImpl(obj, u)
            obj.PreviousInput = u;
        end

        function c1 = isOutputFixedSizeImpl(obj)
            c1 = false;
        end

        function flag = isInputSizeMutableImpl(obj,~)
            flag = true;
        end

        function out = getOutputDataTypeImpl(obj)
            out = propagatedInputDataType(obj,1);
        end

    end

end
