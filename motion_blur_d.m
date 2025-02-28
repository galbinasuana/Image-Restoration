function [TFDh] = motion_blur_d(m, n, iT)
    TFDh = zeros(m, n);
    for x = 1:m
        for y = 2:n
            TFDh(x, y) = (1/iT) * (sin(pi*((y-1)*iT/n)) / sin(pi*((y-1)/n))) * exp(-1i*pi*(y-1)*(iT-1)/n);
        end
        TFDh(x, 1) = 1;
    end
end
