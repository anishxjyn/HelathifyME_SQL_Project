DROP TABLE sales_call;
CREATE TABLE sales_call (
    expert_id NUMERIC,
	team_lead_id NUMERIC,
	user_id NUMERIC,
	India_vs_NRI VARCHAR(50),
	medicalconditionflag VARCHAR(50),
	funnel VARCHAR(50),
	event_type VARCHAR(50),
	current_status VARCHAR(50),
	slot_start_time TIMESTAMP,
	handled_time TIMESTAMP,
	booked_flag VARCHAR(50),
	payment_time TIMESTAMP,
	target_class VARCHAR(50),
	payment INTEGER
);

COPY sales_call
FROM 'D:\MY-DATA\Profession- Stage2\CASE STUDY\hm-cs\sales_call_dataset.csv'
delimiter ','
ENCODING 'UTF8'
CSV header;