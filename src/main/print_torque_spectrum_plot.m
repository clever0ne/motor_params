function print_torque_spectrum_plot(torques, filename)
    if (nargin < 2)
        filename = 'torque_spectrum';
    end

    EPSILON = 0.001;
    MAX_ORDER = length(torques) - 1;

    n = [];
    t = [];
    for order = 0 : MAX_ORDER
        torque = torques(order + 1);
        sigma = 50 * EPSILON;

        x = order + (-5*sigma : EPSILON : 5*sigma);
        y = torque * exp(-(x - order).^2 / (2*sigma^2));

        n = [n, x];
        t = [t, y];
    end

    figure();
    plot(n, t, 'r-');

    hold off;
    grid on;
    axis([0, MAX_ORDER, 0, round(max(torques)) + 1]);

    set(gca, 'xtick', 0 : 1 : MAX_ORDER);
    set(gca, 'FontName', 'Euclid', 'FontSize', 12);
    xlabel('$n, \rm rounds$', 'Interpreter', 'latex', 'FontSize', 12);
    ylabel('$\hat{M}_n, \rm \: N \cdot m$', 'Interpreter', 'latex', 'FontSize', 12);

    if ~exist('../../graphs', 'dir')
        mkdir('../../graphs');
    end

    saveas(gcf, ['../../graphs/', filename, '.emf']);
end
