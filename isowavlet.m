%% set up simulated data
fs = 2; %2 samples per cm
t = 1:1/fs:40;
nt = length(t);

% signal
period = 10; %cm
y = cos(2*pi*t / period) + 7;
ynoise = y + 2*rand(1, length(y));
plot(y);

%% wavlet without noise
scales = 1:1:32;
wname = 'morl';
sca = scal2frq(scales, wname, 1/fs);

coefs = cwt(y, scales, wname);
s = abs(coefs.*coefs);

imagesc(t, [], s);

mm = max(s);

finds = nan(1, length(mm));
for i=1:length(mm)
    finds(i) = find(s(:,i) == mm(i));
end

ff = sca(finds);

figure;
subplot 311;
imagesc(t, [], s);
colormap gray;
ylabel('scales');
subplot 312;
plot(t, ff, 'k');
ylabel('frequency at max (cm^{-1})');
yl = ylim;
hold on;
% plot(t, repmat(.1, 1, length(t)), 'g--');
hold off;
axis([min(t) max(t) yl]);
subplot 313;
plot(t, y, 'Color', [0 .75 .75]);
xlabel('length (cm)');
ylabel('simulated \delta^{15}N (‰)');
axis([min(t) max(t) ylim]);


%% wavlet with some noise

scales = 1:1:32;
wname = 'morl';
sca = scal2frq(scales, wname, 1/fs);

coefs = cwt(ynoise, scales, wname);
s = abs(coefs.*coefs);

imagesc(1:length(y), [], s);

mm = max(s);
med = median(s);

finds = nan(1, length(mm));
finds_med = nan(1, length(med));
for i=1:length(mm)
    finds(i) = find(s(:,i) == mm(i));
    tmpfind = find(abs(s(:,i) - med(i)) == min(abs(s(:,i) - med(i)))); 
    finds_med(i) = tmpfind(1);
end

ff = sca(finds);
ff_med = sca(finds_med);

figure;
subplot 311;
imagesc(t, [], s);
colormap gray;
ylabel('scales');
subplot 312;
plot(t, ff, 'k');
ylabel('frequency at max (cm^{-1})');
yl = ylim;
hold on;
plot(t, repmat(.1, 1, length(t)), 'g--');
hold off;
axis([min(t) max(t) yl]);
subplot 313;
plot(t, ynoise, 'Color', [0 .75 .75]);
xlabel('length (cm)');
ylabel('simulated \delta^{15}N (‰)');
axis([min(t) max(t) ylim]);