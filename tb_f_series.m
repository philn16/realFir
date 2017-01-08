function [] = tb_f_series()
% assignin('base', 'poinz', INTERPOLATION_POINTS)
close all

INTERPOLATION_POINTS = 100;

% START OF COSINE TESTS
if 1
y = [0 1 2 3 4 2 1 2 3 4 5 6 -2];
f = @(x) cos(2*pi*x);
t = linspace(0,1-1/numel(y),numel(y)) / 2;

[r , n] = f_series(  y , f , t);
plotResult();

y = [1 2 3 3 2 1];
f = @(x) cos(2*pi*x);
t = linspace(0,1-1/numel(y),numel(y)) / 2;

[r , n] = f_series(  y , f , t);
plotResult();

y = [1 2 3 4 5 6 7 8 9 15 22];
f = @(x) cos(2*pi*x);
t = linspace(0,1-1/numel(y),numel(y)) + 0.01;

[r , n] = f_series(  y , f , t);
plotResult();
end
% START OF SINE TESTS

y = [0 1 2 3 4 2 1 2 3 4 5 6 -2];
f = @(x) sin(2*pi*x);
t = linspace(0,1-1/numel(y),numel(y)) / 2;

[r , n] = f_series(  y , f , t);
plotResult();

    function [] = plotResult()
        if 1
            % Creates interpolated points and points at specified times from resuting r values
            t_plot = sort([linspace(0,1,INTERPOLATION_POINTS) , t]);
            y_new = zeros(1,numel(t_plot));
            for i=1:numel(y_new)
                y_new(i) = sum(r .* f(t_plot(i) * n));
            end
            
            figure
            hold on
                        plot(t,y,'--Or');
            [~ , indexes] = intersect(t_plot,t);
            plot(t,y_new(indexes),'*b');
            plot(t_plot,y_new,':b');
            legend('Old Y','New Y','interpolated Y');
        end
    end
end