/* Daily voting trend of @busy.pay */

SELECT Date = CONVERT(CHAR(10), timestamp, 23), 
	   Votes = COUNT(author),
	   Authors = COUNT(DISTINCT(author)),
	   Daily_used_Voting_weight = SUM(weight)
	   Average_weight_per_post = SUM(weight) / COUNT(author)
FROM TxVotes
WHERE voter = 'busy.pay' AND CONVERT(CHAR(10), timestamp, 23) BETWEEN '2018-01-01' AND '2019-02-23'
GROUP BY CONVERT(CHAR(10), timestamp, 23)
ORDER BY Date ASC

/* Actual curation yield analysis (Incl. @busy.pay) */

/* Effective_SP */

SELECT [name], Effective_SP = ( CONVERT(FLOAT, LEFT(vesting_shares, CHARINDEX(' ',(vesting_shares))-1))
+ CONVERT(FLOAT, LEFT(received_vesting_shares, CHARINDEX(' ',(received_vesting_shares))-1))
- CONVERT(FLOAT, LEFT(delegated_vesting_shares, CHARINDEX(' ',(delegated_vesting_shares))-1)) ) * 498.6 / 1000000
FROM Accounts
WHERE ( CONVERT(FLOAT, LEFT(vesting_shares, CHARINDEX(' ',(vesting_shares))-1))
+ CONVERT(FLOAT, LEFT(received_vesting_shares, CHARINDEX(' ',(received_vesting_shares))-1))
- CONVERT(FLOAT, LEFT(delegated_vesting_shares, CHARINDEX(' ',(delegated_vesting_shares))-1)) ) * 498.6 / 1000000 > 50
AND name IN (SELECT DISTINCT(curator)
				FROM (
					SELECT curator, CU = SUM(CONVERT(FLOAT, LEFT(reward, CHARINDEX(' ',(reward))-1))) FROM VOCurationRewards
					WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2019-01-01' AND '2019-01-31'
					GROUP BY curator
					) AS Q
					WHERE Q.CU != 0
				)
AND name NOT IN (SELECT DISTINCT(from_account)
					FROM VOFillVestingWithdraws
					WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2018-12-25' AND '2019-02-08' AND CONVERT(FLOAT, LEFT(withdrawn, CHARINDEX(' ',(withdrawn))-1)) > 0
				)
AND name NOT IN (SELECT DISTINCT([from])
					FROM TxTransfers
					WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2018-12-25' AND '2019-02-08' AND type = 'transfer_to_vesting' AND amount > 0
				)
AND name NOT IN (SELECT DISTINCT(delegator)
					FROM TxDelegateVestingShares
					WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2018-12-25' AND '2019-02-08'
					)
AND name NOT IN (SELECT DISTINCT(delegatee)
					FROM TxDelegateVestingShares
					WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2018-12-25' AND '2019-02-08'
					)

ORDER BY [name] ASC

/* Curation SP */

SELECT curator, Curation_SP = SUM(CONVERT(FLOAT, LEFT(reward, CHARINDEX(' ',(reward))-1))) * 498.6 / 1000000
FROM VOCurationRewards
WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2019-01-01' AND '2019-01-31'
AND curator IN (SELECT DISTINCT(curator)
				FROM (
				SELECT curator, CU = SUM(CONVERT(FLOAT, LEFT(reward, CHARINDEX(' ',(reward))-1))) FROM VOCurationRewards
				WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2019-01-01' AND '2019-01-31'
				GROUP BY curator
				) AS Q
				WHERE Q.CU > 0
				)
AND curator IN (SELECT name
				FROM Accounts
				WHERE ( CONVERT(FLOAT, LEFT(vesting_shares, CHARINDEX(' ',(vesting_shares))-1))
						+ CONVERT(FLOAT, LEFT(received_vesting_shares, CHARINDEX(' ',(received_vesting_shares))-1))
						- CONVERT(FLOAT, LEFT(delegated_vesting_shares, CHARINDEX(' ',(delegated_vesting_shares))-1)) ) * 498.6 / 1000000 > 50
				)
AND curator NOT IN (SELECT DISTINCT(from_account)
					FROM VOFillVestingWithdraws
					WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2018-12-25' AND '2019-02-08' AND CONVERT(FLOAT, LEFT(withdrawn, CHARINDEX(' ',(withdrawn))-1)) > 0
					)
AND curator NOT IN (SELECT DISTINCT([from])
					FROM TxTransfers
					WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2018-12-25' AND '2019-02-08' AND type = 'transfer_to_vesting' AND amount > 0
					)
AND curator NOT IN (SELECT DISTINCT(delegator)
					FROM TxDelegateVestingShares
					WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2018-12-25' AND '2019-02-08'
					)
AND curator NOT IN (SELECT DISTINCT(delegatee)
					FROM TxDelegateVestingShares
					WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2018-12-25' AND '2019-02-08'
					)
GROUP BY curator
ORDER BY curator ASC

/* Number of votes */

SELECT voter, Number_of_Votes = COUNT(voter)
FROM TxVotes
WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2018-12-25' AND '2019-01-24'
AND voter IN (SELECT DISTINCT(curator)
				FROM (
				SELECT curator, CU = SUM(CONVERT(FLOAT, LEFT(reward, CHARINDEX(' ',(reward))-1))) FROM VOCurationRewards
				WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2019-01-01' AND '2019-01-31'
				GROUP BY curator
				) AS Q
				WHERE Q.CU > 0
				)
AND voter IN (SELECT name
				FROM Accounts
				WHERE ( CONVERT(FLOAT, LEFT(vesting_shares, CHARINDEX(' ',(vesting_shares))-1))
						+ CONVERT(FLOAT, LEFT(received_vesting_shares, CHARINDEX(' ',(received_vesting_shares))-1))
						- CONVERT(FLOAT, LEFT(delegated_vesting_shares, CHARINDEX(' ',(delegated_vesting_shares))-1)) ) * 498.6 / 1000000 > 50
				)
AND voter NOT IN (SELECT DISTINCT(from_account)
					FROM VOFillVestingWithdraws
					WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2018-12-25' AND '2019-02-08' AND CONVERT(FLOAT, LEFT(withdrawn, CHARINDEX(' ',(withdrawn))-1)) > 0
					)
AND voter NOT IN (SELECT DISTINCT([from])
					FROM TxTransfers
					WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2018-12-25' AND '2019-02-08' AND type = 'transfer_to_vesting' AND amount > 0
					)
AND voter NOT IN (SELECT DISTINCT(delegator)
					FROM TxDelegateVestingShares
					WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2018-12-25' AND '2019-02-08'
					)
AND voter NOT IN (SELECT DISTINCT(delegatee)
					FROM TxDelegateVestingShares
					WHERE CONVERT(CHAR(10), timestamp, 23) BETWEEN '2018-12-25' AND '2019-02-08'
					)
GROUP BY voter
ORDER BY voter ASC

/* For data range check */

SELECT NUMBER_VOTED = COUNT(DISTINCT(name)), SP_VOTED = SUM(CONVERT(FLOAT, LEFT(vesting_shares, CHARINDEX(' ',(vesting_shares))-1))) * 498.6 / 1000000
FROM Accounts
WHERE CONVERT(CHAR(10), last_vote_time, 23) BETWEEN '2018-12-25' AND '2019-02-08' AND (CONVERT(FLOAT, LEFT(vesting_shares, CHARINDEX(' ',(vesting_shares))-1))) * 498.6 / 1000000 > 50