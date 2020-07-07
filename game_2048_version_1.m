function game_2048_version_1
f = figure('units', 'pixels', 'outerposition', [100 100 630 630], 'menubar', 'none'); 
start_game = uicontrol('units', 'pixels', 'style', 'pushbutton', 'position', [100 100 430 330], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 8, 'string', 'START', 'userdata', 'START','callback',@start_game_2048);
function start_game_2048(~,~)
        start_game.Visible = 'off';
ax = axes('units', 'pixels', 'position', [50 50 490 490],'XTick',[],'YTick',[]); 
left_button = uicontrol('units', 'pixels', 'style', 'pushbutton', 'position', [10 545 50 20], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 8, 'string', 'Left', 'userdata', 'left','callback',@move_left);
right_button = uicontrol('units', 'pixels', 'style', 'pushbutton', 'position', [110 545 50 20], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 8, 'string', 'Right', 'userdata', 'right','callback',@move_right);
up_button = uicontrol('units', 'pixels', 'style', 'pushbutton', 'position', [60 570 50 20], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 8, 'string', 'Up', 'userdata', 'up','callback',@move_up);
down_button = uicontrol('units', 'pixels', 'style', 'pushbutton', 'position', [60 545 50 20], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 8, 'string', 'Down', 'userdata', 'down','callback',@move_down);
points = 0;
points_text = uicontrol('units', 'pixels', 'style', 'text', 'position', [550 70 50 20], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 8, 'string', 'Points:', 'userdata', 'points_value');
points_value = uicontrol('units', 'pixels', 'style', 'text', 'position', [550 50 50 20], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 8, 'string', points, 'userdata', 'points_value'); 
 
size = 4;
standart_size_of_number = 480;
chunchic_board = zeros(size,size); % ������� ��� ������ �����
current_board = ones(size,size); % ����� �� ����� 2^n, 1 - �������
do_nothing = false;
new_square = 2; % ����� ������ ����� ����
for i = 1:size % ������ ���� ����
    for j = 1:size
        chunchic_board(i,j) = rectangle('Position',[(i-1)*size (j-1)*size size size],'FaceColor','w'); 
    end
end

%a = [16 1 8 8;1 2 4 8;1 8 4 4;16 1 1 2]; % ��������� ������ 
a = ones(size);
start_random = randi([1 size*size]);
start_coord(1) = floor((start_random-1)/size)+1; % ������� ���������� ��� ������ ������ � ����� �������
start_coord(2) = start_random-(start_coord(1)-1)*size;
a(start_coord(1),start_coord(2)) = new_square; % ���������� ������ � ��������� ������ �����
color_value = 'ymcrgbk'; 
% 1) ���������, ��� ������� ������ ������(>7)
% 2) �������� ������ �� ������ �� �����
% 3) �������� ������ ������� �����
% 4) ������� ������ ������ ����(������ undo � ��� ���)
% 5) ��������� ���-�� ������������� ����(�������� �������� ����� ������ 1 ���
% � ������ ��������� �� ���)
% 6) ������� ����� ��� ����� 4(���� ��������� 25%)
% 7) ������� ����� ����(������� ��� ���������)
% 8) ������� ������(����� �� 2048)
% 9) �������� ������ ��� ������� �� start - ���� ���� :D
% 10) SUPERHARD ����� ������� ����� �������� �� start
for i = 1:size % ������ �����
    for j = 1:size
                if a(size+1-i,j) ~= 1
            temp_size = 2^((floor(log10(a(size+1-i,j))))+2);
            size_of_number = standart_size_of_number/temp_size;
            numbers(i,j) = text((j-1)*size,(i-1)*size+2,num2str(a(size+1-i,j)),'Color',color_value(log2(a(size+1-i,j))),'FontSize',size_of_number); 
        end
    end
end

% ����� ������� ������ start, ����� ����������� ������ ����� � ������ ����

function move_left(~,~)

old_a = a; % ������ �����, ����� � ����� �������� �������
% ���� � == old_a ������� �� �������, ����� ����������

for repeat = 1:size
for i = 1:size % ��� �������� �������, ��������� ������
    for j = 1:size-1 
            if a(i,size+1-j) > a(i,size-j) && a(i,size-j) == 1
                [a(i,size-j),a(i,size+1-j)] = deal(a(i,size+1-j),a(i,size-j)); % "deal" ������ ������� ��������
            end
    end
end
end

check_board_emptiness = zeros(1,size*size); % ����� �� 0 - �����, 1 - ������

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

if a == old_a
%         return % ������� �� �������
    do_nothing = true;
end

if do_nothing == false   
    delete(numbers); % ������� ������ �����
    
for i = 1:size % ������ ����� �����
    for j = 1:size
        if a(size+1-i,j) ~= 1
            temp_size = 2^((floor(log10(a(size+1-i,j))))+2);
            size_of_number = standart_size_of_number/temp_size;
            numbers(i,j) = text((j-1)*size,(i-1)*size+2,num2str(a(size+1-i,j)),'Color',color_value(log2(a(size+1-i,j))),'FontSize',size_of_number); 
        end
    end
end

    for check_board_x = 1:size
        for check_board_y = 1:size
            if a(check_board_x,check_board_y) == 1 % �������� �� �������
                check_board_emptiness((check_board_x-1)*size+check_board_y) = ((check_board_x-1)*size+check_board_y);              
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
        num2str(a(new_number_coord(1),new_number_coord(2))),'Color','y','FontSize',480/size); % ������ ����� �����
    points = points+2;
    points_value.String = num2str(points);
end
    check_board_emptiness = zeros(1,size*size);
    if do_nothing == true
    do_nothing = false;
    end
end

function move_right(~,~)

old_a = a; % ������ �����, ����� � ����� �������� �������
% ���� � == old_a ������� �� �������, ����� ����������

for repeat = 1:size
for i = 1:size % ��� �������� ������, ��������� �������
    for j = 1:size-1 
            if a(i,j) > a(i,j+1) && a(i,j+1) == 1
                [a(i,j),a(i,j+1)] = deal(a(i,j+1),a(i,j)); % "deal" ������ ������� ��������
            end
    end
end
end    

check_board_emptiness = zeros(1,size*size); % ����� �� 0 - �����, 1 - ������

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

if a == old_a
%         return % ������� �� �������
    do_nothing = true;
end

if do_nothing == false   
    delete(numbers); % ������� ������ �����
    
for i = 1:size % ������ ����� �����
    for j = 1:size
        if a(size+1-i,j) ~= 1
            temp_size = 2^((floor(log10(a(size+1-i,j))))+2);
            size_of_number = standart_size_of_number/temp_size;
            numbers(i,j) = text((j-1)*size,(i-1)*size+2,num2str(a(size+1-i,j)),'Color',color_value(log2(a(size+1-i,j))),'FontSize',size_of_number); 
        end
    end
end

    for check_board_x = 1:size
        for check_board_y = 1:size
            if a(check_board_x,check_board_y) == 1 % �������� �� �������
                check_board_emptiness((check_board_x-1)*size+check_board_y) = ((check_board_x-1)*size+check_board_y);              
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
        num2str(a(new_number_coord(1),new_number_coord(2))),'Color','y','FontSize',480/size); % ������ ����� �����
    points = points+2;
    points_value.String = num2str(points);
end
    check_board_emptiness = zeros(1,size*size);
    if do_nothing == true
    do_nothing = false;
    end
end

function move_up(~,~)

old_a = a; % ������ �����, ����� � ����� �������� �������
% ���� � == old_a ������� �� �������, ����� ����������

for repeat = 1:size
for i = 1:size-1 % ��� �������� ����, ��������� �����
    for j = 1:size 
            if a(size+1-i,j) > a(size-i,j) && a(size-i,j) == 1
                [a(size-i,j),a(size+1-i,j)] = deal(a(size+1-i,j),a(size-i,j)); % "deal" ������ ������� ��������
            end
    end
end
end

check_board_emptiness = zeros(1,size*size); % ����� �� 0 - �����, 1 - ������

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

if a == old_a
%         return % ������� �� �������
    do_nothing = true;
end

if do_nothing == false   
    delete(numbers); % ������� ������ �����
    
for i = 1:size % ������ ����� �����
    for j = 1:size
        if a(size+1-i,j) ~= 1
            temp_size = 2^((floor(log10(a(size+1-i,j))))+2);
            size_of_number = standart_size_of_number/temp_size;
            numbers(i,j) = text((j-1)*size,(i-1)*size+2,num2str(a(size+1-i,j)),'Color',color_value(log2(a(size+1-i,j))),'FontSize',size_of_number); 
        end
    end
end

    for check_board_x = 1:size
        for check_board_y = 1:size
            if a(check_board_x,check_board_y) == 1 % �������� �� �������
                check_board_emptiness((check_board_x-1)*size+check_board_y) = ((check_board_x-1)*size+check_board_y);              
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
        num2str(a(new_number_coord(1),new_number_coord(2))),'Color','y','FontSize',480/size); % ������ ����� �����
    points = points+2;
    points_value.String = num2str(points);
end
    check_board_emptiness = zeros(1,size*size);
    if do_nothing == true
    do_nothing = false;
    end
end

function move_down(~,~)

old_a = a; % ������ �����, ����� � ����� �������� �������
% ���� � == old_a ������� �� �������, ����� ����������

for repeat = 1:size
for i = 1:size-1 % ��� �������� ������, ��������� ����
    for j = 1:size 
            if a(i,j) > a(i+1,j) && a(i+1,j) == 1
                [a(i,j),a(i+1,j)] = deal(a(i+1,j),a(i,j)); % "deal" ������ ������� ��������
            end
    end
end
end    

check_board_emptiness = zeros(1,size*size); % ����� �� 0 - �����, 1 - ������

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

if a == old_a
%         return % ������� �� �������
    do_nothing = true;
end

if do_nothing == false   
    delete(numbers); % ������� ������ �����
    
for i = 1:size % ������ ����� �����
    for j = 1:size
        if a(size+1-i,j) ~= 1
            temp_size = 2^((floor(log10(a(size+1-i,j))))+2);
            size_of_number = standart_size_of_number/temp_size;
            numbers(i,j) = text((j-1)*size,(i-1)*size+2,num2str(a(size+1-i,j)),'Color',color_value(log2(a(size+1-i,j))),'FontSize',size_of_number); 
        end
    end
end

    for check_board_x = 1:size
        for check_board_y = 1:size
            if a(check_board_x,check_board_y) == 1 % �������� �� �������
                check_board_emptiness((check_board_x-1)*size+check_board_y) = ((check_board_x-1)*size+check_board_y);              
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
        num2str(a(new_number_coord(1),new_number_coord(2))),'Color','y','FontSize',480/size); % ������ ����� �����
    points = points+2;
    points_value.String = num2str(points);
end
    check_board_emptiness = zeros(1,size*size);
    if do_nothing == true
        do_nothing = false;
    end
end
    end
end

