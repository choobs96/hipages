-- QUESTION 1 - The names and the number of messages sent by each user
SELECT
  u.UserID,
  u.Name,
  COUNT(DISTINCT m.MessageID) AS message_count
FROM Users u
LEFT JOIN Messages m
  ON m.UserIDSender = u.UserID
GROUP BY u.UserID, u.Name
ORDER BY message_count DESC;


-- QUESTION 2 - The total number of messages sent stratified by weekday
SELECT
  DAYOFWEEK(m.DateSent) AS weekday_ord,  -- 1=Sun .. 7=Sat
  DAYNAME(m.DateSent) AS weekday_name,
  COUNT(DISTINCT MessageID) AS total_messages
FROM Messages m
GROUP BY weekday_ord, weekday_name
ORDER BY weekday_ord;

-- QUESTION 3 -  The most recent message from each thread that has no response yet
SELF JOIN TO GET MESSAGES WITH LATER REPLIES 
WITH LaterReplies AS (
  SELECT DISTINCT m.MessageID -- to remove duplicates
  FROM Messages m
  JOIN Messages r
    ON r.ThreadID = m.ThreadID
  AND r.UserIDSender = m.UserIDRecipient     -- recipient replied (condition 1: sender = receipient)
  AND r.UserIDRecipient = m.UserIDSender        -- back to sender  (condition 2: receipient = sender)
  WHERE 
        (r.DateSent > m.DateSent) -- the date of replies must be later
        OR (r.DateSent = m.DateSent AND r.MessageID > m.MessageID)  -- tie-break in case same time
),
Unresponded AS ( -- as long as messageID exist in later replies it will get filtered out.
  SELECT m.*
  FROM Messages m
  LEFT JOIN LaterReplies lr
    ON lr.MessageID = m.MessageID
  WHERE lr.MessageID IS NULL
)
,
Ranked AS ( -- there might be cases where two different messageID are unreplied so this will catch the latest within a thread
  SELECT
    u.*,
    ROW_NUMBER() OVER (
      PARTITION BY u.ThreadID
      ORDER BY u.DateSent DESC, u.MessageID DESC
    ) AS rn
  FROM Unresponded u
)


SELECT
  t.ThreadID,
  t.Subject,
  r.MessageID,
  r.MessageContent,
  r.DateSent,
  s.Name  AS SenderName,
  rc.Name AS RecipientName
FROM Ranked r
JOIN Threads t ON t.ThreadID = r.ThreadID
JOIN Users s ON s.UserID = r.UserIDSender
JOIN Users rc ON rc.UserID = r.UserIDRecipient
WHERE r.rn = 1;

-- QUESTION 4 - For the conversation with the most messages: all user data and message contents ordered chronologically so one can follow the whole conversation
WITH thread_counts AS (
  SELECT ThreadID, COUNT(DISTINCT MessageID) AS msg_count
  FROM Messages
  GROUP BY ThreadID
),
top_thread AS (
  SELECT ThreadID
  FROM thread_counts
  ORDER BY msg_count DESC, ThreadID
  LIMIT 1
)
SELECT
  t.ThreadID,
  t.Subject,
  m.MessageID,
  m.DateSent,
  s.UserID  AS SenderID,
  s.Name    AS SenderName,
  r.UserID  AS RecipientID,
  r.Name    AS RecipientName,
  m.MessageContent
FROM Messages m
JOIN top_thread tt ON tt.ThreadID = m.ThreadID
JOIN Threads t ON t.ThreadID  = m.ThreadID
JOIN Users s ON s.UserID    = m.UserIDSender
JOIN Users r ON r.UserID    = m.UserIDRecipient
ORDER BY m.DateSent ASC, m.MessageID ASC;