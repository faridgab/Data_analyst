# Построение витрины дашбордов на основе Tableau

## Задача

На основе данных пользовательского взаимодействия с карточками статей необходимо построить витрину дашбордов

Витрина: 
o	История событий по темам карточек (два графика - абсолютные числа и процентное соотношение);
o	Разбивка событий по темам источников;
o	Таблица соответствия тем источников темам карточек;

## Данные

•	Источники данных для дашборда: дата-инженеры обещали подготовить для вас агрегирующую таблицу dash_visits. Вот её структура: 
o	record_id — первичный ключ,
o	item_topic — тема карточки,
o	source_topic — тема источника,
o	age_segment — возрастной сегмент,
o	dt — дата и время,
o	visits — количество событий.


## Испульзуем: 

*pandas, PostgreSQL, Tableau*

## Итоги 

Был построены три даш-борда и сделаны выводы по взаимодействию пользователей с карточками Яндекс.Дзен

## Статус:

Проект выполнен.
