--Question a
SELECT p.Name AS PropertyName
FROM [dbo].[Property] AS p
INNER JOIN [dbo].[OwnerProperty] AS op
ON p.Id = op.PropertyId
WHERE op.OwnerId = '1426'

--Question b
SELECT p.Name AS PropertyName, phv.Value AS PropertyValue
FROM [dbo].[Property] AS p
INNER JOIN [dbo].[OwnerProperty] AS op
ON p.Id = op.PropertyId
INNER JOIN [dbo].[PropertyHomeValue] AS phv
ON p.Id = phv.PropertyId
WHERE op.OwnerId = '1426' AND phv.HomeValueTypeId = '1' AND phv.IsActive = '1'

--Question c-i
SELECT p.Name AS PropertyName, tpf.Name AS PaymentFrequency, tp.PaymentAmount, tp.StartDate, tp.EndDate,
CASE WHEN tpf.Name = 'Weekly' THEN SUM(tp.PaymentAmount * DATEDIFF(WEEK, tp.StartDate, tp.EndDate))
WHEN tpf.Name = 'Fortnightly' THEN SUM(tp.PaymentAmount * DATEDIFF(WEEK, tp.StartDate, tp.EndDate) / 2)
ELSE SUM(tp.PaymentAmount * (DATEDIFF(MONTH, tp.StartDate, tp.EndDate) + 1)) 
END AS TotalPaymentAmount
FROM [dbo].[Property] AS p
INNER JOIN [dbo].[OwnerProperty] AS op
ON p.Id = op.PropertyId
INNER JOIN [dbo].[TenantProperty] AS tp
ON p.Id = tp.PropertyId
INNER JOIN [dbo].[TenantPaymentFrequencies] AS tpf
ON tp.PaymentFrequencyId = tpf.Id
WHERE op.OwnerId = '1426'
GROUP BY tpf.Name, p.Name, tp.PaymentAmount, tp.StartDate, tp.EndDate

--Question c-ii

SELECT p.Name AS PropertyName, pf.Yield
FROM [dbo].[Property] AS p
INNER JOIN [dbo].[OwnerProperty] AS op
ON p.Id = op.PropertyId
INNER JOIN [dbo].[PropertyFinance] AS pf
ON p.Id = pf.PropertyId
WHERE op.OwnerId = '1426'

--Question d
SELECT j.Id, ProviderId, PropertyId, OwnerId, PaymentAmount, JobStartDate, JobEndDate, JobDescription, JobStatusId, js.Status AS JobStatus, UpdatedBy, CreatedOn, CreatedBy, UpdatedOn, MaxBudget, PercentDone, Note, AcceptedQuote, OwnerUpdate, ServiceUpdate, JobRequestId
FROM [dbo].[Job] AS j
LEFT JOIN [dbo].[JobStatus] AS js
ON j.JobStatusId = js.Id
WHERE js.Status = 'Open'

--Question e
SELECT p.Name AS PropertyName, ps.FirstName, ps.LastName, tp.PaymentAmount, tpf.Name AS PaymentFrequency
FROM [dbo].[Property] AS p
INNER JOIN [dbo].[OwnerProperty] AS op
ON p.Id = op.PropertyId
INNER JOIN [dbo].[TenantProperty] AS tp
ON p.Id = tp.PropertyId
INNER JOIN [dbo].[Person] AS ps
ON tp.TenantId = ps.Id
INNER JOIN [dbo].[TenantPaymentFrequencies] AS tpf
ON tp.PaymentFrequencyId = tpf.Id
WHERE op.OwnerId = '1426'


--Expence Report
SELECT pe.Description AS Expense, CAST(pe.Amount AS INT), CONCAT(a.Number, ' ', a.Street) AS Address, CAST(pe.Date AS DATE) AS Date, ps.FirstName AS CurrentOwner, p.Bedroom, p.Bathroom, tpf.Name AS Frequency
FROM [dbo].[Property] AS p
INNER JOIN [dbo].[OwnerProperty] AS op
ON p.Id = op.PropertyId
INNER JOIN [dbo].[Person] AS ps
ON op.OwnerId = ps.Id
INNER JOIN [dbo].[PropertyExpense] AS pe
ON p.Id = pe.PropertyId
INNER JOIN [dbo].[Address] AS a
ON p.AddressId = a.AddressId
INNER JOIN [dbo].[PropertyRentalPayment] AS prp
ON p.Id = prp.PropertyId
INNER JOIN [dbo].[TenantPaymentFrequencies] AS tpf
ON prp.FrequencyType = tpf.Id
WHERE p.Name = 'Property A'