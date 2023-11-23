%Definimos una funcion cuya salida sea un vector con todas las eciaciones
%diferenciales que posteriormente resolveremos.

%Por comodidad trabajaremos con vectores asi que la entrada será un vector
function [Vnmh]=HH (t,P)

%Parametros de entrada:
    %P: vector fila con los parametros de las ecuaciones diferenciales del
    %potencial de membrana, n, m y h en ese orden
    %t: está incluida para que funcione ode45
%Parametros de salida:
    %Vnmh: vector columna que contiene las derivadas de V n m h
    %respectivamente

%En primer lugar damos valores a las variables

%Potenciales (mV)
Vna=120; Vk=-12; Vl=10.6;

%Conductancias máximas (mS/cm2)
gna=120; gk=36; gl=0.3;

%Condictancia (uF/cm2)
C=1;

%Constantes de transiciones
alpha_n=0.01*(10-P(1))/(exp((10-P(1))/10)-1);
alpha_m=0.1*(25-P(1))/(exp((25-P(1))/10)-1);
alpha_h=0.07*exp(-P(1)/20);

beta_n=0.125*exp(-P(1)/80);
beta_m=4*exp(-P(1)/18);
beta_h=1/(exp((30-P(1))/10)+1);

%Definimos el vector (de momento fila) salida que contiene las derivadas del
%potencial de membrana,n, m y h

Vnmh=[1/C*(I(t)-gna*P(3)^3*P(4)*(P(1)-Vna)-gk*P(2)^4*(P(1)-Vk)-gl*(P(1)-Vl)),alpha_n*(1-P(2))-beta_n*P(2),alpha_m*(1-P(3))-beta_m*P(3),alpha_h*(1-P(4))-beta_h*P(4)]';
end

