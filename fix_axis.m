function [  ] = fix_axis( extra_Y_spacing , max_Y_diff )
% Makes the axis slightly larger on the Y
% Great for log plots
% Maxes the minimum need to be at most max_Y_diff smaller than max
if ~exist('max_Y_diff','var')
   max_Y_diff = 80; 
end
if ~exist('extra_Y_spacing','var')
    extra_Y_spacing = 0.05;
end
curAxis = axis;
    if curAxis(4) - curAxis(3) > max_Y_diff
        curAxis = [curAxis(1:2) curAxis(4)-max_Y_diff curAxis(4)];
        axis(curAxis);
    end
        axis(curAxis + (curAxis(4)-curAxis(3))*extra_Y_spacing*[0 0 -1 1])
end

