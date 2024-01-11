--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: cambiostatoaereotriggerfunction(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cambiostatoaereotriggerfunction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF OLD.Stato = 'funzionante' AND NEW.Stato = 'non funzionante' THEN
        UPDATE Volo
        SET CodiceAereo = (
            SELECT CodiceAereo
            FROM Aereo
            WHERE Stato = 'funzionante'
            LIMIT 1
        )
        WHERE CodiceAereo = OLD.CodiceAereo;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.cambiostatoaereotriggerfunction() OWNER TO postgres;

--
-- Name: inserimentonuovovolotriggerfunction(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.inserimentonuovovolotriggerfunction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    
    IF NOT EXISTS (
        SELECT 1
        FROM Volo
        WHERE CodiceAereo = NEW.CodiceAereo
        LIMIT 1
    ) THEN
        UPDATE Aereo
        SET Note = 'Volo inaugurale in data ' || NEW.DataViaggio
        WHERE CodiceAereo = NEW.CodiceAereo;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.inserimentonuovovolotriggerfunction() OWNER TO postgres;

--
-- Name: inserimentoprenotazionetriggerfunction(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.inserimentoprenotazionetriggerfunction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_eta_media NUMERIC;
    v_numero_adulti INT;
    v_numero_bambini INT;
    v_totale_euro_fatturato FLOAT;
BEGIN
    SELECT AVG(C.Età), COUNT(CASE WHEN C.Età >= 18 THEN 1 END), COUNT(CASE WHEN C.Età < 18 THEN 1 END), SUM(NEW.CostoFatturato)
    INTO v_eta_media, v_numero_adulti, v_numero_bambini, v_totale_euro_fatturato
    FROM Prenotazione P
    JOIN Cliente C ON P.CodiceCliente = C.CodiceCliente
    WHERE P.NumeroVolo = NEW.NumeroVolo;

    -- Aggiorna le informazioni nella tabella STATISTICHE
    UPDATE Statistiche
    SET NumeroPrenotazioni = NumeroPrenotazioni + 1,
        EtàMediaPasseggeri = v_eta_media,
        NumeroAdulti = v_numero_adulti,
        NumeroBambini = v_numero_bambini,
        TotaleEuroFatturato = v_totale_euro_fatturato
    WHERE IdVolo = NEW.NumeroVolo;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.inserimentoprenotazionetriggerfunction() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: aereo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aereo (
    codiceaereo character varying(255) NOT NULL,
    codicecompagnia character varying(255) NOT NULL,
    modello character varying(255) NOT NULL,
    stato character varying(255) NOT NULL,
    note character varying(255)
);


ALTER TABLE public.aereo OWNER TO postgres;

--
-- Name: aeroporto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aeroporto (
    codiceaeroporto character varying(255) NOT NULL,
    citta character varying(255) NOT NULL,
    nome character varying(255) NOT NULL,
    numeropiste integer NOT NULL,
    nazionalita character varying(255) NOT NULL
);


ALTER TABLE public.aeroporto OWNER TO postgres;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    codicecliente integer NOT NULL,
    nome character varying(255) NOT NULL,
    indirizzo character varying(255) NOT NULL,
    numerotelefono character varying(20) NOT NULL,
    eta integer NOT NULL
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- Name: compagnia_aerea; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compagnia_aerea (
    nomecompagnia character varying(255) NOT NULL,
    sede character varying(255) NOT NULL
);


ALTER TABLE public.compagnia_aerea OWNER TO postgres;

--
-- Name: prenotazione; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prenotazione (
    numeroprenotazione integer NOT NULL,
    codicecliente integer NOT NULL,
    numerovolo integer NOT NULL,
    dataprenotazione date NOT NULL,
    dataviaggio date NOT NULL,
    costofatturato double precision NOT NULL
);


ALTER TABLE public.prenotazione OWNER TO postgres;

--
-- Name: statistiche; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statistiche (
    idvolo integer NOT NULL,
    numeroprenotazioni integer NOT NULL,
    "etàmediapasseggeri" double precision NOT NULL,
    numeroadulti integer NOT NULL,
    numerobambini integer NOT NULL,
    totaleeurofatturato double precision NOT NULL
);


ALTER TABLE public.statistiche OWNER TO postgres;

--
-- Name: trasporto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trasporto (
    codicevolo integer NOT NULL,
    tipo character varying(255) NOT NULL
);


ALTER TABLE public.trasporto OWNER TO postgres;

--
-- Name: volo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.volo (
    numerovolo integer NOT NULL,
    terminalorigine character varying(255) NOT NULL,
    terminaldestinazione character varying(255) NOT NULL,
    scaliintermedi character varying(255),
    postiprenotati integer NOT NULL,
    postidisponibili integer NOT NULL,
    costobase double precision NOT NULL,
    codicecompagnia character varying(255) NOT NULL,
    codiceaereo character varying(255) NOT NULL,
    dataviaggio date NOT NULL
);


ALTER TABLE public.volo OWNER TO postgres;

--
-- Data for Name: aereo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aereo (codiceaereo, codicecompagnia, modello, stato, note) FROM stdin;
AA123	American Airlines	Boeing 737	Operativo	Nessuna nota
DL456	Delta Air Lines	Airbus A320	In manutenzione	Controllo prevolo in corso
EK789	Emirates	Boeing 777	Operativo	\N
AF987	Air France	Airbus A350	Operativo	Revisione programmata
BA654	British Airways	Boeing 787	In manutenzione	Riparazione al motore
LH321	Lufthansa	Airbus A380	Operativo	Consegna recente
AZ278	Alitalia	Airbus 582	Operativo	Nessuna nota
AS350	AirOne	Modello AA	funzionante	Aereo funzionante di AirOne
ET789	Emirates	Modello EK	funzionante	Aereo funzionante di Emirates
LH456	Lufthansa	Modello LH	funzionante	Aereo funzionante di Lufthansa
DL789	Delta Air Lines	Modello DL	funzionante	Aereo funzionante di Delta Air Lines
AF123	AirFrance	Modello AF1	funzionante	Aereo funzionante di AirFrance
LH459	Lufthansa	Modello LH1	non funzionante	Aereo non funzionante di Lufthansa
AF779	AirFrance	Modello AF2	in manutenzione	Aereo in manutenzione di AirFrance
LH987	Lufthansa	Modello LH2	funzionante	Aereo funzionante di Lufthansa con note aggiuntive
AF654	AirFrance	Modello AF3	non funzionante	Aereo non funzionante di AirFrance con problemi tecnici
LH789	Lufthansa	Modello LH3	funzionante	Aereo funzionante di Lufthansa con equipaggiamento avanzato
AF456	AirFrance	Modello AF4	in manutenzione	Aereo in manutenzione di AirFrance
LH123	Lufthansa	Modello LH4	non funzionante	Aereo non funzionante di Lufthansa
AF981	AirFrance	Modello AF5	funzionante	Aereo funzionante di AirFrance
LH654	Lufthansa	Modello LH5	funzionante	Aereo funzionante di Lufthansa
\.


--
-- Data for Name: aeroporto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aeroporto (codiceaeroporto, citta, nome, numeropiste, nazionalita) FROM stdin;
FCO	Roma	Leonardo da Vinci	2	Italia
LHR	Londra	Heathrow	2	Regno Unito
JFK	New York	John F. Kennedy	4	Stati Uniti
CDG	Parigi	Charles de Gaulle	4	Francia
DXB	Dubai	Dubai International	2	Emirati Arabi Uniti
AMS	Amsterdam	Schiphol	6	Paesi Bassi
HND	Tokyo	Haneda	4	Giappone
SYD	Sydney	Kingsford Smith	3	Australia
ICN	Seoul	Incheon	2	Corea del Sud
SIN	Singapore	Changi	4	Singapore
CIA	Roma	G. B. Pastine	3	Italia
NAP	Napoli	Internazionale di Napoli	2	Italia
MAD	Madrid	Adolfo Suárez Madrid-Barajas	4	Spagna
BCN	Barcellona	Barcelona-El Prat	3	Spagna
AGP	Malaga	Malaga-Costa del Sol	2	Spagna
VLC	Valencia	Valencia Airport	1	Spagna
CDA	Parigi	Charles de Ann	4	Francia
ORY	Parigi	Orly	3	Francia
MRS	Marsiglia	Provenza	2	Francia
NCE	Nizza	Costa Azzurra	2	Francia
FRA	Francoforte	Francoforte sul Meno	3	Germania
MUC	Monaco di Baviera	Franz Josef Strauss	2	Germania
TXL	Berlino	Tegel	2	Germania
DUS	Düsseldorf	Düsseldorf	3	Germania
HAM	Amburgo	Amburgo	2	Germania
\.


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente (codicecliente, nome, indirizzo, numerotelefono, eta) FROM stdin;
1	Mario Rossi	Via Roma 123	+39 1234567890	35
2	Anna Bianchi	Via Milano 456	+39 9876543210	28
3	Luigi Verdi	Via Napoli 789	+39 5556667777	42
4	Laura Gialli	Via Firenze 101	+39 3334445555	22
5	Paolo Neri	Via Torino 202	+39 1112223333	40
6	Giulia Azzurri	Via Venezia 303	+39 9998887777	31
\.


--
-- Data for Name: compagnia_aerea; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compagnia_aerea (nomecompagnia, sede) FROM stdin;
AirOne	Milano
Alitalia	Roma
Lufthansa	Berlino
Emirates	Dubai
British Airways	Londra
Delta Air Lines	Atlanta
Singapore Airlines	Singapore
Qatar Airways	Doha
Cathay Pacific	Hong Kong
Air France	Parigi
KLM Royal Dutch Airlines	Amsterdam
American Airlines	Dallas
Turkish Airlines	Istanbul
Etihad Airways	Abu Dhabi
Southwest Airlines	Dallas
ANA All Nippon Airways	Tokyo
Qantas	Sydney
Virgin Atlantic	Londra
United Airlines	Chicago
Emirates SkyCargo	Dubai
AirFrance	Parigi
\.


--
-- Data for Name: prenotazione; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prenotazione (numeroprenotazione, codicecliente, numerovolo, dataprenotazione, dataviaggio, costofatturato) FROM stdin;
1	1	1	2023-01-01	2023-01-15	600
2	2	2	2023-01-02	2023-01-20	700
3	3	3	2023-01-03	2023-01-25	550
4	4	4	2023-01-04	2023-01-18	480
5	5	5	2023-01-05	2023-01-22	750
\.


--
-- Data for Name: statistiche; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.statistiche (idvolo, numeroprenotazioni, "etàmediapasseggeri", numeroadulti, numerobambini, totaleeurofatturato) FROM stdin;
1	10	35.5	8	2	5000
2	15	28.7	12	3	7500
\.


--
-- Data for Name: trasporto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trasporto (codicevolo, tipo) FROM stdin;
1	Merci
2	Passeggeri
3	Passeggeri
4	Merci
5	Passeggeri
\.


--
-- Data for Name: volo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.volo (numerovolo, terminalorigine, terminaldestinazione, scaliintermedi, postiprenotati, postidisponibili, costobase, codicecompagnia, codiceaereo, dataviaggio) FROM stdin;
1	Roma	Madrid	Scalo C	150	50	500	AirOne	AA123	2023-01-01
2	Parigi	Madrid	\N	180	70	550	Emirates	EK789	2023-01-03
3	Madrid	Roma	Scalo D	120	80	480	Lufthansa	BA654	2023-01-04
4	Londra	Parigi	Scalo G, Scalo H	220	30	700	Delta Air Lines	DL456	2023-01-05
5	New York	Tokyo	\N	170	60	520	Air France	AF987	2023-01-06
6	Roma	Napoli	ScaloE, ScaloA	100	50	500	Alitalia	AZ278	2023-12-21
7	Parigi	Milano	Scalo A	150	100	600	AirOne	AS350	2023-01-06
8	Londra	Bari	Scalo B	180	120	550	Emirates	ET789	2023-01-06
9	China	Napoli	Scalo C	200	150	700	Lufthansa	LH456	2023-01-06
10	Milano	Roma	Scalo D	220	170	750	Delta Air Lines	DL789	2023-01-06
11	Parigi	Lione	Scalo A	150	100	600	AirFrance	AF123	2023-01-21
12	Marsiglia	Nizza	Scalo B	180	120	550	Lufthansa	LH459	2023-01-22
13	Orly	Provenza	Scalo C	200	150	700	AirFrance	AF779	2023-01-23
14	Marsiglia	Costa Azzura	Scalo D	220	170	750	Lufthansa	LH987	2023-01-24
15	Nizza	Parigi	Scalo E	170	130	600	AirFrance	AF654	2023-01-25
16	Parigi	Monaco	Scalo F	200	180	700	Lufthansa	LH789	2023-01-26
17	Monaco	Francoforte	Scalo G	180	150	550	AirFrance	AF987	2023-01-27
18	Berlino	Tegel	Scalo H	160	120	650	Lufthansa	LH654	2023-01-28
19	Dusseldorf	Amburgo	Scalo I	190	160	700	AirFrance	AF981	2023-01-29
20	Amburgo	Monaco di baviera	Scalo J	210	180	800	Lufthansa	LH654	2023-01-30
21	Parigi	Berlino	Scalo A	150	100	600	AirFrance	AF123	2023-02-01
22	Marsiglia	Francoforte	Scalo B	180	120	550	Lufthansa	LH459	2023-02-02
23	Nizza	Amburgo	Scalo C	200	150	700	AirFrance	AF779	2023-02-03
24	Parigi	Monaco di Baviera	Scalo D	220	170	750	Lufthansa	LH987	2023-02-04
25	Marsiglia	Düsseldorf	Scalo E	170	130	600	AirFrance	AF654	2023-02-05
26	Lione	Stoccarda	Scalo F	200	180	700	Lufthansa	LH789	2023-02-06
27	Bordeaux	Colonia	Scalo G	180	150	550	AirFrance	AF987	2023-02-07
28	Tolosa	Hannover	Scalo H	160	120	650	Lufthansa	LH654	2023-02-08
29	Nantes	Norimberga	Scalo I	190	160	700	AirFrance	AF981	2023-02-09
30	Strasburgo	Amburgo	Scalo J	210	180	800	Lufthansa	LH654	2023-02-10
31	Parigi	Berlino	Scalo A	150	100	600	AirFrance	AF123	2023-02-11
32	Marsiglia	Francoforte	Scalo B	180	120	550	Lufthansa	LH459	2023-02-12
33	Nizza	Amburgo	Scalo C	200	150	700	AirFrance	AF779	2023-02-13
34	Parigi	Monaco di Baviera	Scalo D	220	170	750	Lufthansa	LH987	2023-02-14
35	Marsiglia	Düsseldorf	Scalo E	170	130	600	AirFrance	AF654	2023-02-15
36	Lione	Stoccarda	Scalo F	200	180	700	Lufthansa	LH789	2023-02-16
37	Bordeaux	Colonia	Scalo G	180	150	550	AirFrance	AF987	2023-02-17
38	Tolosa	Hannover	Scalo H	160	120	650	Lufthansa	LH654	2023-02-18
39	Nantes	Norimberga	Scalo I	190	160	700	AirFrance	AF981	2023-02-19
40	Strasburgo	Amburgo	Scalo J	210	180	800	Lufthansa	LH654	2023-02-20
41	Parigi	Berlino	Scalo A	150	100	600	AirFrance	AF123	2023-02-21
42	Marsiglia	Francoforte	Scalo B	180	120	550	Lufthansa	LH459	2023-02-22
43	Nizza	Amburgo	Scalo C	200	150	700	AirFrance	AF779	2023-02-23
44	Parigi	Monaco di Baviera	Scalo D	220	170	750	Lufthansa	LH987	2023-02-24
45	Marsiglia	Düsseldorf	Scalo E	170	130	600	AirFrance	AF654	2023-02-25
46	Lione	Stoccarda	Scalo F	200	180	700	Lufthansa	LH789	2023-02-26
47	Bordeaux	Colonia	Scalo G	180	150	550	AirFrance	AF987	2023-02-27
48	Tolosa	Hannover	Scalo H	160	120	650	Lufthansa	LH654	2023-02-28
49	Parigi	Berlino	Scalo A	150	100	600	AirFrance	AF123	2023-03-01
50	Marsiglia	Francoforte	Scalo B	180	120	550	Lufthansa	LH459	2023-03-02
51	Nizza	Amburgo	Scalo C	200	150	700	AirFrance	AF779	2023-03-03
52	Parigi	Monaco di Baviera	Scalo D	220	170	750	Lufthansa	LH987	2023-03-04
53	Marsiglia	Düsseldorf	Scalo E	170	130	600	AirFrance	AF654	2023-03-05
54	Lione	Stoccarda	Scalo F	200	180	700	Lufthansa	LH789	2023-03-06
55	Bordeaux	Colonia	Scalo G	180	150	550	AirFrance	AF987	2023-03-07
56	Tolosa	Hannover	Scalo H	160	120	650	Lufthansa	LH654	2023-03-08
57	Nantes	Norimberga	Scalo I	190	160	700	AirFrance	AF981	2023-03-09
58	Strasburgo	Amburgo	Scalo J	210	180	800	Lufthansa	LH654	2023-03-10
59	Parigi	Berlino	Scalo A	150	100	600	AirFrance	AF123	2023-03-11
60	Marsiglia	Francoforte	Scalo B	180	120	550	Lufthansa	LH459	2023-03-12
61	Nizza	Amburgo	Scalo C	200	150	700	AirFrance	AF779	2023-03-13
62	Parigi	Monaco di Baviera	Scalo D	220	170	750	Lufthansa	LH987	2023-03-14
63	Marsiglia	Düsseldorf	Scalo E	170	130	600	AirFrance	AF654	2023-03-15
64	Lione	Stoccarda	Scalo F	200	180	700	Lufthansa	LH789	2023-03-16
65	Bordeaux	Colonia	Scalo G	180	150	550	AirFrance	AF987	2023-03-17
66	Tolosa	Hannover	Scalo H	160	120	650	Lufthansa	LH654	2023-03-18
67	Nantes	Norimberga	Scalo I	190	160	700	AirFrance	AF981	2023-03-19
68	Strasburgo	Amburgo	Scalo J	210	180	800	Lufthansa	LH654	2023-03-20
69	Parigi	Berlino	Scalo A	150	100	600	AirFrance	AF123	2023-03-21
70	Marsiglia	Francoforte	Scalo B	180	120	550	Lufthansa	LH459	2023-03-22
71	Nizza	Amburgo	Scalo C	200	150	700	AirFrance	AF779	2023-03-23
72	Parigi	Monaco di Baviera	Scalo D	220	170	750	Lufthansa	LH987	2023-03-24
73	Marsiglia	Düsseldorf	Scalo E	170	130	600	AirFrance	AF654	2023-03-25
74	Lione	Stoccarda	Scalo F	200	180	700	Lufthansa	LH789	2023-03-26
75	Bordeaux	Colonia	Scalo G	180	150	550	AirFrance	AF987	2023-03-27
76	Tolosa	Hannover	Scalo H	160	120	650	Lufthansa	LH654	2023-03-28
77	Nantes	Norimberga	Scalo I	190	160	700	AirFrance	AF981	2023-03-29
78	Strasburgo	Amburgo	Scalo J	210	180	800	Lufthansa	LH654	2023-03-30
\.


--
-- Name: aereo aereo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aereo
    ADD CONSTRAINT aereo_pkey PRIMARY KEY (codiceaereo);


--
-- Name: aeroporto aeroporto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aeroporto
    ADD CONSTRAINT aeroporto_pkey PRIMARY KEY (codiceaeroporto);


--
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (codicecliente);


--
-- Name: compagnia_aerea compagnia_aerea_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compagnia_aerea
    ADD CONSTRAINT compagnia_aerea_pkey PRIMARY KEY (nomecompagnia);


--
-- Name: prenotazione prenotazione_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prenotazione
    ADD CONSTRAINT prenotazione_pkey PRIMARY KEY (numeroprenotazione);


--
-- Name: statistiche statistiche_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statistiche
    ADD CONSTRAINT statistiche_pkey PRIMARY KEY (idvolo);


--
-- Name: trasporto trasporto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trasporto
    ADD CONSTRAINT trasporto_pkey PRIMARY KEY (codicevolo);


--
-- Name: volo volo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volo
    ADD CONSTRAINT volo_pkey PRIMARY KEY (numerovolo);


--
-- Name: aereo cambiostatoaereotrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER cambiostatoaereotrigger AFTER UPDATE ON public.aereo FOR EACH ROW EXECUTE FUNCTION public.cambiostatoaereotriggerfunction();


--
-- Name: volo inserimentonuovovolotrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER inserimentonuovovolotrigger AFTER INSERT ON public.volo FOR EACH ROW EXECUTE FUNCTION public.inserimentonuovovolotriggerfunction();


--
-- Name: prenotazione inserimentoprenotazionetrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER inserimentoprenotazionetrigger AFTER INSERT ON public.prenotazione FOR EACH ROW EXECUTE FUNCTION public.inserimentoprenotazionetriggerfunction();


--
-- Name: aereo aereo_codicecompagnia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aereo
    ADD CONSTRAINT aereo_codicecompagnia_fkey FOREIGN KEY (codicecompagnia) REFERENCES public.compagnia_aerea(nomecompagnia);


--
-- Name: prenotazione prenotazione_codicecliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prenotazione
    ADD CONSTRAINT prenotazione_codicecliente_fkey FOREIGN KEY (codicecliente) REFERENCES public.cliente(codicecliente);


--
-- Name: prenotazione prenotazione_numerovolo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prenotazione
    ADD CONSTRAINT prenotazione_numerovolo_fkey FOREIGN KEY (numerovolo) REFERENCES public.volo(numerovolo);


--
-- Name: statistiche statistiche_idvolo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statistiche
    ADD CONSTRAINT statistiche_idvolo_fkey FOREIGN KEY (idvolo) REFERENCES public.volo(numerovolo);


--
-- Name: trasporto trasporto_codicevolo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trasporto
    ADD CONSTRAINT trasporto_codicevolo_fkey FOREIGN KEY (codicevolo) REFERENCES public.volo(numerovolo);


--
-- Name: volo volo_codiceaereo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volo
    ADD CONSTRAINT volo_codiceaereo_fkey FOREIGN KEY (codiceaereo) REFERENCES public.aereo(codiceaereo);


--
-- Name: volo volo_codicecompagnia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volo
    ADD CONSTRAINT volo_codicecompagnia_fkey FOREIGN KEY (codicecompagnia) REFERENCES public.compagnia_aerea(nomecompagnia);


--
-- PostgreSQL database dump complete
--

