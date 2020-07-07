% 1) ���������, ��� ������� ������ ������(>7) - DONE!
% 2) �������� ������ �� ������ �� ����� - DONE!
% 3) �������� ������ ������� ����� - DONE!
% 4) ������� ������ ������ ����(������ undo � ��� ���)
% 5) ��������� ���-�� ������������� ����(�������� �������� ����� ������ 1 ���
% � ������ ��������� �� ���) - DONE!
% 6) ������� ����� ��� ����� 4(���� ��������� 25%) - DONE!
% 7) ������� ����� ����(������� ��� ���������) - DONE!
% 8) ������� ������(����� �� 2048) - DONE!
% 9) �������� ������ ��� ������� �� start - ���� ���� :D 
% 10) SUPERHARD ����� ������� ����� �������� �� start
% 11) ������ RESTART - DONE!

function game_2048_lose_possibility_version_6
f = figure('units', 'pixels', 'outerposition', [100 100 630 650], 'menubar', 'none'); 
toolbar = uitoolbar(f);
     [img,map] = imread(fullfile(matlabroot,...
            'toolbox','matlab','icons','file_new.png'));        
    p = uipushtool(toolbar,'TooltipString','Toolbar push button',...
                 'ClickedCallback',@start_game_2048, 'CData', double(img)/65536);
            
function start_game_2048(~,~)
    
p.ClickedCallback = @restart_game_2048;
ax = axes('units', 'pixels', 'position', [50 50 490 490],'XTick',[],'YTick',[]);
set (f,'keypressfcn',@move);
points = 0;
points_text = uicontrol('units', 'pixels', 'style', 'text', 'position', [550 70 50 20], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 8, 'string', 'Points:', 'userdata', 'points_text');
points_value = uicontrol('units', 'pixels', 'style', 'text', 'position', [550 50 50 20], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 8, 'string', points, 'userdata', 'points_value'); 
victory_sign = uicontrol('units', 'pixels', 'style', 'text', 'position', [230 550 250 40], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 20,'visible','off','string', 'VICTORY!!!!!!! :)', 'userdata', 'victory');
loser_sign = uicontrol('units', 'pixels', 'style', 'text', 'position', [10 10 690 40], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 20,'visible','on','string',...
     '','userdata', 'loser'); 
 
size = 4;
standart_size_of_number = 480;
chunchic_board = zeros(size,size); % ������� ��� ������ �����

do_nothing = false;
new_number_value = [2 2 2 4]; % ����� ������ �� ���� �����(2 - 75%, 4 - 25%)

for i = 1:size % ������ ���� ����
    for j = 1:size
        chunchic_board(i,j) = rectangle('Position',[(i-1)*size (j-1)*size size size],'FaceColor','w'); 
    end
end
new_square = new_number_value(randi([1 4])); % ����� ����� ����� ����

a = ones(size); % ��������� �����
% a = [8192 4096 2048 1024;64 128 256 512;32 16 8 4;2 2 131072 16384]; % ��� �������� ������ 
% a = [32 64 32 8;128 1024 128 64;2 32 512 256;2 128 1 1]; % ��� �������� ���������
start_random = randi([1 size*size]); % �������� ����� ������, ��� �������� ������ �����
start_coord(1) = floor((start_random-1)/size)+1; % ������� ���������� ��� ������ ������ � ������ ������
start_coord(2) = start_random-(start_coord(1)-1)*size;
a(start_coord(1),start_coord(2)) = new_square; % ���������� ����� � ��������� ������ �����

color_value = [1 0.5 0.5;1 0 0;1 1 0.5;1 1 0;0.5 1 0.5;0.5 1 0;0 1 0.5;0.5 1 1;0 1 1;0 0.5 1;1 0.5 1;0.5 0.5 1;0.5 0 0.5;0.5 0.5 0;0 0 0;0.5 0.5 0.5;0.5 0.5 0.5];
for i = 1:size % ������ �����
    for j = 1:size
                if a(size+1-i,j) ~= 1                      
            color_of_number = log2(a(size+1-i,j)); % ���-�� ���� � ������
            rank_of_number = floor(log10(a(size+1-i,j)))+1;
            if rank_of_number == 1
                temp_size = 4;
            elseif rank_of_number == 2
                temp_size = 6;
            elseif rank_of_number == 3
                temp_size = 9;
            elseif rank_of_number == 4
                temp_size = 12;
            elseif rank_of_number == 5
                temp_size = 15;
            elseif rank_of_number == 6
                temp_size = 18;
            end
            size_of_number = 480/temp_size;
            numbers(i,j) = text((j-1)*size,(i-1)*size+2,num2str(a(size+1-i,j)),'Color',[color_value(color_of_number,1) color_value(color_of_number,2) color_value(color_of_number,3)],'FontSize',size_of_number); 
        end
    end
end

function move(hObject,eventDat)
   current_key = get(hObject,'CurrentKey');
   old_a = a; % ������ �����, ����� � ����� �������� �������
   % ���� � == old_a ������� �� �������, ����� ����������
new_square = new_number_value(randi([1 4])); % ����� ����� ����� ����

if strcmp(current_key,'leftarrow') == 1
for repeat = 1:size
for i = 1:size % ��� �������� �������, ��������� ������
    for j = 1:size-1 
            if a(i,size+1-j) > a(i,size-j) && a(i,size-j) == 1
                [a(i,size-j),a(i,size+1-j)] = deal(a(i,size+1-j),a(i,size-j)); % "deal" ������ ������� ��������
            end
    end
end
end

for i = 1:size % ��� �����
    for j = 1:size-1 
            if a(i,j) == a(i,j+1) && a(i,j) ~= 1 
                a(i,j) = a(i,j)+a(i,j+1);
                for temp = j+1:size
                    c(temp) = a(i,temp);
                end
                    c = circshift(c,-1,2); % "circshift" �������� ������ � ��������� �����������
                for temp = j+1:size
                    a(i,temp) = c(temp);
                end
                c = [];
                a(i,size) = 1;
            end           
    end  
end

end
if strcmp(current_key,'rightarrow') == 1
for repeat = 1:size
for i = 1:size % ��� �������� ������, ��������� �������
    for j = 1:size-1 
            if a(i,j) > a(i,j+1) && a(i,j+1) == 1
                [a(i,j),a(i,j+1)] = deal(a(i,j+1),a(i,j)); % "deal" ������ ������� ��������
            end
    end
end
end    

for i = 1:size % ��� ������
    for j = 1:size-1 
            if a(i,size-j+1) == a(i,size-j) && a(i,size-j) ~= 1 
                a(i,size-j+1) = a(i,size-j+1)+a(i,size-j);
                for temp = j:size-1
                    c(temp-j+1) = a(i,temp-j+1);
                end
                    c = circshift(c,1,2); % "circshift" �������� ������ � ��������� �����������
                for temp = j:size-1
                    a(i,temp-j+1) = c(temp-j+1);
                end
                c = [];
                a(i,1) = 1;
            end           
    end  
end
end
if strcmp(current_key,'uparrow') == 1
for repeat = 1:size
for i = 1:size-1 % ��� �������� ����, ��������� �����
    for j = 1:size 
            if a(size+1-i,j) > a(size-i,j) && a(size-i,j) == 1
                [a(size-i,j),a(size+1-i,j)] = deal(a(size+1-i,j),a(size-i,j)); % "deal" ������ ������� ��������
            end
    end
end
end

for i = 1:size-1 % ��� �����
    for j = 1:size 
            if a(i,j) == a(i+1,j) && a(i,j) ~= 1 
                a(i,j) = a(i,j)+a(i+1,j);
                for temp = i+1:size
                    c(temp) = a(temp,j);
                end
                    c = circshift(c,-1,2); % "circshift" �������� ������ � ��������� �����������
                for temp = i+1:size
                    a(temp,j) = c(temp);
                end
                c = [];
                a(size,j) = 1;
            end           
    end  
end
end

if strcmp(current_key,'downarrow') == 1
for repeat = 1:size
for i = 1:size-1 % ��� �������� ������, ��������� ����
    for j = 1:size 
            if a(i,j) > a(i+1,j) && a(i+1,j) == 1
                [a(i,j),a(i+1,j)] = deal(a(i+1,j),a(i,j)); % "deal" ������ ������� ��������
            end
    end
end
end    

for i = 1:size-1 % ��� ����
    for j = 1:size 
            if a(size-i+1,j) == a(size-i,j) && a(size-i,j) ~= 1 
                a(size-i+1,j) = a(size-i+1,j)+a(size-i,j);
                for temp = i:size-1
                    c(temp-i+1) = a(temp-i+1,j);
                end
                    c = circshift(c,1,2); % "circshift" �������� ������ � ��������� �����������
                for temp = i:size-1
                    a(temp-i+1,j) = c(temp-i+1);
                end
                c = [];
                a(1,j) = 1;
            end           
    end  
end  
end
check_board_emptiness = zeros(1,size*size); % ����� �� 0 - �����, 1 - ������
if a == old_a
%         return % ������� �� �������
    do_nothing = true;
end

    for check_board_x = 1:size
        for check_board_y = 1:size
            if a(check_board_x,check_board_y) == 1 % �������� �� �������
                check_board_emptiness((check_board_x-1)*size+check_board_y) = ((check_board_x-1)*size+check_board_y); % ���������� ������ � ������� �������� � ������          
            end
        end
    end
    
    lose = 0;
    for lose_check = 1:size*size % �������� �� ���������
        if check_board_emptiness(lose_check) ~= 0
            lose = lose+1; 
        end
    end
    if lose == 0
                loser_sign.String = 'LOSER LOSER LOSER LOSER LOSER LOSER';
%                 start_game.Visible = 'on';
    end
if do_nothing == false   
    delete(numbers); % ������� ������ �����
    
for i = 1:size % ������ ����� �����
    for j = 1:size
        if a(size+1-i,j) ~= 1
        color_of_number = log2(a(size+1-i,j)); % ���-�� ���� � ������
            rank_of_number = floor(log10(a(size+1-i,j)))+1;
            if rank_of_number == 1
                temp_size = 4;
            elseif rank_of_number == 2
                temp_size = 6;
            elseif rank_of_number == 3
                temp_size = 9;
            elseif rank_of_number == 4
                temp_size = 12;
            elseif rank_of_number == 5
                temp_size = 15;
            elseif rank_of_number == 6
                temp_size = 18;
            end
            size_of_number = standart_size_of_number/temp_size;
                        
            numbers(i,j) = text((j-1)*size,(i-1)*size+2,num2str(a(size+1-i,j)),'Color',[color_value(color_of_number,1) color_value(color_of_number,2) color_value(color_of_number,3)],'FontSize',size_of_number);
        end
    end
end


    counter = 0; % �������
    for check_board = 1:size*size % ������ ������ ������ ������ � ���������� ������
        if check_board_emptiness(check_board) ~= 0
            counter = counter+1; % ���-�� ������ ������
        end
    end
    
    check_board_emptiness = sort(check_board_emptiness,2,'descend'); % ��������� � �������� �������(����� ���� ���� � �����)
    number_of_empty_space = randi([1 counter]); % �������� ����� � ������ ������� � ������� ��������
    new_number = check_board_emptiness(number_of_empty_space); % ����� ������, ��� �������� ����� ������
    new_number_coord(1) = floor((new_number-1)/size)+1; % ������� ���������� ��� ������ ������ � ����� �������
    new_number_coord(2) = new_number-(new_number_coord(1)-1)*size;
    a(new_number_coord(1),new_number_coord(2)) = new_square; % ���������� ������ � ��������� ������ �����
    numbers(size-new_number_coord(1)+1,new_number_coord(2)) = text((new_number_coord(2)-1)*size,14-(new_number_coord(1)-1)*size,...
        num2str(a(new_number_coord(1),new_number_coord(2))),'Color',[1 0.5 0.5],'FontSize',480/size); % ������ ����� �����
    points = points+2;
    points_value.String = num2str(points);
end
    check_board_emptiness = zeros(1,size*size);
    if do_nothing == true
    do_nothing = false;
    end

    for i = 1:size
        for j = 1:size
            if a(i,j) == 2048
                victory_sign.Visible = 'on';
            end
        end
    end
end
    function restart_game_2048(~,~)
        loser_sign.String = '';
        delete(numbers)
        points = 0;
        points_value.String = num2str(0);
        a = ones(size);
        start_random = randi([1 size*size]); % �������� ����� ������, ��� �������� ������ �����
start_coord(1) = floor((start_random-1)/size)+1; % ������� ���������� ��� ������ ������ � ������ ������
start_coord(2) = start_random-(start_coord(1)-1)*size;
a(start_coord(1),start_coord(2)) = new_square; % ���������� ����� � ��������� ������ �����

color_value = [1 0.5 0.5;1 0 0;1 1 0.5;1 1 0;0.5 1 0.5;0.5 1 0;0 1 0.5;0.5 1 1;0 1 1;0 0.5 1;1 0.5 1;0.5 0.5 1;0.5 0 0.5;0.5 0.5 0;0 0 0];
for i = 1:size % ������ �����
    for j = 1:size
                if a(size+1-i,j) ~= 1
        color_of_number = log2(a(size+1-i,j)); % ���-�� ���� � ������
            rank_of_number = floor(log10(a(size+1-i,j)))+1;
            if rank_of_number == 1
                temp_size = 4;
            elseif rank_of_number == 2
                temp_size = 6;
            elseif rank_of_number == 3
                temp_size = 9;
            elseif rank_of_number == 4
                temp_size = 12;
            elseif rank_of_number == 5
                temp_size = 15;
            elseif rank_of_number == 6
                temp_size = 18;
            end
            size_of_number = standart_size_of_number/temp_size;
            numbers(i,j) = text((j-1)*size,(i-1)*size+2,num2str(a(size+1-i,j)),'Color',[color_value(color_of_number,1) color_value(color_of_number,2) color_value(color_of_number,3)],'FontSize',size_of_number); 
        end
    end
end
    end
end
end

