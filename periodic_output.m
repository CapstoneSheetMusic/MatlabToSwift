%Make the function in a different file
function sout = periodic_output(b,a,s)
 N = size(s,2);
 S = fft(s,N);  %compute FFT of one input period
 H = freqz(b,a,2*pi.*(0:N-1)./N);%evaluate filter at DFT frequencies:
 SOUT = H.*S;%element-wise multiplication:
 sout = ifft(SOUT,N);%compute inverse FFT
end