function print_torque_plot(angle, torque, filename, labelname)
    if (nargin < 3)
        filename = 'torque';
    end

    if (nargin < 4)
        labelname = 'M';
    end

    EPSILON = 0.001;
    min_angle = angle(1);
    max_angle = angle(end);
    min_torque = min(min(torque));
    max_torque = max(max(torque));

    delta_torque = 0.05 * (max_torque - min_torque);
    min_torque = min_torque - (delta_torque + EPSILON);
    max_torque = max_torque + (delta_torque + EPSILON);

    figure();
    options = {'r-', 'b--', 'g--'};
    smooth_angle = min_angle : 1 : max_angle;
    for idx = 1 : min(size(torque, 1), length(options))
        smooth_torque = spline(angle, torque(idx, :), smooth_angle);
        plot(smooth_angle, smooth_torque, options{idx});
        hold on;
    end

    hold off;
    grid on;
    axis([min_angle, max_angle, min_torque, max_torque]);

    set(gca, 'xtick', min_angle : 30 : max_angle);
    set(gca, 'FontName', 'Euclid', 'FontSize', 12);
    xlabel('$\varphi, \rm deg$', 'Interpreter', 'latex', 'FontSize', 12);
    ylabel(['$', labelname, ', \rm \: N \cdot m$'], 'Interpreter', 'latex', 'FontSize', 12);

    if ~exist('../../graphs', 'dir')
        mkdir('../../graphs');
    end

    saveas(gcf, ['../../graphs/', filename, '.emf']);
end
