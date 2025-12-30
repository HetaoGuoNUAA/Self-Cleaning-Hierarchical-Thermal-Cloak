%Calculate the average emissivity
clc
clear all
close all

T_sample=200+273.15;
T_amb=293.15;%Unit£¬K


[data1]=xlsread('C:\Users\18329\Desktop\compare_result.xlsx');
data=zeros(length(data1),2);
data(:,1)=data1(:,1);%Wavelength
data(:,2)=data1(:,5);%Emissivity
if max(data(:,2))>2
    data(:,2)=data(:,2)/100;
end

t_atm(:,1)=data(:,1);%Wavelength
t_atm(:,2)=data1(:,3);%Atmospheric transmittance

c1=3.7414*10^8;
c2=1.43879*10^4;
PI=3.1415926;
theta=1:1:90;

E_emission3_5=0;
e_emission3_5=0;
E_emission5_8=0;
e_emission5_8=0;
E_emission8_14=0;
e_emission8_14=0;
E_emission3_5_8_14=0;
e_emission3_5_8_14=0;
E_emission3_14=0;
e_emission3_14=0;
ave3_5=0;
ave5_8=0;
ave8_14=0;
ave3_5_8_14=0;
ave3_14=0;



for i=2:length(data)
    wavelength=data(i,1);
    temperature=T_sample;
    emission=(c1/(wavelength^5))*(1/(exp(c2/wavelength/temperature)-1));
    if (wavelength>3 && wavelength<=5)
        E_emission3_5=E_emission3_5+PI*emission*(data(i,1)-data(i-1,1));
        e_emission3_5=e_emission3_5+PI*emission*data(i,2)*(data(i,1)-data(i-1,1));
    end
    if (wavelength>5 && wavelength<=8)
        E_emission5_8=E_emission5_8+PI*emission*(data(i,1)-data(i-1,1));
        e_emission5_8=e_emission5_8+PI*emission*data(i,2)*(data(i,1)-data(i-1,1));
    end
    if (wavelength>8 && wavelength<=14)
        E_emission8_14=E_emission8_14+PI*emission*(data(i,1)-data(i-1,1));
        e_emission8_14=e_emission8_14+PI*emission*data(i,2)*(data(i,1)-data(i-1,1));
    end
    if ((wavelength>3 && wavelength<=5)||(wavelength>8 && wavelength<=14))
        E_emission3_5_8_14=E_emission3_5_8_14+PI*emission*(data(i,1)-data(i-1,1));
        e_emission3_5_8_14=e_emission3_5_8_14+PI*emission*data(i,2)*(data(i,1)-data(i-1,1));
    end
    if (wavelength>3 && wavelength<=14)
        E_emission3_14=E_emission3_14+PI*emission*(data(i,1)-data(i-1,1));
        e_emission3_14=e_emission3_14+PI*emission*data(i,2)*(data(i,1)-data(i-1,1));
    end
end
ave3_5=e_emission3_5/E_emission3_5;
ave5_8=e_emission5_8/E_emission5_8;
ave8_14=e_emission8_14/E_emission8_14;
ave3_5_8_14=e_emission3_5_8_14/E_emission3_5_8_14;
ave3_14=e_emission3_14/E_emission3_14;




%Infrared stealth
P_rad3_5_8_14=0;
for i=2:length(data)
    wavelength=data(i,1);
    if ((wavelength>3 && wavelength<=5) || (wavelength>8 && wavelength<=14))
        temperature=T_sample;
        emission=(c1/(wavelength^5))*(1/(exp(c2/wavelength/temperature)-1));
        for j=1:length(theta)
            P_rad3_5_8_14=P_rad3_5_8_14+2*PI*sin(j/180*PI)*cos(j/180*PI)*(1/180*PI)*emission*data(i,2)*1*(data(i,1)-data(i-1,1));
        end
    end
end

P_atm3_5_8_14=0;
for i=2:length(data)
    wavelength=data(i,1);
    if ((wavelength>3 && wavelength<=5) || (wavelength>8 && wavelength<=14))
        temperature=T_amb;
        emission=(c1/(wavelength^5))*(1/(exp(c2/wavelength/temperature)-1));
        
        for j=1:length(theta)
            e_atm=1-t_atm(i,2)^(1/cos(j/180*PI));
            P_atm3_5_8_14=P_atm3_5_8_14+2*PI*sin(j/180*PI)*cos(j/180*PI)*(1/180*PI)*emission*data(i,2)*e_atm*(data(i,1)-data(i-1,1));
        end
    end
end

P_radar=P_rad3_5_8_14-P_atm3_5_8_14;

%Radiation cooling
P_rad5_8=0;
for i=2:length(data)
    wavelength=data(i,1);
    if (wavelength>5 && wavelength<=8)
        temperature=T_sample;
        emission=(c1/(wavelength^5))*(1/(exp(c2/wavelength/temperature)-1));
        for j=1:length(theta)
            P_rad5_8=P_rad5_8+2*PI*sin(j/180*PI)*cos(j/180*PI)*(1/180*PI)*emission*data(i,2)*1*(data(i,1)-data(i-1,1));
        end
    end
end

P_rad5_8
P_radar