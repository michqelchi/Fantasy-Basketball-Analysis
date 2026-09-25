-- Creating a CTE to display average expert ranking
SELECT
    player,
    AVG(rank) AS avg_expert_rank
FROM (
    SELECT player, rank FROM espn_rankings
    UNION ALL
    SELECT player, rank FROM fantasypros_rankings
    UNION ALL
    SELECT player, rank FROM leaguewinner_rankings
    UNION ALL
    SELECT player, rank FROM lineupexperts_rankings
    UNION ALL
    SELECT player, rank FROM yahoo_rankings
)
GROUP BY player
ORDER BY avg_expert_rank ASC;
-- Creating a new CTE to display average expert ranking + ADP
WITH consensus_rankings as ( SELECT player, ROUND(AVG(rank), 1)AS avg_expert_rank, ROUND( SQRT(AVG(rank * rank) - AVG(rank) * AVG(rank)), 2) AS rank_std_dev
																FROM ( SELECT player, rank FROM espn_rankings UNION ALL
																				SELECT player, rank FROM fantasypros_rankings UNION ALL
																				SELECT player, rank FROM leaguewinner_rankings UNION ALL
																				SELECT player, rank FROM lineupexperts_rankings UNION ALL
																				SELECT player, rank FROM yahoo_rankings)
																GROUP BY player)
 
SELECT
    ESPNadp.player,
    ESPNadp.pos,
    ESPNadp.adp,
    consensus_rankings.avg_expert_rank,
	consensus_rankings.rank_std_dev,
    ROUND(ESPNadp.adp - consensus_rankings.avg_expert_rank, 1) AS value
FROM ESPNadp
LEFT JOIN consensus_rankings
    ON ESPNadp.player = consensus_rankings.player
ORDER BY value DESC;
-- Turning this CTE into a view that I can export to Excel (delete this query if you just want to see the final table)
CREATE VIEW final_rankings AS WITH consensus_rankings as ( SELECT player, ROUND(AVG(rank), 1)AS avg_expert_rank, ROUND( SQRT(AVG(rank * rank) - AVG(rank) * AVG(rank)), 2) AS rank_std_dev
																FROM ( SELECT player, rank FROM espn_rankings UNION ALL
																				SELECT player, rank FROM fantasypros_rankings UNION ALL
																				SELECT player, rank FROM leaguewinner_rankings UNION ALL
																				SELECT player, rank FROM lineupexperts_rankings UNION ALL
																				SELECT player, rank FROM yahoo_rankings)
																GROUP BY player)
 
SELECT
    ESPNadp.player,
    ESPNadp.pos,
    ESPNadp.adp,
    consensus_rankings.avg_expert_rank,
	consensus_rankings.rank_std_dev,
    ROUND(ESPNadp.adp - consensus_rankings.avg_expert_rank, 1) AS value
FROM ESPNadp
LEFT JOIN consensus_rankings
    ON ESPNadp.player = consensus_rankings.player
ORDER BY value DESC;
	
