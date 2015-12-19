% Import each image and convert to 2D image
I_1002 = imread('1002.jpg');
info1002 = imfinfo('1002.jpg');
img2d_1002 = rgb2gray(I_1002);
I_1006 = imread('1006.jpg');
info1006 = imfinfo('1006.jpg');
img2d_1006 = rgb2gray(I_1006);
I_1010 = imread('1005.jpg');
info1010 = imfinfo('1005.jpg');
img2d_1010 = rgb2gray(I_1010);
input = imread('Rochelle.jpg');
info_input = imfinfo('Rochelle.jpg');
img2d_input = rgb2gray(input);

%Resize and adjust image
width = 210;
images = {img2d_1002,img2d_1006,img2d_1010,img2d_input};

for k = 1:4
    dim = size(images{k});
    images{k} = imresize(images{k},[width*dim(1)/dim(2) width],'bicubic');
end

resize_1002 = images{1};
resize_1006 = images{2};
resize_1010 = images{3};
resize_input = images{4};

adjust_1002 = imadjust(resize_1002);
adjust_1006 = imadjust(resize_1006);
adjust_1010 = imadjust(resize_1010);
adjust_input = imadjust(resize_input);

%Thin the lines in the fingerprint
thin = {adjust_1002,adjust_1006,adjust_1010,adjust_input};

for i = 1:4
    thin{i} = bwmorph(thin{i}, 'clean');
end

thin_1002 = thin{1};
thin_1006 = thin{2};
thin_1010 = thin{3};
thin_input = thin{4};

%Edge Detection
detect = {thin_1002,thin_1006,thin_1010,thin_input};

for j = 1:4
    detect{j} = edge(detect{j},'prewitt');
end

edge_1002 = detect{1};
edge_1006 = detect{2};
edge_1010 = detect{3};
edge_input = detect{4};

figure(1)
subplot(221)
%autocorrelation of input(unknown fingerprint)
autocorr = xcorr2(double(edge_input));
mesh(autocorr);
title('Autocorrelation of Unknown Fingerprint');
xlabel('Pixels');
ylabel('Pixels');
zlabel('Pixel Intensity');
grid on
subplot(222)
%cross-correlation of input with image 1002
input_img1002 = xcorr2(double(edge_input),(double(edge_1002)));
mesh(input_img1002);
title('Cross-correlation of Unknown with Fingerprint 1002');
xlabel('Pixels');
ylabel('Pixels');
zlabel('Pixel Intensity');
grid on
subplot(223)
%cross-correlation of input with image 1006
input_img1006 = xcorr2(double(edge_input),(double(edge_1006)));
mesh(input_img1006);
title('Cross-correlation of Unknown with Fingerprint 1006');
xlabel('Pixels');
ylabel('Pixels');
zlabel('Pixel Intensity');
grid on
subplot(224)
%cross-correlation of input with image 1005
input_img1005 = xcorr2(double(edge_input),(double(edge_1010)));
mesh(input_img1005);
title('Cross-correlation of Unknown with Fingerprint 1005');
xlabel('Pixels');
ylabel('Pixels');
zlabel('Pixel Intensity');
grid on

%Slice taken of Mesh graph
figure(2)
subplot(221)
plot(autocorr(243,:));
title('Slice Autocorrelation of Unknown Fingerprint');
xlabel('Pixels');
ylabel('Pixel Intensity');
grid on
subplot(222)
plot(input_img1002(233,:));
title('Slice Cross-correlation of Unknown with Fingerprint 1002');
xlabel('Pixels');
ylabel('Pixel Intensity');
grid on
subplot(223)
plot(input_img1006(251,:));
title('Slice Cross-correlation of Unknown with Fingerprint 1006');
xlabel('Pixels');
ylabel('Pixel Intensity');
grid on
subplot(224)
plot(input_img1005(273,:));
title('Slice Cross-correlation of Unknown with Fingerprint 1005');
xlabel('Pixels');
ylabel('Pixel Intensity');
grid on

%Difference taken between Autocorrelation and each Cross-correlation graph
figure(3)
diff_1 = input_img1002(233,:) - autocorr(243,:);
subplot(221)
plot(diff_1002);
title({'Difference Between Cross-correlation of','Unknown with Fingerprint 1002 and Autocorrelation'});
xlabel('Pixels');
ylabel('Pixel Intensity');
grid on
diff_2 = input_img1006(251,:) - autocorr(243,:);
subplot(222)
plot(diff_1006);
title({'Difference Between Cross-correlation of','Unknown with Fingerprint 1006 and Autocorrelation'});
xlabel('Pixels');
ylabel('Pixel Intensity');
grid on
diff_3 = input_img1005(273,:) - autocorr(243,:);
subplot(223)
plot(diff_1005);
title({'Difference Between Cross-correlation of','Unknown with Fingerprint 1005 and Autocorrelation'});
xlabel('Pixels');
ylabel('Pixel Intensity');
grid on

%Square each element in each matrix
squared_1002 = diff_1002.^2;
squared_1006 = diff_1006.^2;
squared_1005 = diff_1005.^2;

%Sum all the elements in each matrix
sum_1002 = sum(squared_1002);
sum_1006 = sum(squared_1006);
sum_1005 = sum(squared_1005);

%Create matrix of sums and find the minimum sum
compare = [sum_1002,sum_1006,sum_1005];
[a,b] = min(compare);
match = b;

%Determine which sum is a match and output which fingerprint from database
%the input matches
if match == 1
    disp('Fingerprint matches 1002 from Database.')
end
if match == 2
    disp('Fingerprint matches 1006 from Database.')
end
if match == 3
    disp('Fingerprint matches 1005 from Database.')
end

