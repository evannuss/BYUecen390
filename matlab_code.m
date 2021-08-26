clc, close all
f_players = [1471, 1724, 2000, 2273, 2632, 2941, 3333, 3571, 3846, 4167];
% Player center frequencies in Hz
H = [c;c;c;c;c;c;c;c;c;c]; % Comment out the H's when running for the first time
a = zeros(10,11);
b = a;
for i = 1:10
f_s = 10000; % sampling frequency (remember we have decimated)
BW = 50; % Full bandwidth of filters in Hz
f_lower = f_players(i) - BW/2; % Lower corner frequency of BPF
f_upper = f_players(i) + BW/2; % Upper corner frequency of BPF
[b(i,:), a(i,:)] = butter(5, [f_lower*2/f_s, f_upper*2/f_s]);
% IMPORTANT: ‘butter’ takes frequency specifications in half cycles/sample,
% not Hz, hence the division by f s and multiplication by 2
f_axis = linspace(1000, 4500, 2000); % create a freq axis from 1 to 4.5 kHz
c = freqz(b(i,:), a(i,:), f_axis, f_s); % calculates the freq response H1
% at the frequencies in f axis
H(i,:) = c;
end

save a.txt a -ascii -double
save b.txt b -ascii -double

%% Frequency Response of the filters
figure
f = 0:f_s/(1000):f_s/2;
for i = 1:10
H2 = freqz(b(i,:),a(i,:),f,f_s);
plot(f,abs(H2));
hold on
end
xlabel("frequency in Hz");
ylabel("transmission")
%% Frequency Response in dB
figure
for i = 1:10
H2 = freqz(b(i,:),a(i,:),f,f_s);
H_db = 20*log10(abs(H2));
plot(f,H_db);
hold on
end
axis([0 5000 -50 3]);
ylim([-100 0]);
xlabel("frequency(Hz)");
ylabel("transmission (dB)")

%% Computing energy
t = linspace(0, 0.2, 2000);  % The time vector with a length of 0.2 seconds and 2000 total samples
figure
for j = 1:10
x = square(2*pi*f_players(j)*t);     % Create the time domain square wave
for i = 1:10
y = filter (b(i,:),a(i,:),x);
end
w = [0 0 0 0 0 0 0 0 0 0];
for i = 1:10
    filt = filter(b(i,:),a(i,:),x);
    filt = abs(filt);
    filt = filt.^2;
    filt = sum(filt);
    w(i) = filt;
end
subplot(5,2,j);
bar(w);
xlabel("channel");
ylabel("energy");
end