function print_phase_switching_torque_plot(angle, torque, phases, filename)
    if (nargin < 3)
        phases = 3;
    end

    if (nargin < 4)
        filename = 'phase_switching_torque';
    end

    EPSILON = 0.001;
    min_angle = angle(1);
    max_angle = angle(end);
    min_torque = min(min(torque));
    max_torque = max(max(torque));

    delta_torque = 0.05 * (max_torque - min_torque);
    min_torque = min_torque - (delta_torque + EPSILON);
    max_torque = max_torque + (delta_torque + EPSILON);

    phase_angle = (max_angle - min_angle) / phases;

    smooth_angle{1} = min_angle : 1 : max_angle;
    smooth_angle{2} = min_angle : 1 : min_angle + phase_angle;
    smooth_angle{3} = max_angle - phase_angle : 1 : max_angle;

    smooth_torque = zeros(3, length(smooth_angle{1}));

    smooth_torque(1, :) = spline(angle, torque, smooth_angle{1});
    smooth_torque(2, 1 + smooth_angle{2}) = smooth_torque(1, 1 + smooth_angle{3});
    smooth_torque(3, 1 + smooth_angle{3}) = smooth_torque(1, 1 + smooth_angle{2});

    figure();
    options = {'r--', 'g--', 'b--'};
    for idx = 1 : length(options)
        plot(smooth_angle{1}, smooth_torque(idx, :), options{idx});
        hold on;
    end

    plot(smooth_angle{1}, max(smooth_torque), 'r-');

    hold off;
    grid on;
    axis([min_angle, max_angle, min_torque, max_torque]);

    set(gca, 'xtick', min_angle : 30 : max_angle);
    set(gca, 'FontName', 'Euclid', 'FontSize', 12);
    xlabel('$\varphi, \rm deg$', 'Interpreter', 'latex', 'FontSize', 12);
    ylabel('$M, \rm \: N \cdot m$', 'Interpreter', 'latex', 'FontSize', 12);

    if ~exist('../../graphs', 'dir')
        mkdir('../../graphs');
    end

    saveas(gcf, ['../../graphs/', filename, '.emf']);
end
