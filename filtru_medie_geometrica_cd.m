% incarcare pachet de statistici
pkg load statistics;

% incarcare imagine originala
imagine_originala = imread('lighthouse.jpg');
[m, n] = size(imagine_originala);
img = double(imagine_originala);

% citirea parametrilor de la tastatura
iT = input('Introduceti intensitatea efectului de miscare (iT): ');
sigma = input('Introduceti intensitatea zgomotului (sigma): ');
alpha = input('Introduceti valoarea pentru alpha: ');

% validare valoare alpha
while (alpha < 0 || alpha > 1)
    fprintf('Valoarea pentru alpha trebuie sa fie intre 0 si 1.\n');
    alpha = input('Introduceti o valoare valida pentru alpha: ');
end

% aplicarea efectului de miscare si zgomot
TFD_img = fft2(img);
TFDh = motion_blur_d(m, n, iT);
TFDg = TFDh .* TFD_img;
img_motion_blur = real(ifft2(TFDg));
zgomot = normrnd(0, sigma, m, n);
img_perturbata = img_motion_blur + zgomot;

% calcul filtrul invers si filtrul Wiener
gam = 0.1;
eps = 0.001;

% filtrul laplace in frecvente
w = load('laplace.txt');
TFDl = filtru_laplace(m, n, w);

% aplicare filtrul medie geometrica
H_geometric = zeros(m, n);
for x = 1:m
    for y = 1:n
        if (abs(TFDh(x, y))^2 + gam * (abs(TFDl(x, y))^2) > eps)
            val_w = (TFDh(x, y))' / (abs(TFDh(x, y))^2 + gam * (abs(TFDl(x, y)))^2);
        else
            val_w = 1;
        end
        if abs(TFDh(x, y)) > eps
            val_i = 1 / abs(TFDh(x, y));
        else
            val_i = 1;
        end
        H_geometric(x, y) = TFDg(x, y).*val_w^(1-alpha).*val_i^alpha;
    end
end

% imagine restaurata
img_restaurata = real(ifft2(H_geometric));


figure;
subplot(1, 3, 1);
imshow(imagine_originala);
title('Imaginea originala');
subplot(1, 3, 2);
imshow(uint8(img_perturbata));
title(sprintf('Imaginea perturbata\nmiscare: iT = %d, zgomot: sigma = %d', iT, sigma));
imwrite(uint8(img_perturbata), 'imagine_perturbata.jpg');
subplot(1, 3, 3);
imshow(uint8(img_restaurata));
title(sprintf('Imaginea restaurata\nalpha: %.2f', alpha));
imwrite(uint8(img_restaurata), 'imagine_restaurata.jpg');


% calcul SNR
SNR_o_p = SNR('lighthouse.jpg', 'imagine_perturbata.jpg');
disp(['SNR imagine perturbata versus imagine originala  ' num2str(SNR_o_p)]);
SNR_o_r = SNR('lighthouse.jpg', 'imagine_restaurata.jpg');
disp(['SNR imagine restaurata versus imagine originala  ' num2str(SNR_o_r)]);

% calcul RMI
RMI_o_p = RMI('lighthouse.jpg', 'imagine_perturbata.jpg');
disp(['RMI imagine perturbata versus imagine originala  ' num2str(RMI_o_p)]);
RMI_o_r = RMI('lighthouse.jpg', 'imagine_restaurata.jpg');
disp(['RMI imagine restaurata versus imagine originala  ' num2str(RMI_o_r)]);
