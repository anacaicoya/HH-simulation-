%Definimos una función en la que simularemos el valor del potencial de
%membrana con la función ode45

%Damos un intervalo de tiempo (ms) y valores iniciales
V0=0; 
t0=0;
tf=100;

%Tendremos que definir las variables del problema para luego poder calcular
%el estado inicial 
alpha_n=0.01*(10-V0)/(exp((10-V0)/10)-1);
alpha_m=0.1*(25-V0)/(exp((25-V0)/10)-1);
alpha_h=0.07*exp(-V0/20);

beta_n=0.125*exp(-V0/80);
beta_m=4*exp(-V0/18);
beta_h=1/(exp((30-V0)/10)+1);

n0=alpha_n/(alpha_n+beta_n); 
m0=alpha_m/(alpha_m+beta_m); 
h0=alpha_h/(alpha_h+beta_h); 

%Las condiciones iniciales se deben almacenar en un vector
Vnmh0=[V0,n0,m0,h0];

%Ya tenemos definidas todas las variables necesarias para el programa Vnmh
%A la función ode45 hay que introducirle como variable el tiempo aunque no
%se use
[t,V]=ode45(@HH,[t0,tf],Vnmh0);
V(:,1)=V(:,1)-65; %establecemos el potencial de reposo en 0

% Dibujamos las gráficas para ver el resultado
% Primero dibujamos el potencia y la intensidad 
figure(1)
subplot(2,1,1)
plot(t,V(:,1),'LineWidth',2)
ylim([-80 55])
%xlim([0 60])
title('Evolución del potencial de membrana')
xlabel('Tiempo (ms)')
ylabel('V(mV)')
ax = gca; %Para cambiar el tamaño de fuente en los ejes
ax.FontSize = 20;

subplot(2,1,2)

%Para dibujar correctamente la intensidad deberemos definirla en vector
%almacenando sus valores 1 a 1
I=@(t) I(t); %Definimos I como una función del tiempo
Idib=zeros(1,length(t)); %Creamos el vector donde iremos almacenando los valores de I
for i=1:length(t) 
    Idib(i)=I(t(i));
end
plot(t,Idib,'LineWidth',2)
ylim([min(Idib)-2 max(Idib)+2])
%xlim([0 60])
title('Corriente suministrada')
xlabel('Tiempo (ms)')
ylabel('I(\muA/cm^2)')
ax = gca; %Para cambiar el tamaño de fuente en los ejes
ax.FontSize = 20;

% %A continuación dibujamos las variables n m y h con el potencial de
% %membrana
figure(2)
subplot(2,2,1)
plot(t,V(:,1),'LineWidth',2)
xlabel('Tiempo (ms)')
ylabel('V(mV)')
ylim([-80 55])
ax = gca; %Para cambiar el tamaño de fuente en los ejes
ax.FontSize = 20;

subplot(2,2,2)
plot(t,V(:,2),'LineWidth',2)
xlabel('Tiempo (ms)')
ylabel('n')
ylim([-0.1 1.1])
ax = gca; %Para cambiar el tamaño de fuente en los ejes
ax.FontSize = 20;

subplot(2,2,3)
plot(t,V(:,3),'LineWidth',2)
xlabel('Tiempo (ms)')
ylabel('m')
ylim([-0.1 1.1])
ax = gca; %Para cambiar el tamaño de fuente en los ejes
ax.FontSize = 20;

subplot(2,2,4)
plot(t,V(:,4),'LineWidth',2)
xlabel('Tiempo (ms)')
ylabel('h')
ylim([-0.1 1.1])
ax = gca; %Para cambiar el tamaño de fuente en los ejes
ax.FontSize = 20;

%Vamos a intentar representar el estado estacionario y el tiempo de
%inactivacion de los canales con potenciales de membrana entre -40 y 100
Vd=linspace(-40,100,100000);
alpha_n=@(V) 0.01*(10-V)/(exp((10-V)/10)-1);
alpha_m=@(V) 0.1*(25-V)/(exp((25-V)/10)-1);
alpha_h=@(V) 0.07*exp(-V/20);

alpha_nd=zeros(1,length(Vd));
alpha_md=zeros(1,length(Vd));
alpha_hd=zeros(1,length(Vd));

for j=1:length(Vd)
    alpha_nd(j)=alpha_n(Vd(j));
    alpha_md(j)=alpha_m(Vd(j));
    alpha_hd(j)=alpha_h(Vd(j));
end

beta_n=@(V) 0.125*exp(-V/80);
beta_m=@(V) 4*exp(-V/18);
beta_h=@(V) 1/(exp((30-V)/10)+1);

beta_nd=zeros(1,length(Vd));
beta_md=zeros(1,length(Vd));
beta_hd=zeros(1,length(Vd));

for j=1:length(Vd)
    beta_nd(j)=beta_n(Vd(j));
    beta_md(j)=beta_m(Vd(j));
    beta_hd(j)=beta_h(Vd(j));
end

tau_n=1./(alpha_nd+beta_nd);
tau_m=1./(alpha_md+beta_md);
tau_h=1./(alpha_hd+beta_hd);

ninf=alpha_nd./(alpha_nd+beta_nd);
minf=alpha_md./(alpha_md+beta_md);
hinf=alpha_hd./(alpha_hd+beta_hd);

figure(3)
ax = gca;
ax.FontSize = 30;
subplot(1,2,1)
plot(Vd,tau_n,'LineWidth',2)
hold on
plot(Vd,tau_m,'LineWidth',2)
plot(Vd,tau_h,'LineWidth',2)
title('Tiempos de relajación','FontSize',25)
legend('\tau_n','\tau_m','\tau_h','Location','east','FontSize',25)
xlim([-40 100])
xlabel('V(mV)','FontSize',30)
ylabel('s^{-1}','FontSize',30)
ax = gca;
ax.FontSize = 30; %Aumentamos el tamaño de los números del eje
hold off
subplot(1,2,2)
plot(Vd,ninf,'LineWidth',2)
hold on
plot(Vd,minf,'LineWidth',2)
plot(Vd,hinf,'LineWidth',2)
title('Estados estacionarios','FontSize',25)
legend('n_{\infty}','m_{\infty}','h_{\infty}','Location','east','FontSize',25)
xlim([-40 100])
xlabel('V(mV)','FontSize',30)
ax = gca; %Para cambiar el tamaño de fuente en los ejes
ax.FontSize = 30;
hold off

figure(4)
subplot(3,1,1)
plot(t,V(:,1),'LineWidth',2)
ylim([-80 55])
xlabel('Tiempo (ms)')
ylabel('V(mV)')
ax = gca; %Para cambiar el tamaño de fuente en los ejes
ax.FontSize = 20;
subplot(3,1,[2,3])
plot(V(:,1),V(:,2))
xlabel('V(mV)')
ylabel('n')
ylim([0.3 0.8])
ax = gca; %Para cambiar el tamaño de fuente en los ejes
ax.FontSize = 20;