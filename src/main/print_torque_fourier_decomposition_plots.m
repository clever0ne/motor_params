function print_torque_fourier_decomposition_plots(angle, torques, filename)
    if (nargin < 3)
        filename = 'torque';
    end

    MAX_ORDER = size(torques, 1) - 1;
    for order = 0 : MAX_ORDER
        torque = torques(order + 1, :);
        print_torque_plot(angle, torque, [filename, '_', num2str(order)], ['\hat{M}_{', num2str(order), '}']);
    end
end