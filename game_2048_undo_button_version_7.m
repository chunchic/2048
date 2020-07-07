% 1) придумать, как сделать больше цветов(>7) - DONE!
% 2) поменять кнопки на экране на клаву - DONE!
% 3) изменить размер больших чисел - DONE!
% 4) сделать разные режимы игры(кнопку undo и без нее) - DONE!
% 5) уменьшить кол-во однообразного кода - DONE!
% 6) сделать спаун для цифры 4(шанс выпадения 25%) - DONE!
% 7) сделать конец игры - DONE!
% 8) сделать победу(дошел до 2048) - DONE!
% 9) добавить музыку при нажатии на start - гимн ссср :D - НЕ МОГУ 
% 10) SUPERHARD: выбор размера доски перед нажатием на start
% 11) кнопка RESTART - DONE!
% 12) SUPERHARD: сохранять рекорды (отдельно для каждого режима)
% 13) сделать кнопку undo - DONE!

function game_2048_undo_button_version_7
global old_a
f = figure('units', 'pixels', 'outerposition', [100 100 660 650], 'menubar', 'none'); 
toolbar = uitoolbar(f);
     [img,map] = imread(fullfile(matlabroot,...
            'toolbox','matlab','icons','file_new.png'));        
    p = uipushtool(toolbar,'TooltipString','Toolbar push button',...
                 'ClickedCallback',@start_game_2048, 'CData', double(img)/65536);
difficulty_sign = uicontrol('units', 'pixels', 'style', 'text', 'position', [20 525 300 30], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 15,'visible','on','string', 'choose the game difficulty :)', 'userdata', 'victory_sign');
game_difficulty = uicontrol('units', 'pixels', 'style', 'popupmenu', 'position', [20 500 150 20], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 15,'visible','on','string',...
     {'noob :(';'more than a noob :)'},'userdata', 'difficulty');          
function start_game_2048(~,~)
p.ClickedCallback = @restart_game_2048;
% game_difficulty.Visible = 'off';
difficulty_sign.Visible = 'off';
game_difficulty.Position = [550 250 90 40];

ax = axes('units', 'pixels', 'position', [50 50 490 490],'XTick',[],'YTick',[]);
set (f,'keypressfcn',@move);
points = 0;
points_text = uicontrol('units', 'pixels', 'style', 'text', 'position', [550 70 50 20], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 8, 'string', 'Points:', 'userdata', 'points_text');
points_value = uicontrol('units', 'pixels', 'style', 'text', 'position', [550 50 50 20], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 8, 'string', points, 'userdata', 'points_value'); 
victory_sign = uicontrol('units', 'pixels', 'style', 'text', 'position', [230 550 250 40], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 20,'visible','on','string', '', 'userdata', 'victory');
loser_sign = uicontrol('units', 'pixels', 'style', 'text', 'position', [10 10 690 40], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 20,'visible','on','string',...
     '','userdata', 'loser'); 
undo_button = uicontrol('units', 'pixels', 'style', 'pushbutton', 'position', [550 300 90 40], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 20,'enable','on','string', 'Undo', 'userdata', 'undo', 'callback',@undo);
if game_difficulty.Value == 2
    undo_button.Visible = 'off';
elseif game_difficulty.Value == 1
    undo_button.Visible = 'on';
end
size = 4;
standart_size_of_number = 480;
chunchic_board = zeros(size,size); % видимая для игрока доска

do_nothing = false;
new_number_value = [2 2 2 4]; % спаун одного из этих чисел(2 - 75%, 4 - 25%)

for i = 1:size % рисуем поле игры
    for j = 1:size
        chunchic_board(i,j) = rectangle('Position',[(i-1)*size (j-1)*size size size],'FaceColor','w'); 
    end
end
new_square = new_number_value(randi([1 4])); % новое число после хода

a = ones(size); % начальная доска
% a = [8192 4096 2048 1024;64 128 256 512;32 16 8 4;2 2 131072 16384]; % для проверки победы 
% a = [32 64 32 8;128 1024 128 64;2 32 512 256;2 128 1 1]; % для проверки поражения
start_random = randi([1 size*size]); % выбираем номер клетки, где появится первое число
start_coord(1) = floor((start_random-1)/size)+1; % считаем координаты для номера клетки с первым числом
start_coord(2) = start_random-(start_coord(1)-1)*size;
a(start_coord(1),start_coord(2)) = new_square; % добавление числа в рандомное пустое место

color_value = [1 0.5 0.5;1 0 0;1 1 0.5;1 1 0;0.5 1 0.5;0.5 1 0;0 1 0.5;0.5 1 1;0 1 1;0 0.5 1;1 0.5 1;0.5 0.5 1;0.5 0 0.5;0.5 0.5 0;0 0 0;0.5 0.5 0.5;0.5 0.5 0.5];
for i = 1:size % рисуем числа
    for j = 1:size
                if a(size+1-i,j) ~= 1                      
            color_of_number = log2(a(size+1-i,j)); % степень двойки
            rank_of_number = floor(log10(a(size+1-i,j)))+1; % кол-во цифр в числах +1
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
   old_a = a; % делаем копию, чтобы в конце сравнить массивы
   % если а == old_a выходим из функции, иначе продолжаем
   new_square = new_number_value(randi([1 4])); % новое число после хода
   undo_button.Enable = 'on';

if strcmp(current_key,'leftarrow') == 1
for repeat = 1:size
for i = 1:size % все единички направо, остальное налево
    for j = 1:size-1 
            if a(i,size+1-j) > a(i,size-j) && a(i,size-j) == 1
                [a(i,size-j),a(i,size+1-j)] = deal(a(i,size+1-j),a(i,size-j)); % "deal" меняет местами значения
            end
    end
end
end

for i = 1:size % ход влево
    for j = 1:size-1 
            if a(i,j) == a(i,j+1) && a(i,j) ~= 1 
                a(i,j) = a(i,j)+a(i,j+1);
                for temp = j+1:size
                    c(temp) = a(i,temp);
                end
                    c = circshift(c,-1,2); % "circshift" сдвигает массив в выбранное направление
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
for i = 1:size % все единички налево, остальное направо
    for j = 1:size-1 
            if a(i,j) > a(i,j+1) && a(i,j+1) == 1
                [a(i,j),a(i,j+1)] = deal(a(i,j+1),a(i,j)); % "deal" меняет местами значения
            end
    end
end
end    

for i = 1:size % ход вправо
    for j = 1:size-1 
            if a(i,size-j+1) == a(i,size-j) && a(i,size-j) ~= 1 
                a(i,size-j+1) = a(i,size-j+1)+a(i,size-j);
                for temp = j:size-1
                    c(temp-j+1) = a(i,temp-j+1);
                end
                    c = circshift(c,1,2); % "circshift" сдвигает массив в выбранное направление
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
for i = 1:size-1 % все единички вниз, остальное вверх
    for j = 1:size 
            if a(size+1-i,j) > a(size-i,j) && a(size-i,j) == 1
                [a(size-i,j),a(size+1-i,j)] = deal(a(size+1-i,j),a(size-i,j)); % "deal" меняет местами значения
            end
    end
end
end

for i = 1:size-1 % ход вверх
    for j = 1:size 
            if a(i,j) == a(i+1,j) && a(i,j) ~= 1 
                a(i,j) = a(i,j)+a(i+1,j);
                for temp = i+1:size
                    c(temp) = a(temp,j);
                end
                    c = circshift(c,-1,2); % "circshift" сдвигает массив в выбранное направление
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
for i = 1:size-1 % все единички наверх, остальное вниз
    for j = 1:size 
            if a(i,j) > a(i+1,j) && a(i+1,j) == 1
                [a(i,j),a(i+1,j)] = deal(a(i+1,j),a(i,j)); % "deal" меняет местами значения
            end
    end
end
end    

for i = 1:size-1 % ход вниз
    for j = 1:size 
            if a(size-i+1,j) == a(size-i,j) && a(size-i,j) ~= 1 
                a(size-i+1,j) = a(size-i+1,j)+a(size-i,j);
                for temp = i:size-1
                    c(temp-i+1) = a(temp-i+1,j);
                end
                    c = circshift(c,1,2); % "circshift" сдвигает массив в выбранное направление
                for temp = i:size-1
                    a(temp-i+1,j) = c(temp-i+1);
                end
                c = [];
                a(1,j) = 1;
            end           
    end  
end  
end
check_board_emptiness = zeros(1,size*size); % доска из 0 - пусто, 1 - занято
if a == old_a
%         return % выходим из функции
    do_nothing = true;
end

    for check_board_x = 1:size
        for check_board_y = 1:size
            if a(check_board_x,check_board_y) == 1 % проверка на пустоту
                check_board_emptiness((check_board_x-1)*size+check_board_y) = ((check_board_x-1)*size+check_board_y); % записываем номера с пустыми клетками в массив          
            end
        end
    end
    
    lose = 0;
    lose_check_hor = 1;
    lose_check_vert = 1;
    for lose_check = 1:size*size % проверка на поражение
        if check_board_emptiness(lose_check) ~= 0
            lose = lose+1; 
        end
    end
    for lose_check_hor_x = 1:size
        for lose_check_hor_y = 1:size-1
            if a(lose_check_hor_x,lose_check_hor_y) == a(lose_check_hor_x,lose_check_hor_y+1)
                lose_check_hor = 0;
            end
        end
    end
    for lose_check_vert_x = 1:size-1
        for lose_check_vert_y = 1:size
            if a(lose_check_vert_x,lose_check_vert_y) == a(lose_check_vert_x+1,lose_check_vert_y)
                lose_check_vert = 0;    
            end
        end
    end
    if lose == 0 && lose_check_hor == 1 && lose_check_vert == 1
                victory_sign.String = '';
                loser_sign.String = 'LOSER LOSER LOSER LOSER LOSER LOSER';
                
%                 start_game.Visible = 'on';
    end
       
   
if do_nothing == false   
    delete(numbers); % удаляем старые числа
    
for i = 1:size % рисуем новые числа
    for j = 1:size
        if a(size+1-i,j) ~= 1
        color_of_number = log2(a(size+1-i,j)); % степень двойки
            rank_of_number = floor(log10(a(size+1-i,j)))+1; % кол-во цифр в числах +1
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


    counter = 0; % счетчик
    for check_board = 1:size*size % кладем номера пустых клеток в одномерный массив
        if check_board_emptiness(check_board) ~= 0
            counter = counter+1; % кол-во пустых клеток
        end
    end
    new_square = new_number_value(randi([1 4])); % новое число после хода
    check_board_emptiness = sort(check_board_emptiness,2,'descend'); % сортируем в обратном порядке(чтобы нули были в конце)
    number_of_empty_space = randi([1 counter]); % выбираем номер в списке номеров с пустыми клетками
    new_number = check_board_emptiness(number_of_empty_space); % номер клетки, где появится новое число
    new_number_coord(1) = floor((new_number-1)/size)+1; % считаем координаты для номера клетки с новым числом
    new_number_coord(2) = new_number-(new_number_coord(1)-1)*size;
    a(new_number_coord(1),new_number_coord(2)) = new_square; % добавление числа в рандомное пустое место
    
    if new_square == 2 
    numbers(size-new_number_coord(1)+1,new_number_coord(2)) = text((new_number_coord(2)-1)*size,14-(new_number_coord(1)-1)*size,...
        num2str(a(new_number_coord(1),new_number_coord(2))),'Color',[1 0.5 0.5],'FontSize',480/size); % рисуем новое число
    elseif new_square == 4
    numbers(size-new_number_coord(1)+1,new_number_coord(2)) = text((new_number_coord(2)-1)*size,14-(new_number_coord(1)-1)*size,...
        num2str(a(new_number_coord(1),new_number_coord(2))),'Color',[1 0 0],'FontSize',480/size); % рисуем новое число    
    end
    points = points+2;
    points_value.String = num2str(points);
end
    check_board_emptiness = zeros(1,size*size);
    if do_nothing == true
    do_nothing = false;
    end

    for i = 1:size
        for j = 1:size
            if a(i,j) == 2048 && lose ~= 0
                victory_sign.String = 'VICTORY!!!!!!!!!! :)';
            end
        end
    end

end

    function undo(~,~)
        undo_button.Enable = 'off';
        delete(numbers)
        points = points - 2;
        points_value.String = num2str(points);
        a = old_a;
        for i = 1:size % рисуем числа
            for j = 1:size
                if a(size+1-i,j) ~= 1
            color_of_number = log2(a(size+1-i,j)); % степень двойки
            rank_of_number = floor(log10(a(size+1-i,j)))+1; % кол-во цифр в числах +1
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

    function restart_game_2048(~,~)
if game_difficulty.Value == 2
    undo_button.Visible = 'off';
elseif game_difficulty.Value == 1
    undo_button.Visible = 'on';
end
    undo_button.Enable = 'off';
        loser_sign.String = '';
        delete(numbers)
        points = 0;
        points_value.String = num2str(0);
        a = ones(size);
        new_square = new_number_value(randi([1 4])); % новое число после хода
        start_random = randi([1 size*size]); % выбираем номер клетки, где появится первое число
start_coord(1) = floor((start_random-1)/size)+1; % считаем координаты для номера клетки с первым числом
start_coord(2) = start_random-(start_coord(1)-1)*size;
a(start_coord(1),start_coord(2)) = new_square; % добавление числа в рандомное пустое место

color_value = [1 0.5 0.5;1 0 0;1 1 0.5;1 1 0;0.5 1 0.5;0.5 1 0;0 1 0.5;0.5 1 1;0 1 1;0 0.5 1;1 0.5 1;0.5 0.5 1;0.5 0 0.5;0.5 0.5 0;0 0 0];
for i = 1:size % рисуем числа
    for j = 1:size
                if a(size+1-i,j) ~= 1
        color_of_number = log2(a(size+1-i,j)); % степень двойки
            rank_of_number = floor(log10(a(size+1-i,j)))+1; % кол-во цифр в числах +1
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

