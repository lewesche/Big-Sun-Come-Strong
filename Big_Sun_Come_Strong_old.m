%Leif Wesche
%Big Sun Come Strong 2D

clear all
close all
clc

M0=800;
x0=0; y0=0;

Particles=5000;

dt=0.0333;
run_time=240;

% xyi=randi([20,20], [2, Particles])+rand([2, Particles])/5;
% vi=randi([5,15], [1, Particles])+rand([1, Particles]);

xyi=[randi([20,20], [2, Particles/2])+rand([2, Particles/2])/4, randi([20,20], [2, Particles/2])+rand([2, Particles/2])/4];
vi=[randi([5,15], [1, Particles/2])+rand([1, Particles/2]), randi([-15,-5], [1, Particles/2])-rand([1, Particles/2])];


%Shuffle vectors - Not Working
ind=randperm(length(vi));
for i=ind
xy(1,i)=xyi(1,i);
xy(2,i)=xyi(2,i);
v(i)=vi(i);
end

%Calculate Initial Velocities In Cartesian Coords.
for n=1:Particles
r=[xy(1,n)-x0; xy(2,n)-y0];
vxy(:,n)=v(n)*[r(2), -r(1)]/norm(r);
end

M=M0;

time=0:dt:run_time;

fig=figure('Position', [100, 50, 800, 720], 'color', [0.1, 0.1, 0.1]);
for t=time
    
    %M=M0+0.25*M0*sin(t)
    
    for n=1:Particles
        r(:,n)=[xy(1,n)-x0; xy(2,n)-y0];
        a(:,n)=M/(norm(r(:,n))^2).*(-r(:,n));
    end
    for n=1:Particles
        if norm(r(:,n))<=0.25;
            a(:,n)=[0;0];
            %vxy(:,n)=real(vxy(:,n).^0.1);
        end
    end
    vxy=vxy+a.*dt;
    xy=xy+vxy.*dt;
    
    plot(x0, y0, 'wo', 'linewidth', 6*M/M0); hold on
    plot(xy(1,:), xy(2,:), 'o', 'linewidth', 1, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0.9, 0, 0]); hold on
    set(gca, 'Color', [0.1, 0.1, 0.1])
    axis([-40, 40, -40, 40]); axis off
    pause(dt) 
    hold off

end

%%
close all
clear all
clc

%for t=time
pos = [2 4 2 2]; 
r=rectangle('Position',[-5/2,-10/2,5,10],'FaceColor', [0.9, 0, 0] ,'EdgeColor','k', 'LineWidth',3)
axis equal
%end