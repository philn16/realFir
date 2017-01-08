function [] = tb_get_h()
close all
clear variables

indexes=[];t=[];t_plot=[];H_phased=[];h=[];

yr = [0 0 0 1   1 1 1   0 0];
yi = [0 0 0 0.5 1 1 0.5 0 0];
y=yr+1j*yi;
sub1();
sub2();
plotAll();
hPlot();

y = [zeros(1,4) , ones(1,4) , zeros(1,4)];
sub1();
sub2();
plotAll();
hPlot();

y = [zeros(1,0) , ones(1,4) , zeros(1,8)];
sub1();
sub2();
plotAll();
hPlot();

    function [] = sub2()
        [h , M] = get_h(y , t);
        H = freqz(h,1,2*pi*t_plot);
        H_phased = H .* exp(1j*M*(2*pi*t_plot));
    end

    function [] = sub1()
        t = linspace(0,1-1/numel(y),numel(y)) / 2;
        t_plot = sort([t , linspace(0,0.5,400)]);
        [~,indexes] = intersect(t_plot,t);
    end

    function [] = hPlot()
        figure
        plot(0:(numel(h)-1),h,':*')
        title('UPR plot');
        xlabel('Sample number');
        axis('tight');
        fix_axis( 0.03 , Inf );
    end

    function [] = plotAll()
        plotResponse(@(x) abs(x));
        title('Abs plot');
        plotResponse(@(x) real(x));
        title('Real plot');
        plotResponse(@(x) imag(x));
        title('Imag plot');
    end

    function [] = plotResponse(f)
        if ~exist('f','var')
            f = @(x) abs(x);
        end
        figure
        hold on
        plot(t , f(y),'--b*');
        plot(t,f(H_phased(indexes)),'rO')
        plot(t_plot,f(H_phased),'r:')
        legend('Desired','New');
    end
end