function [inst,cust,vh,dc0]=donnee_p2(file_name)
z = textread(file_name,'%s');
nl = size(z,1);l=0;
inst.v_num = str2num(z{5});
inst.v_cap = str2num(z{6});
inst.cust_nbr = (nl-18)/7-1;
for i=19:7:nl
    l=l+1;
    cust(l,1) = str2num(z{i});          % num�ro du client.
    cust(l,2) = str2num(z{i+1});        % abscise du client.
    cust(l,3) = str2num(z{i+2});        % ordonn�e du client.
    cust(l,4) = str2num(z{i+3});        % demande du client.
    cust(l,5) = str2num(z{i+4});        % ai du client.
    cust(l,6) = str2num(z{i+5});        % bi du client.
    cust(l,7) = str2num(z{i+6});        % temp du service du client.
end
%% Changement du nbr des v�hicules suivant le nbr des clients
switch inst.cust_nbr
    case 200
        inst.v_num = 6;
    case 400
        inst.v_num = 12;
    case 600
        inst.v_num = 18;
    case 800
        inst.v_num = 24;
    case 1000
        inst.v_num = 30;
end
%% cr�ation du vh.ncptd et ch.pchst et vh.pos
for i=1:inst.v_num
    vh.ncptd(i,1) = i;                    % num�ro du v�hicule.
    vh.ncptd(i,2) = inst.v_cap;           % num�ro du v�hicule.
    vh.ncptd(i,3) = cust(1,1);            % position du v�hicule.
    vh.ncptd(i,4) = 0;                    % temp du v�hicule.
    vh.ncptd(i,5) = 0;                    % distance du v�hicule.
    vh.ncptd(i,6) = 0;                    % indice d'affectation = 0 ou 1.
    % Historique desu v�hicules.
    vh.pchst{i}(1,1) = vh.ncptd(i,3);     % position
    vh.pchst{i}(1,2) = vh.ncptd(i,2);     % capacit�
    vh.pchst{i}(1,3) = vh.ncptd(i,4);     % temp
    vh.pchst{i}(1,4) = vh.ncptd(i,5);     % distance
end
%% Calcul des distances entre les clients et le d�p�t
dc0 = (dist([cust(:,2) cust(:,3)]'));