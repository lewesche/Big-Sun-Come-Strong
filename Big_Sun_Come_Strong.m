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
Particles=1000;                 %Number of Particles
dt=1/30;                      %Time step (sec)
run_time=80;                   %Run Time (sec)
D=3;                            %Dimesions (2 or 3)
Tv=10;                          %Time to switch to 3D view (sec)


%Backgrond 
t0=8;                           %Fade Cycle Time
s=15;                           %Number of Background Points
trgb=8;                         %Color Change Speed
bi=0.65;                         %Background Point Brightness (3D)

%Audio
Song='09 Coronus, The Terminator.mp3';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Setup %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

A=[];
for i=1:(tf-ts)*30-1
    temp=(a(:,i));
    temp=max(temp);
    A=[A, temp];
end






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

%Background Color Map 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Iterate %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time=0:dt:run_time-d*dt;
fig=figure('Position', [100, 25, 826, 786], 'color', [0, 0, 0]); F=[];

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
        
        [x, v] = BSCS_Dynamics(x, v, dt, M, x0);

        %Calculate Object Scale based on Audio
        scl=(2*A(round((dt+t)/dt))/500)^2;
        
        for i=1:length(ind)
            plot3(ind(1,i), ind(2,i), ind(3,i), 'd', 'linewidth', 1+scl, 'MarkerFaceColor', [bi*abs(sin(t/trgb)), 0, bi*abs(cos(t/trgb))].*(C(i)).^2, 'MarkerEdgeColor', [bi*abs(sin(t/trgb)), 0, bi*abs(cos(t/trgb))].*(C(i)).^2); hold on
        end
        plot3(x0(1), x0(2), x0(3), 'o', 'linewidth', 7*M/M0+1.5*scl, 'Color', [abs(sin(t/trgb)), 0, abs(cos(t/trgb))]); hold on
        plot3(x(1,:), x(2,:), x(3,:), 'o', 'linewidth', 1, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [abs(sin(t/trgb)), 0, abs(cos(t/trgb))]); hold on
        set(gca, 'Color', [0, 0, 0])
        axis([-40, 40, -40, 40, -40, 40]); axis off
        %xlabel('x','color', 'w');    ylabel('y','color', 'w');    zlabel('z','color', 'w');
        if t < Tv
            view(0,90)
        else
            view(-90+90*cos((t-Tv)/6), 90*cos((t-Tv)/6))
        end
        pause(dt)
        hold off
        %F=[F, getframe(fig,[0, 0, 780 780])];
        F=[F, getframe(fig)];
    end

    v=VideoWriter('BSCS_Test3.avi','Uncompressed AVI');
    v.FrameRate = 30;
    %v.Quality = 100;
    open(v)
    writeVideo(v,F)
    close(v)

end






%% View Audio Signal
clear all
close all
clc



[song, Fs] = audioread('09 Coronus, The Terminator.mp3');
ts=1/Fs+110;
tf=130;
[song, Fs] = audioread('09 Coronus, The Terminator.mp3', [ts*Fs, tf*Fs]);



r=Fs/30; %30 FPS

signal=song(1:2:end,1);

a=[];
for i=r/2+1:r/2:length(signal)-r/2-1
    a=[a, abs(fft(signal((i-r/2):(i+r/2))))];
end

A=[]; scl=0;
figure
sound(song, Fs);
[sx, sy, sz]=sphere(15);
for i=1:(tf-ts)*30-1
    
    temp=(a(:,i));
    subplot(3,1,1)
    plot(temp)
    axis([0,1500,0,1000])
    
    %temp(temp<3)=0;
    temp=max(temp);
    A=[A, temp];
    if i<100
        subplot(3,1,2)
        plot(A, 'r', 'linewidth', 2)
        axis([0,120,0,1000])
    end
    if i>100
        subplot(3,1,2)
        plot(A(end-100:end), 'r', 'linewidth', 2)
        axis([0,120,0,1000])
    end
    
    
    scl=(scl+(0.1*A(end)/500).^2)*(exp(-scl))^(0.01);
    exp(-scl)
    
    subplot(3,1,3)
%     plot(0, 'ro', 'MarkerFaceColor', 'r', 'linewidth', 2+scl)
    s=surf(scl*sx, scl*sy, scl*sz); camlight; lighting phong; s.EdgeColor = 'none'; grid off
    axis([-1, 1, -1, 1, -1, 1])
    title(num2str(round(i/30)))
    
    pause(1/90)
end



