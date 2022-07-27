function main_p2()
%% Importation des donnees.
l0=1;tab{l0,1}='Fichier'; tab{l0,2}='Distance'; tab{l0,3}='Temp d''execution';
lst_rep1 = dir ('Homberger*');
for i0 = 1:size(lst_rep1,1)
    nom_fch=lst_rep1(i0,1).name;
    lst_rep2 = dir ([nom_fch '\*.txt']);
    for j0 = 1:size(lst_rep2,1)
        file_name = lst_rep2 (j0,1).name;
        fprintf('Traitement du fichier :: %s du repertoire :: %s ...\n',file_name,nom_fch);
        % file_name = 'C1_10_1.txt';
        tic;
        [inst,cust,vh,dc0] = donnee_p2([nom_fch '\' file_name]);
        list0 = cust(2:end,1);        
        %% Affectation du temp pour chaque tourne suivant le fichier.
        if (file_name(1)=='C')
            inst.T = 750; % 250
        else
            inst.T = 100;
        end
        %% Initialisation.
        ma0=false;
        temp_inst=cust(2,7);
        
        %%
        while (size(list0,1)~=0)
            %% definir les clients critique.
            list_c=[];l=0;
            for i = 1:size(list0,1)
                if temp_inst>cust(list0(i,1)+1,6) %(vh.ncptd(1,4)+cust(list0(i,1)+1,7))
                    l=l+1; list_c(l,1)=list0(i,1);
                    list_c(l,2)=cust(list0(i,1)+1,7); % supprime
                    list_c(l,3)=vh.ncptd(1,4); %  supprime
                    list_c(l,4)=vh.ncptd(1,4)+cust(list0(i,1)+1,7); %   supprime
                    list_c(l,5)=cust(list0(i,1)+1,6); %  supprime
                end
            end
            
            %% on affecte les vehicule au clients critique.
            if (size (list_c,1) > inst.v_num)
                list=list_c(:,1);
                ma0=true;
            else
                list=list0;
                for i = 1:size(list_c,1)
                    % on cherche la vehicule la plus proche qui vvrifie la capacite
                    cc=list_c(i,1); cc_dmd=cust(cc+1,4); cc_t=cust(cc+1,7);    
                    vh=afct_vh(cc,cc_dmd,cc_t,vh,dc0);
                    k00=find(list0==cc); list0(k00,:)=[];  
                    k01=find(list==cc); list(k01,:)=[];
                end
            end
            %% on affecte les clients aux vehicules selon leurs positions.
            for i = 1 : inst.v_num
                while (vh.ncptd(i,6)==0)&&(size(list0,1)~=0)
                    if (vh.ncptd(i,3)==0)
                        y=cppl(vh.ncptd(i,3),list,dc0,-1); % plus loint client.
                        vh=afct_cl(i,1,y,vh,cust); % choix du client.
                        k1=find(list(:,1)==y(1,1)); list(k1,:)=[];
                        k2=find(list0(:,1)==y(1,1)); list0(k2,:)=[];
                    else
                        m=0;
                        x=cppl(vh.ncptd(i,3),list,dc0,1); % plus proche client.
                        ma=ceil(size(list,1)/inst.v_num);
                        for j=1:ma % size(x,1)
                            if ((cust(x(j,1)+1,4)<vh.ncptd(i,2))&& ... % teste capacite
                                    (vh.ncptd(i,4)<cust(x(j,1)+1,6))&& ... % teste bi.
                                    ((vh.ncptd(i,4)+cust(x(j,1)+1,7))<inst.T)) % teste T.
                                m=1;
                                vh=afct_cl(i,j,x,vh,cust); % choix du client.
                                k1=find(list(:,1)==x(j,1)); list(k1,:)=[];
                                k2=find(list0(:,1)==x(j,1)); list0(k2,:)=[]; 
                                break;
                            end
                        end
                        if (m==0) % retour de la vehicule au depot.
                            vh.ncptd(i,2)=inst.v_cap;	% modifier la capacite du vehicule.
                            vh.ncptd(i,5)=vh.ncptd(i,5)+dc0(vh.ncptd(i,3)+1,1);  % modifier la distance parcouru par le vehicule.
                            vh.ncptd(i,3)=0;  % modifier la position du vehicule au client y(i,1).
                            vh.ncptd(i,4)=0; % modifier le temp parcouru par le vehicule.                    
                            vh.ncptd(i,6)=0;
                            l=size(vh.pchst{i},1);
                            vh.pchst{i}(l+1,1)=vh.ncptd(i,3);
                            vh.pchst{i}(l+1,2)=vh.ncptd(i,2);
                            vh.pchst{i}(l+1,3)=vh.ncptd(i,4);
                            vh.pchst{i}(l+1,4)=vh.ncptd(i,5);
                        end
                    end
                end
            end
            if ma0==true
                for i=1:size(list,1)
                    k3=find(list0(:,1)==list(i,1)); list0(k3,:)=[];
                end
                ma0=false;
            end
            vh.ncptd(:,6)=zeros(inst.v_num,1);
            temp_inst=temp_inst+cust(2,7);
            
            %% Retour des vehicules au depot.
            if (size(list0,1)==0)
                for i1 = 1:inst.v_num
                    if (vh.ncptd(i1,3)~=0)
                        vh.ncptd(i1,2)=inst.v_cap;	% modifier la capacite du vehicule.
                        vh.ncptd(i1,5)=vh.ncptd(i1,5) + dc0(vh.ncptd(i1,3)+1,1);   % modifier la distance parcouru par le vehicule.
                        vh.ncptd(i1,3)=0;  % modifier la position du vehicule au client y(i,1).
                        vh.ncptd(i1,4)=0; % modifier le temp parcouru par le vehicule.                
                        vh.ncptd(i1,6)=0;
                        l=size(vh.pchst{i1},1);
                        vh.pchst{i1}(l+1,1)=vh.ncptd(i1,3);
                        vh.pchst{i1}(l+1,2)=vh.ncptd(i1,2);
                        vh.pchst{i1}(l+1,3)=vh.ncptd(i1,4);
                        vh.pchst{i1}(l+1,4)=vh.ncptd(i1,5);
                    end
                end
            end
        end
        d=0;
        for i2=1:inst.v_num
            nl0=size(vh.pchst{i2},1); 
            d=d+vh.pchst{i2}(nl0,4);
        end
        tm_inst=toc;
        %% Affichage & sauvegarde des donnees.
        fprintf('Resultat du fichier est : Distance parcouru = %s, Temp d''execution = %s.\nSauvegarde des donnees en cour ...\n',num2str(d),num2str(tm_inst));        
        l0=l0+1;
        tab{l0,1}=file_name;        
        tab{l0,2}=d;        
        tab{l0,3}=tm_inst;
        %%
        clear inst cust vh dc0 tm_inst;
    end
    fprintf('Enregistrement du fichier excel.\n');
    xlswrite('Resultats',tab,nom_fch(1:14));
end