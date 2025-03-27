CREATE ANALYZER ngram_lowercase_analyzer (
  TOKENIZER ngram_tokenizer with (
    min_gram = 2,
    max_gram = 10,
    type = "ngram"
  ),
  TOKEN_FILTERS (asciifolding, lowercase)
);

CREATE ANALYZER edge_ngram_lowercase_analyzer (
  TOKENIZER edge_ngram_tokenizer with (
    min_gram = 2,
    max_gram = 30,
    type = "edge_ngram",
    token_chars = ["letter",
          "digit",
          "symbol",
          "punctuation"]
  ),
  TOKEN_FILTERS (asciifolding, lowercase)
);

CREATE ANALYZER edge_ngram_full_field_analyzer (
  TOKENIZER edge_ngram_full_field_tokenizer with (
    min_gram = 2,
    max_gram = 30,
    type = "edge_ngram"
  ),
  TOKEN_FILTERS (
    asciifolding,
    lowercase,
    length_min_2_chars with (type = "length", min = 2)
  )
);

CREATE ANALYZER edge_ngram_phone_analyzer (
  TOKENIZER edge_ngram_phone_tokenizer with (
    min_gram = 2,
    max_gram = 15,
    type = "edge_ngram",
    token_chars = [
          "digit"
        ]
  )
);

CREATE ANALYZER full_search_analyzer extends whitespace with (
  TOKEN_FILTERS (
    asciifolding,
    lowercase,
    length_min_2_chars with (type = "length", min = 2)
  )
);

CREATE ANALYZER full_search_ngram_analyzer extends keyword with (TOKEN_FILTERS (asciifolding, lowercase));

create table customers (
  id integer,
  name text,
  address text,
  lat double precision,
  lng double precision,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  phone text,
  merchant_id integer,
  image character varying(255),
  access_token character varying(255),
  confirmation_code character varying(255),
  approved boolean,
  push_token character varying(255),
  uuid text,
  email character varying(255),
  external_id text,
  delete_at timestamp without time zone,
  extras object,
  original_lat_lng_changed timestamp without time zone,
  blocked_email boolean,
  address_second_line text,
  zipcode character varying,
  stripe_id character varying,
  original_phone_number character varying,
  uploaded_profile_image character varying,
  original_lat double precision,
  original_lng double precision,
  consecutive_checkins_out_of_geofence integer,
  allow_sending_email boolean,
  allow_sending_sms boolean,
  mobile_version character varying,
  mobile_type integer,
  mobile_maker character varying,
  client_version character varying,
  client_name character varying,
  city character varying,
  borough character varying,
  state character varying,
  dev boolean,
  business_code character varying,
  language character varying(255),
  district character varying,
  house_number integer,
  street character varying,
  allow_dynamically_updating_location boolean,
  address_type integer,
  tax_payer_external_id character varying,
  tax_payer_name character varying,
  rank integer,
  user_id integer,
  has_parking_area boolean,
  driver_preparation_time integer,
  default_estimate_duration_on_site_in_seconds integer,
  kind integer,
  INDEX name_ngram using fulltext (name) with (analyzer = 'edge_ngram_lowercase_analyzer'),
  INDEX external_id_ngram using fulltext (external_id) with (analyzer = 'ngram_lowercase_analyzer'),
  INDEX phone_ngram using fulltext (phone) with (analyzer = 'edge_ngram_phone_analyzer'),
  INDEX original_phone_number_ngram using fulltext (original_phone_number) with (analyzer = 'edge_ngram_phone_analyzer'),
  INDEX address_ngram using fulltext (address) with (analyzer = 'ngram_lowercase_analyzer'),
  INDEX original_phone_number_ignore using fulltext (original_phone_number) with (analyzer = 'full_search_analyzer')
);

create table way_points (
  id integer,
  lat double precision,
  lng double precision,
  task_id integer,
  done boolean,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  customer_id integer,
  address text,
  position integer,
  scheduled_at timestamp without time zone,
  checkin_time timestamp without time zone,
  checkout_time timestamp without time zone,
  note character varying(255),
  find_me boolean,
  asap boolean,
  late boolean,
  eta timestamp without time zone,
  etl timestamp without time zone,
  silent boolean,
  phone text,
  email character varying(255),
  delete_at timestamp without time zone,
  checkin_lat double precision,
  checkin_lng double precision,
  checkout_lat double precision,
  checkout_lng double precision,
  etos integer,
  distance_traveled_client double precision,
  distance_traveled_server double precision,
  automatically_checked_in integer,
  automatically_checked_out integer,
  merchant_id integer,
  start_lat double precision,
  start_lng double precision,
  start_time timestamp without time zone,
  estimated_distance integer,
  estimated_time integer,
  allow_editing_inventory boolean,
  must_approve_inventory boolean,
  address_second_line text,
  zipcode character varying,
  allow_scanning_inventory boolean,
  allow_editing_payment boolean,
  late_reason character varying,
  no_later_than timestamp without time zone,
  no_earlier_than timestamp without time zone,
  masked_phone_number character varying,
  twilio_number_id integer,
  marked_late_at timestamp without time zone,
  borough character varying,
  city character varying,
  distance_traveled double precision,
  state character varying,
  delivery_confirmation_scan integer,
  delivery_confirmation_note integer,
  delivery_confirmation_photo integer,
  delivery_confirmation_signature integer,
  delivery_confirmation_form integer,
  delivery_confirmation_ocr integer,
  company_name character varying,
  customer_contact_ids integer [],
  contacts object,
  allow_editing_original_quantity boolean,
  pickup_dropoff_option integer,
  delivery_confirmation_cash integer,
  district character varying,
  house_number integer,
  street character varying,
  pending_geocode boolean,
  original_eta timestamp without time zone,
  allow_automatic_set_coordinates boolean,
  has_to_leave_by timestamp without time zone,
  extras object,
  automatically_geocoded boolean,
  original_etl timestamp without time zone,
  hidden boolean,
  address_type integer,
  location_name character varying,
  location_id integer,
  name character varying,
  ui_data object,
  first_attempt_promise_no_earlier_than timestamp without time zone,
  first_attempt_promise_no_later_than timestamp without time zone,
  driver_preparation_time integer,
  parking_spot_id integer,
  checkin_origin integer,
  checkout_origin integer,
  predicted_etos integer,
  delivery_method character varying,
  base_etos integer,
  verification_pin_code character varying,
  INDEX address_ngram using fulltext (address) with (analyzer = 'edge_ngram_lowercase_analyzer'),
  INDEX city_ngram using fulltext (city) with (analyzer = 'edge_ngram_lowercase_analyzer'),
  INDEX zipcode_ngram using fulltext (zipcode) with (analyzer = 'edge_ngram_full_field_analyzer'),
  INDEX phone_ngram using fulltext (phone) with (analyzer = 'edge_ngram_phone_analyzer'),
  INDEX zipcode_ignore using fulltext (zipcode) with (analyzer = 'full_search_analyzer')
);

create table tasks (
  id integer,
  title text,
  customer_id integer,
  user_id integer,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  status integer,
  merchant_id integer,
  delete_at timestamp without time zone,
  shift_id integer,
  alerted_client_time timestamp without time zone,
  extras object,
  active_way_point_id integer,
  started_time timestamp without time zone,
  ended_time timestamp without time zone,
  late boolean,
  external_id text INDEX using fulltext,
  start_lat double precision,
  start_lng double precision,
  uuid text,
  priority integer,
  distance_traveled double precision,
  automatically_started integer,
  total_price double precision,
  price_before_tax double precision,
  tax_price double precision,
  payment_method integer,
  tip double precision,
  left_to_be_paid double precision,
  origin_id integer,
  webhooks object,
  delivery_price double precision,
  accept_time timestamp without time zone,
  last_assigned_time timestamp without time zone,
  dispatcher_id integer,
  automatically_assigned boolean,
  tag_id integer,
  automatically_ended integer,
  automatically_cancelled integer,
  test boolean,
  late_reason text,
  ready_to_execute boolean,
  cancelled_at timestamp without time zone,
  first_way_point_lat double precision,
  first_way_point_lng double precision,
  last_way_point_lat double precision,
  last_way_point_lng double precision,
  first_way_point_schedule timestamp without time zone,
  last_way_point_schedule timestamp without time zone,
  discount double precision,
  tip_driver_enabled boolean,
  pre_delivery_tip double precision,
  post_delivery_tip_cash double precision,
  post_delivery_tip_credit double precision,
  run_uuid text,
  scheduled_to_be_ready timestamp without time zone,
  run_start_time timestamp without time zone,
  run_end_time timestamp without time zone,
  group_uuid text,
  group_leader_id integer,
  task_type_id integer,
  parent_task_id integer,
  cancellation_lat double precision,
  cancellation_lng double precision,
  not_ready_to_execute_and_invisible boolean,
  run_id integer,
  distance_automatically_set integer,
  done_processing boolean,
  payment_type_name text,
  linked_task_id integer,
  shadow_task_id integer,
  shadow_master_task_id integer,
  first_way_point_has_to_leave_by timestamp without time zone,
  acknowledged_at timestamp without time zone,
  task_configuration_id integer,
  fleet_id integer,
  fleet_delivery_external_id text,
  start_preparation_at timestamp without time zone,
  preparation_acknowledge_time_actual timestamp without time zone,
  preparation_start_time_actual timestamp without time zone,
  preparation_start_time_planned timestamp without time zone,
  preparation_end_time_actual timestamp without time zone,
  preparation_end_time_planned timestamp without time zone,
  preparation_ready_for_pickup_time_actual timestamp without time zone,
  preparation_ready_for_pickup_time_planned timestamp without time zone,
  preparation_picked_up_time_actual timestamp without time zone,
  preparation_status integer,
  required_skills array(varchar),
  quote_id text,
  delivery_window_id integer,
  origin_title text,
  last_ready_to_execute_at timestamp without time zone,
  round_trip boolean,
  failed_delivery_attempts integer,
  virtual_task boolean,
  action_data object,
  planning_done boolean,
  delivery_cost double precision,
  internal_fee double precision,
  invalidated boolean,
  preparation_external_id text,
  service_plan_id integer,
  rank integer,
  left_to_be_paid_for_delivery integer,
  planning_published boolean,
  teams_ids array(integer),
  small_cart_fee double precision,
  service_fee double precision,
  vehicle_id integer,
  total_weight double precision,
  additional_attributes object,
  reserved_until timestamp without time zone,
  recurrent_task_template_id integer,
  total_handling_units object,
  team_id integer,
  INDEX external_id_ngram using fulltext (external_id) with (analyzer = 'ngram_lowercase_analyzer'),
  INDEX title_standard using fulltext (title),
  INDEX title_ngram using fulltext (title) with (analyzer = 'edge_ngram_lowercase_analyzer'),
  INDEX preparation_external_id_ignore using fulltext (preparation_external_id) with (analyzer = 'full_search_analyzer'),
  INDEX preparation_external_id_ignore_two using fulltext (preparation_external_id) with (analyzer = 'full_search_ngram_analyzer')

insert into
  tasks (
    id,
    title,
    external_id,
    status,
    ended_time,
    merchant_id,
    team_id,
    task_type_id
  ) (
    select
      id,
      ['Stacy Jacobs', 'Amy Scott', 'Michelle Reyes', 'James Gregory', 'Craig Ross', 'Leslie Rodriguez', 'Paige Hill', 'Brandon Martinez', 'David Molina', 'Charles Lawson', 'Mary Flores', 'Cheryl Campbell', 'Margaret Hughes', 'Clayton Rangel', 'Nicole Flores', 'Mr. Travis Phelps', 'Sarah White', 'Jessica Villarreal', 'David Lee', 'Taylor Smith', 'Kimberly Hammond', 'Kevin Harris', 'Michael Gutierrez', 'Tamara Chen', 'Douglas Gomez', 'William Grimes', 'Wanda Peterson', 'Tiffany Hawkins', 'Danielle Miller', 'Brittany Jackson', 'Joseph Gardner', 'Sylvia Sellers', 'Katherine Smith', 'Elizabeth Baker', 'Lacey Allen', 'Jennifer Chavez', 'Jennifer Mullins', 'Denise Lyons', 'Phillip Fox', 'Alan Caldwell', 'Michael Flowers', 'Brian Mann', 'Julia Brown', 'Seth Thompson', 'Ryan Floyd', 'David Krueger', 'Amber Anderson', 'Mark Pearson', 'Sarah Jones', 'Daniel Anderson', 'Colleen Kaiser', 'Lisa Young', 'Trevor Garza', 'Alyssa Gray', 'Jennifer Mora', 'Elizabeth Bryant', 'Dana Gonzalez', 'Gary Whitney', 'Lisa Martin', 'Linda Mann', 'Michael Campbell', 'Samuel Mason', 'Scott Gordon', 'Lee Howell', 'Kathleen Duncan', 'Austin Davidson', 'Jessica Williams', 'Emily Richardson', 'Theresa Campbell', 'Michael Carney', 'Jennifer Keller', 'Mr. Charles Clark', 'Helen Valentine', 'James Lowery', 'Connor Johnson', 'Taylor Frye', 'Eric Thompson', 'Jordan Barnes', 'Nicholas Richards', 'Michelle Miller', 'Charles Whitaker', 'Mariah Dillon', 'Tamara Woodard', 'Jeffrey Gonzalez', 'Troy Munoz', 'Adam Nelson', 'Louis Frye', 'Rachel Mcdaniel', 'Sara Riley', 'William Smith', 'David Smith Jr.', 'Michael Hamilton', 'Matthew Rose II', 'Teresa Edwards', 'Sean Soto', 'Kathy Smith', 'Brent Jenkins', 'Justin Parker', 'Jason Boyd', 'Michele Evans'] [floor(random()*100)+1] as title,
      ['Stacy Jacobs', 'Amy Scott', 'Michelle Reyes', 'James Gregory', 'Craig Ross', 'Leslie Rodriguez', 'Paige Hill', 'Brandon Martinez', 'David Molina', 'Charles Lawson', 'Mary Flores', 'Cheryl Campbell', 'Margaret Hughes', 'Clayton Rangel', 'Nicole Flores', 'Mr. Travis Phelps', 'Sarah White', 'Jessica Villarreal', 'David Lee', 'Taylor Smith', 'Kimberly Hammond', 'Kevin Harris', 'Michael Gutierrez', 'Tamara Chen', 'Douglas Gomez', 'William Grimes', 'Wanda Peterson', 'Tiffany Hawkins', 'Danielle Miller', 'Brittany Jackson', 'Joseph Gardner', 'Sylvia Sellers', 'Katherine Smith', 'Elizabeth Baker', 'Lacey Allen', 'Jennifer Chavez', 'Jennifer Mullins', 'Denise Lyons', 'Phillip Fox', 'Alan Caldwell', 'Michael Flowers', 'Brian Mann', 'Julia Brown', 'Seth Thompson', 'Ryan Floyd', 'David Krueger', 'Amber Anderson', 'Mark Pearson', 'Sarah Jones', 'Daniel Anderson', 'Colleen Kaiser', 'Lisa Young', 'Trevor Garza', 'Alyssa Gray', 'Jennifer Mora', 'Elizabeth Bryant', 'Dana Gonzalez', 'Gary Whitney', 'Lisa Martin', 'Linda Mann', 'Michael Campbell', 'Samuel Mason', 'Scott Gordon', 'Lee Howell', 'Kathleen Duncan', 'Austin Davidson', 'Jessica Williams', 'Emily Richardson', 'Theresa Campbell', 'Michael Carney', 'Jennifer Keller', 'Mr. Charles Clark', 'Helen Valentine', 'James Lowery', 'Connor Johnson', 'Taylor Frye', 'Eric Thompson', 'Jordan Barnes', 'Nicholas Richards', 'Michelle Miller', 'Charles Whitaker', 'Mariah Dillon', 'Tamara Woodard', 'Jeffrey Gonzalez', 'Troy Munoz', 'Adam Nelson', 'Louis Frye', 'Rachel Mcdaniel', 'Sara Riley', 'William Smith', 'David Smith Jr.', 'Michael Hamilton', 'Matthew Rose II', 'Teresa Edwards', 'Sean Soto', 'Kathy Smith', 'Brent Jenkins', 'Justin Parker', 'Jason Boyd', 'Michele Evans'] [floor(random()*100)+1] as external_id,
      floor(random() * 8) + 1 as status,
      now() - (floor(random() * 730) * interval '1 day') as ended_time,
      case
        when random() < 0.5 then 1
        when random() < 0.5 then 2
        when random() < 0.5 then 3
        when random() < 0.5 then 4
        else 5
      end as merchant_id,
      floor(random() * 250) + 1 as team_id,
      floor(random() * 7) + 1 as task_type_id
    from
      generate_series(1, 1000000) as id
  );

insert into
  customers (id, name, phone) (
    select
      id,
      ['James Williams', 'Robert Miller', 'James Burns', 'Michael Hoffman', 'Daniel Munoz', 'Katherine Higgins', 'Regina Smith', 'Sharon Baxter', 'Kenneth Sanford', 'Sarah Lewis', 'Gregory Murray', 'Thomas Brown', 'Brandi Jordan', 'James Reyes', 'Dylan Ferguson', 'Shannon Ramos', 'Jasmine Hernandez', 'Janet Booth', 'Melissa Williams', 'Terri Schaefer', 'Dawn Carson', 'Bonnie Carter', 'Deanna Galvan', 'Mary Santos', 'Jeremy Bowers', 'Jackie Collins', 'Yesenia Webb', 'Erik Rodriguez', 'Jeremy Carey', 'Raymond Robles', 'Catherine Francis', 'Richard Sellers', 'Michelle Harrell', 'Mary Hodge', 'Lisa Gibbs', 'Kathryn Vang', 'Dana Valentine', 'Nathan Gordon', 'Thomas Roberts', 'Elizabeth Schultz', 'Patricia Ross', 'Jessica Jones', 'Debbie Johnson', 'Nicole Johnson', 'Emily Buckley', 'Joanna Mcdaniel', 'Mark Johnson', 'Angela Gonzalez', 'Elizabeth Garza', 'Linda Smith', 'Lucas Hill', 'Ashley Daugherty', 'Linda Harris', 'John Allen', 'Craig Rollins', 'Jamie Carey', 'Diana Lopez', 'Kevin Mccullough', 'Randy Tran Jr.', 'Leslie Martinez', 'Anthony Villa', 'Kathryn Hale', 'Virginia Snyder', 'Mr. Theodore Marshall MD', 'Gregory Burgess', 'Linda Brown', 'Kathryn Blevins', 'Ryan Jenkins', 'Rhonda Hendricks', 'Elizabeth Clay', 'Robert Casey', 'Gregory Gallegos', 'Sarah Rogers', 'Jacob Steele', 'Paul Stone', 'Stacy Hancock', 'Richard Simon', 'Cassandra Hurley', 'Matthew Peck', 'Sherry Lester', 'Julie Lutz', 'Thomas Tyler', 'Stefanie Richard', 'Jared Duffy', 'Ryan Morgan', 'Craig Lee', 'Shane Goodman', 'John Parrish', 'Daniel Tate', 'Benjamin Garza', 'Amanda Long', 'David Williams', 'Jason Payne', 'Dawn Baker', 'Sean Carpenter', 'Kyle Ramos', 'Stephen Armstrong', 'Matthew Molina', 'Teresa Maldonado', 'Michael Wilkins'] [floor(random()*100)+1] as name,
      ['+12953505448', '+11905184951', '+18042482553', '+19149712387', '+16166764600', '+12027300554', '+11892633628', '+15323557247', '+15222090502', '+12671277239', '+11090721920', '+12105528972', '+19384841641', '+16949792753', '+14289338017', '+10471796332', '+19842432729', '+16461975114', '+14675808007', '+19281911777', '+10187697937', '+18817774023', '+15502769171', '+13495401787', '+14094596521', '+15003539128', '+10356253565', '+14423173913', '+13475220390', '+19611170654', '+15854712143', '+13992167054', '+18841791460', '+14356578039', '+17914937496', '+17913249959', '+10850334373', '+10865044441', '+13182258438', '+18351572820', '+16315540550', '+15481506772', '+16150430101', '+12125861062', '+14129306347', '+14502216620', '+11243948618', '+19452492642', '+15815673870', '+19383545060', '+15229589429', '+13515441283', '+13882762938', '+15532711512', '+16737470762', '+12521340743', '+11344906687', '+12168712139', '+12721549323', '+18574651737', '+19882643813', '+17747628798', '+10890134811', '+10644500922', '+19959000741', '+18117951197', '+16090813528', '+19105142194', '+13370419762', '+17647863830', '+10318820001', '+15481786973', '+18944202879', '+16793723407', '+11856803011', '+10363713361', '+14132540969', '+17489239825', '+14595961929', '+13308668108', '+17858400641', '+11664038925', '+15692672292', '+18873148203', '+11450323169', '+13493952598', '+12600579317', '+17147834562', '+14059076825', '+10162330254', '+15291908735', '+15108977285', '+15118464508', '+15901987932', '+11770023652', '+18058870336', '+14964678876', '+18544892084', '+15257910603', '+13334618420'] [floor(random()*100)+1] as phone
    from
      generate_series(1, 1000000) as id
  );

insert into
  way_points (
    id,
    task_id,
    customer_id,
    position,
    no_earlier_than,
    city,
    address,
    no_later_than
  ) (
    with base as (
      select
        id,
        id / 2 as task_id,
        floor(random() * 1000000) + 1 as customer_id,
        (id % 2) + 1 as position,
        now() - (floor(random() * 730 * 24) * interval '1 hours') as no_earlier_than,
        ['New Janetshire', 'Lake Amandaville', 'Lake David', 'East Mark', 'Sarahberg', 'North David', 'North Matthew', 'Lake Jeffreyberg', 'Lake Dianaville', 'Stephenshaven', 'Alanbury', 'Reedfurt', 'New Eugenechester', 'New Danielstad', 'Port Brandon', 'Pettyshire', 'Lisaberg', 'Lake Margaretfort', 'Smithstad', 'Smithside', 'East Jimmy', 'Markhaven', 'West Kristinafort', 'Fryeborough', 'Thomasborough', 'North Jenniferberg', 'Donnaton', 'Sandershaven', 'Morganchester', 'Lake Austinmouth', 'New Lisamouth', 'West Victoria', 'Wandachester', 'Ramosborough', 'Kempbury', 'Port Suzannefort', 'Fordstad', 'North Andrewbury', 'Port Robert', 'Brianland', 'Kimberlymouth', 'Brightstad', 'North Jessica', 'New Elizabeth', 'Lake Kyleburgh', 'Deantown', 'New Julie', 'New Davidview', 'Howardfort', 'Nathantown', 'Leonardside', 'Derekport', 'Stephanieport', 'West Sarah', 'Smithberg', 'Martinfort', 'Lewisside', 'Brookschester', 'East Shane', 'Tarafort', 'Juliebury', 'North Jennifer', 'South Brandon', 'Traceyview', 'Amyhaven', 'South Anthony', 'Lake Latoyaburgh', 'Kyleville', 'Jenniferstad', 'Port Bryanburgh', 'Port Kenneth', 'Chapmanburgh', 'Santosmouth', 'Williehaven', 'New Kristyshire', 'Lake Seanfurt', 'South Elizabeth', 'Thomasburgh', 'East Crystal', 'West Tracy', 'West Donaldland', 'Watkinsstad', 'Hermanfurt', 'New Allison', 'Port Timothy', 'West Catherinehaven', 'Michelefort', 'Lake Christopher', 'East Patriciabury', 'Davidsonland', 'South Jeffview', 'New Joel', 'North Danatown', 'Hobbsburgh', 'East Brandyborough', 'Lake Michele', 'Edwardsfurt', 'Port Thomasstad', 'West Amyport', 'Lake Samuel'] [floor(random()*100)+1] as city,
        ['1559 James Mission Suite 799 South Elizabeth, PA 25984', '446 Wilkinson Branch East Cherylfort, CO 56487', '994 Mills Glen Apt. 776 Hoganhaven, SD 70785', '011 Sanders Roads Apt. 817 Roberttown, WV 68487', '35508 Nichols Lock Johnsonbury, MA 58470', '38616 Brown Village Ryanview, GA 58855', '59456 Clark Spur Suite 312 West Joseph, LA 92206', '588 Friedman Motorway Port Wendy, TN 07145', '39386 Guzman Court Apt. 024 North Matthew, LA 96836', 'PSC 9993, Box 6408 APO AA 94620', '54478 Castillo Lane Suite 507 Lake Christian, IL 06875', '83403 Richard View Apt. 850 West Charles, VT 07965', '06934 Bishop Extension Apt. 811 Port Cameronchester, CT 15436', '590 Valencia Dam East Christopher, CO 30810', '143 Martin Drive West Allisonbury, TN 09619', '942 Tammy Park Lake Gregory, WA 01805', '11761 Jennifer Point Apt. 604 Lake Ryanstad, ND 31739', '5563 Jill Crescent South Thomas, DC 45478', '910 Courtney Way Apt. 642 East Christopher, ID 85974', '497 White Fords North Williamtown, RI 47752', '197 Wang Light Suite 531 Amystad, OK 47697', '6930 Rivers Road Baldwinfurt, LA 68268', '11222 Roberts Wall Suite 048 West Courtney, WV 93321', '48431 Cheryl Mall Apt. 331 Woodport, DC 26087', '342 Ray Plaza Suite 029 Lake Juliebury, WV 00621', '4555 Martin Plaza Apt. 505 East Kristinemouth, HI 28381', '677 Baker Alley Apt. 960 North Matthewton, LA 12047', '83458 Summers Views West Randy, VA 38239', '6727 Natasha Ranch Lake Jackport, MD 50942', '0628 Moore Pines New Philipbury, KY 76375', '930 Williams Knoll Apt. 853 East Jose, HI 19945', '65772 Chelsea Court Sanfordstad, NC 01028', '75755 Erica Wall South Johnburgh, VA 97669', '01272 Anna Corner Apt. 741 Teresaberg, UT 27889', '004 Mary Cove Apt. 180 Youngside, MD 83526', 'PSC 1046, Box 8587 APO AA 24815', '9702 Nicholas Coves Suite 331 Solomonland, ME 01847', 'PSC 5170, Box 3413 APO AP 07662', '90309 Jeffrey Meadow Robertsmouth, AL 72339', '4810 Jonathan Port Apt. 482 Smithberg, MD 05882', '03994 Arnold Bridge South Jerrymouth, RI 20351', '187 Jones Fork Apt. 222 Colestad, NC 91203', '2193 Perry Pass Apt. 472 West Whitneyton, MN 04514', '148 Cheryl Village Suite 073 Port Robertshire, MN 74227', '4003 Crystal Cape South Tyler, SD 05261', '037 Richard Ville Kathrynhaven, DC 85145', '7538 Nash Parkway Apt. 383 South Ericafurt, AZ 29324', '917 Frazier Turnpike Apt. 877 Kerrymouth, CT 20215', '40495 Jared Passage North Nicholas, MO 59557', 'USNV Faulkner FPO AE 92056', '0951 Rodriguez Pass New Amanda, VT 89580', 'PSC 4605, Box 3599 APO AA 01276', 'Unit 6421 Box 8090 DPO AA 92020', '33092 Bailey Point Apt. 125 Christineport, CT 39618', '6561 Garcia Greens Suite 234 Thompsonbury, NE 97652', '5088 Patrick Trail Suite 598 West Gabriellaport, AL 34191', '119 Rivera Mill New Megan, MI 94555', '23526 John Lakes Justinview, MI 75568', '93912 Schneider Islands Suite 621 West Danielland, NV 81727', 'Unit 6347 Box 4604 DPO AA 23470', '0537 Parker Neck Frederickchester, LA 97068', '36428 Daniels Key Suite 002 Geraldshire, AL 33466', '7214 Nichols Lights Apt. 553 New Jasonshire, WV 17777', '817 Hansen Forest Suite 241 Miguelfurt, VT 65986', '0830 Morgan Avenue Port Codytown, TX 28801', '28271 Cox Falls Andrewschester, MS 50704', '53860 Danielle Circle Lake Kennethport, WY 58670', '785 Christian Island Barryview, IL 79375', '552 Sarah Plains Suite 766 Lake Carolynchester, SC 32984', '371 Chan Flat South Matthewstad, MT 34729', '24155 Garner Rest Robinsontown, TX 07240', '5514 Richard Circles Suite 350 South Theresa, FL 29770', 'Unit 6999 Box 3429 DPO AE 41048', 'USNV White FPO AE 77674', '85933 Heather Skyway Suite 588 Williamshire, TN 89864', '4861 Mario Springs Mooreberg, CO 24477', '6360 Dale Burgs Apt. 268 Danielburgh, KY 53328', '724 Gregory Camp Suite 114 North Stacey, AZ 73260', '42642 Thompson Place Melissaview, RI 04097', '34983 Michael Drive Apt. 740 New Amy, HI 67004', '123 Daniel Drive Jeffreyton, PA 48454', '742 Molly Dale Suite 778 New Rachelburgh, PA 54172', '989 Mejia Plain Apt. 809 Ochoaview, OR 46152', '096 Katrina Crossroad North Juanborough, WA 62596', '280 Chavez Forest Apt. 210 New Susan, AR 52505', '03999 Anderson Trace Lake Christinehaven, HI 51295', '100 Johnson Center Apt. 955 South Charlesshire, TN 30612', 'USNV Carrillo FPO AE 63280', '2115 Brittney Forks Elizabethbury, NY 10962', '24823 Robinson Coves Mcmahonland, SD 96998', '339 Shawn Crest Jessicaburgh, KS 10629', '395 Yoder Walk Anthonyville, SD 92204', '8407 Robert Common West Alfred, HI 42033', '488 Mike Skyway Suite 426 West Kelseyside, MT 44424', '554 Jacob Fords Maldonadohaven, MD 45933', '7056 Sanders Radial Apt. 700 Zacharyview, NJ 45282', '449 Derrick Isle Apt. 000 West Amberland, NM 02329', '6998 Maria Islands Port Timothyburgh, NC 39483', '2831 Garrett Burg Apt. 769 Lake Jeffrey, AZ 67413', '391 Patel Point Port Elizabethtown, NH 61428'] [floor(random()*100)+1] as address
      from
        generate_series(1, 2000000) as id
    )
    select
      *,
      no_earlier_than + interval '6 hours' as no_later_than
    from
      base
  );

ANALYZE;
