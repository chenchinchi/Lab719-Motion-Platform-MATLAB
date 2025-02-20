clc;
clear;
close all;
warning off;
controller = plane_controller("COM3","COM4");

controller.home_x();
controller.home_y();
controller.home_z();

pause(15)
disp("測試x...");
r_x = controller.move_x_ABS(300,100);
disp(r_x);
disp("測試y...");
r_y = controller.move_y_ABS(300,100);
disp(r_y);
pause(5)
x = 100;
y = 100;
for i = 1:10 
        controller.move_x_INC(x,500);
        x = x*-1;
        controller.move_y_INC(y,500);
        y = y*-1;
        controller.move_z_ABS(100,50);
        controller.move_z_ABS(0,50);
end

controller.home_x();
controller.home_y();
controller.home_z();