function [TFDh] = filtru_laplace(m, n, w)
    [m1, n1] = size(w);
    h = zeros(m, n);
    l1 = uint16(m/2); c1 = uint16(n/2);
    for i = -(m1-1)/2:(m1-1)/2
        for j = -(n1-1)/2:(n1-1)/2
            h(l1+i, c1+j) = w(i+(m1-1)/2+1, j+(n1-1)/2+1);
        end
    end
    TFDh = fft2(h);
end
