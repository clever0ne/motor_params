function retval = print_torque_dq_plot(density, torque, filename, labelname)
    if (nargin < 3)
        filename = 'torque_dq';
    end

    if (nargin < 4)
        labelname = 'M_{dq}';
    end

    EPSILON = 0.001;
    density = density / 1000000;
    min_density = density(1);
    max_density = density(end);
    min_torque = min(torque);
    max_torque = max(torque);

    delta_torque = 0.05 * (max_torque - min_torque);
    min_torque = min_torque - (delta_torque + EPSILON);
    max_torque = max_torque + (delta_torque + EPSILON);

    figure();
    smooth_density = min_density : 1 : max_density;
    smooth_torque = spline(density, torque, smooth_density);
    plot(smooth_density, smooth_torque, 'r-');

    grid on;
    axis([min_density, max_density, min_torque, max_torque]);

    set(gca, 'xtick', min_density : 20 : max_density);
    set(gca, 'FontName', 'Euclid', 'FontSize', 12);
    xlabel('$j, \rm A/mm^2$', 'Interpreter', 'latex', 'FontSize', 12);
    ylabel(['$', labelname, ', \rm \: N \cdot m$'], 'Interpreter', 'latex', 'FontSize', 12);

    if ~exist('../../graphs', 'dir')
        mkdir('../../graphs');
    end

    saveas(gcf, ['../../graphs/', filename, '.emf']);
end
