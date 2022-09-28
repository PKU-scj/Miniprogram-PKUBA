clear

% ����: ['����','����','����','����','�ǻ�','����','��ѧ','����','����','����','��ѧ','����','Ԫ��','�ſ�','ҽѧ','��Ժ','�⻪','����','����'],
% Ů��: ['�⾭','����','����','�ǻ�','�ؿ�','����','��ѧ','��΢','���','��ѧ','��Ժ','����','����','�´�','�Ź�','�ſ�','ҽѧ','Ԫ��','����','��ѧ','��Ժ','����'],

% team_new = {};
team_new = {...
    'A1' 'm' '����' ... % ����: ['','','','','','','','','','','','','','','','','','','']
    'A2' 'm' '�ǻ�' ...
    'A3' 'm' '��Ժ' ...
    'A4' 'm' '����' ...
    'B1' 'm' '����' ... 
    'B2' 'm' '�ſ�' ...
    'B3' 'm' '����' ...
    'B4' 'm' '��ѧ' ...
    'C1' 'm' 'ҽѧ' ...
    'C2' 'm' '����' ...
    'C3' 'm' '����' ...
    'C4' 'm' '����' ...
    'D1' 'm' '����' ...
    'D2' 'm' '��ѧ' ...
    'D3' 'm' '����' ...
    'D4' 'm' 'Ԫ��' ... 
    'E1' 'm' '�⻪' ...
    'E2' 'm' '����' ...
    'E3' 'm' '����' ...
    ...
    'A1' 'f' 'ҽѧ' ... % Ů��: ['','','','','','','','','','','','','','','','','','','','','','']
    'A2' 'f' '�Ź�' ...
    'A3' 'f' '����' ...
    'A4' 'f' '��΢' ...
    'B1' 'f' '��Ժ' ...
    'B2' 'f' '���' ...
    'B3' 'f' '����' ...
    'B4' 'f' '�ؿ�' ...
    'C1' 'f' '�ǻ�' ...
    'C2' 'f' '����' ...
    'C3' 'f' '�⾭' ...
    'C4' 'f' '��Ժ' ...
    'D1' 'f' 'Ԫ��' ...
    'D2' 'f' '��ѧ' ...
    'D3' 'f' '��ѧ' ...
    'D4' 'f' '����' ...
    'E1' 'f' '�´�' ...
    'E2' 'f' '����' ...
    'E3' 'f' '����' ...
    'F1' 'f' '�ſ�' ...
    'F2' 'f' '����' ...
    'F3' 'f' '��ѧ' ...
    };
meta = ['{' ...
        '"games": ["����","Ů��"],' ... % Ӧ��app.js��GROUP_NAMES��ͬ
        '"place_all": ["���Ķ�һ","���Ķ���","���Ķ���","��°�"]' ... 
        '}' ];
meta = jsondecode(meta);


place_all = meta.place_all;
place_num = length(place_all);
place = cell(place_num,1);
% �涨����ÿһ����ʹ�õĳ���
place{1} = [2,5,8,12,14,17]; % xls����еĵ�2,5,8,12,14,17��ʹ�õ�һ������
place{2} = [3,6,9,13,15];
place{3}= [4,7,10];
place{4} = [11,16];


% ��ȡ������ɿɱ�������С�����json�ļ�
[~,txt,data] = xlsread('schedule.xlsx');

[row,col] = size(data);
data_new = [];
for k = 1:row
    for j = 1:col
        if strfind(upper(data{k,j}),'VS')
            temp = data{k,j};
            temp(temp==' ')=''; % delete all space
            tempdata.sex = true;
            if temp(end-1) == 'Ů'
                tempdata.sex = false;
                tempdata.group = meta.games{2};
%                 if strcmp(temp(1),'��')
%                     tempdata.group = meta.games{3};
%                 else
%                     tempdata.group = meta.games{4};
%                 end
                pos_end = 3;
            else
                tempdata.sex = true;
                tempdata.group = meta.games{1};
%                 if strcmp(temp(1),'��')
%                     tempdata.group = meta.games{1};
%                 else
%                     tempdata.group = meta.games{2};
%                 end
                pos_end = 0;
            end
            if strfind(data{k,j},'VS')
                pos1 = strfind(data{k,j},'VS')-1;
            elseif strfind(data{k,j},'vs')
                pos1 = strfind(data{k,j},'vs')-1;
            end
            pos2 = pos1 + 3;
            tempdata.home_team = temp(1:pos1);
            tempdata.away_team = temp(pos2:end-pos_end);
            tempdata.home_team_score = -1;
            tempdata.away_team_score = -1;
            % substitute
            for i = 1:3:length(team_new)
                if strcmp(tempdata.home_team,team_new{i}) && (tempdata.sex == (strcmp(team_new{i+1},'m')))
                    tempdata.home_team = team_new{i+2};
                elseif strcmp(tempdata.home_team,team_new{i}) && (tempdata.sex == (~strcmp(team_new{i+1},'f')))
                    tempdata.home_team = team_new{i+2};                    
                end
                if strcmp(tempdata.away_team,team_new{i}) && (tempdata.sex == (strcmp(team_new{i+1},'m')))
                    tempdata.away_team = team_new{i+2};
                elseif strcmp(tempdata.away_team,team_new{i}) && (tempdata.sex == (~strcmp(team_new{i+1},'f')))
                    tempdata.away_team = team_new{i+2};                    
                end
            end
            for i = 1:place_num
                if sum(place{i}==j)>=1
                    tempdata.place = place_all{i};
                    break
                end
            end
            if contains([tempdata.home_team,tempdata.away_team],'����') && ~contains([tempdata.home_team,tempdata.away_team],'�����')
                tempdata.adjustable = false;
            else
                tempdata.adjustable = true;
            end
            
            if strcmp(data{k,1},'2022/11/4') || strcmp(data{k,1},'2022/11/5')
                tempdata.adjustable = false;
            end
            
            temp_time = datetime([datestr(data{k,1},'yyyy/mm/dd'),datestr(data{1,j},' HH:MM:00')]);
            temp_time = temp_time - hours(8); %΢��С�������ݿ⵼��ʱ��Ϊ+0���й�Ϊ+8
            tempdata0 = jsonencode(tempdata);
            tempdata0 = [tempdata0(1:end-1),',"time":{"$date":"',datestr(temp_time,'yyyy-mm-ddTHH:MM:00Z"}}')];
            data_new = [data_new,tempdata0];
        end
    end
end
disp(data_new)
fid = fopen('schedule.json','w','n','UTF-8');
fprintf(fid, '%s', data_new);
fclose(fid);