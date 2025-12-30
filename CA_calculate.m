%Contact angle
clc
clear all
close all

W=100;%width
P=200;%period
H=500;%height

f_S=W^2/P^2;
f_L=1-f_S;
theta_Y=110;%unit，degree

CA=(acos((cos(theta_Y/180*3.1415)*f_S-f_L)))/3.1415*180;

