% signal = randi([0,1],[1,5]);
signal = [1 0 1 0 1];
sig_polar =signal;
polar_NRZ = sig_polar;
polar_RZ = sig_polar;
ami = sig_polar;
sig_ami = signal;
sig_manch  = signal;
manch = sig_polar;
sig_inv = signal;
inv_NRZ = sig_polar;
sig_multi = signal;
multi = sig_polar;
%for polar signals map output to 1, -1 instead of 1, 0
for i= 1: length(signal)
    if signal(i) == 0
        sig_polar(i) = -1;
    else
        sig_polar(i) = 1;
    end
end
%for ami
flag = 0;
for i= 1: length(signal)
    if signal(i) == 0
        sig_ami(i) = 0;
    else
        if flag == 0 && signal(i)==1
            sig_ami(i) = 1;
            flag = 1;
        elseif flag ==1 && signal(i)==1
            sig_ami(i) = -1;
            flag = 0;
        end
    end
end

%for NRZ inverted
sig_inv(1)= 1; %awel mabda2 a5aleeha high
for i= 2: length(signal)
    if signal(i) == 0
        sig_inv(i) = sig_inv(i-1);
    else
        if sig_inv(i-1)==1
            sig_inv(i) = -1;
            
        elseif sig_inv(i-1)==-1
            sig_inv(i) = 1;
            
        end
    end
end

%for multi
sig_multi(1)= 1; %awel mabda2 a5aleeha high
for i= 2: length(signal)
    if signal(i) == 0
        sig_multi(i) = sig_multi(i-1);
    else
        if sig_multi(i-1)==1
            sig_multi(i) = 0;
            
        elseif sig_multi(i-1)==0
            sig_multi(i) = -1;
            
        elseif sig_multi(i-1)==-1
            sig_multi(i) = 1;
            
        end
    end
end

%polar nrz
i=1;
t = 0:0.01:length(signal);
for j = 1:length(t)
    
    if t(j)<=i
        polar_NRZ(j)= sig_polar(i);
        
    else
        polar_NRZ(j)= sig_polar(i);
        i=i+1;
    end
end

%polar RZ
k=1;
a = 0;
b = 0.5;
t = 0:0.01:length(signal);
for j = 1:length(t) %j goes from 1 to 501
    
    if t(j)>=a && t(j)<=b
        polar_RZ(j)= sig_polar(k);
        
    elseif t(j)>b && t(j)<=k
        polar_RZ(j)= 0;
    else
        a = a+1;
        b= b+1; 
        k= k+1;
    
    end
end


%ami
k=1;
a = 0;
b = 0.5;
t = 0:0.01:length(signal);
for j = 1:length(t) 
    
    if t(j)>=a && t(j)<=b
        ami(j)= sig_ami(k);
        
    elseif t(j)>b && t(j)<=k
        ami(j)= 0;
    else
        a = a+1;
        b= b+1; 
        k= k+1;
    
    end
end
%manchester
k=1;
a = 0;
b = 0.5;
t = 0:0.01:length(signal);
for j = 1:length(t) 
    
    if t(j)>=a && t(j)<=b
        manch(j)= sig_polar(k);
        
    elseif t(j)>b && t(j)<=k
        if sig_polar(k)== 1
        manch(j)= -1;
        elseif sig_polar(k)== -1
         manch(j)= 1;
         
        end
    else
        a = a+1;
        b= b+1; 
        k= k+1;
    
    end
end
%inverted
i=1;
t = 0:0.01:length(signal);
for j = 1:length(t)
    
    if t(j)<=i
        inv_NRZ(j)= sig_inv(i);
        
    else
        inv_NRZ(j)= sig_inv(i);
        i=i+1;
    end
end

%multi
i=1;
t = 0:0.01:length(signal);
for j = 1:length(t)
    
    if t(j)<=i
        multi(j)= sig_multi(i);
        
    else
        multi(j)= sig_multi(i);
        i=i+1;
    end
end
subplot(6,1,1)
plot(t,polar_RZ)
axis([0 length(signal) -3 3])
title('Subplot 1: Polar RZ')

subplot(6,1,2)
plot(t,polar_NRZ)
axis([0 length(signal) -3 3])
title('Subplot 2: Polar NRZ')

subplot(6,1,3)
plot(t,ami)
axis([0 length(signal) -3 3])
title('Subplot 3: AMI')

subplot(6,1,4)
plot(t,manch)
axis([0 length(signal) -3 3])
title('Subplot 4: Manchester')

subplot(6,1,5)
plot(t,inv_NRZ)
axis([0 length(signal) -3 3])
title('Subplot 5: Inverted')

subplot(6,1,6)
plot(t,multi)
axis([0 length(signal) -3 3])
title('Subplot 6: Multi-level transmission ')

%power
figure
dt = t(2)-t(1);
Fs  = 1/dt;
h = spectrum.welch;
p1 = psd(h,polar_RZ,'Fs', Fs);
subplot(6,1,1)
plot(p1)
p2 = psd(h,polar_NRZ,'Fs', Fs);
subplot(6,1,2)
plot(p2)
p3 = psd(h,ami,'Fs', Fs);
subplot(6,1,3)
plot(p3)
p4 = psd(h,manch,'Fs', Fs);
subplot(6,1,4)
plot(p4)
p5= psd(h,inv_NRZ,'Fs', Fs);
subplot(6,1,5)
plot(p5)
p6= psd(h,multi,'Fs', Fs);
subplot(6,1,6)
plot(p6)
