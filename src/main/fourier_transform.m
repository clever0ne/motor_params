function [magnitude, phase] = fourier_transform(x)
    len = length(x) - 1;
    y = fft(x, len) / len;
    y(2 : end) = 2 * y(2 : end);

    magnitude = abs(y(1 : len / 2));
    phase = angle(y(1 : len / 2));
end