%% Observabilidad

syms J_eq b_eq R_s lambda Pp Lq

%Observabilidad desde theta
A = [0 1 0;
    0 -b_eq/J_eq 3*Pp*lambda/(2*J_eq);
    0 -Pp/Lq -R_s/Lq];

C = [1 0 0];

O = [C;
    C*A;
    C*A*A]

%Observabilidad desde omega
C_omega = [0 1 0];

O_omega = [C_omega;
           C_omega*A;
           C_omega*A*A]

%%Controlabilidad

B = [0; 0; 1/Lq];

Cont = [B A*B A*A*B]