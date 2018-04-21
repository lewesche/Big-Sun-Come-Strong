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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Iterate %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time=0:dt:run_time;
fig=figure('Position', [100, 50, 800, 720], 'color', [0.1, 0.1, 0.1]);
%2D Animation
if D==2
    for t=time
        [x, v] = BSCS_Dynamics(x, v, dt, M, x0);
    
        plot(x0(1), x0(2), 'wo', 'linewidth', 6*M/M0); hold on
        plot(x(1,:), x(2,:), 'o', 'linewidth', 1, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0.9, 0, 0]); hold on
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
