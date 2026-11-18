USE IT_ServiceCenter_Practice;
GO

-- ============================================================
-- Домашнее задание: 10 SQL-запросов
-- База данных: IT_ServiceCenter_Practice
-- ============================================================

-- Запрос 1. Полный список заявок
-- Выводим номер заявки, описание, дату создания и стоимость.
-- Сортировка от новых заявок к старым.
SELECT RequestId, [Description], CreatedAt, Cost
FROM ServiceRequests
ORDER BY CreatedAt DESC;
GO

-- Запрос 2. Новые заявки
-- Название статуса получаем из таблицы RequestStatuses через JOIN.
SELECT sr.RequestId, sr.[Description], sr.CreatedAt
FROM ServiceRequests AS sr
INNER JOIN RequestStatuses AS rs ON sr.StatusId = rs.StatusId
WHERE rs.StatusName = N'Новая';
GO

-- Запрос 3. Дорогие сетевые обращения
-- Заявки категории "Сеть" со стоимостью больше 1000 рублей.
SELECT sr.RequestId, sr.[Description], sr.Cost, c.CategoryName
FROM ServiceRequests AS sr
INNER JOIN Categories AS c ON sr.CategoryId = c.CategoryId
WHERE c.CategoryName = N'Сеть' AND sr.Cost > 1000;
GO

-- Запрос 4. Поиск по фрагменту текста
-- Ищем слово "принтер" в любой части описания.
SELECT RequestId, [Description], CreatedAt
FROM ServiceRequests
WHERE [Description] LIKE N'%принтер%';
GO

-- Запрос 5. Подробный отчёт по заявкам
-- LEFT JOIN с Employees: заявки без назначенного сотрудника тоже попадают в результат.
SELECT
    sr.RequestId,
    cl.FullName AS ClientName,
    cat.CategoryName,
    sr.[Description],
    st.StatusName,
    e.FullName AS EmployeeName,
    sr.Cost
FROM ServiceRequests AS sr
INNER JOIN Clients AS cl ON sr.ClientId = cl.ClientId
INNER JOIN Categories AS cat ON sr.CategoryId = cat.CategoryId
INNER JOIN RequestStatuses AS st ON sr.StatusId = st.StatusId
LEFT JOIN Employees AS e ON sr.EmployeeId = e.EmployeeId;
GO

-- Запрос 6. Заявки без назначенного сотрудника
SELECT sr.RequestId, sr.[Description], sr.CreatedAt, cl.FullName AS ClientName
FROM ServiceRequests AS sr
INNER JOIN Clients AS cl ON sr.ClientId = cl.ClientId
WHERE sr.EmployeeId IS NULL
ORDER BY sr.CreatedAt;
GO

-- Запрос 7. Количество заявок по статусам
SELECT st.StatusName, COUNT(*) AS RequestsCount
FROM ServiceRequests AS sr
INNER JOIN RequestStatuses AS st ON sr.StatusId = st.StatusId
GROUP BY st.StatusName
ORDER BY RequestsCount DESC;
GO

-- Запрос 8. Анализ стоимости по категориям
-- Только категории со средней стоимостью выше 1000 рублей.
SELECT
    c.CategoryName,
    AVG(sr.Cost) AS AvgCost,
    MAX(sr.Cost) AS MaxCost
FROM ServiceRequests AS sr
INNER JOIN Categories AS c ON sr.CategoryId = c.CategoryId
GROUP BY c.CategoryName
HAVING AVG(sr.Cost) > 1000;
GO

-- Запрос 9. Клиенты с несколькими обращениями
-- Не менее двух заявок, сортировка по количеству по убыванию.
SELECT cl.FullName, COUNT(sr.RequestId) AS RequestsCount
FROM Clients AS cl
INNER JOIN ServiceRequests AS sr ON cl.ClientId = sr.ClientId
GROUP BY cl.FullName
HAVING COUNT(sr.RequestId) >= 2
ORDER BY RequestsCount DESC;
GO

-- Запрос 10. Клиенты без заявок
-- LEFT JOIN + IS NULL: клиенты, у которых нет ни одной заявки.
SELECT cl.FullName, cl.City
FROM Clients AS cl
LEFT JOIN ServiceRequests AS sr ON cl.ClientId = sr.ClientId
WHERE sr.RequestId IS NULL;
GO
