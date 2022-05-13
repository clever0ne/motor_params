function [angle, torque] = load_data(filepath)
    tab = importdata(filepath);
    angle = tab.data(:, 2)';
    torque = tab.data(:, 3)';
end
