function print_efficiency_coefficients(kgamma, dm, kf, kt, sigma, filename)
    if (nargin < 6)
        filename = 'result';
    end

    if ~exist('../../result', 'dir')
        mkdir('../../result');
    end

    id = fopen(['../../result/', filename, '.txt'], 'w');

    fprintf(id, 'k_gamma = %10.4f\n', kgamma);
    fprintf(id, 'DeltaM  = %10.4f\n', dm);
    fprintf(id, 'k_F     = %10.4f mA^2/W\n', kf / 1000000);
    fprintf(id, 'k_T     = %10.4f N*m/W\n', kt);
    fprintf(id, 'sigma   = %10.4f kPa\n', sigma / 1000);

    fclose(id);
end
