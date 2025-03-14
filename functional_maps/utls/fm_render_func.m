function [image] = fm_render_func(Shape, func, Camera)
%
% Produce a rendered image of a 3D shape froma given camera configuration
% Input arguments:
%   Shape:  input mesh
%   Camera: camera configuration
% Ouput argument:
%   image:  the rendered image with specified image dimension

li = 0.75;

hFig = figure('visible', 'off');
set(hFig, 'Position', [1 1 Camera.nWidth Camera.nHeight]);
set(gcf,'Color',[1 1 1]);

func = (func - min(func))/(max(func) - min(func));

viewDis = norm(Camera.origin - Camera.lookAt);
view_angle = atan(Camera.scale/viewDis)*2;
view_angle = view_angle*180/pi;
trisurf(Shape.faceVIds',...
    Shape.vertexPoss(1,:),...
    Shape.vertexPoss(2,:),...
    Shape.vertexPoss(3,:),...
    func',...
    'AmbientStrength', 0.2,...
    'SpecularStrength', 0.5,...
    'EdgeColor', 'none','FaceLighting','flat');
hold on;
% 'FaceColor', [0.216, 0.494, 0.722],...

axis_z = Camera.origin - Camera.lookAt;
viewDis = norm(axis_z);
axis_z = axis_z/viewDis;
axis_y = Camera.upVec;
axis_x = cross(axis_y, axis_z);
lightPos = Camera.lookAt + axis_y*viewDis*0.6;
lightPos2 = Camera.origin + axis_x*viewDis*0.4;
lightPos3 = Camera.origin - axis_x*viewDis*0.4;

light('Color', ones(1,3)*li, 'Position', lightPos,'Style','infinite');
light('Color', ones(1,3)*li, 'Position', lightPos2,'Style','infinite');
light('Color', ones(1,3)*li, 'Position', lightPos3,'Style','infinite');

campos(Camera.origin);
camtarget(Camera.lookAt);
camproj('perspective');
camup(Camera.upVec);
camva(view_angle);
daspect([1,1,1]);
axis off;

F = getframe;
[image, map] = frame2im(F);
close(hFig);
