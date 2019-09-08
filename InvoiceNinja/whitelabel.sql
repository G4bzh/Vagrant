UPDATE companies
SET plan = 'white_label',
    plan_term = 'year',
    plan_started = '2019-01-01 00:00:00.000',
    plan_paid = '2019-01-01 00:00:00.000',
    plan_expires = '2099-01-01 00:00:00.000',
    payment_id = 1234567890
WHERE id=1;
