-- I manually standardized the player names using the update and set queries. This subsequent query is to verify there are no players that will appear twice under different formats of their name

SELECT player, COUNT(*) AS appearances
FROM (
    SELECT player, source FROM espn_rankings
    UNION ALL
    SELECT player, source  FROM fantasypros_rankings
    UNION ALL
    SELECT player, source FROM leaguewinner_rankings
    UNION ALL
    SELECT player, source FROM lineupexperts_rankings
    UNION ALL
    SELECT player, source FROM yahoo_rankings
)
GROUP BY player
ORDER BY appearances ASC;
