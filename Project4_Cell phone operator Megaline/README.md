# Определение перспективного тарифа для телеком-компании

## Данные

Пять файлов, предоставленных заказчиком: 
- users (данные 500 пользователей заказчика: кто они, откуда, каким тарифом пользуются), 
- tariffs (данные о тарифных планах заказчика), 
- calls (информация о совершенных пользователями звонках в течение года), 
- internet (данные о пользовательском трафике за тот же срок),
- messeges (информация об отправленных  в течение года SMS .

## Задача

Необходимо провести анализ пользовательского поведения и определить, какой тариф (из двух существующих) прибыльнее с точки зрения компании. 
Для ответа на этот вопрос будут проверены две гипотезы:

* средняя выручка пользователей тарифов «Ультра» и «Смарт» различаются;
* средняя выручка пользователей из Москвы отличается от выручки пользователей из других регионов.

## Используемые библиотеки

*pandas, scipy, numpy, matplotlib, seaborn*

## Итоги исследования

1. Средняя длительность разговоров у абонентов тарифа Ultra больше, чем у абонентов тарифа Smart. В течение года пользователи обоих тарифов увеличивают среднюю продолжительность своих разговоров. Рост средней длительности разговоров у абонентов тарифа Smart равномерный в течение года. Пользователи тарифа Ultra не проявляют подобной линейной стабильности. Стоит отметить, что феврале у абонентов обоих тарифных планов наблюдались самые низкие показатели.
2. В среднем количество сообщений пользователи тарифа Ultra отправляют больше - почти на 20 сообщений больше, чем пользователи тарифа Smart. Количество сообщений в течение года на обоих тарифак растет. Динамика по отправке сообщений схожа с тенденциями по длительности разговоров: в феврале отмечено наименьшее количество сообщений за год и пользователи тарифа Ultra также проявляют нелинейную полодительную динамику.
3. Меньше всего пользователи использовали интернет в январе, феврале и апреле. Чаще всего абоненты тарифа Smart тратят 15-17 Гб, а абоненты тарифного плана Ultra - 19-21 ГБ.

## Статус:

Проект выполнен.
