alter table public.user_pins
add column sentiment_label text,
add column sentiment_score real;

alter table public.user_pins
add constraint user_pins_sentiment_label_check
check (sentiment_label in ('POSITIVE', 'NEGATIVE'));
