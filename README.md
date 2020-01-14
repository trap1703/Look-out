# Look-out
Впередсмотрящий — дежурный матрос на носу корабля, наблюдающий за горизонтом.
------------------------------------------------------------------------------
Данный софт написан для облегчения жизни системных администраторов и 
инженеров технической поддержки в их повседневной работе.
Я как автор программы даю право на использование в личных и рабочих целях.
Программа для мониторинга доступности критичных узлов сети.
Возможно отслеживание до 30 узлов. Узлы перечисляются в файле Hostlist.ini.
Формат файла крайне прост и содержит пример заполнения.
В файле setup.ini содержаться три настройки
timeout:300 - время в милисекундах превышение которого считается потерей пакета
counter:3 - количество пакетов в одном цикле проверки
countlos:2 - количество потерянных пакетов в одном цикле проверки для принятия решения "Тревога"
В случае возникновения потери связи события пишуться в лог-файл PINGLog.txt
Звук тревоги содержит файл ALARM.wav - можно поставить свой звук в формате wav.
Все предложения и замечания а так же жалобы  и благодарности могут быть приняты здесь: trap1703@gmail.com
===============================================================================
The forward looking one is a sailor on duty at the bow of the ship, watching the horizon.
-------------------------------------------------- ----------------------------
This software is written to make life easier for system administrators and
technical support engineers in their daily work.
I, as the author of the program, give the right to use for personal and work purposes.
The program for monitoring the availability of critical network nodes.
Tracking up to 30 nodes is possible. Nodes are listed in the Hostlist.ini file.
The file format is extremely simple and contains an example of filling.
The setup.ini file contains three settings
timeout: 300 - time in milliseconds, the excess of which is considered a packet loss
counter: 3 - the number of packets in one scan cycle
countlos: 2 - the number of lost packets in one scan cycle for making the decision "Alarm"
In the event of a loss of communication events are written to the log file PINGLog.txt
The alarm sound contains the ALARM.wav file - you can set your own sound in wav format.
All suggestions and comments as well as complaints and gratitude can be accepted here: trap1703@gmail.com
