% MMI 502 Lab 7 - Seth Hochberg

%% Problem 1 - Import, make granular, recombine, export
[signal fs bitdepth] = wavread('trumpet.wav');
framesize = .05 * fs;
hopsize = round(.5 * framesize); 
numframes = floor((length(signal) - framesize + hopsize) / hopsize); 
framematrix = zeros(framesize,numframes);

%Decompose signal into frames
for currentframe = 1:hopsize:length(signal)-framesize
        thisframe = signal(currentframe:currentframe+framesize-1);
        framematrix(:,round(currentframe/hopsize)+1) = thisframe .* hanning(framesize);
        %plot(thisframe' .* hanning(framesize));
        %pause;
end

%% Reconstruct the signal in normal order, unmodified
newsignal = zeros(1, length(signal));
for currentframe = 1:numframes
        signalindex = (currentframe-1)*hopsize+1:(currentframe-1)*hopsize+framesize;
        newsignal(signalindex) = newsignal(signalindex) + framematrix(:,currentframe)';
end

figure;
subplot(211);
plot(signal');
title('Original');
subplot(212);
plot(newsignal);
title('Recomposed');

soundsc(newsignal, fs);
wavwrite(newsignal, fs, 'trumpted_recombined.wav');

%% Reconstructing the signal in the reverse order
newsignal = zeros(1, length(signal));
for currentframe = 1:numframes
        signalindex = (currentframe-1)*hopsize+1:(currentframe-1)*hopsize+framesize;
        newsignal(signalindex) = newsignal(signalindex) + framematrix(:,(numframes-currentframe)+1)';
end

figure;
subplot(211);
plot(signal);
title('Original');
subplot(212);
plot(newsignal);
title('Reversed');

soundsc(newsignal, fs);
wavwrite(newsignal, fs, 'trumpted_recombined_reversed.wav');

%% Reconstructing the signal in random grain order
newsignal = zeros(1, length(signal));
randframes = randperm(numframes);
for currentframe = 1:numframes
        signalindex = (currentframe-1)*hopsize+1:(currentframe-1)*hopsize+framesize;
        newsignal(signalindex) = newsignal(signalindex) + framematrix(:,randframes(currentframe))';
end

figure;
subplot(211);
plot(signal);
title('Original');


subplot(212);
plot(newsignal);
title('Random');

soundsc(newsignal, fs);
wavwrite(newsignal, fs, 'trumpted_recombined_randomized.wav');