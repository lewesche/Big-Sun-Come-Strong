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
Particles=5000;                 %Number of Particles
dt=0.0333;                      %Time step 
run_time=240;                   %Run Time
D=2;                            %Dimesions (2 or 3)

%Backgrond
t0=5;                           %Fade Cycle Time
s=50;                           %Number of Background Points
trgb=10;                         %Color Change Speed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Setup %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Set Center Position/Mass
if D==2
    z0=[];
end
x0=[x0; y0; z0]; M=M0;

%Generate Particle initial positions and speeds
xi=[randi([20,20], [D, Particles/2])+rand([D, Particles/2])/4, randi([20,20], [D, Particles/2])+rand([D, Particles/2])/4];
vi=[randi([5,15], [1, Particles/2])+rand([1, Particles/2]), randi([-15,-5], [1, Particles/2])-rand([1, Particles/2])];

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
        v(:,n)=V(n)*[r(2), -r(1), r(3)]/norm(r);
    end
end

%Background Color Map
map=[];
for i=logspace(0, 1.5, 100)
    temp=[0.5, 0, 0.7]/i;
    map=[temp; map];
end
C=zeros(83, 83); 
[gridx, gridy]=meshgrid([-41:41], [-41:41]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Iterate %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time=0:dt:run_time;
fig=figure('Position', [100, 50, 800, 720], 'color', [0, 0, 0]);
%2D Animation
if D==2
    C=zeros([83, 83]); C(83,83)=1;
    ind=randi([1, 82], 2, s);
    ind(3,:)=1:length(ind);
    for t=time
        
        map=[];
        for i=logspace(0, 1.5, 100)
            temp=[abs(sin(t/trgb)), 0, abs(cos(t/trgb))]/i;
            map=[temp; map];
        end
        if round(mod(t,t0), 1) == 0
            tc=0;
        end
        tc=tc+dt;
        for i=1:length(ind)
            C(ind(1,i), ind(2,i))=(0.4*cos(tc/(t0/2)*pi+ind(3,i))+0.6);
            if C(ind(1,i), ind(2,i)) < 0.25
                C(ind(1,i), ind(2,i))=0;
                ind(1:end-1,i)=randi([1, 82], 2, 1);
            end
        end
        
        [x, v] = BSCS_Dynamics(x, v, dt, M, x0);
        
        pcolor(gridx, gridy, C); colormap(map); hold on
        plot(x0(1), x0(2), 'o', 'linewidth', 8*M/M0, 'Color', [abs(sin(t/trgb)), 0, abs(cos(t/trgb))]); hold on
        plot(x(1,:), x(2,:), 'o', 'linewidth', 1, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [abs(sin(t/trgb)), 0, abs(cos(t/trgb))]); hold on
        set(gca, 'Color', [0.1, 0.1, 0.1])
        axis([-40, 40, -40, 40]); axis off
        pause(dt) 
        hold off 
    end
end


%3D Animation
if D==3
    for t=time
        [x, v] = BSCS_Dynamics(x, v, dt, M, x0);

        plot3(x0(1), x0(2), x0(3), 'wo', 'linewidth', 6*M/M0); hold on
        plot3(x(1,:), x(2,:), x(3,:), 'o', 'linewidth', 1, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0.9, 0, 0]); hold on
        set(gca, 'Color', [0.1, 0.1, 0.1])
        axis([-40, 40, -40, 40, -40, 40]); %axis off
        view(-40*cos(t/12), 30*cos(t/12))
        pause(dt)
        hold off
    end
end


%%

clear all
close all
clc

figure
[gridx, gridy]=meshgrid([-41:41], [-41:41]);

dt=0.0333;
time=0:dt:20;
t0=1;
s=50

map=[];
for i=logspace(0, 1.5, 100)
    temp=[0.5, 0, 0.7]/i;
    map=[temp; map];
end

C=zeros([83, 83]); C(83,83)=1;
ind=randi([1, 83], 2, s);
ind(3,:)=1:length(ind)
for t=time
    if round(mod(t,t0), 1) == 0
        tc=0;
    end
    tc=tc+dt;
    for i=1:length(ind)
        C(ind(1,i), ind(2,i))=(0.4*cos(tc/(t0/2)*pi+ind(3,i))+0.6);
    end
    [tc, 0.25*cos(tc/(t0/2)*pi+pi)+0.75]
    pcolor(gridx, gridy, C); colormap(map); hold on
    pause(dt)
    hold off
end


%%
close all 
clear all
clc

map=[];
for i=1:100
    temp=[0.5, 0, 0.7]./i;
    map=[temp; map];
end
[gridx, gridy]=meshgrid([-41:41], [-41:41]);


C=zeros([83, 83]); C(83,83)=1;
ind=randi([1, 83], 2, 15);
for i=1:length(ind)
    C(ind(1,i), ind(2,i))=sin(t);
end
max(C)
figure
pcolor(gridx, gridy, C); colormap(map);
  


