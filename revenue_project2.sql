with q as (
select gp.user_id, date_trunc('month', gp.payment_date)::date as payment_date, gp.game_name, gpu.language, gpu.age, sum(gp.revenue_amount_usd) as revenue_usd
from project.games_payments gp
join project.games_paid_users gpu
on gp.user_id = gpu.user_id
group by 1, 2, 3, 4, 5)

select *, q.payment_date - lag(q.payment_date,1) over (PARTITION BY q.user_id ORDER BY q.payment_date)::date as date_diff, 
		lag(q.payment_date) over (PARTITION BY q.user_id)::date as prev_paymdate,
		min(q.payment_date) over (PARTITION BY q.user_id)::date as first_paym_date, 
		max(q.payment_date) over (PARTITION BY q.user_id)::date as last_paym_date,
		case 
			when lag(q.revenue_usd) over (PARTITION BY q.user_id) < q.revenue_usd then q.revenue_usd end as expans_mrr,
		case 
			when lag(q.revenue_usd) over (PARTITION BY q.user_id) > q.revenue_usd then q.revenue_usd end as contrac_mrr
from q


 


