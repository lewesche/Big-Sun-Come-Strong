%Leif Wesche
%Big Sun Come Strong 2D

clear all
close all
clc

M0=800;
x0=0; y0=0; z0=0;
Particles=5000;
dt=0.0333;
run_time=240;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xi=[randi([20,20], [3, Particles/2])+rand([3, Particles/2])/4, randi([20,20], [3, Particles/2])+rand([3, Particles/2])/4];
vi=[randi([5,15], [1, Particles/2])+rand([1, Particles/2]), randi([-15,-5], [1, Particles/2])-rand([1, Particles/2])];
D=size(xi); D=D(1);

%Shuffle vectors - Not Working
ind=randperm(length(vi));
for i=ind
    x(1,i)=xi(1,i);
    x(2,i)=xi(2,i);
    x(3,i)=xi(3,i);
    V(i)=vi(i);
end

x0=[x0; y0; z0];
%Calculate Initial Velocities In Cartesian Coords.
for n=1:Particles
    for d=[1:D]
        r(d,:)=[x(d,n)-x0(d)];
    end
    if D==2
        r(3)=[];
    end
    v(:,n)=V(n)*[r(2), -r(1), r(3)]/norm(r);
end

M=M0;

time=0:dt:run_time;
fig=figure('Position', [100, 50, 800, 720], 'color', [0.1, 0.1, 0.1]);
for t=time
    
    %M=M0+0.25*M0*sin(t)
    
    [x, v] = BSCS_Dynamics(x, v, dt, M, x0);
    
%     plot(x0(1), x0(2), 'wo', 'linewidth', 6*M/M0); hold on
%     plot(x(1,:), x(2,:), 'o', 'linewidth', 1, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0.9, 0, 0]); hold on
%     set(gca, 'Color', [0.1, 0.1, 0.1])
%     axis([-40, 40, -40, 40]); axis off
%     pause(dt) 
%     hold off

    plot3(x0(1), x0(2), x0(3), 'wo', 'linewidth', 6*M/M0); hold on
    plot3(x(1,:), x(2,:), x(3,:), 'o', 'linewidth', 1, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0.9, 0, 0]); hold on
    set(gca, 'Color', [0.1, 0.1, 0.1])
    axis([-40, 40, -40, 40, -40, 40]); %axis off
    
    pause(dt)
    hold off
end
