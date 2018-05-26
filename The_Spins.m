%Leif Wesche
%Big Sun Come Strong 2D

clear all
close all
clc



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Inputs %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M0=800;                         %Obrital Mass
x0=0; y0=0; z0=0;               %Mass Fixed Location
Particles=7000;                 %Number of Particles
dt=1/30;                        %Time step (sec)
run_time=237;                   %Run Time (sec)
D=3;                            %Dimesions (2 or 3)
Tv0=113;                        %Time to switch to 3D view (sec)
Tvf=188;                        %Time to switch to 2D view (sec)

%Backgrond 
t0=8;                           %Fade Cycle Time
s=15;                           %Number of Background Points
trgb=8;                         %Color Change Speed
bi=0.65;                         %Background Point Brightness (3D)

%Audio
Song='Flying Lotus - 10 - Do the Astral Plane.mp3'; %Enter Audio
s0=9; %Signal Strength


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Setup %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Process Audio 
[song, Fs] = audioread(Song);
ts=1/Fs;
tf=run_time;
[song, Fs] = audioread(Song, [ts*Fs, tf*Fs]);
r=Fs*dt;
signal=song(1:2:end,1);

a=[];
for i=r/2+1:r/2:length(signal)-r/2-1
    a=[a, abs(fft(signal((i-r/2):(i+r/2))))];
end

A=[0];
for i=1:(tf-ts)*30-1
    temp=(a(:,i));
    A=[A, max(temp)];
    scl=smooth(A, 'moving');
    scl=scl/max(scl);
end
scl=s0*scl;
disp('Audio Processed')

%Set Center Position/Mass
if D==2
    z0=[];
end
x0=[x0; y0; z0]; 

M=M0;

%Generate Particle initial positions and speeds
xi=[]; vi=[];

xi=[randi([20,20], [2, Particles/2])+rand([2, Particles/2])/4, randi([20,20], [2, Particles/2])+rand([2, Particles/2])/4];
vi=[randi([5,15], [1, Particles/2])+rand([1, Particles/2]), randi([-15,-5], [1, Particles/2])-rand([1, Particles/2])];
if D==3;
    xi(3,:)=length(Particles);
end

%Shuffle Position/Velocity Vectore
ind=randperm(length(vi)); V=[]; x=[];
for i=ind
    x=[x, xi(:,i)];
    V=[V,vi(i)];
end


%Calculate Initial Velocities In Cartesian Coords.
for n=1:Particles
    for d=[1:D]
        r(d,:)=[x(d,n)-x0(d)];
    end
    if D==2
        v(:,n)=V(n)*[r(2), -r(1)]/norm(r);
    end
    if D==3
        v(:,n)=V(n)*[r(2), -r(1), 0]/norm(r);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Iterate %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time=0:dt:run_time-d*dt;
%fig=figure('Position', [100, 25, 826, 786], 'color', [0, 0, 0]); F=[];
fig=figure('Position', [800, 0, 1080, 1080], 'color', [0, 0, 0]); Fa=[]; Fb=[]; Fc=[]; Fd=[]; Fe=[]; Ff=[];
%3D Animation
if D==3
    
    ind=randi([1, 80], 3, s)-40;
    ind(4,:)=1:length(ind);
    
    for t=time
        
        for i=1:length(ind)
        C(i)=(0.4*cos(t/(t0/2)*pi+ind(4,i))+0.6);
        if C(i) < 0.205
            C(i)=0;
            ind(1:end-1,i)=randi([1, 80], 3, 1)-40;
        end
        end
        
        %Let Particles go after 
        if round(t,3) >= (213.8)
            M=0;
        end
        
        [x, v] = BSCS_Dynamics(x, v, dt, M, x0);

        
        for i=1:length(ind)
            plot3(ind(1,i), ind(2,i), ind(3,i), 'd', 'linewidth', 1+scl(round((2*dt+t)/dt)), 'MarkerFaceColor', [bi*abs(sin(t/trgb)), 0, bi*abs(cos(t/trgb))].*(C(i)).^2, 'MarkerEdgeColor', [bi*abs(sin(t/trgb)), 0, bi*abs(cos(t/trgb))].*(C(i)).^2); hold on
        end
        plot3(x0(1), x0(2), x0(3), 'o', 'linewidth', 7*800/M0+scl(round((2*dt+t)/dt)), 'Color', [abs(sin(t/trgb)), 0, abs(cos(t/trgb))]); hold on
        plot3(x(1,:), x(2,:), x(3,:), 'o', 'linewidth', 1.5, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [abs(sin(t/trgb)), 0, abs(cos(t/trgb))]); hold on
        set(gca, 'Color', [0, 0, 0])
        axis([-40, 40, -40, 40, -40, 40]); axis off
        %xlabel('x','color', 'w');    ylabel('y','color', 'w');    zlabel('z','color', 'w');
        if (t < Tv0) || (t > Tvf)
            view(0,90)
        else
            view(-90+90*cos((t-Tv0)/6), 90*cos((t-Tv0)/6))
        end
        pause(dt)
        hold off
        
        if (round(t,3)<=40)
            Fa=[Fa, getframe(fig)];
        end
        if round(t,3)==40
        disp('Frames A Generated')
        vid=VideoWriter('BSCS_Test9a.avi','Uncompressed AVI');
        open(vid)
        writeVideo(vid,Fa)
        close(vid)
        disp('Video A Created')
        clear Fa
        clear vid
        end
        
        if (round(t,3)>40) && (round(t,3)<=80)
            Fb=[Fb, getframe(fig)];
        end
        if round(t,3)==80
        disp('Frames B Generated')
        vid=VideoWriter('BSCS_Test9b.avi','Uncompressed AVI');
        open(vid)
        writeVideo(vid,Fb)
        close(vid)
        disp('Video B Created')
        clear Fb
        clear vid
        end
        
        if (round(t,3)>80) && (round(t,3)<=120)
            Fc=[Fc, getframe(fig)];
        end
        if round(t,3)==120
        disp('Frames C Generated')
        vid=VideoWriter('BSCS_Test9c.avi','Uncompressed AVI');
        open(vid)
        writeVideo(vid,Fc)
        close(vid)
        disp('Video C Created')
        clear Fc
        clear vid
        end
        
        if (round(t,3)>120) && (round(t,3)<=160)
            Fd=[Fd, getframe(fig)];
        end
        if round(t,3)==160
        disp('Frames D Generated')
        vid=VideoWriter('BSCS_Test9d.avi','Uncompressed AVI');
        open(vid)
        writeVideo(vid,Fd)
        close(vid)
        disp('Video D Created')
        clear Fd
        clear vid
        end
        
        if (round(t,3)>160) && (round(t,3)<=200)
            Fe=[Fe, getframe(fig)];
        end
        if round(t,3)==200
        disp('Frames E Generated')
        vid=VideoWriter('BSCS_Test9e.avi','Uncompressed AVI');
        open(vid)
        writeVideo(vid,Fe)
        close(vid)
        disp('Video E Created')
        clear Fe
        clear vid
        end
        
        if (round(t,3)>200) && (round(t,3)<=240)
            Ff=[Ff, getframe(fig)];
        end
    end
    
    disp('Frames F Generated')
    
    vid=VideoWriter('BSCS_Test9f.avi','Uncompressed AVI');
    open(vid)
    writeVideo(vid,Ff)
    close(vid)
    disp('Video F Created')
    
end






%% View Audio Signal
clear all
close all
clc



[song, Fs] = audioread('Flying Lotus - 10 - Do the Astral Plane.mp3');
ts=1/Fs+70;
tf=90;
[song, Fs] = audioread('Flying Lotus - 10 - Do the Astral Plane.mp3', [ts*Fs, tf*Fs]);



r=Fs/30; %30 FPS

signal=song(1:2:end,1);

a=[];
for i=r/2+1:r/2:length(signal)-r/2-1
    a=[a, abs(fft(signal((i-r/2):(i+r/2))))];
end

A=[0];
freq=[];
for i=1:(tf-ts)*30-1
    temp=(a(:,i));
    freq=[freq, temp];
    A=[A, max(temp)];
    scl=smooth(A, 'moving');
    scl=scl/max(scl);
end


figure
sound(song, Fs);
[sx, sy, sz]=sphere(15);
for i=1:(tf-ts)*30-1
    

    subplot(4,1,1)
    plot(freq(:,i))
    axis([0,1500,0,1000])
    
    if i<100
        subplot(4,1,2)
        plot(A(1:i), 'r', 'linewidth', 2)
        axis([0,120,0,1000])
    end
    if i>100
        subplot(4,1,2)
        plot(A(i-99:i), 'r', 'linewidth', 2)
        axis([0,120,0,1000])
    end
    

    

    scl=smooth(A, 'moving');
    scl=scl/max(scl);
        if i<100
        subplot(4,1,3)
        plot(scl(1:i), 'g', 'linewidth', 2)
        axis([0,120,0,1.1])
        end
    if i>100
        subplot(4,1,3)
        plot(scl(i-99:i), 'g', 'linewidth', 2)
        axis([0,120,0,1.1])
    end
    
    
    
    
    pause(1/90)
end



