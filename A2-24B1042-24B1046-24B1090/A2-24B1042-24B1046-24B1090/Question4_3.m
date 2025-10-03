% Read the image T1 imread
% and type cast them as a double array
im_1 = double(imread('T1.jpg'));

% I_2 = 255*(I_1)^2 / (max(I_1)^2 + 1)
im_2 = ((im_1.^2).*255)./(max(im_1(:))^2 + 1);

correlation_coeff = zeros(21, 1);
tx_values = -10:10; 
QMI = zeros(21, 1);
MI = zeros(21, 1);

% Shift the second image by t_x pixels [-10, 10]
for t_x = -10:10
    % Assign 0 to unoccupied pixels using FillValues
    shifted_im_2 = imtranslate(im_2, [t_x, 0],'FillValues', 0);
    % Calculating dependies
    %%% Correlation coefficient
    corr = corr2(im_1, shifted_im_2);
    correlation_coeff(t_x + 11) = corr;
    %%% QMI

    %%%% JOINT PDF
    %%%%% Creating the histrgam
    %%%%% Since bin size is 10 we need 26 bins for each pixel interval
    normalised_hist = zeros(26, 26);
    [height, width] = size(im_1);
    count = 0;
    for h = 1:height
        for w = 1:width
            pix_1 = im_1(h, w);
            pix_2 = shifted_im_2(h, w);
            if(pix_2 == 0) 
                continue;
            else
                normalised_hist(floor(pix_1/10) + 1, floor(pix_2/10) + 1) = normalised_hist(floor(pix_1/10) + 1, floor(pix_2/10) + 1) + 1;
                count = count + 1;
            end
        end
    end
    %%%%%% Now normalise it
    normalised_hist = normalised_hist / count;

    %%%% MARGINAL PDF
    pdf_1 = sum(normalised_hist, 2);
    pdf_2 = sum(normalised_hist, 1);

    pdf_1_2 = pdf_1 * pdf_2;
    square_term = (normalised_hist - pdf_1_2).^2;
    qmi = sum(square_term(:));
    QMI(t_x + 11) = qmi;
    %%% MI
    frac = normalised_hist ./ pdf_1_2;
    frac(isnan(frac)) = 0; % Handle division by zero
    frac(frac == 0) = 1;
    mi = sum(sum(normalised_hist .* log(frac)));
    MI(t_x + 11) = mi;
end

% Display the plots
sgtitle('Analysis when the second image is func');
subplot(3,1,1);
plot(tx_values, correlation_coeff, '-o', 'LineWidth', 1.5, 'MarkerSize', 6);
title('Correlation Coefficient');
xlabel('t_x');
ylabel('Correlation Coefficient');

subplot(3,1,2);
plot(tx_values, QMI, '-s', 'LineWidth', 1.5, 'MarkerSize', 6);
title('Quadratic Mutual Information (QMI)');
xlabel('t_x');
ylabel('QMI');

subplot(3,1,3);
plot(tx_values, MI, '-^', 'LineWidth', 1.5, 'MarkerSize', 6);
title('Mutual Information (MI)');
xlabel('t_x');
ylabel('MI');