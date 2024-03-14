-- Create `plans` table
CREATE TABLE public.plans (
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    plan_name character varying(255),
    plan_amount integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

-- Create `user_id_seq` sequence
CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- Create `users` table
CREATE TABLE public.users (
    id integer DEFAULT nextval('public.user_id_seq'::regclass) NOT NULL,
    email character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    password character varying(60),
    user_active integer DEFAULT 0,
    is_admin integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

-- Create `user_plans` table
CREATE TABLE public.user_plans (
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    user_id integer,
    plan_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

-- Insert initial data into `users` table
INSERT INTO public.users (email, first_name, last_name, password, user_active, is_admin, created_at, updated_at)
VALUES
    ('admin@example.com', 'Admin', 'User', '$2a$12$1zGLuYDDNvATh4RA4avbKuheAMpb1svexSzrQm7up.bnpwQHs0jNe', 1, 1, '2022-03-14 00:00:00', '2022-03-14 00:00:00');

-- Insert initial data into `plans` table
INSERT INTO public.plans (plan_name, plan_amount, created_at, updated_at)
VALUES
    ('Bronze Plan', 1000, '2022-05-12 00:00:00', '2022-05-12 00:00:00'),
    ('Silver Plan', 2000, '2022-05-12 00:00:00', '2022-05-12 00:00:00'),
    ('Gold Plan', 3000, '2022-05-12 00:00:00', '2022-05-12 00:00:00');

-- Set the sequence value for `plans_id_seq`
SELECT pg_catalog.setval('public.plans_id_seq', 1, false);

-- Set the sequence value for `user_id_seq`
SELECT pg_catalog.setval('public.user_id_seq', 2, true);

-- Set the sequence value for `user_plans_id_seq`
SELECT pg_catalog.setval('public.user_plans_id_seq', 1, false);

-- Add primary key constraints
ALTER TABLE ONLY public.plans ADD CONSTRAINT plans_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.users ADD CONSTRAINT users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.user_plans ADD CONSTRAINT user_plans_pkey PRIMARY KEY (id);

-- Add foreign key constraints for `user_plans`
ALTER TABLE ONLY public.user_plans
    ADD CONSTRAINT user_plans_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.plans(id) ON UPDATE RESTRICT ON DELETE CASCADE;

ALTER TABLE ONLY public.user_plans
    ADD CONSTRAINT user_plans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE CASCADE;
