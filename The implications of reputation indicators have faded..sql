/* Rank by follower's SP sum */

SELECT TOP 1000 N_ame =  F.following, Follower_SP = SUM(CONVERT(FLOAT,LEFT(SubString(A.vesting_shares, PatIndex('%[0-9]%', A.vesting_shares), LEN(A.vesting_shares)),PatIndex('%[^0-9]%', SubString(A.vesting_shares, PatIndex('%[0-9]%', A.vesting_shares),  LEN(A.vesting_shares)))-1 ))) * 497.66528369215 / 1000000
FROM Accounts AS A INNER JOIN Followers AS F ON A.name = F.follower
WHERE CONVERT(FLOAT,LEFT(SubString(A.vesting_shares, PatIndex('%[0-9]%', A.vesting_shares), LEN(A.vesting_shares)),PatIndex('%[^0-9]%', SubString(A.vesting_shares, PatIndex('%[0-9]%', A.vesting_shares),  LEN(A.vesting_shares)))-1 )) > 2000
GROUP BY F.following
ORDER BY Follower_SP DESC

/* Rank by reputation score */

SELECT TOP 2000 name, reputation
FROM Accounts
WHERE CONVERT(FLOAT,LEFT(SubString(vesting_shares, PatIndex('%[0-9]%', vesting_shares), LEN(vesting_shares)),PatIndex('%[^0-9]%', SubString(vesting_shares, PatIndex('%[0-9]%', vesting_shares),  LEN(vesting_shares)))-1 )) > 2000
ORDER BY reputation DESC

/* follower's SP sum of "Ned" */

SELECT N_ame = F.following, Follower_SP = SUM(CONVERT(FLOAT,LEFT(SubString(A.vesting_shares, PatIndex('%[0-9]%', A.vesting_shares), LEN(A.vesting_shares)),PatIndex('%[^0-9]%', SubString(A.vesting_shares, PatIndex('%[0-9]%', A.vesting_shares),  LEN(A.vesting_shares)))-1 ))) * 497.66528369215 / 1000000
FROM Accounts AS A INNER JOIN Followers AS F ON A.name = F.follower
WHERE CONVERT(FLOAT,LEFT(SubString(A.vesting_shares, PatIndex('%[0-9]%', A.vesting_shares), LEN(A.vesting_shares)),PatIndex('%[^0-9]%', SubString(A.vesting_shares, PatIndex('%[0-9]%', A.vesting_shares),  LEN(A.vesting_shares)))-1 )) > 2000
AND F.following = 'ned'
GROUP BY F.following
ORDER BY Follower_SP DESC
