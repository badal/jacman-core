-- requete de recuperation du nombre des abonnement a notifier
--
-- returns :
-- le nombre d'abonnements
--

SELECT
  count(*)
FROM
  abonnement
  LEFT JOIN type_abonnement ON abonnement_type = type_abonnement_id
WHERE
  type_abonnement_code = 'E'
  AND abonnement_ignorer = 0
  AND abonnement_ip_a_notifier = 1
  AND abonnement_annee >= YEAR(NOW());
