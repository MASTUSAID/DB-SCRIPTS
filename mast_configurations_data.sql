--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.5
-- Dumped by pg_dump version 9.3.1
-- Started on 2015-08-06 16:57:24

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- TOC entry 4470 (class 0 OID 22910)
-- Dependencies: 183
-- Data for Name: action; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO action VALUES ('Default', NULL, 5, NULL);


--
-- TOC entry 4515 (class 0 OID 0)
-- Dependencies: 184
-- Name: actions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('actions_id_seq', 5, true);


--
-- TOC entry 4472 (class 0 OID 22943)
-- Dependencies: 191
-- Data for Name: attribute_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO attribute_category VALUES (1, 'General');
INSERT INTO attribute_category VALUES (3, 'Multimedia');
INSERT INTO attribute_category VALUES (4, 'Tenure');
INSERT INTO attribute_category VALUES (5, 'Non Natural Person');
INSERT INTO attribute_category VALUES (2, 'Natural Person');
INSERT INTO attribute_category VALUES (6, 'Custom');
INSERT INTO attribute_category VALUES (7, 'General(Property)');


--
-- TOC entry 4475 (class 0 OID 22980)
-- Dependencies: 200
-- Data for Name: datatype_id; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO datatype_id VALUES (1, 'String');
INSERT INTO datatype_id VALUES (2, 'Date');
INSERT INTO datatype_id VALUES (3, 'Boolean');
INSERT INTO datatype_id VALUES (4, 'Number');
INSERT INTO datatype_id VALUES (5, 'Dropdown');


--
-- TOC entry 4473 (class 0 OID 22949)
-- Dependencies: 192
-- Data for Name: attribute_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO attribute_master VALUES (19, 'Occupation', 'occupation', 1, 2, 'natural_person', '50', false, NULL, true, 'Kazi ', true);
INSERT INTO attribute_master VALUES (32, 'Tenure Start Date', 'social_tenure_startdate', 2, 4, 'social_tenure_relationship', '10', false, NULL, false, 'Muda Tarehe ya Kuanza ', true);
INSERT INTO attribute_master VALUES (33, 'Tenure End Date', 'social_tenure_enddate', 2, 4, 'social_tenure_relationship', '10', false, NULL, false, 'Muda Tarehe ya Mwisho ', true);
INSERT INTO attribute_master VALUES (22, 'Marital Status', 'marital_status', 5, 2, 'natural_person', '10', false, NULL, true, 'Hali ya ndoa ', true);
INSERT INTO attribute_master VALUES (26, 'Household Relation', 'household_relation', 1, 2, 'natural_person', '50', false, NULL, true, 'Kaya Uhusiano ', true);
INSERT INTO attribute_master VALUES (21, 'Age', 'age', 4, 2, 'natural_person', '50', true, NULL, true, 'Umri ', true);
INSERT INTO attribute_master VALUES (25, 'Tenure Relation', 'tenure_relation', 1, 2, 'natural_person', '50', true, NULL, true, 'Muda Uhusiano ', true);
INSERT INTO attribute_master VALUES (1, 'First Name', 'first_name', 1, 2, 'natural_person', '100', true, 1, true, 'Jina la kwanza ', true);
INSERT INTO attribute_master VALUES (2, 'Last Name', 'last_name', 1, 2, 'natural_person', '100', true, 2, true, 'Jina la Mwisho ', true);
INSERT INTO attribute_master VALUES (3, 'Middle Name', 'middle_name', 1, 2, 'natural_person', '100', false, NULL, true, 'Jina la Kati ', true);
INSERT INTO attribute_master VALUES (4, 'Gender', 'gender', 5, 2, 'natural_person', '100', true, NULL, true, 'Jinsia ', true);
INSERT INTO attribute_master VALUES (27, 'Witness', 'witness', 1, 2, 'natural_person', '10', true, NULL, true, 'Shahidi ', true);
INSERT INTO attribute_master VALUES (6, 'Institution name', 'institution_name', 1, 5, 'non_natural_person', '10', true, 1, true, 'Jina Taasisi ', true);
INSERT INTO attribute_master VALUES (7, 'Address', 'address', 1, 5, 'non_natural_person', '50', false, NULL, true, 'Mitaani ', true);
INSERT INTO attribute_master VALUES (8, 'Phone Number', 'phone_number', 4, 5, 'non_natural_person', '50', true, NULL, true, 'Nambari ya simu ', true);
INSERT INTO attribute_master VALUES (10, 'Comments', 'comments', 1, 3, 'source_document', '100', false, NULL, true, 'Maoni ', true);
INSERT INTO attribute_master VALUES (11, 'Name', 'scanned_source_document', 1, 3, 'source_document', '100', true, 1, true, 'Jina ', true);
INSERT INTO attribute_master VALUES (12, 'Share', 'share', 4, 4, 'social_tenure_relationship', '10', false, NULL, false, 'Share ', true);
INSERT INTO attribute_master VALUES (251, 'Son Name', 'Son_name', 1, 6, 'custom', '12', true, NULL, false, '', false);
INSERT INTO attribute_master VALUES (241, 'Neighbour''s Name', 'number', 1, 6, 'custom', '40', false, NULL, true, 'Jina Neighbour ya ', false);
INSERT INTO attribute_master VALUES (256, 'Witness 1', 'Witness1', 1, 6, 'custom', '15', false, NULL, false, 'Witness 1', false);
INSERT INTO attribute_master VALUES (17, 'Comments', 'comments', 1, 7, 'spatial_unit', '100', false, 1, true, 'Maoni ', true);
INSERT INTO attribute_master VALUES (5, 'Mobile No.', 'mobile', 4, 2, 'natural_person', '10', false, NULL, true, 'Simu No. ', true);
INSERT INTO attribute_master VALUES (242, 'Family Income', 'number 2', 4, 6, 'custom', '20', false, NULL, false, 'Mapato ya familia ', false);
INSERT INTO attribute_master VALUES (50, 'Witness 3', 'witness_1', 1, 7, 'spatial_unit', '200', false, NULL, true, 'Shahidi 3', true);
INSERT INTO attribute_master VALUES (51, 'Witness 4', 'witness_1', 1, 7, 'spatial_unit', '200', false, NULL, true, 'Shahidi 4', true);
INSERT INTO attribute_master VALUES (9, 'Proposed Use', 'proposed_use', 5, 7, 'spatial_unit', '100', true, NULL, true, 'Matumizi yanayopendekezwa', true);
INSERT INTO attribute_master VALUES (13, 'How long have you used  this land ?', 'tenure_duration', 4, 4, 'social_tenure_relationship', '10', true, NULL, true, 'Ni kwa muda gani umetumia ardhi hii ?', true);
INSERT INTO attribute_master VALUES (38, 'Quality of soil', 'quality_of_soil', 5, 7, 'spatial_unit', '50', true, NULL, true, 'Ubora wa udongo', true);
INSERT INTO attribute_master VALUES (39, 'Slope of Land (%)', 'slope', 5, 7, 'spatial_unit', '50', true, NULL, true, 'Slope ya Ardhi (%)', true);
INSERT INTO attribute_master VALUES (37, 'Land Type', 'landtype_value', 5, 7, 'spatial_unit', '50', true, NULL, true, 'Ardhi Aina', true);
INSERT INTO attribute_master VALUES (40, 'Owner', 'owner', 3, 2, 'natural_person', '20', true, NULL, true, 'Mmiliki', true);
INSERT INTO attribute_master VALUES (42, 'Citizenship', 'citizenship', 1, 2, 'natural_person', '100', true, NULL, true, 'Uraia', true);
INSERT INTO attribute_master VALUES (43, 'Resident', 'resident_of_village', 3, 2, 'natural_person', '20', true, NULL, true, 'Mkazi', true);
INSERT INTO attribute_master VALUES (20, 'Education Level', 'education', 5, 2, 'natural_person', '50', true, NULL, true, 'Ngazi ya Elimu', true);
INSERT INTO attribute_master VALUES (23, 'Type of Right of occupancy', 'tenureclass_id', 5, 4, 'social_tenure_relationship', '10', true, NULL, true, 'Aina ya Hakimiliki', true);
INSERT INTO attribute_master VALUES (24, 'Occupancy Type', 'occupancy_type_id', 5, 4, 'social_tenure_relationship', '10', true, 1, true, 'Aina ya umiliki', true);
INSERT INTO attribute_master VALUES (31, 'Type of Tenure', 'social_tenure_relationship_type', 5, 4, 'social_tenure_relationship', '10', true, NULL, true, 'Aina ya milki', true);
INSERT INTO attribute_master VALUES (41, 'Administator', 'administator', 1, 2, 'natural_person', '100', false, NULL, true, 'Msimamizi', true);
INSERT INTO attribute_master VALUES (44, 'Neighbor North', 'neighbor_north', 1, 7, 'spatial_unit', '200', true, NULL, true, 'Jirani kaskazini', true);
INSERT INTO attribute_master VALUES (45, 'Neighbor South', 'neighbor_south', 1, 7, 'spatial_unit', '200', true, NULL, true, 'Jirani Kusini', true);
INSERT INTO attribute_master VALUES (46, 'Neighbor East', 'neighbor_east', 1, 7, 'spatial_unit', '200', true, NULL, true, 'Jirani Mashariki', true);
INSERT INTO attribute_master VALUES (47, 'Neighbor West', 'neighbor_west', 1, 7, 'spatial_unit', '200', true, NULL, true, 'Jirani Magharibi', true);
INSERT INTO attribute_master VALUES (15, 'Number of signatory(s)', 'total_househld_no', 4, 1, 'spatial_unit', '10', true, NULL, true, 'Idadi ya wenye saini', true);
INSERT INTO attribute_master VALUES (16, 'Existing Use', 'existing_use', 5, 7, 'spatial_unit', '10', true, NULL, true, 'Matumii yaliyopo', true);
INSERT INTO attribute_master VALUES (48, 'Witness 1', 'witness_1', 1, 1, 'spatial_unit', '200', true, NULL, true, 'Shahidi 1', true);
INSERT INTO attribute_master VALUES (49, 'Witness 2', 'witness_1', 1, 1, 'spatial_unit', '200', true, NULL, true, 'Shahidi 2', true);
INSERT INTO attribute_master VALUES (52, 'Group Type', 'type_name', 5, 5, 'spatial_unit', '200', true, NULL, true, 'Aina Group', true);
INSERT INTO attribute_master VALUES (53, 'Right of Way/Other Use', 'other_use_type', 1, 7, 'spatial_unit', '50', true, NULL, true, 'Haki ya njia/Matumizi mengine', true);
INSERT INTO attribute_master VALUES (257, 'test0106', 'test0106', 1, 3, 'custom', '50', false, NULL, true, 'test0106', false);
INSERT INTO attribute_master VALUES (258, 'test0206', 'test', 4, 6, 'custom', '50', true, NULL, false, 'test0206', false);
INSERT INTO attribute_master VALUES (259, 'testString0306length5', 'testString0306length5', 1, 1, 'custom', '5', true, NULL, true, 'testString0306length5', false);
INSERT INTO attribute_master VALUES (260, 'testDate0306', 'testDate0306', 2, 1, 'custom', '1', true, NULL, true, 'testDate0306', false);
INSERT INTO attribute_master VALUES (261, 'testBoolean0306', 'testBoolean0306', 3, 1, 'custom', '1', true, NULL, true, 'testBoolean0306', false);
INSERT INTO attribute_master VALUES (262, 'testNumber0306', 'testNumber0306', 4, 1, 'custom', '1', true, NULL, true, 'testNumber0306', false);
INSERT INTO attribute_master VALUES (263, 'uatattribute', 'uattest', 1, 6, 'custom', '100', true, NULL, false, 'uatattribute', false);


--
-- TOC entry 4474 (class 0 OID 22958)
-- Dependencies: 194
-- Data for Name: attribute_options; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO attribute_options VALUES (19, 'None', 20, 'hakuna', 1);
INSERT INTO attribute_options VALUES (22, 'University', 20, 'Chuo Kikuu', 4);
INSERT INTO attribute_options VALUES (20, 'Primary', 20, 'Msingi', 2);
INSERT INTO attribute_options VALUES (1, 'male', 4, 'kiume', 1);
INSERT INTO attribute_options VALUES (2, 'female', 4, 'kike', 2);
INSERT INTO attribute_options VALUES (4, 'married', 22, 'ndoa', 2);
INSERT INTO attribute_options VALUES (6, 'divorced', 22, 'talaka', 3);
INSERT INTO attribute_options VALUES (7, 'widow', 22, 'mjane', 4);
INSERT INTO attribute_options VALUES (8, 'widower', 22, 'mwanaume', 5);
INSERT INTO attribute_options VALUES (62, 'Commercial', 16, 'Biashara', 5);
INSERT INTO attribute_options VALUES (9, 'Forest', 9, 'Misitu', 2);
INSERT INTO attribute_options VALUES (71, 'Single occupier', 31, 'Milki Binafsi', 2);
INSERT INTO attribute_options VALUES (72, 'Joint Occupiers', 31, 'Milki ya pamoja', 3);
INSERT INTO attribute_options VALUES (70, 'Occupancy in common', 31, 'Milki kwa hisa', 1);
INSERT INTO attribute_options VALUES (80, 'Flat/Plain', 37, 'Tambarare', 1);
INSERT INTO attribute_options VALUES (81, 'Sloping', 37, 'Mteremko', 2);
INSERT INTO attribute_options VALUES (83, 'Valley', 37, 'Bonde', 4);
INSERT INTO attribute_options VALUES (53, 'Agriculture', 16, 'Kilimo', 1);
INSERT INTO attribute_options VALUES (29, 'Customary Right of Occupancy', 23, 'Hakimiliki ya kimila', 2);
INSERT INTO attribute_options VALUES (5, 'Agriculture', 9, 'Kilimo', 1);
INSERT INTO attribute_options VALUES (38, 'Settlement', 9, 'Makazi', 3);
INSERT INTO attribute_options VALUES (56, 'Settlement', 16, 'Makazi', 3);
INSERT INTO attribute_options VALUES (59, 'Facility (church/mosque/recreation)', 16, 'Kituo (Kanisa/Msikiti/Burudani)', 8);
INSERT INTO attribute_options VALUES (54, 'Forest', 16, 'Misitu', 2);
INSERT INTO attribute_options VALUES (40, 'Community Service', 9, 'Huduma za jamii', 6);
INSERT INTO attribute_options VALUES (57, 'Community Service', 16, 'Huduma za jamii', 6);
INSERT INTO attribute_options VALUES (3, 'un-married', 22, 'Hajaoa/hajaolewa', 1);
INSERT INTO attribute_options VALUES (75, 'Conservation', 9, 'Hifadhi', 14);
INSERT INTO attribute_options VALUES (79, 'Conservation', 16, 'Hifadhi', 14);
INSERT INTO attribute_options VALUES (17, 'Customary(Individual)', 24, 'Kimila (Binafsi)', 1);
INSERT INTO attribute_options VALUES (18, 'Customary(Collective)', 24, 'Kimila(Kwa pamoja)', 2);
INSERT INTO attribute_options VALUES (61, 'Wildlife (hunting)', 16, 'Wanyamapori (Uwindaji)', 10);
INSERT INTO attribute_options VALUES (42, 'Facility (church/mosque/recreation)', 9, 'Kituo (Kanisa/Msikiti/Burudani)', 8);
INSERT INTO attribute_options VALUES (44, 'Wildlife (hunting)', 9, 'Wanyamapori (Uwindaji)', 10);
INSERT INTO attribute_options VALUES (55, 'Livestock (pastoralism)', 16, 'Mifugo (Ufugaji)', 4);
INSERT INTO attribute_options VALUES (39, 'Livestock (pastoralism)', 9, 'Mifugo (Ufugaji)', 4);
INSERT INTO attribute_options VALUES (30, 'Right of Use', 23, 'Haki ya Matumizi', 3);
INSERT INTO attribute_options VALUES (103, 'Derivative Right', 23, 'Hakimiliki isiyo asili', 1);
INSERT INTO attribute_options VALUES (58, 'Grassland', 16, 'Nyika', 7);
INSERT INTO attribute_options VALUES (41, 'Grassland', 9, 'Nyika', 7);
INSERT INTO attribute_options VALUES (73, 'Wildlife (tourism)', 9, 'Wanyamapori (Utalii)', 12);
INSERT INTO attribute_options VALUES (74, 'Industrial', 9, 'Viwanda', 13);
INSERT INTO attribute_options VALUES (77, 'Wildlife (tourism)', 16, 'Wanyamapori (Utalii)', 12);
INSERT INTO attribute_options VALUES (78, 'Industrial', 16, 'Viwanda', 13);
INSERT INTO attribute_options VALUES (82, 'Mountainous', 37, 'Milima', 3);
INSERT INTO attribute_options VALUES (84, '0-2%', 39, '0-2%', 1);
INSERT INTO attribute_options VALUES (85, '2-5%', 39, '2-5%', 2);
INSERT INTO attribute_options VALUES (86, '5-10%', 39, '5-10%', 3);
INSERT INTO attribute_options VALUES (87, '10-20%', 39, '10-20%', 4);
INSERT INTO attribute_options VALUES (21, 'Secondary', 20, 'Sekondari', 3);
INSERT INTO attribute_options VALUES (76, 'Mining', 9, 'Uchimbaji madini', 11);
INSERT INTO attribute_options VALUES (69, 'Mining', 16, 'Uchimbaji madini', 11);
INSERT INTO attribute_options VALUES (60, 'Commercial/Service', 16, 'Biashara', 9);
INSERT INTO attribute_options VALUES (43, 'Commercial/Service', 9, 'Biashara', 9);
INSERT INTO attribute_options VALUES (45, 'Commercial', 9, 'Biashara', 5);
INSERT INTO attribute_options VALUES (88, '10-50%', 39, '10-50%', 5);
INSERT INTO attribute_options VALUES (89, 'Very good', 38, 'Very Good', 1);
INSERT INTO attribute_options VALUES (90, 'Moderate good', 38, 'Wastani Nzuri', 2);
INSERT INTO attribute_options VALUES (91, 'Poor', 38, 'Maskini', 3);
INSERT INTO attribute_options VALUES (92, 'Very Poor', 38, 'Duni Sana', 4);
INSERT INTO attribute_options VALUES (93, 'Civic', 52, 'Civic', 1);
INSERT INTO attribute_options VALUES (94, 'Mosque', 52, 'Msikiti', 2);
INSERT INTO attribute_options VALUES (95, 'Association', 52, 'Association', 3);
INSERT INTO attribute_options VALUES (96, 'Cooperation', 52, 'Ushirikiano', 4);
INSERT INTO attribute_options VALUES (97, 'Informal', 52, 'Rasmi', 5);
INSERT INTO attribute_options VALUES (98, 'Other', 52, 'Nyingine', 6);


--
-- TOC entry 4476 (class 0 OID 22985)
-- Dependencies: 202
-- Data for Name: education_level; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO education_level VALUES (1, 'None');
INSERT INTO education_level VALUES (2, 'Primary');
INSERT INTO education_level VALUES (3, 'Secondary');
INSERT INTO education_level VALUES (4, 'University');


--
-- TOC entry 4477 (class 0 OID 22991)
-- Dependencies: 203
-- Data for Name: gender; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO gender VALUES (1, 'Male', 'kiume');
INSERT INTO gender VALUES (2, 'Female', 'kike');


--
-- TOC entry 4478 (class 0 OID 22999)
-- Dependencies: 205
-- Data for Name: group_person; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4516 (class 0 OID 0)
-- Dependencies: 206
-- Name: group_person_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('group_person_gid_seq', 1, false);


--
-- TOC entry 4507 (class 0 OID 23876)
-- Dependencies: 290
-- Data for Name: group_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO group_type VALUES (1, 'Civic', 'Civic');
INSERT INTO group_type VALUES (2, 'Mosque', 'Msikiti');
INSERT INTO group_type VALUES (3, 'Association', 'Association');
INSERT INTO group_type VALUES (4, 'Cooperative', 'Ushirikiano');
INSERT INTO group_type VALUES (5, 'Informal', 'Rasmi');
INSERT INTO group_type VALUES (6, 'Other', 'Nyingine');


--
-- TOC entry 4508 (class 0 OID 23881)
-- Dependencies: 291
-- Data for Name: land_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO land_type VALUES (1, 'Flat/Plain', 'Tambarare');
INSERT INTO land_type VALUES (2, 'Sloping', 'Mteremko');
INSERT INTO land_type VALUES (3, 'Mountainous', 'Milima');
INSERT INTO land_type VALUES (4, 'Valley', 'Bonde');


--
-- TOC entry 4480 (class 0 OID 23004)
-- Dependencies: 207
-- Data for Name: land_use_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO land_use_type VALUES (1, 'Agriculture', 'Kilimo');
INSERT INTO land_use_type VALUES (2, 'Forest', 'Misitu');
INSERT INTO land_use_type VALUES (3, 'Settlement', 'Makazi');
INSERT INTO land_use_type VALUES (4, 'Livestock (pastoralism)', 'Mifugo (Ufugaji)');
INSERT INTO land_use_type VALUES (5, 'Commercial', 'Biashara');
INSERT INTO land_use_type VALUES (6, 'Community Service', 'Huduma za jamii');
INSERT INTO land_use_type VALUES (7, 'Grassland', 'Nyika');
INSERT INTO land_use_type VALUES (13, 'Industrial', 'Viwanda');
INSERT INTO land_use_type VALUES (14, 'Conservation', 'Hifadhi');


--
-- TOC entry 4481 (class 0 OID 23067)
-- Dependencies: 218
-- Data for Name: marital_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO marital_status VALUES (1, 'un-married', 'Hajaoa/hajaolewa');
INSERT INTO marital_status VALUES (2, 'married', 'ndoa');
INSERT INTO marital_status VALUES (3, 'divorced', 'ndoandoa');
INSERT INTO marital_status VALUES (4, 'widow', 'mjane');
INSERT INTO marital_status VALUES (5, 'widower', 'mwanaume');


--
-- TOC entry 4482 (class 0 OID 23075)
-- Dependencies: 220
-- Data for Name: module; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO module VALUES ('dynalayer', NULL, NULL, 24);
INSERT INTO module VALUES ('fileupload', NULL, NULL, 25);
INSERT INTO module VALUES ('textstyle', NULL, NULL, 26);
INSERT INTO module VALUES ('editing', NULL, NULL, 27);
INSERT INTO module VALUES ('clear_selection', NULL, NULL, 28);
INSERT INTO module VALUES ('saveproject', NULL, NULL, 29);
INSERT INTO module VALUES ('openproject', NULL, NULL, 30);
INSERT INTO module VALUES ('geoprocessing', NULL, NULL, 32);
INSERT INTO module VALUES ('zoomout', NULL, NULL, 3);
INSERT INTO module VALUES ('zoomin', NULL, NULL, 2);
INSERT INTO module VALUES ('thematic', NULL, NULL, 21);
INSERT INTO module VALUES ('export', NULL, NULL, 22);
INSERT INTO module VALUES ('markup', NULL, NULL, 23);
INSERT INTO module VALUES ('info', NULL, NULL, 11);
INSERT INTO module VALUES ('measurelength', NULL, NULL, 12);
INSERT INTO module VALUES ('zoomprevious', NULL, NULL, 8);
INSERT INTO module VALUES ('fixedzoomin', NULL, NULL, 6);
INSERT INTO module VALUES ('zoomnext', NULL, NULL, 9);
INSERT INTO module VALUES ('fullview', NULL, NULL, 10);
INSERT INTO module VALUES ('zoomtolayer', NULL, NULL, 5);
INSERT INTO module VALUES ('fixedzoomout', NULL, NULL, 7);
INSERT INTO module VALUES ('complaint', NULL, NULL, 33);
INSERT INTO module VALUES ('bookmark', NULL, NULL, 20);
INSERT INTO module VALUES ('query', NULL, NULL, 19);
INSERT INTO module VALUES ('print', NULL, NULL, 18);
INSERT INTO module VALUES ('zoomtoxy', NULL, NULL, 17);
INSERT INTO module VALUES ('search', NULL, NULL, 16);
INSERT INTO module VALUES ('selectpolygon', NULL, NULL, 15);
INSERT INTO module VALUES ('selectbox', NULL, NULL, 14);
INSERT INTO module VALUES ('selectfeature', NULL, NULL, 13);
INSERT INTO module VALUES ('report', NULL, NULL, 34);
INSERT INTO module VALUES ('importdata', NULL, NULL, 35);
INSERT INTO module VALUES ('radiometric', NULL, NULL, 36);
INSERT INTO module VALUES ('magnetic', NULL, NULL, 37);
INSERT INTO module VALUES ('pan', 'Map Pan ', NULL, 4);


--
-- TOC entry 4483 (class 0 OID 23078)
-- Dependencies: 221
-- Data for Name: module_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO module_action VALUES ('Default', 'bookmark', 89, NULL);
INSERT INTO module_action VALUES ('Default', 'fixedzoomin', 90, NULL);
INSERT INTO module_action VALUES ('Default', 'fixedzoomout', 91, NULL);
INSERT INTO module_action VALUES ('Default', 'fullview', 92, NULL);
INSERT INTO module_action VALUES ('Default', 'info', 93, NULL);
INSERT INTO module_action VALUES ('Default', 'measurelength', 94, NULL);
INSERT INTO module_action VALUES ('Default', 'pan', 95, NULL);
INSERT INTO module_action VALUES ('Default', 'search', 96, NULL);
INSERT INTO module_action VALUES ('Default', 'zoomin', 97, NULL);
INSERT INTO module_action VALUES ('Default', 'zoomnext', 98, NULL);
INSERT INTO module_action VALUES ('Default', 'zoomout', 99, NULL);
INSERT INTO module_action VALUES ('Default', 'zoomprevious', 100, NULL);
INSERT INTO module_action VALUES ('Default', 'zoomtolayer', 101, NULL);
INSERT INTO module_action VALUES ('Default', 'zoomtoxy', 102, NULL);
INSERT INTO module_action VALUES ('Default', 'clear_selection', 103, NULL);
INSERT INTO module_action VALUES ('Default', 'markup', 104, NULL);
INSERT INTO module_action VALUES ('Default', 'print', 105, NULL);
INSERT INTO module_action VALUES ('Default', 'selectbox', 106, NULL);
INSERT INTO module_action VALUES ('Default', 'selectfeature', 107, NULL);
INSERT INTO module_action VALUES ('Default', 'selectpolygon', 108, NULL);
INSERT INTO module_action VALUES ('Default', 'textstyle', 109, NULL);
INSERT INTO module_action VALUES ('Default', 'editing', 110, NULL);
INSERT INTO module_action VALUES ('Default', 'complaint', 111, NULL);
INSERT INTO module_action VALUES ('Default', 'dynalayer', 112, NULL);
INSERT INTO module_action VALUES ('Default', 'export', 113, NULL);
INSERT INTO module_action VALUES ('Default', 'fileupload', 114, NULL);
INSERT INTO module_action VALUES ('Default', 'geoprocessing', 115, NULL);
INSERT INTO module_action VALUES ('Default', 'importdata', 116, NULL);
INSERT INTO module_action VALUES ('Default', 'openproject', 117, NULL);
INSERT INTO module_action VALUES ('Default', 'query', 118, NULL);
INSERT INTO module_action VALUES ('Default', 'report', 119, NULL);
INSERT INTO module_action VALUES ('Default', 'saveproject', 120, NULL);
INSERT INTO module_action VALUES ('Default', 'thematic', 121, NULL);
INSERT INTO module_action VALUES ('Default', 'magnetic', 122, NULL);
INSERT INTO module_action VALUES ('Default', 'radiometric', 123, NULL);


--
-- TOC entry 4517 (class 0 OID 0)
-- Dependencies: 222
-- Name: module_action_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('module_action_id_seq', 123, true);


--
-- TOC entry 4518 (class 0 OID 0)
-- Dependencies: 223
-- Name: module_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('module_id_seq', 37, true);


--
-- TOC entry 4493 (class 0 OID 23215)
-- Dependencies: 257
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO role VALUES ('ROLE_PUBLICUSER', 'Public User', 3, NULL);
INSERT INTO role VALUES ('ROLE_USER', 'User', 2, NULL);
INSERT INTO role VALUES ('ROLE_TRUSTED_INTERMEDIARY', 'Trusted Intermediary', 4, NULL);
INSERT INTO role VALUES ('ROLE_ADJUDICATOR', 'Adjudicator', 5, NULL);
INSERT INTO role VALUES ('ROLE_LAO', 'Land Administration Official', 6, NULL);
INSERT INTO role VALUES ('ROLE_ADMIN', 'System Administrator', 1, NULL);
INSERT INTO role VALUES ('ROLE_PM', 'Project Manager', 7, NULL);


--
-- TOC entry 4486 (class 0 OID 23085)
-- Dependencies: 224
-- Data for Name: module_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO module_role VALUES ('ROLE_ADMIN', 'selectpolygon', NULL, 660, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'bookmark', NULL, 724, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'clear_selection', NULL, 725, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'dynalayer', NULL, 727, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'editing', NULL, 728, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'export', NULL, 729, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'fileupload', NULL, 730, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'fixedzoomin', NULL, 731, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'fixedzoomout', NULL, 732, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'fullview', NULL, 733, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'geoprocessing', NULL, 734, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'info', NULL, 736, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'magnetic', NULL, 737, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'markup', NULL, 738, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'measurelength', NULL, 739, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'openproject', NULL, 740, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'pan', NULL, 741, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'print', NULL, 742, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'query', NULL, 743, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'radiometric', NULL, 744, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'saveproject', NULL, 746, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'search', NULL, 747, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'selectbox', NULL, 748, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'selectfeature', NULL, 749, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'selectpolygon', NULL, 750, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'zoomin', NULL, 753, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'zoomnext', NULL, 754, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'zoomout', NULL, 755, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'zoomprevious', NULL, 756, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'zoomtolayer', NULL, 757, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'zoomtoxy', NULL, 758, NULL);
INSERT INTO module_role VALUES ('ROLE_ADMIN', 'zoomtoxy', NULL, 759, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'bookmark', NULL, 760, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'clear_selection', NULL, 761, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'dynalayer', NULL, 763, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'editing', NULL, 764, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'export', NULL, 765, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'fileupload', NULL, 766, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'fixedzoomin', NULL, 767, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'fixedzoomout', NULL, 768, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'fullview', NULL, 769, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'geoprocessing', NULL, 770, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'info', NULL, 772, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'magnetic', NULL, 773, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'markup', NULL, 774, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'measurelength', NULL, 775, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'openproject', NULL, 776, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'pan', NULL, 777, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'print', NULL, 778, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'query', NULL, 779, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'radiometric', NULL, 780, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'saveproject', NULL, 782, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'search', NULL, 783, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'selectbox', NULL, 784, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'selectfeature', NULL, 785, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'selectpolygon', NULL, 786, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'zoomin', NULL, 789, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'zoomnext', NULL, 790, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'zoomout', NULL, 791, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'zoomprevious', NULL, 792, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'zoomtolayer', NULL, 793, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'zoomtoxy', NULL, 794, NULL);
INSERT INTO module_role VALUES ('ROLE_PM', 'zoomtoxy', NULL, 795, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'bookmark', NULL, 796, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'clear_selection', NULL, 797, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'dynalayer', NULL, 799, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'editing', NULL, 800, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'export', NULL, 801, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'fileupload', NULL, 802, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'fixedzoomin', NULL, 803, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'fixedzoomout', NULL, 804, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'fullview', NULL, 805, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'geoprocessing', NULL, 806, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'info', NULL, 808, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'magnetic', NULL, 809, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'markup', NULL, 810, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'measurelength', NULL, 811, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'openproject', NULL, 812, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'pan', NULL, 813, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'print', NULL, 814, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'query', NULL, 815, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'radiometric', NULL, 816, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'saveproject', NULL, 818, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'search', NULL, 819, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'selectbox', NULL, 820, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'selectfeature', NULL, 821, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'selectpolygon', NULL, 822, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'zoomin', NULL, 825, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'zoomnext', NULL, 826, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'zoomout', NULL, 827, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'zoomprevious', NULL, 828, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'zoomtolayer', NULL, 829, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'zoomtoxy', NULL, 830, NULL);
INSERT INTO module_role VALUES ('ROLE_LAO', 'zoomtoxy', NULL, 831, NULL);


--
-- TOC entry 4487 (class 0 OID 23117)
-- Dependencies: 231
-- Data for Name: occupancy_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO occupancy_type VALUES (4, 'Disputed');
INSERT INTO occupancy_type VALUES (8, 'Customary(Individual)');
INSERT INTO occupancy_type VALUES (9, 'Customary (Collecrtive)');
INSERT INTO occupancy_type VALUES (10, 'Comfort');
INSERT INTO occupancy_type VALUES (11, 'Usufruct');
INSERT INTO occupancy_type VALUES (12, 'Water Rights');
INSERT INTO occupancy_type VALUES (3, 'Formal Ownership (Free-hold)');
INSERT INTO occupancy_type VALUES (5, 'Possession');
INSERT INTO occupancy_type VALUES (6, 'Grazing (Pastoral)');
INSERT INTO occupancy_type VALUES (7, 'Tenancy');
INSERT INTO occupancy_type VALUES (1, 'Customary(Individual)');
INSERT INTO occupancy_type VALUES (2, 'Customary(Collective)');


--
-- TOC entry 4488 (class 0 OID 23146)
-- Dependencies: 239
-- Data for Name: person_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO person_type VALUES (1, 'Natural');
INSERT INTO person_type VALUES (2, 'Non-Natural');
INSERT INTO person_type VALUES (3, 'Owner');
INSERT INTO person_type VALUES (4, 'Administrator');
INSERT INTO person_type VALUES (5, 'Guardian');


--
-- TOC entry 4489 (class 0 OID 23154)
-- Dependencies: 241
-- Data for Name: printtemplate; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO printtemplate VALUES ('Landscape (10inx 15in)', 'print-tmpl-landscape', NULL, 1, '2');
INSERT INTO printtemplate VALUES ('Portrait', 'print-tmpl-potrait', NULL, 2, '3');


--
-- TOC entry 4519 (class 0 OID 0)
-- Dependencies: 242
-- Name: printtemplate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('printtemplate_id_seq', 3, true);


--
-- TOC entry 4491 (class 0 OID 23210)
-- Dependencies: 255
-- Data for Name: projection; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO projection VALUES ('EPSG:27700', 'British National Grid Projection', 3, '1');
INSERT INTO projection VALUES ('EPSG:900913', 'SphericalMercator', 4, '1');
INSERT INTO projection VALUES ('EPSG:32643', 'EPSG:32643', 5, '1');
INSERT INTO projection VALUES ('EPSG:4326', 'EPSG:4326', 6, '1');
INSERT INTO projection VALUES ('EPSG:32733', 'EPSG:32733', 6, NULL);
INSERT INTO projection VALUES ('EPSG:21036', 'Arc1960_Zone36South', 1, NULL);


--
-- TOC entry 4520 (class 0 OID 0)
-- Dependencies: 256
-- Name: projection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('projection_id_seq', 6, true);


--
-- TOC entry 4521 (class 0 OID 0)
-- Dependencies: 258
-- Name: role_module_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('role_module_id_seq', 831, true);


--
-- TOC entry 4522 (class 0 OID 0)
-- Dependencies: 259
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('roles_id_seq', 27, true);


--
-- TOC entry 4496 (class 0 OID 23228)
-- Dependencies: 261
-- Data for Name: share_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO share_type VALUES (1, 'Occupancy in common');
INSERT INTO share_type VALUES (2, 'Single occupier');
INSERT INTO share_type VALUES (3, 'Joint Occupiers');


--
-- TOC entry 4509 (class 0 OID 23886)
-- Dependencies: 292
-- Data for Name: slope_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO slope_values VALUES (1, '0-2%');
INSERT INTO slope_values VALUES (2, '2-5%');
INSERT INTO slope_values VALUES (3, '5-10%');
INSERT INTO slope_values VALUES (4, '10-20%');
INSERT INTO slope_values VALUES (5, '10-50%');


--
-- TOC entry 4510 (class 0 OID 23891)
-- Dependencies: 293
-- Data for Name: soil_quality_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO soil_quality_values VALUES (1, 'Very good');
INSERT INTO soil_quality_values VALUES (2, 'Moderate good');
INSERT INTO soil_quality_values VALUES (3, 'Poor');
INSERT INTO soil_quality_values VALUES (4, 'Very poor');


--
-- TOC entry 4266 (class 0 OID 21892)
-- Dependencies: 171
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: rdsadmin
--



--
-- TOC entry 4497 (class 0 OID 23266)
-- Dependencies: 269
-- Data for Name: structure_facility; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4523 (class 0 OID 0)
-- Dependencies: 270
-- Name: structure_facility_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('structure_facility_gid_seq', 1, false);


--
-- TOC entry 4499 (class 0 OID 23271)
-- Dependencies: 271
-- Data for Name: style; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4524 (class 0 OID 0)
-- Dependencies: 272
-- Name: styles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('styles_id_seq', 1, false);


--
-- TOC entry 4501 (class 0 OID 23279)
-- Dependencies: 273
-- Data for Name: sunit_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO sunit_status VALUES (1, 'New');
INSERT INTO sunit_status VALUES (2, 'Adjudicated');
INSERT INTO sunit_status VALUES (3, 'Spatially Validated');
INSERT INTO sunit_status VALUES (4, 'Approved');
INSERT INTO sunit_status VALUES (5, 'Rejected');
INSERT INTO sunit_status VALUES (6, 'CCRO Generated');
INSERT INTO sunit_status VALUES (7, 'Final');


--
-- TOC entry 4502 (class 0 OID 23293)
-- Dependencies: 277
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4503 (class 0 OID 23296)
-- Dependencies: 278
-- Data for Name: task_scheduler; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4504 (class 0 OID 23299)
-- Dependencies: 279
-- Data for Name: tenure_class; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO tenure_class VALUES (2, 'Customary Right of Occupancy');
INSERT INTO tenure_class VALUES (4, 'Right of Use');
INSERT INTO tenure_class VALUES (5, 'Formal Ownership (Free-hold)');
INSERT INTO tenure_class VALUES (6, 'Right to Manage');
INSERT INTO tenure_class VALUES (3, 'Right of Use');
INSERT INTO tenure_class VALUES (1, 'Derivative Right');


--
-- TOC entry 4505 (class 0 OID 23305)
-- Dependencies: 280
-- Data for Name: unit; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO unit VALUES ('m', 'm', 5, '1');
INSERT INTO unit VALUES ('km', 'km', 4, '1');
INSERT INTO unit VALUES ('dd', 'dd', 1, '1');
INSERT INTO unit VALUES ('ft', 'ft', 2, NULL);
INSERT INTO unit VALUES ('in', 'in', 3, NULL);
INSERT INTO unit VALUES ('mi', 'mi', 6, NULL);


--
-- TOC entry 4525 (class 0 OID 0)
-- Dependencies: 281
-- Name: unit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('unit_id_seq', 6, true);


--
-- TOC entry 4383 (class 0 OID 23321)
-- Dependencies: 286
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO users VALUES ('admin', 'Tanzania_Pilot_Live', 'admin@rmsi.com', '2015-11-05', '2015-06-25', NULL, true, 'LY3t9lcJ/iwbHCdsO+yjRg==', 'xJDH3YRCr%2BSDZ1xP0OYTXmnS5%2FvCv68CCh2teLg%2F1yzAIOPxm%2BZe0DLYeXRl5UuY', 7953, NULL, '');


-- Completed on 2015-08-06 16:58:54

--
-- PostgreSQL database dump complete
--

