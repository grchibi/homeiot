-- Project Name : My Home IoT
-- Date/Time    : 2020/06/09
-- Author       : Tomoyuki Taguchi
-- RDBMS Type   : PostgreSQL
-- Application  : vim


CREATE OR REPLACE FUNCTION clean_old_records()
RETURNS INTEGER AS $$
DECLARE
  delete_rows INTEGER;
  dt_max TIMESTAMP;

BEGIN
  SELECT DATE_TRUNC('day', MAX(dt AT TIME ZONE 'UTC' AT TIME ZONE 'JST')) INTO dt_max FROM tph_records;
  SELECT dt_max - INTERVAL '2 years' INTO dt_max;
  RAISE INFO '[clean_old_records] records prior to % will be deleted.', dt_max;

  DELETE FROM tph_records WHERE dt < dt_max;

  GET DIAGNOSTICS delete_rows = ROW_COUNT;

  RETURN delete_rows;

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION create_hl_hist()
RETURNS VOID AS $$
DECLARE
  dt_finish DATE;
  dt_start DATE;
  rc_dev RECORD;
  rc_tmp RECORD;
  refcur_recs REFCURSOR;
  ts_now TIMESTAMP;

BEGIN
  SELECT INTO ts_now NOW();
  RAISE INFO 'START function create_hl_hist() => %', ts_now;

  FOR rc_dev IN SELECT id FROM iot_devices LOOP
    RAISE INFO '[create_hl_hist] start id => %', rc_dev.id;

    -- Start date

    SELECT MAX(dt AT TIME ZONE 'UTC' AT TIME ZONE 'JST') INTO dt_start FROM tph_hl_records WHERE iot_device_id = rc_dev.id;
    IF dt_start IS NULL THEN  -- no historical data
      SELECT MIN(CAST(dt AT TIME ZONE 'UTC' AT TIME ZONE 'JST' AS DATE)) INTO dt_start FROM tph_records WHERE iot_device_id = rc_dev.id;
      IF dt_start IS NULL THEN
        RAISE INFO '[create_hl_hist]   data not found => %', rc_dev.id;
        CONTINUE;
      END IF;

    ELSE
      SELECT dt_start + INTERVAL '1 day' INTO dt_start;

    END IF;

    RAISE INFO '[create_hl_hist]   start date => %', dt_start;

    -- Finish date

    SELECT MAX(CAST(dt AT TIME ZONE 'UTC' AT TIME ZONE 'JST' AS DATE)) INTO dt_finish FROM tph_records WHERE iot_device_id = rc_dev.id;
    IF dt_finish IS NULL THEN
      SELECT INTO dt_finish CAST(NOW() AS DATE);
    END IF;

    SELECT dt_finish - INTERVAL '1 day' INTO dt_finish;

    RAISE INFO '[create_hl_hist]   finish date => %', dt_finish;

    -- Calculation

    OPEN refcur_recs FOR EXECUTE 'SELECT CAST(dt AT TIME ZONE ''UTC'' AT TIME ZONE ''JST'' AS DATE) AS dt, MIN(h) AS min_h, MAX(h) AS max_h, MIN(p) AS min_p, MAX(p) AS max_p, MIN(t) AS min_t, MAX(t) AS max_t FROM tph_records WHERE iot_device_id = ' || rc_dev.id || ' AND ''' || dt_start || ''' <= CAST(dt AT TIME ZONE ''UTC'' AT TIME ZONE ''JST'' AS DATE) AND CAST(dt AT TIME ZONE ''UTC'' AT TIME ZONE ''JST'' AS DATE) <= ''' || dt_finish || ''' GROUP BY CAST(dt AT TIME ZONE ''UTC'' AT TIME ZONE ''JST'' AS DATE)';

    FETCH NEXT FROM refcur_recs INTO rc_tmp;
    WHILE FOUND LOOP

      --RAISE INFO '[create_hl_hist]     %:  t(%, %)  p(%, %)  h(%, %)', rc_tmp.dt, rc_tmp.min_t, rc_tmp.max_t, rc_tmp.min_p, rc_tmp.max_p, rc_tmp.min_h, rc_tmp.max_h;

      INSERT INTO tph_hl_records VALUES (NEXTVAL('tph_hl_records_id_seq'), rc_tmp.dt, rc_tmp.min_t, rc_tmp.min_p, rc_tmp.min_h, false, rc_dev.id, NOW(), NOW());
      INSERT INTO tph_hl_records VALUES (NEXTVAL('tph_hl_records_id_seq'), rc_tmp.dt, rc_tmp.max_t, rc_tmp.max_p, rc_tmp.max_h, true, rc_dev.id, NOW(), NOW());

      FETCH NEXT FROM refcur_recs INTO rc_tmp;
    END LOOP;	-- WHILE LOOP

    CLOSE refcur_recs;

  END LOOP;	-- FOR LOOP

  RETURN;

END;
$$ LANGUAGE plpgsql;

