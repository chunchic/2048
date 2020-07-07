% 1) придумать, как сделать больше цветов(>7) - DONE!
% 2) поменять кнопки на экране на клаву - DONE!
% 3) изменить размер больших чисел - DONE!
% 4) сделать разные режимы игры(кнопку undo и без нее) - DONE!
% 5) уменьшить кол-во однообразного кода - DONE!
% 6) сделать спаун для цифры 4(шанс выпадения 25%) - DONE!
% 7) сделать конец игры - DONE!
% 8) сделать победу(дошел до 2048) - DONE!
% 9) добавить музыку при нажатии на start - гимн ссср :D - DONE!
% 10) SUPERHARD: выбор размера доски перед нажатием на start
% 11) кнопка RESTART - DONE!
% 12) SUPERHARD: сохранять рекорды (отдельно для каждого режима) - DONE!(только без undo)
% 13) сделать кнопку undo - DONE!
% 14) кнопку на тулбаре для очистки рекордов(чтобы выдавало предупреждение
% - "are u sure u wanna delete all your scores?)" - DONE!
% 15) кнопку на тулбаре для отключния музыки(гимна) - DONE!

function game_2048_finishing_toolbar_version_9
global old_a
global score
global name
global record_check
f = figure('units', 'pixels', 'outerposition', [100 100 660 650], 'menubar', 'none'); 
toolbar = uitoolbar(f);
[img,map] = imread(fullfile(matlabroot,...
        'toolbox','matlab','icons','file_new.png'));        
p = uipushtool(toolbar,'TooltipString','Start',...
        'ClickedCallback',@start_game_2048, 'CData', double(img)/65536);
    
difficulty_sign = uicontrol('units', 'pixels', 'style', 'text', 'position', [20 525 300 30], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 15,'visible','on','string', 'choose the game difficulty :)', 'userdata', 'victory_sign');
game_difficulty = uicontrol('units', 'pixels', 'style', 'popupmenu', 'position', [20 500 150 20], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 15,'visible','on','string',...
     {'noob :(';'more than a noob :)'},'userdata', 'difficulty');
enter_your_name_sign = uicontrol('units', 'pixels', 'style', 'text', 'position', [20 400 300 30], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 15,'visible','on','string', 'enter your name, mortal', 'userdata', 'enter_your_name_sign');
enter_your_name = uicontrol('units', 'pixels', 'style', 'edit', 'position', [20 350 300 30], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 15,'visible','on','string', '', 'userdata', 'name');
[img,map] = imread(fullfile(matlabroot,...
        'toolbox','matlab','icons','tool_text_justify.png'));        
records_toolbar = uipushtool(toolbar,'TooltipString','Highscores',...
        'ClickedCallback',@open_records, 'CData', double(img)/65536);       
record_check = 0;
   
function start_game_2048(~,~)
[img,map] = imread(fullfile(matlabroot,...
        'toolbox','matlab','icons','help_gs.png'));        
anthem_toolbar = uipushtool(toolbar,'TooltipString','Restart anthem',...
        'ClickedCallback',@restart_anthem, 'CData', double(img)/65536);
    
[img,map] = imread(fullfile(matlabroot,...
        'toolbox','matlab','icons','help_gs.png'));        
stop_anthem_toolbar = uipushtool(toolbar,'TooltipString','Stop anthem',...
        'ClickedCallback',@stop_anthem, 'CData', double(img)/65536);
    
name = enter_your_name.String;
p.ClickedCallback = @restart_game_2048;
p.TooltipString = 'Restart';
difficulty_sign.Visible = 'off';
game_difficulty.Position = [550 250 90 40];
enter_your_name.Visible = 'off';
enter_your_name_sign.Visible = 'off';

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
% a = [8192 4096 2048 1024;64 128 256 512;32 16 8 4;2 2 1 1]; % для проверки победы 
% a = [32 64 32 8;2 1024 128 64;2 32 512 256;2 128 4096 1024]; % для проверки поражения
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

% anthem_filename = 'anthem.wav';
% [y,Fs] = audioread(anthem_filename);
% play_anthem = audioplayer(y,Fs);
% play(play_anthem);

function move(hObject,~)
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
                save_records();
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
    score = str2num(points_value.String);
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
        score = str2num(points_value.String);
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
        
record_check = 0;
if game_difficulty.Value == 2
    undo_button.Visible = 'off';
elseif game_difficulty.Value == 1
    undo_button.Visible = 'on';
end

        loser_sign.String = '';
        delete(numbers)
        points = 0;
        points_value.String = num2str(0);
        a = ones(size);
%         a = [8192 4096 2048 1024;64 128 256 512;32 16 8 4;2 2 1 1]; % для проверки победы 
%         a = [32 64 32 8;2 1024 128 64;2 32 512 256;2 128 4096 1024]; % для проверки поражения
        new_square = new_number_value(randi([1 4])); % новое число после хода
        start_random = randi([1 size*size]); % выбираем номер клетки, где появится первое число
start_coord(1) = floor((start_random-1)/size)+1; % считаем координаты для номера клетки с первым числом
start_coord(2) = start_random-(start_coord(1)-1)*size;
a(start_coord(1),start_coord(2)) = new_square; % добавление числа в рандомное пустое место

anthem_filename = 'C:\Users\chunchic\Document\ФЭФ\семестр 7\game_2048\anthem.wav';
[y,Fs] = audioread(anthem_filename);
play_anthem = audioplayer(y,Fs);
play(play_anthem);

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
%         function restart_anthem(~,~) 
%             anthem_filename = 'C:\Users\chunchic\Document\ФЭФ\семестр 7\game_2048\anthem.wav';
%             [y,Fs] = audioread(anthem_filename);
%             play_anthem = audioplayer(y,Fs);
%             play(play_anthem);
%         end
%         
%     function stop_anthem(~,~)
%         stop(play_anthem);
%     end
end

    function open_records(~,~)
     records_file = fopen('C:\Users\chunchic\Document\ФЭФ\семестр 7\game_2048\records_names_of_pros.txt'); % открываем файл
     names = textscan(records_file,'%s', 'Delimiter','\n'); % читаем файл
     fclose(records_file); % закрываем файл
        
     records_file = fopen('C:\Users\chunchic\Document\ФЭФ\семестр 7\game_2048\records_values_of_pros.txt'); % открываем файл
     values = textscan(records_file,'%s', 'Delimiter','\n'); % читаем файл
     fclose(records_file); % закрываем файл

     records_figure = figure('units', 'pixels', 'outerposition', [100 100 600 600], 'menubar', 'none');
     records_number = uicontrol('units','pixels', 'style', 'text', 'fontsize', 15, 'position', [10 50 50 430], 'userdata', 'records_number');
     records_names = uicontrol('units','pixels', 'style', 'text', 'fontsize', 15, 'position', [75 50 250 430], 'userdata', 'records_names');
     records_values = uicontrol('units','pixels', 'style', 'text', 'fontsize', 15, 'position', [270 50 350 430], 'userdata', 'records_values');
     records_number_sign = uicontrol('units','pixels', 'style', 'text', 'fontsize', 20, 'string', '№', 'position', [10 480 50 40], 'userdata', 'records_number_sign');
     records_names_sign = uicontrol('units','pixels', 'style', 'text', 'fontsize', 20, 'string', 'NAMES', 'position', [75 480 250 40], 'userdata', 'records_names_sign');
     records_values_sign = uicontrol('units','pixels', 'style', 'text', 'fontsize', 20, 'string', 'SCORE', 'position', [270 480 350 40], 'userdata', 'records_values_sign');
     records_difficulty_sign = uicontrol('units','pixels', 'style', 'text', 'fontsize', 20, 'string', 'NOT NOOBZ', 'position', [75 540 350 30], 'userdata', 'records_difficulty_sign');
     delete_records_button = uicontrol('units','pixels', 'style', 'pushbutton', 'fontsize', 15, 'string', 'delete records', 'position', [400 20 150 30], 'userdata', 'delete_records', 'callback', @delete_records);
     
     value_num = str2num(char(values{1}));
     sorted_value = sort(value_num,'descend');
     records_values.String = sorted_value; % записываем очки в окно
     temp_num = zeros(length(value_num),1);
     for i = 1:length(value_num)
        for j = 1:length(value_num)
           if sorted_value(i) == value_num(j)
               temp_num(i) = j; % чтобы отсортировать имена соответственно по кол-ву очков
               value_num(j) = 1; % при одинаковых очках temp_num должен пропускать то, которое уже проверил
               break
           end
        end
     end
     % не пашет с одинаковыми очками. ПРОВЕРИТЬ. ИСПРАВИТЬ
    names_cell = cell(length(value_num),1);
    for i = 1:length(value_num)
        names_cell(i) = names{1}(temp_num(i));
    end
    records_names.String = names_cell; % записываем имена в окно
    
    number = 1:length(value_num);
    records_number.String = number;   
    
    function delete_records(~,~)
        button = questdlg('Are you sure?','Delete Records','Yes','No','No'); % последний No - дефаут
        switch button
        case 'Yes',
            emptiness = '';
            deletion = fopen('C:\Users\chunchic\Document\ФЭФ\семестр 7\game_2048\records_names_of_pros.txt','w'); % открываем файл(%w для записи)
            fprintf(deletion,emptiness);
            fclose(deletion);
            
            deletion = fopen('C:\Users\chunchic\Document\ФЭФ\семестр 7\game_2048\records_values_of_pros.txt','w'); % открываем файл(%w для записи)
            fprintf(deletion,emptiness);
            fclose(deletion);
            
            close(records_figure)
        case 'No',           
        end
    end    
    end

    % если имя пустое, не сохранять
    function save_records(~,~) % не получается
        if game_difficulty.Value == 2
        if record_check == 0
            record_check = 1; % чтобы не сохранялось по несколько раз
            
        records_file = fopen('C:\Users\chunchic\Document\ФЭФ\семестр 7\game_2048\records_names_of_pros.txt');
        names_cell = textscan(records_file,'%s', 'Delimiter','\n');
        fclose(records_file); % закрываем файл
        
        names_cell{1}(length(names_cell{1})+1) = cellstr(name); % записываем имя в еще одну клетку
        names_char = char(names_cell{1});       
        
        records_file = fopen('C:\Users\chunchic\Document\ФЭФ\семестр 7\game_2048\records_names_of_pros.txt','w'); % открываем файл(%w для записи)         
        for i = 1:size(names_char,1)
            for j = 1:size(names_char,2)
                fprintf(records_file, '%c', names_char(i,j)); % записываем в файл (имя кол-во очков) 
            end
            fprintf(records_file,'\n');
        end
        fclose(records_file); % закрываем файл   
        

        records_file = fopen('C:\Users\chunchic\Document\ФЭФ\семестр 7\game_2048\records_values_of_pros.txt'); % открываем файл
        score_cell = textscan(records_file,'%s', 'Delimiter','\n');
        fclose(records_file);
        
        score_cell{1}(length(score_cell{1})+1) = cellstr(num2str(score));
        score_num = str2num(char(score_cell{1})); 
        
        records_file = fopen('C:\Users\chunchic\Document\ФЭФ\семестр 7\game_2048\records_values_of_pros.txt','w'); % открываем файл(%w для записи) 
        for i = 1:length(score_num)
            fprintf(records_file, '%d', score_num(i)); % записываем в файл (имя кол-во очков) 
            fprintf(records_file,'\n');
        end
        end
        end
    end
end

