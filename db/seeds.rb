puts ""
puts "Seeding things..."
puts ""

UserDeviceType.create([{ id: 1, title: 'ios_app' } ])
ChatRoom.create([{ id: 1, title: 'General'}])

SiteLogType.create([{ id: 1, title: 'Authentication'}, { id: 2, title: 'General'}, { id: 3, title: 'Error'}])

TrainingItemType.create([{ id: 1, title: 'Text' }, { id: 2, title: 'Link' }, { id: 3, title: 'Video' }, { id: 4, title: 'Instructor Approval' }])

ReportHandler.create([{ id: 1, name: 'Generic Approval' }])

# make a base field
Field.create([{ name: 'Yes/No/Maybe' }])
FieldDescriptor.create([{ title: 'Yes', field: Field.first }, { title: 'No', field: Field.first }, { title: 'Maybe', field: Field.first }])
FieldDescriptorClass.create([{ title: 'Character Full Names', class_name: 'Character', class_field: 'full_name' }])

# make all the other fields
Field.create([{ id: '60152083-97c5-4262-9c88-2903cc8c44ad', name: 'Jump Point Connection Size' },
  { id: '62fdb35f-39ab-47f8-9fc0-0c690793e076', name: 'Jump Point Connection Status' },
  { id: 'ce45fca0-80c1-4969-84d4-2449eb0f5164', name: 'Gravity Well Luminosity Class' },
  { id: 'e5d23d1f-13bc-42b9-949f-383097773727', name: 'Gravity Well Type' },
  { id: '9393a4e0-210b-43db-a5e7-92d7d0226066', name: 'Location Type' },
  { id: '62ac3a07-ece3-4079-8da1-3e88617032fd', name: 'System Object Kind' }])

  FieldDescriptor.create([{ id:'9886a385-414d-42fd-bf06-a7da2d3aee8d',field_id:'60152083-97c5-4262-9c88-2903cc8c44ad',title:'Small',description:'Small Jump Point',ordinal:1 }, 
    { id:'e37a0432-57bc-4bcd-9449-5f9dfeddf271',field_id:'60152083-97c5-4262-9c88-2903cc8c44ad',title:'Medium',description:'Medium Jump Point',ordinal:2 }, 
    { id:'8984d2db-4b37-49cb-8588-a56bf35c8ff5',field_id:'60152083-97c5-4262-9c88-2903cc8c44ad',title:'Large',description:'Large Jump Point',ordinal:3 }, 
    { id:'550ae124-62bc-44c7-b3ac-3c336fdf5389',field_id:'62fdb35f-39ab-47f8-9fc0-0c690793e076',title:'Collapsed',description:'A collapsed jump point.',ordinal:1 }, 
    { id:'fd17e671-6dc7-4892-a651-633a750ad66b',field_id:'62fdb35f-39ab-47f8-9fc0-0c690793e076',title:'Active',description:'An active jump point.',ordinal:2 }, 
    { id:'122eef2b-4c15-447c-abff-1aeb167ec505',field_id:'62fdb35f-39ab-47f8-9fc0-0c690793e076',title:'Active - Not Public',description:'An active but not published jump point.',ordinal:3 }, 
    { id:'8f8ad7dd-6d11-42f8-bd6f-43c5ffc8e835',field_id:'62fdb35f-39ab-47f8-9fc0-0c690793e076',title:'Suspected',description:'A jump point which is suspected to exist but is not confirmed.',ordinal:4 }, 
    { id:'eec2d143-8dc7-4b9a-b3e1-e242844c9679',field_id:'e5d23d1f-13bc-42b9-949f-383097773727',title:'Black Hole (N/A)',description:'An ultra dense concentration of matter from which nothing escapes...or does it?',ordinal:1 }, 
    { id:'8adde7df-17b6-47aa-8986-f29a185f11fd',field_id:'e5d23d1f-13bc-42b9-949f-383097773727',title:'Star (O)',description:'Blue in color. Approximate surface temperature of over 25,000 K. Singly ionized helium lines (H I) either in emission or absorption. Strong UV continuum.',ordinal:2 }, 
    { id:'aa7149c4-8381-4ea7-91e1-c01df40285aa',field_id:'e5d23d1f-13bc-42b9-949f-383097773727',title:'Star (B)',description:'Blue in color. Approximate surface temperature of 11,000 - 25,000 K. Neutral helium lines (H II) in absorption.',ordinal:3 }, 
    { id:'0c4440f8-0326-4c0d-81d4-3a2fdd7493c2',field_id:'e5d23d1f-13bc-42b9-949f-383097773727',title:'Star (A)',description:'Blue in color. Approximate surface temperature of 7,500 - 11,000 K. Hydrogen (H) lines strongest for A0 stars, decreasing for other A\'s.',ordinal:4 }, 
    { id:'2c88b954-04ae-43b0-b2aa-6a58fe8b99b0',field_id:'e5d23d1f-13bc-42b9-949f-383097773727',title:'Star (F)',description:'Blue to white in color. Approximate surface temperature of 6,000 - 7,500 K. Ca II absorption. Metallic lines become noticeable.',ordinal:5 }, 
    { id:'c94ac19b-aa46-477c-ac66-3d717b2f43af',field_id:'e5d23d1f-13bc-42b9-949f-383097773727',title:'Star (G)',description:'White to yellow in color. Approximate surface temperature of 5,000 - 6,000 K. Absorption lines of neutral metallic atoms and ions (e.g. once-ionized calcium).',ordinal:6 }, 
    { id:'dbfeb49c-4bff-4f2d-812d-f09685ba7c96',field_id:'e5d23d1f-13bc-42b9-949f-383097773727',title:'Star (K)',description:'Orange to red in color. Approximate surface temperature of 3,500 - 5,000 K. Metallic lines, some blue continuum.',ordinal:7 }, 
    { id:'edad4f3a-71ce-4812-ab11-df0b01ef2fb8',field_id:'e5d23d1f-13bc-42b9-949f-383097773727',title:'Star (M)',description:'Red in color. Approximate surface temperature of under 3,500 K. Some molecular bands of titanium oxide.',ordinal:8 }, 
    { id:'d29c494f-3ee1-4bea-b5ac-907eb6802609',field_id:'ce45fca0-80c1-4969-84d4-2449eb0f5164',title:'Ia',description:'Very luminous supergiants',ordinal:2 }, 
    { id:'23a0cbdf-8a97-4d5b-923a-6fb24d84ccc6',field_id:'ce45fca0-80c1-4969-84d4-2449eb0f5164',title:'Ib',description:'Less luminous supergiants',ordinal:3 }, 
    { id:'0bf9a345-b711-46b3-9455-65ea82769b72',field_id:'ce45fca0-80c1-4969-84d4-2449eb0f5164',title:'II',description:'Luminous giants',ordinal:4 }, 
    { id:'af5507ba-4874-4acf-ba5b-fed9eb568357',field_id:'ce45fca0-80c1-4969-84d4-2449eb0f5164',title:'III',description:'Giants',ordinal:5 }, 
    { id:'e5bd92f8-b34a-4150-a8cc-417bc19197c2',field_id:'ce45fca0-80c1-4969-84d4-2449eb0f5164',title:'IV',description:'Subgiants',ordinal:6 }, 
    { id:'98e7673d-99f2-4e76-bf08-f4e94abc303c',field_id:'ce45fca0-80c1-4969-84d4-2449eb0f5164',title:'V',description:'Main sequence stars (dwarf stars)',ordinal:7 }, 
    { id:'6b15e11e-c7ae-4e3c-afec-f425c97790e1',field_id:'ce45fca0-80c1-4969-84d4-2449eb0f5164',title:'VI',description:'Subdwarf',ordinal:8 }, 
    { id:'cec22e41-aa1a-49ae-9ba1-3d3dffd8d125',field_id:'ce45fca0-80c1-4969-84d4-2449eb0f5164',title:'VIII',description:'White Dwarf',ordinal:9 }, 
    { id:'34890f34-096d-4670-a79e-5b1e36ea45e2',field_id:'ce45fca0-80c1-4969-84d4-2449eb0f5164',title:'N/A',description:'Black hole or other like brown dwarfs.',ordinal:10 }, 
    { id:'2add5860-c58b-4810-ae40-784a6c75c85c',field_id:'e5d23d1f-13bc-42b9-949f-383097773727',title:'Star (L)',description:'Reddish in color. Slightly cooler than class M stars',ordinal:9 }, 
    { id:'843ca017-8645-4fae-a746-cd75ac74177b',field_id:'e5d23d1f-13bc-42b9-949f-383097773727',title:'Star (T)',description:'Methane dwarf. Dark red in color when viewed via spectral analysis. Surface temperatures between approximately 550 and 1,300 K',ordinal:10 }, 
    { id:'7c6c9a7e-752e-4d57-a422-2fae94eb7d61',field_id:'e5d23d1f-13bc-42b9-949f-383097773727',title:'Star (Y)',description:'Brown in color. Non-luminous. Surface temperature typically below 500K.',ordinal:11 }, 
    { id:'f4f36159-b6b4-4c7e-99d1-29461ba134c8',field_id:'ce45fca0-80c1-4969-84d4-2449eb0f5164',title:'0',description:'Hypergiants or extremely luminous supergiants',ordinal:1 }, 
    { id:'41143a88-d331-4ccb-ab64-f172948b283f',field_id:'9393a4e0-210b-43db-a5e7-92d7d0226066',title:'POI',description:'A point of interest',ordinal:1 }, 
    { id:'ffec49b2-cd5f-48d1-8607-df6d46ac65e4',field_id:'9393a4e0-210b-43db-a5e7-92d7d0226066',title:'Store front',description:'A store or location that sells things',ordinal:2 }, 
    { id:'ee351848-ef7e-417c-8781-b5999c2bf025',field_id:'9393a4e0-210b-43db-a5e7-92d7d0226066',title:'Homestead',description:'A small single structure outpost',ordinal:3 }, 
    { id:'a3e15f52-e48a-465f-8c78-eeea063568a6',field_id:'9393a4e0-210b-43db-a5e7-92d7d0226066',title:'Base (Civilian)',description:'A larger collection of output structures operated by civilians.',ordinal:4 }, 
    { id:'02d4e08a-0081-435d-a189-00db0cc801b2',field_id:'9393a4e0-210b-43db-a5e7-92d7d0226066',title:'Base (Mercenary)',description:'A larger collection of output structures operated by mercenaries.',ordinal:5 }, 
    { id:'488c3722-55bb-4d1f-a79b-41ec9fe251d3',field_id:'9393a4e0-210b-43db-a5e7-92d7d0226066',title:'Base (Pirate)',description:'A larger collection of output structures operated by pirates.',ordinal:6 }, 
    { id:'c6404a8e-abef-4b15-97c6-98ff230a2fe6',field_id:'9393a4e0-210b-43db-a5e7-92d7d0226066',title:'Derelict',description:'A ship, typically crashed on the surface of a planetary body',ordinal:8 }, 
    { id:'1468dfcf-e848-491c-b980-bc0d429ccb13',field_id:'9393a4e0-210b-43db-a5e7-92d7d0226066',title:'Debris',description:'Debris. Generally non-descript junk.',ordinal:9 }, 
    { id:'30464ec5-949c-4a03-9d46-d95a32411c95',field_id:'9393a4e0-210b-43db-a5e7-92d7d0226066',title:'Ruins',description:'Ruins of some kind or another. Ancient or otherwise.',ordinal:10 }, 
    { id:'3ffb2364-48c7-4995-9c35-68311c6267d4',field_id:'9393a4e0-210b-43db-a5e7-92d7d0226066',title:'Base (Military)',description:'A larger collection of output structures operated by a military.',ordinal:7 }, 
    { id:'b7968f3a-41ce-49db-9a4c-86deb9953ad0',field_id:'62ac3a07-ece3-4079-8da1-3e88617032fd',title:'Station',description:'A small station that does not fall into other classifications.',ordinal:1 }, 
    { id:'ba0577d8-1220-43e5-9072-9eda7d6a9923',field_id:'62ac3a07-ece3-4079-8da1-3e88617032fd',title:'Satellite',description:'A generic satellite that does not fit into other classifications.',ordinal:2 }, 
    { id:'a0e3f23c-70ba-4ce1-8168-cd949b3740e3',field_id:'62ac3a07-ece3-4079-8da1-3e88617032fd',title:'Communications Satellite',description:'A communication satellite that is a part of the galactic communications network.',ordinal:3 }, 
    { id:'3c5b0bad-0518-4bb4-9a11-de14601842cc',field_id:'62ac3a07-ece3-4079-8da1-3e88617032fd',title:'Derelict Ship',description:'A ship abandoned and/or destroyed in space. ',ordinal:4 }, 
    { id:'41ff4e5b-48b2-40ef-a0e4-c4f8e7ad5cbc',field_id:'62ac3a07-ece3-4079-8da1-3e88617032fd',title:'Derelict Cargo',description:'A collection of cargo found in space. (likely a temporary fixture)',ordinal:5 }, 
    { id:'a1d54b82-b1bb-4faf-aa48-35695476cf53',field_id:'62ac3a07-ece3-4079-8da1-3e88617032fd',title:'Debris',description:'Non-specific collection of debris.',ordinal:6 }, 
    { id:'90f1149b-b747-405d-8660-0db730e0d69f',field_id:'62ac3a07-ece3-4079-8da1-3e88617032fd',title:'Rest Stop Station',description:'A \'small\' rest stop station. The stations typically provide a variety of service but lack habitation.',ordinal:7 }, 
    { id:'bdb3c43b-c7f3-4739-a969-3e58118e8f97',field_id:'62ac3a07-ece3-4079-8da1-3e88617032fd',title:'Port Station',description:'A \'large\' port station. These stations feature habitation and large collection of public services. They also typically provide docking moorings for larger classes of starship.',ordinal:8 }, 
    { id:'0a5faa82-ae2a-424e-9d68-790a6f3ec39a',field_id:'62ac3a07-ece3-4079-8da1-3e88617032fd',title:'Other',description:'Other objects which do not meet the currently defined definitions.',ordinal:99 }, 
    { id:'53923cf1-087c-4437-a5ad-2e4549e31ce8',field_id:'9393a4e0-210b-43db-a5e7-92d7d0226066',title:'Other',description:'Location types which do not fit into the current set of location classifications.',ordinal:99 }])

MenuItem.create([{ id: 1, title: 'Dashboard', icon: 'fa-star', link: '/', ordinal: 1 },
                 { id: 2, title: 'Profiles', icon: 'fa-users', link: '/profiles', ordinal: 2 },
                 { id: 3, title: 'Events', icon: 'fa-calendar', link: '/events', ordinal: 3 },
                 { id: 4, title: 'Job Board', icon: 'fa-briefcase', link: '/job-board', ordinal: 4 },
                 { id: 5, title: 'Flight Logs', icon: 'fa-book', link: '/flight-logs', ordinal: 5 },
                 { id: 6, title: 'Reports', icon: 'fa-file-alt', link: '/reports', ordinal: 6 },
                 { id: 8, title: 'Alerts', icon: 'fa-bell', link: '/alerts', ordinal: 8 },
                #  { id: 9, title: 'Commodities', icon: 'fa-hand-holding-usd', link: '/commodities', ordinal: 9 },
                 { id: 10, title: 'Offender Reports', icon: 'fa-shield-alt', link: '/offender-reports', ordinal: 10 },
                 { id: 11, title: 'System Map', icon: 'fa-globe', link: '/system-map', ordinal: 11 },
                 { id: 12, title: 'Admin', icon: 'fas fa-user', ordinal: 13 },
                 { id: 13, title: 'Requests', icon: 'fa-folder-open', link: '/requests', ordinal: 12 },
                 { id: 14, title: 'Impersonation', icon: 'fas fa-user', link: '/impersonate', ordinal: 1, nested_under_id: 12 },
                 { id: 15, title: 'Site Logs', icon: 'fas fa-user', link: '/site-logs', ordinal: 2, nested_under_id: 12 },
                 { id: 16, title: 'Roles', icon: 'fas fa-key', link: '/roles', ordinal: 3, nested_under_id: 12 },
                 { id: 17, title: 'Liabilities', icon: 'fas fa-chart-line', link: '/liabilities', ordinal: 4, nested_under_id: 12 },
                 { id: 18, title: 'Jobs Admin', icon: 'fas fa-building', link: '/jobs', ordinal: 5, nested_under_id: 12 },
                 { id: 19, title: 'Law Library', icon: 'fas fa-gavel', link: '/law-library', ordinal: 6, nested_under_id: 12 },
                 { id: 20, title: 'Faction', icon: 'fas fa-gavel', link: '/faction-admin', ordinal: 7, nested_under_id: 12 },
                 { id: 21, title: 'Field Admin', icon: 'fas fa-toilet-paper', link: '/field-admin', ordinal: 8, nested_under_id: 12 }
                 ])
# { id: 37, name: 'Roles Administrator', description: 'Can administrate roles.' },
# { id: 38, name: 'Jobs Administrator', description: 'Can view the jobs administrative panel.' },
# { id: 39, name: 'Logs Viewer', description: 'Can view site logs' },
# { id: 40, name: 'Liabilities Viewer', description: 'Can view the liabilites' },
MenuItemRole.create([{ id: 1, menu_item_id: 12, role_id: 42 },
                     { id: 2, menu_item_id: 14, role_id: 32 },
                     { id: 3, menu_item_id: 15, role_id: 39 },
                     { id: 4, menu_item_id: 16, role_id: 37 },
                     { id: 5, menu_item_id: 17, role_id: 40 },
                     { id: 6, menu_item_id: 18, role_id: 38 },
                     { id: 7, menu_item_id: 19, role_id: 43 }])

OauthClient.create([{ id: 1, title: "Test Client", client_id: "test-client", logo: '/assets/imgs/bendrocorp-final.png'}])

Badge.create([{ id: 1, title: 'Member', image_link: '/assets/imgs/badges/member.png', ordinal: 1 },
              { id: 2, title: 'Founder', image_link: '/assets/imgs/badges/founder.png', ordinal: 2 },
              { id: 3, title: 'Executive Board', image_link: '/assets/imgs/badges/eb.png', ordinal: 3 },
              { id: 4, title: 'Pilot Certification', image_link: '/assets/imgs/badges/pilot.png', ordinal: 4 },
              { id: 5, title: 'Donor', image_link: '/assets/imgs/badges/donor.png', ordinal: 5 }])

SystemMapAtmoGase.create([{ id: 1, title: "Oxygen (o2)" },
                          { id: 2, title: "Nitrogen (n2)" },
                          { id: 3, title: "Hydrogen (h2)" },
                          { id: 4, title: "Flourine (f2)" },
                          { id: 5, title: "Chlorine (cl2)" },
                          { id: 6, title: "Carbon Dioxide (co2)" },
                          { id: 7, title: "Carbon Monoxide" },
                          { id: 8, title: "Argon (ar2)" },
                          { id: 9, title: "Helium (he2)" },
                          { id: 10, title: "Neon" },
                          { id: 11, title: "Radon" },
                          { id: 12, title: "Krypton"},
                          { id: 13, title: "Sulfer Dioxide" },
                          { id: 14, title: "Water Vaper (h2o)"},
                          { id: 15, title: "Ammonia"},
                          { id: 16, title: "Methane"}])

JobBoardMissionCompletionCriterium.create([{ id: 1, title: 'Escort', description: 'Escort a fellow employee during a non-event cargo run.'},
                                           { id: 2, title: 'Bounty', description: 'TBA'},
                                           { id: 3, title: 'Catalogue', description: 'TBA'},
                                           { id: 4, title: 'Recovery', description: 'TBA'},
                                           { id: 5, title: 'Other', description: 'See mission description'}])

JobBoardMissionStatus.create([{ id: 1, title: 'Open', description: 'A mission that is open for acceptance.'},
                              { id: 2, title: 'Closed', description: 'A mission that has been closed.'},
                              { id: 3, title: 'Success', description: 'A mission where the objective(s) were met.'},
                              { id: 4, title: 'Failed', description: 'A mission where the objective(s) could not be met.'}])

JobLevel.create([{ id: 1, title: 'CEO', ordinal: 1},
                 { id: 2, title: 'Executive', ordinal: 2},
                 { id: 3, title: 'Director', ordinal: 3},
                 { id: 4, title: 'Manager', ordinal: 4},
                 { id: 5, title: 'Grade 4', ordinal: 5},
                 { id: 6, title: 'Grade 3', ordinal: 6},
                 { id: 7, title: 'Grade 2', ordinal: 7},
                 { id: 8, title: 'Grade 1', ordinal: 8},
                 { id: 9, title: 'Applicant', ordinal: 9}])

StoreCurrencyType.create([{ id: 1, title: 'Dollars', description: 'Good ole\' U.S.A. green backs. Used for real life items.', currency_symbol: '$' },
                          { id: 2, title: 'Operations Points', description: 'Internal BendroCorp currency. Redeemable for in-game items', currency_symbol: '(op)' }])

# Open, Processing, Shipped|Fulfilled, Cancelled, Refunded
StoreOrderStatus.create([{ id: 1, title: 'Open', description: 'Order is complete and awaiting intial processing. For real life items international shipping will be calculated during this time and you may be asked to pay additional shipping if you do not live in the continental U.S.A.'},
                         { id: 2, title: 'Processing', description: 'Your order is being processed by a real person.'},
                         { id: 3, title: 'Shipped/Fulfilled', description: 'Your order has been shipped and/or fulfilled.'},
                         { id: 4, title: 'Cancelled', description: 'This order has been cancelled and is awaiting refund.'},
                         { id: 5, title: 'Refunded', description: 'This order has been refunded.', can_select: false }])

alert_types = AlertType.create([{ id: 1, title: 'Notice', sub_title: '', description: 'Informational alerts for employees', selectable:true },
                                { id: 2, title: 'Travel Advisory', sub_title: 'Short-Term', description: 'Typically issued if an offender report was recently logged in the system. Has an expiration.'},
                                { id: 3, title: 'Travel Advisory', sub_title: 'Long-Term', description: 'Indicates that employees should exercise extreme caution when entering the system, planet (eventually moon or system object)'},
                                { id: 4, title: 'Travel Ban', sub_title: 'Long-Term', description: 'Indicates that employees are not allowed to operate in the system in an official capacity without an escort or Executive approval'},
                                { id: 5, title: 'CSAR', sub_title: 'Rescue Request', description: 'An employee is requesting emergency assistance.', selectable:true }])

factions = FactionAffiliation.create([{ title: 'UEE', description: 'To be added', color: '#48BBD5' },
                                      { title: 'Banu', description: 'To be added', color: '#FFCE17' },
                                      { title: 'Vanduul', description: 'To be added', color: '#BD002D' },
                                      { title: 'Xi\'an', description: 'To be added', color: '#52C231' },
                                      { title: 'Developing', description: 'To be added', color: '#CA922D' },
                                      { title: 'Unclaimed', description: 'To be added', color: '#F68520' },
                                      { title: 'Hurston', description: 'To be added' },
                                      { title: 'ArcCorp', description: 'To be added' }])

CharacterGender.create([{ id: 1, title: 'Male' },
                        { id: 2, title: 'Female' }])

CharacterSpecy.create([{ id: 1, title: 'Human', description: 'Humans of Earth, Sol System'}])

OffenderReportViolenceRating.create([{ id: 1, title: "Neusance", description: "Through recklessness created dangerous situations around and/or through such actions damaged BendroCorp property.", color:"yellow" },
                                     { id: 2, title: "Dangerous", description: "Fired directly on a ship and/or person but did not attempt to destroy/kill. Should be approached with caution.", color:"orange" },
                                     { id: 3, title: "Lethal Threat", description: "Intended to destroy/disable/kill a ship and/or person(s) or has attempted to sieze mercantile cargo or corporate equipment by force. Should be approached with extreme caution.", color:"red" }])

OffenderReportInfraction.create([{ id: 1, title: "Theft", description: "", violence_rating: OffenderReportViolenceRating.find_by_id(2) },
                                 { id: 2, title: "Piracy", description: "", violence_rating: OffenderReportViolenceRating.find_by_id(3) },
                                 { id: 3, title: "Attempted Murder", description: "", violence_rating: OffenderReportViolenceRating.find_by_id(3) },
                                 { id: 4, title: "Murder", description: "", violence_rating: OffenderReportViolenceRating.find_by_id(3) },
                                 { id: 5, title: "Manslaughter", description: "", violence_rating: OffenderReportViolenceRating.find_by_id(3) },
                                 { id: 6, title: "Trepass", description: "", violence_rating: OffenderReportViolenceRating.find_by_id(2) },
                                 { id: 7, title: "Nuisance", description: "", violence_rating: OffenderReportViolenceRating.find_by_id(1) },
                                 { id: 8, title: "Endangerment", description: "", violence_rating: OffenderReportViolenceRating.find_by_id(1) },
                                 { id: 9, title: "Destruction", description: "", violence_rating: OffenderReportViolenceRating.find_by_id(2) },])

OffenderReportForceLevel.create([{ id: 1, title: "None", description: "No force was used to stop the offender (ex. verbal) (explain)", ordinal: 1 },
                                 { id: 2, title: "Non-Lethal", description: "Force not designed to cause harm was used to stop the offender.", ordinal: 2 },
                                 { id: 3, title: "Less-than-lethal", description: "Less-than-lethal force was used to subdue the offender. (ex. stun weapons, disrupters, warning shot)", ordinal: 3 },
                                 { id: 4, title: "Lethal", description: "Lethal force was used to stop the offender", ordinal: 4 },
                                 { id: 5, title: "None (Unable)", description: "Force could not be used to stop the offender (explain)", ordinal: 5 }])

# SystemMapSystemSafetyRating.create([{ id: 1, title: "No Threat", description: "There have been no recent reports of BendroCorp ships being attacked here.", color:"green" },
#                                    { id: 2, title: "Threat Exists", description: "There have been recent but non-frequent reports of BendroCorp ships being fired on this area or along this flight path. Exercise caution.", color:"yellow" },
#                                    { id: 3, title: "Escort Required", description: "There have been recent and frequent reports of BendroCorp ships being attacked in this area or along this flight path. Corporate freighters and medium-large ships on sanctioned missions are required to have an escort in this area.", color:"red" }])

# SystemMapObjectKind.create([{ id: 1, title: "System", class_name: "SystemMapSystem"},
#                             { id: 2, title: "Gravity Well", class_name: "SystemMapSystemGravityWell"},
#                             { id: 3, title: "Planet", class_name: "SystemMapSystemPlanetaryBody"},
#                             { id: 4, title: "Moon", class_name: "SystemMapSystemPlanetaryBodyMoon"},
#                             { id: 5, title: "System Object", class_name: "SystemMapSystemObject"},
#                             { id: 6, title: "Settlement", class_name: "SystemMapSystemSettlement"},
#                             { id: 7, title: "Location", class_name: "SystemMapSystemPlanetaryBodyLocation"},
#                             { id: 8, title: "Fauna", class_name: "SystemMapFauna"},
#                             { id: 9, title: "Flora", class_name: "SystemMapFlora"},
#                             { id: 10, title: "Jump Point", class_name: "SystemMapSystemConnection"}])

ships = Ship.create([{ name: 'M50 Intercepter', manufacturer: 'ORIG'},
                      { name: 'Mustang Beta', manufacturer: 'CNOU'},
                      { name: 'Mustang Gamma', manufacturer: 'CNOU'},
                      { name: 'Mustang Delta', manufacturer: 'CNOU'},
                      { name: 'Mustang Omega', manufacturer: 'CNOU'},
                      { name: 'Mustang Alpha', manufacturer: 'CNOU'},
                      { name: 'Redeemer', manufacturer: 'AEGS'},
                      { name: 'Gladius', manufacturer: 'AEGS'},
                      { name: 'Aurora ES', manufacturer: 'RSI'},
                      { name: 'Aurora LX', manufacturer: 'RSI'},
                      { name: 'Aurora MR', manufacturer: 'RSI'},
                      { name: 'Aurora CL', manufacturer: 'RSI'},
                      { name: 'Aurora LN', manufacturer: 'RSI'},
                      { name: '300i', manufacturer: 'ORIG'},
                      { name: '315p', manufacturer: 'ORIG'},
                      { name: '325a', manufacturer: 'ORIG'},
                      { name: '350R', manufacturer: 'ORIG'},
                      { name: 'F7C Hornet', manufacturer: 'ANVL'},
                      { name: 'F7C-S Hornet Ghost', manufacturer: 'ANVL'},
                      { name: 'F7C-R Hornet Tracker', manufacturer: 'ANVL'},
                      { name: 'F7C-M Super Hornet', manufacturer: 'ANVL'},
                      { name: 'F7CA Hornet', manufacturer: 'ANVL'},
                      { name: 'Constellation Andromeda', manufacturer: 'RSI'},
                      { name: 'Constellation Aquila', manufacturer: 'RSI'},
                      { name: 'Constellation Taurus', manufacturer: 'RSI'},
                      { name: 'Constellation Phoenix', manufacturer: 'RSI'},
                      { name: 'Freelancer', manufacturer: 'MISC'},
                      { name: 'Freelancer DUR', manufacturer: 'MISC'},
                      { name: 'Freelancer MAX', manufacturer: 'MISC'},
                      { name: 'Freelancer MIS', manufacturer: 'MISC'},
                      { name: 'Cutlass Black', manufacturer: 'DRAK'},
                      { name: 'Cutlass Red', manufacturer: 'DRAK'},
                      { name: 'Cutlass Blue', manufacturer: 'DRAK'},
                      { name: 'Avenger Stalker', manufacturer: ''},
                      { name: 'Avenger Warlock', manufacturer: 'AEGS'},
                      { name: 'Avenger Titan', manufacturer: 'AEGS'},
                      { name: 'Gladiator', manufacturer: 'ANVL'},
                      { name: 'Starfarer', manufacturer: 'MISC'},
                      { name: 'Starfarer Gemini', manufacturer: 'MISC'},
                      { name: 'Caterpillar', manufacturer: 'DRAK'},
                      { name: 'Retaliator', manufacturer: 'AEGS'},
                      { name: 'Scythe', manufacturer: 'VANDUUL'},
                      { name: 'Idris-M', manufacturer: 'AEGS'},
                      { name: 'Idris-P', manufacturer: 'AEGS'},
                      { name: 'Khartu-al', manufacturer: 'XIAN'},
                      { name: 'Merchantman', manufacturer: 'BANU'},
                      { name: '890 Jump', manufacturer: 'ORIG'},
                      { name: 'Carrack', manufacturer: 'ANVL'},
                      { name: 'Herald', manufacturer: 'DRAK'},
                      { name: 'Hull C', manufacturer: 'MISC'},
                      { name: 'Hull A', manufacturer: 'MISC'},
                      { name: 'Hull B', manufacturer: 'MISC'},
                      { name: 'Hull D', manufacturer: 'MISC'},
                      { name: 'Hull E', manufacturer: 'MISC'},
                      { name: 'Orion', manufacturer: 'RSI'},
                      { name: 'Reclaimer', manufacturer: 'AEGS'},
                      { name: 'Javelin Class Destroyer', manufacturer: 'AEGS'},
                      { name: 'Vanguard Warden', manufacturer: 'AEGS'},
                      { name: 'Vanguard Harbinger', manufacturer: 'AEGS'},
                      { name: 'Vanguard Sentinel', manufacturer: 'AEGS'},
                      { name: 'Reliant Kore', manufacturer: 'MISC'},
                      { name: 'Reliant Mako', manufacturer: 'MISC'},
                      { name: 'Reliant Sen', manufacturer: 'MISC'},
                      { name: 'Reliant Tana', manufacturer: 'MISC'},
                      { name: 'Genesis Starliner', manufacturer: 'CRSD'},
                      { name: 'Glaive', manufacturer: 'ESPERIA'},
                      { name: 'Endeavor', manufacturer: 'MISC'},
                      { name: 'Sabre', manufacturer: 'AEGS'},
                      { name: 'Crucible', manufacturer: 'ANVL'},
                      { name: 'Terrapin', manufacturer: 'ANVL'}])

page_categories = PageCategory.create([{ title: 'General' },
                                       { title: 'Recruitment' },
                                       { title: 'Transport' },
                                       { title: 'Security' },
                                       { title: 'Research' },
                                       { title: 'Ships' },
                                       { title: 'Training' }])

event_types = EventType.create([{ id: 1, title: 'Operation'},
                                { id: 2, title: 'Livestream'}])

attendence_types = AttendenceType.create([{ id: 1, title: "Attending"},
                                          { id: 2, title: 'Not Attending'},
                                          { id: 3, title: 'No Response'}])

approval_types = ApprovalType.create([{ id: 1, title: 'Pending', description: 'Not yet approved or declined request.'},
                                      { id: 2, title: 'Pending (Unseen)', description: 'Not yet approved or declined request and not viewed.'},
                                      { id: 3, title: 'Pending (Seen)', description: 'Not yet approved or declined request and viewed.'},
                                      { id: 4, title: 'Approved', description: 'Approved request'},
                                      { id: 5, title: 'Declined', description: 'Declined request'},
                                      { id: 6, title: 'Feedback not needed', description: 'Feedback not needed.'}])

ApprovalWorkflow.create([{ id: 1, title: 'Standard', description: 'Standard all or nothing approval workflow'},
                         { id: 2, title: 'Standard - Applicant', description: 'This approval is similiar to standard except that it is meant to exclusively handle applicant approvals' },
                         { id: 3, title: 'Standard - Do Nothing', description: 'This approval is similiar to standard except that nothing happens if the approval passes' }])
#page = Page.create([{ title: 'Test page',
#                      subtitle: 'This is a catchy sub title',
#                      content: 'This is some page content its kinda cool and will allow HTML. Trust will be important here.',
#                      url_link: 'test-page',
#                      tags: 'testing guild',
#                      is_published: true,
#                      published_when: Time.now,
#                      page_category: page_categories[0] }])
#create default roles
roles = Role.create([{ id:1, name: 'Editor', description: 'Access to administrative controller.' },
                     { id:2, name: 'Executive', description: 'Access to Executive areas.' },
                     { id:3, name: 'Directors', description: 'Access to Director areas.'},
                     { id:4, name: 'Logistics', description: 'Access to Logistics areas.' },
                     { id:5, name: 'Security', description: 'Access to Security areas.' },
                     { id:6, name: 'Research', description: 'Access to Research areas.' },
                     { id:7, name: 'Human Resources', description: 'Access to Human Resources areas.' },
                     { id:8, name: 'Diplomat', description: 'A person with diplomatic access to the BendroCorp dashboard.' },
                     { id:9, name: 'CEO', description: 'The CEO of BendroCorp', max_users: 1},
                     { id:10, name: 'COO', description: 'The COO of BendroCorp', max_users: 1},
                     { id:11, name: 'CFO', description: 'The CFO of BendroCorp', max_users: 1},
                     { id:12, name: 'HR Director', description: 'The Human Resources Director of BendroCorp.', max_users: 1},
                     { id:13, name: 'Logistics Director', description: 'The Director of the Logistics Division.', max_users: 1},
                     { id:14, name: 'Security Director', description: 'The Director of the Security Division.', max_users: 1},
                     { id:15, name: 'Research Director', description: 'The Director of the Research Division.', max_users: 1},
                     { id:16, name: 'Offender Report Approver', description: 'Can approve offender reports'},
                     { id:17, name: 'Claim Approver', description: 'Can approve employee insurances claims.'},
                     { id:18, name: 'Event Editor', description: 'Can add and edit events'},
                     { id:19, name: 'Event Admin', description: 'Same rights as Event Editor and can certify events attendence and delete events.'},
                     { id:20, name: 'Directors', description: 'The Directors of BendroCorp.'},
                     { id:21, name: 'Flight Log Admin', description: 'Can approve flight log entries'},
                     { id:22, name: 'System Map Editor', description: 'Can create new system map entries'},
                     { id:23, name: 'System Map Admin', description: 'Can approve system map entries'},
                     { id:24, name: 'Research Division 0', description: 'Research Division 0'},
                     { id:25, name: 'Customer Service', description: ''},
                     { id:26, name: 'Customer Service Manager', description: ''},
                     { id:27, name: 'Trade Calculator Admin', description: ''},
                     { id:28, name: 'Job Board Admin', description: ''},
                     { id:29, name: 'Pages Editor', description: '' },
                     { id:30, name: 'Pages Admin', description: '' },
                     { id:31, name: 'Store Admin', description: '' },
                     { id:32, name: 'Impersonater', description: ''},
                     { id:33, name: 'Approval Kind Admin', description: ''},
                     { id:34, name: 'Menu Editor', description: 'Has the ability to edit the application menu.'},
                     { id:0, name: 'Member', description: 'Is a member of BendroCorp'},
                     { id: 35, name: 'Training Admin', description: '' },
                     { id: 36, name: 'Training Instructor', description: '' },
                     { id: 37, name: 'Roles Administrator', description: 'Can administrate roles.' },
                     { id: 38, name: 'Jobs Administrator', description: 'Can view the jobs administrative panel.' },
                     { id: 39, name: 'Logs Viewer', description: 'Can view site logs' },
                     { id: 40, name: 'Liabilities Viewer', description: 'Can view the liabilites' },
                     { id: 41, name: 'CEO Assistant', description: 'Assistant to the CEO' },
                     { id: 42, name: 'Admin Menu', description: 'Allows access to the admin menu' },
                     { id: 43, name: 'Legal Administrator', description: 'Allow admin access to the law system.'},
                     { id: 44, name: 'News Administrator', description: 'Allow admin access to the in-fiction news system.'},
                     { id: 45, name: 'Director of Medicine', description: '' },
                     { id: 46, name: 'Medical', description: '' },
                     { id: 47, name: 'Assistant to the CEO', description: '' },
                     { id: 48, name: 'Report Builder', description: '' },
                     { id: 49, name: 'Report Admin', description: '' },
                     { id: 50, name: 'Bot Master', description: '' },
                     { id: 51, name: 'Faction Administrator', description: '' },
                     { id: 52, name: 'Field Administrator', description: '' }])

ClassificationLevel.create([{ id: 1, title: 'Unclassified', description: 'Publically available corporate information.', ordinal: 1 },
                           { id: 2, title: 'Confidential', description: 'Not publically available information. Available to all members.', ordinal: 2 },
                           { id: 3, title: 'Secret', description: 'Sensitive non-compartmentalized information.', ordinal: 3 },
                           { id: 4, title: 'Top Secret', description: 'Highly sensitive non-compartmentalized information.', ordinal: 4 },
                           { id: 5, title: 'Special Access E1', description: 'Special access executive group. CEO and COO only.', ordinal: 5, compartmentalized: true },
                           { id: 6, title: 'Special Access E2', description: 'Special access executive group. CEO, COO and HR only.', ordinal: 6, compartmentalized: true },
                           { id: 7, title: 'Special Access R0', description: 'Special access group. CEO and Director of Research only. Along with members of Division 0.', ordinal: 7, compartmentalized: true, hidden: true },
                           { id: 8, title: 'Special Access R1', description: 'Special access group. CEO, COO and Director of Research.', ordinal: 8, compartmentalized: true },
                           { id: 9, title: 'Special Access R2', description: 'Special access group. CEO, COO, Director of Security and Director of Research.', ordinal: 9, compartmentalized: true },
                           { id: 10, title: 'Special Access L0', description: 'Special access group. CEO and Director of Logistics.', ordinal: 10, compartmentalized: true, hidden: true },
                           { id: 11, title: 'Special Access L1', description: 'Special access group. CEO, COO and Director of Logistics.', ordinal: 11, compartmentalized: true },
                           { id: 12, title: 'Special Access L2', description: 'Special access group. CEO, COO and Director of Logistics.', ordinal: 12, compartmentalized: true },
                           { id: 13, title: 'Special Access S0', description: 'Special access group. CEO and Director of Security.', ordinal: 13, compartmentalized: true, hidden: true  },
                           { id: 14, title: 'Special Access SI0', description: 'Special access group. CEO, Director of Security and Customer Service Manager.', ordinal: 14, compartmentalized: true, hidden: true  },
                           { id: 15, title: 'Special Access SI1', description: 'Special access group. CEO, COO, Director of Security, Customer Service Agents and Customer Service Manager.', ordinal: 15, compartmentalized: true, hidden: true  },
                           { id: 16, title: 'Special Access S1', description: 'Special access group. CEO, COO and Director of Security.', ordinal: 16, compartmentalized: true },
                           { id: 17, title: 'Special Access D1', description: 'Special access group. All Executives and Directors.', ordinal: 17, compartmentalized: true },
                          ])

ClassificationLevelRole.create([{ classification_level_id: 5, role_id: 9 }, #CEO
                                { classification_level_id: 5, role_id: 10 }, #COO
                                #G2
                                { classification_level_id: 6, role_id: 9 },
                                { classification_level_id: 6, role_id: 10 },
                                { classification_level_id: 6, role_id: 12 },
                                #R0
                                { classification_level_id: 7, role_id: 9 },
                                { classification_level_id: 7, role_id: 15 },
                                { classification_level_id: 7, role_id: 24 },
                                #R1
                                { classification_level_id: 8, role_id: 9 }, #CEO
                                { classification_level_id: 8, role_id: 10 }, #COO
                                { classification_level_id: 8, role_id: 15 }, #R-Director
                                #R2
                                { classification_level_id: 9, role_id: 9 },
                                { classification_level_id: 9, role_id: 10 },
                                { classification_level_id: 9, role_id: 15 },
                                { classification_level_id: 9, role_id: 14 }, #D-Security
                                #L0
                                { classification_level_id: 10, role_id: 9 }, #CEO
                                { classification_level_id: 10, role_id: 13 }, #D-Logistics
                                #L1
                                { classification_level_id: 11, role_id: 9 }, #CEO
                                { classification_level_id: 11, role_id: 10 }, #COO
                                { classification_level_id: 11, role_id: 13 }, #D-Logistics
                                #L2
                                { classification_level_id: 12, role_id: 9 }, #CEO
                                { classification_level_id: 12, role_id: 10 }, #COO
                                { classification_level_id: 12, role_id: 13 }, #D-Logistics
                                { classification_level_id: 12, role_id: 14 }, #D-Security
                                #S0
                                { classification_level_id: 13, role_id: 9 }, #CEO
                                { classification_level_id: 13, role_id: 14 }, #D-Security
                                #SI0
                                { classification_level_id: 14, role_id: 9 }, #CEO
                                { classification_level_id: 14, role_id: 14 }, #D-Security
                                { classification_level_id: 14, role_id: 26 }, #CS-Manager
                                #SI1
                                { classification_level_id: 15, role_id: 9 }, #CEO
                                { classification_level_id: 15, role_id: 10 }, #COO
                                { classification_level_id: 15, role_id: 14 }, #D-Security
                                { classification_level_id: 15, role_id: 26 }, #CS-Manager
                                { classification_level_id: 15, role_id: 25 }, #COO
                                #S1
                                { classification_level_id: 16, role_id: 9 }, #CEO
                                { classification_level_id: 16, role_id: 10 }, #COO
                                { classification_level_id: 16, role_id: 14 }, #D-Security
                                #D1
                                { classification_level_id: 17, role_id: 9 }, #CEO
                                { classification_level_id: 17, role_id: 10 }, #COO
                                { classification_level_id: 17, role_id: 14 }, #D-Security
                                { classification_level_id: 17, role_id: 13 }, #D-Logistics
                                { classification_level_id: 17, role_id: 15 } #R-Director
                               ])

nested_roles = NestedRole.create([{role_id: 9, role_nested_id:2}, #CEO roles
                                  {role_id: 9, role_nested_id:3},
                                  {role_id: 9, role_nested_id:4},
                                  {role_id: 9, role_nested_id:5},
                                  {role_id: 9, role_nested_id:6},
                                  {role_id: 9, role_nested_id:7},
                                  {role_id: 9, role_nested_id:2},
                                  {role_id: 9, role_nested_id:19},
                                  {role_id: 9, role_nested_id:16},
                                  {role_id: 9, role_nested_id:21},
                                  {role_id: 9, role_nested_id:23},
                                  {role_id: 9, role_nested_id:17},
                                  {role_id: 9, role_nested_id:27},
                                  {role_id: 9, role_nested_id:28},
                                  {role_id: 9, role_nested_id:30},
                                  {role_id: 9, role_nested_id:31},
                                  {role_id: 9, role_nested_id:32},
                                  {role_id: 9, role_nested_id:35},
                                  {role_id: 9, role_nested_id:36},
                                  {role_id: 9, role_nested_id:37},
                                  {role_id: 9, role_nested_id:38},
                                  {role_id: 9, role_nested_id:39},
                                  {role_id: 9, role_nested_id:40},
                                  {role_id: 10, role_nested_id:2},#COO Roles
                                  {role_id: 10, role_nested_id:3},
                                  {role_id: 10, role_nested_id:4},
                                  {role_id: 10, role_nested_id:5},
                                  {role_id: 10, role_nested_id:6},
                                  {role_id: 10, role_nested_id:7},
                                  {role_id: 10, role_nested_id:19},
                                  {role_id: 10, role_nested_id:16},
                                  {role_id: 10, role_nested_id:21},
                                  {role_id: 10, role_nested_id:23},
                                  {role_id: 10, role_nested_id:17},
                                  {role_id: 10, role_nested_id:27},
                                  {role_id: 10, role_nested_id:28},
                                  {role_id: 10, role_nested_id:30},
                                  {role_id: 10, role_nested_id:31},
                                  {role_id: 11, role_nested_id:2},#CFO Roles
                                  {role_id: 11, role_nested_id:3},
                                  {role_id: 11, role_nested_id:4},
                                  {role_id: 11, role_nested_id:5},
                                  {role_id: 11, role_nested_id:6},
                                  {role_id: 11, role_nested_id:7},
                                  {role_id: 11, role_nested_id:19},
                                  {role_id: 11, role_nested_id:17},
                                  {role_id: 11, role_nested_id:27},
                                  {role_id: 12, role_nested_id:2},#HR Director Roles
                                  {role_id: 12, role_nested_id:4},
                                  {role_id: 12, role_nested_id:5},
                                  {role_id: 12, role_nested_id:6},
                                  {role_id: 12, role_nested_id:7},
                                  {role_id: 12, role_nested_id:16},
                                  {role_id: 12, role_nested_id:20},
                                  {role_id: 13, role_nested_id:19}, #logistics director
                                  {role_id: 13, role_nested_id:4},
                                  {role_id: 13, role_nested_id:20},
                                  {role_id: 13, role_nested_id:21},
                                  {role_id: 13, role_nested_id:27},
                                  {role_id: 14, role_nested_id:5}, #security director
                                  {role_id: 14, role_nested_id:18},
                                  {role_id: 14, role_nested_id:16},
                                  {role_id: 15, role_nested_id:20},
                                  {role_id: 15, role_nested_id:6}, #research director
                                  {role_id: 15, role_nested_id:18},
                                  {role_id: 15, role_nested_id:20},
                                  {role_id: 15, role_nested_id:23},
                                  {role_id: 6, role_nested_id:22}, #research division
                                  {role_id: 35, role_nested_id:36}, #research division
                                  ])

approval_kinds = ApprovalKind.create([{ id: 1, title: 'Role Request'},
                                     { id: 2, title: 'Application Approval Request'},
                                     { id: 3, title: 'Award Approval'},
                                     { id: 4, title: 'Role Removal'},
                                     { id: 5, title: 'Claim Request'},
                                     { id: 6, title: 'Event Certification'},
                                     { id: 7, title: 'Offender Report'},
                                     { id: 8, title: 'Training Report'},
                                     { id: 9, title: 'Flight Log Entry'}, #only if event related - may not use
                                     { id: 10, title: 'System Map Entry'},
                                     { id: 11, title: 'Organization Ship Request'},
                                     { id: 12, title: 'Role Removal Request'},
                                     { id: 13, title: 'Research Project Approval Request'},
                                     { id: 14, title: 'Research Project Change Lead Request'},
                                     { id: 15, title: 'Offender Bounty Approval Request'},
                                     { id: 16, title: 'Organization Ship Crew Request'},
                                     { id: 17, title: 'Job Change Request'},
                                     { id: 18, title: 'Job Board Completion Request'},
                                     { id: 19, title: 'Job Board Creation Request'},
                                     { id: 20, title: 'Add System Map Item Request'},
                                     { id: 21, title: 'Report Approval Request'},
                                     { id: 22, title: 'Position Change Request'},
                                     { id: 23, title: 'Applicant Approval Request'},
                                     { id: 24, title: 'Training Item Completion Request'}])

ResearchProjectStatus.create([{ id: 1, title: 'Created/Approval Pending'},
                              { id: 2, title: 'Project Not Approved/Request Denied'},
                              { id: 3, title: 'In-Progress'},
                              { id: 4, title: 'Completed'},
                              { id: 5, title: 'Cancelled'}])

ResearchProjectTaskStatus.create([{ id: 1, title: 'In-Progress'},
                                  { id: 2, title: 'Completed'},
                                  { id: 3, title: 'Cancelled'}])

TradeItemType.create([{ id: 1, title: 'Resource Mineral'},
                      { id: 2, title: 'Resource Liquid'},
                      { id: 3, title: 'Resource Gas'},
                      { id: 4, title: 'Organic Other'},
                      { id: 5, title: 'Waste'},
                      { id: 6, title: 'Foodstuff'},
                      { id: 7, title: 'Technology'},
                      { id: 8, title: 'Component'},
                      { id: 9, title: 'Passenger'},
                      { id: 10, title: 'Metal'},
                      { id: 11, title: 'Salvage'},
                      { id: 12, title: 'Industrial'},
                      { id: 13, title: 'Vehicle'},
                      { id: 14, title: 'Pharma'},
                      { id: 15, title: 'Consumer Item'},
                      { id: 16, title: 'Other Item'},
                      { id: 17, title: 'Other'},
                      { id: 18, title: 'Rare'}])

approval_kinds[0].roles << roles[1] #execs - Role Request
approval_kinds[1].roles << roles[1] #execs - Application Approval Request
approval_kinds[2].roles << roles[1] #execs - Award Approval
approval_kinds[3].roles << roles[1] #execs - Role Removal
approval_kinds[4].roles << roles[10] #CFO { id: 5, title: 'Claim Request'}
approval_kinds[5].roles << roles[9] #COO - Event Certification
approval_kinds[5].roles << roles[8] #CEO - Event Certification
approval_kinds[6].roles << roles[11]# hr director - Offender Report
approval_kinds[6].roles << roles[13] #directory of security - Offender Report
approval_kinds[6].roles << roles[8] #ceo - Offender Report - NOTE# this needs to come out once testing is done
approval_kinds[7].roles << roles[11]# hr director - Training Report
approval_kinds[8].roles << roles[20] #flight log approver - Flight Log Entry
approval_kinds[9].roles << roles[22] #system map entry - system map approver

approval_kinds[10].roles << roles[1] #execs - Organization Ship Request

approval_kinds[11].roles << roles[1] #execs - Role Removal Request

approval_kinds[12].roles << roles[8] #CEO, Research Director - Start Research Project
approval_kinds[12].roles << roles[14]

approval_kinds[12].roles << roles[8] #CEO, Research Director - Research Project Change Lead
approval_kinds[12].roles << roles[14]
approval_kinds[14].roles << roles[8] #ceo - bounty approvals
approval_kinds[14].roles << roles[9] #coo - bounty approvals
approval_kinds[14].roles << roles[13] #Director of security - bounty approvals

approval_kinds[16].roles << roles[8] #ceo - job change
approval_kinds[16].roles << roles[9] #coo - job change
approval_kinds[16].roles << roles[11]# hr director - Training Report

#job board approval
approval_kinds[17].roles << roles[8] #CEO
approval_kinds[17].roles << roles[9] #COO

#job board creation approval
approval_kinds[18].roles << roles[8] #CEO
approval_kinds[18].roles << roles[9] #COO

# Add System Map Item Request
approval_kinds[19].roles << roles[8] #CEO, Research Director - Research Project Change Lead
approval_kinds[19].roles << roles[14] #Research Director

#add execs to position change approval
approval_kinds[21].roles << roles[1] #execs

# lesson approval
approval_kinds[23].roles << roles[35]

# add CEO

divisions = Division.create([{ id: 1,
                               name: 'Executive Division',
                               short_name: 'Executive Division',
                               description: 'Executive level positions are contained within this division.',
                               color: '#666666',
                               font_color: '#fff',
                               ordinal: 1 },
                               { id: 2,
                               name: 'Colonial Division',
                               short_name: 'Colonial & Logistics Division',
                               description: 'This division is responsible for the procuring and safely transporting goods to various planatery systems.',
                               color: 'yellow',
                               font_color: '#000',
                               ordinal: 2 },
                               { id: 3,
                               name: 'Security Division',
                               short_name: 'Security & Safety Division',
                               description: 'This division is responsible for facilitating assest protection for all BendroCorp resources and personnel.',
                               color: 'red',
                               font_color: '#fff',
                               ordinal: 3 },
                               { id: 4,
                               name: 'Research Division',
                               short_name: 'Research & Discovery Division',
                               description: 'This division is responsible for conducting scientific research, jump point discovery and recovery of BendroCorp and client assets.',
                               color: 'orange',
                               font_color: '#fff',
                               ordinal: 4 },
                               { id: 5,
                               name: 'Applications',
                               short_name: 'Applications & Recruitment Unit',
                               description: 'This unit is managed by the Director of Human Resources and is where new applications are housed.',
                               color: '#000',
                               font_color: '#fff',
                               can_have_ships: false,
                               ordinal: 98 },
                               { id: 6,
                               name: 'Retired',
                               short_name: 'Former Employees',
                               description: 'This is not a unit but it is the list of those people who have come before and I have left BendroCorp for a variety of reasons.',
                               color: '#000',
                               font_color: '#fff',
                               can_have_ships: false,
                               ordinal: 99 },
                               { id: 7,
                               name: 'Medical Division',
                               short_name: 'Medical & Rescue Division',
                               description: 'This division establishes guidelines and procedures to ensure that BendroCorp business operations are conducted in a manner which is safe and that protects the general welfare of BendroCorp employees. This division also provides timely medical assistance and medical care to BendroCorp employees, partners and the public at large.',
                               color: '#fff',
                               font_color: '#000',
                               can_have_ships: false,
                               ordinal: 5 } ])

jobs = Job.create([{ id:1,title:"Chief Executive Officer",description:"The Chief Executive Officer is in no small terms the leader of BendroCorp. The CEO presides over the Executive Board and sets the strategic direction of BendroCorp. All Directors report to the CEO.",recruit_job_id:nil,next_job_id:nil,division_id:1,hiring:false,job_level_id:1,max:1,hiring_description:nil,read_only:true,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:2,title:"Chief Operations Officer",description:"The Chief Operations Officer sees to the day to day 'tactical' operations of BendroCorp ensuring that the organization is running smoothly. All Directors report to the COO (and the CEO).",recruit_job_id:nil,next_job_id:nil,division_id:1,hiring:false,job_level_id:2,max:1,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:3,title:"Chief Financial Officer",description:"The boss",recruit_job_id:nil,next_job_id:nil,division_id:1,hiring:false,job_level_id:2,max:1,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:4,title:"Director of Human Resources",description:"The boss",recruit_job_id:nil,next_job_id:nil,division_id:1,hiring:false,job_level_id:3,max:1,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:5,title:"Customer Service Manager",description:"The Customer Service manager helps oversee various relationships with other corporation as well as researching avenues for better galactic engagement.",recruit_job_id:nil,next_job_id:nil,division_id:1,hiring:false,job_level_id:4,max:1,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:6,title:"Director of Colonial Affairs",description:"The Director of Colonial Affairs oversees and leads the Colonial & Logistics division. They oversee all of BendroCorp logistical operations including shipping and mining along with the construction of outposts and colonies.",recruit_job_id:nil,next_job_id:nil,division_id:2,hiring:false,job_level_id:3,max:1,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:7,title:"Director of Security",description:"The Director of Security is the leader of the Security & Safety Division and is directly responsible for ensuring the security of BendroCorp operations, assets and personnel from outside threats.",recruit_job_id:nil,next_job_id:nil,division_id:3,hiring:false,job_level_id:3,max:1,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:8,title:"Director of Research",description:"Oversees the day-to-day operations of the Research Division. Maintains an active exploration plan which facilitates the diligent search for new jump points and star systems. Oversees the training for all personnel under their command and ensure that all of their subordinate have the units required to maintain their certifications. Reports to the Chief Operations Officer.",recruit_job_id:nil,next_job_id:nil,division_id:4,hiring:false,job_level_id:3,max:1,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:9,title:"Junior Merchant Captain",description:"Entry level position into the logistics side of the Colonial & Logistics Division.",recruit_job_id:nil,next_job_id:13,division_id:2,hiring:true,job_level_id:9,max:0,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:13},
                    { id:10,title:"Junior Security Officer",description:"Entry-level security officer position. The 'beat cops' of BendroCorp. Security officers are what keep BendroCorp members safe. Security Officers are highly skilled operators who are highly effective in both space and ground combat.",recruit_job_id:nil,next_job_id:nil,division_id:3,hiring:true,job_level_id:9,max:0,hiring_description:"Entry-level security officer position. The 'beat cops' of BendroCorp. Security officers are what keep BendroCorp members safe. Security Officers are highly skilled operators who are highly effective in both space and ground combat.",read_only:false,op_eligible:false,checks_max_headcount_from_id:14},
                    { id:12,title:"Merchant Commander",description:"Manages a fleet of Merchant Captains.",recruit_job_id:nil,next_job_id:nil,division_id:2,hiring:false,job_level_id:7,max:1,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:13,title:"Merchant Captain",description:"Merchant Captain are purveyors of economic opportunity for BendroCorp. Whether operating trade vessels hauling goods to and fro or operating a mining vessel to extract required resources for Engineers Merchant Captains are the economic backbone of BendroCorp.",recruit_job_id:nil,next_job_id:nil,division_id:2,hiring:false,job_level_id:8,max:6,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:14,title:"Security Officer",description:"The 'beat cops' of BendroCorp. Security officers are what keep BendroCorp members safe. Security Officers are highly skilled operators who are highly effective in both space and ground combat.",recruit_job_id:nil,next_job_id:15,division_id:3,hiring:false,job_level_id:8,max:8,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:15,title:"Security Sergeant",description:"Supervises a wing of security officers. Responsible for the individual training of Security Officers under their supervision.",recruit_job_id:nil,next_job_id:16,division_id:3,hiring:false,job_level_id:7,max:2,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:16,title:"Security Lieutenant",description:"Not currently in use. Supervises up to three squads of security officers",recruit_job_id:nil,next_job_id:nil,division_id:3,hiring:false,job_level_id:5,max:0,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:17,title:"Senior Research Technician",description:"Overseas a team of technician dedicated to scientific research.",recruit_job_id:nil,next_job_id:17,division_id:4,hiring:false,job_level_id:9,max:1,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:18,title:"Junior Technician",description:"Entry level position into the Research Division. A researcher and scientist within the research division. A technician conducts various research projects at the direction of their Senior Technician and the Director of Research.",recruit_job_id:nil,next_job_id:19,division_id:4,hiring:true,job_level_id:8,max:0,hiring_description:"Entry level position into the Research Division. A researcher and scientist within the research division. A technician conducts various research projects at the direction of their Senior Technician and the Director of Research.",read_only:false,op_eligible:false,checks_max_headcount_from_id:19},
                    { id:19,title:"Technician",description:"A researcher and scientist within the research division. A technician conducts various research projects at the direction of their Senior Technician and the Director of Research.",recruit_job_id:nil,next_job_id:20,division_id:4,hiring:false,job_level_id:7,max:6,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:20,title:"Senior Engineering Technician",description:"Overseas a team of technician dedicated to engineering research and asset recovery.",recruit_job_id:nil,next_job_id:nil,division_id:4,hiring:false,job_level_id:6,max:1,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:21,title:"Applicant",description:"An individual who has applied to BendroCorp",recruit_job_id:nil,next_job_id:nil,division_id:5,hiring:false,job_level_id:9,max:-1,hiring_description:nil,read_only:true,op_eligible:false,checks_max_headcount_from_id:nil},
                    { id:22,title:"Retired",description:"A person who has voluntarily left BendroCorp.",recruit_job_id:nil,next_job_id:nil,division_id:6,hiring:nil,job_level_id:9,max:-1,hiring_description:nil,read_only:true,op_eligible:false,checks_max_headcount_from_id:nil},
                    { id:23,title:"Discharged",description:"A person who has involuntarily been removed from BendroCorp.",recruit_job_id:nil,next_job_id:nil,division_id:6,hiring:false,job_level_id:9,max:-1,hiring_description:nil,read_only:true,op_eligible:false,checks_max_headcount_from_id:nil},
                    { id:24,title:"Withdrawn",description:"An individual who has withdrawn their application to BendroCorp.",recruit_job_id:nil,next_job_id:nil,division_id:6,hiring:false,job_level_id:9,max:-1,hiring_description:nil,read_only:true,op_eligible:false,checks_max_headcount_from_id:nil},
                    { id:25,title:"Director of Medicine",description:"Is the senior physician within BendroCorp and directly responsible for the execution of proper medical care within BendroCorp. Responsible for developing the policies defined by the purpose for this division with input from other Directors and Executives. Develops training curriculum to train medical division staff in proper medical and patient care. Supervises, directs and is responsible for the day-to-day activities of the medical division. The Director of Medicine reports to the Chief Operations Officer.",recruit_job_id:nil,next_job_id:nil,division_id:7,hiring:false,job_level_id:3,max:1,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:26,title:"Physician",description:"Provides Tier 1 and Tier 2 medical care. Manages clinical teams as required. Assists the Chief Medical Officer as required in their duties.",recruit_job_id:nil,next_job_id:nil,division_id:7,hiring:false,job_level_id:4,max:2,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:27,title:"First Responder",description:"Provides Tier 3 medical care. Assists in the stabilization of patients for Tier 1 and Tier 2 medical care. Participates in rescue and recovery operations. Performs other duties as directed by BendroCorp executives, Chief Medical Officer and medical division physicians.",recruit_job_id:nil,next_job_id:26,division_id:7,hiring:false,job_level_id:7,max:4,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:28,title:"Junior First Responder",description:"Entry level position into the Medical Division. Provides Tier 3 medical care. Assists in the stabilization of patients for Tier 1 and Tier 2 medical care. Participates in rescue and recovery operations. Performs other duties as directed by BendroCorp executives, Chief Medical Officer and medical division physicians.",recruit_job_id:nil,next_job_id:27,division_id:7,hiring:false,job_level_id:8,max:0,hiring_description:"Entry level position into the Medical Division. Provides Tier 3 medical care. Assists in the stabilization of patients for Tier 1 and Tier 2 medical care. Participates in rescue and recovery operations. Performs other duties as directed by BendroCorp executives, Chief Medical Officer and medical division physicians.",read_only:false,op_eligible:true,checks_max_headcount_from_id:27},
                    { id:29,title:"Security Captain",description:"The Security Captain is the second in command of the security division and reports to the Director of Security.",recruit_job_id:nil,next_job_id:nil,division_id:3,hiring:false,job_level_id:4,max:1,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:31,title:"Senior Colonial Engineer",description:"The Senior Colonial Engineer acts as the primary operator supervisor of a BendroCorp Pioneer vessel. This will versed engineers are responsible for ensuring the safe construction for homesteads, outposts, and colonies. ",recruit_job_id:nil,next_job_id:nil,division_id:2,hiring:false,job_level_id:nil,max:1,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:32,title:"Colonial Engineer",description:"The Colonial Engineer works under a Senior Colonial Engineer to execute on the safe operation of a BendroCorp Pioneer vessel. Engineers are responsible for ensuring the safe construction for homesteads, outposts, and colonies. ",recruit_job_id:nil,next_job_id:nil,division_id:2,hiring:false,job_level_id:nil,max:4,hiring_description:nil,read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:33,title:"Junior Colonial Engineer",description:"The entry-level position into the Colonial side of the Colonial The Colonial Engineer works under a Senior Colonial Engineer to execute on the safe operation of a BendroCorp Pioneer vessel. Engineers are responsible for ensuring the safe construction for homesteads, outposts, and colonies. ",recruit_job_id:nil,next_job_id:32,division_id:2,hiring:false,job_level_id:nil,max:0,hiring_description:"The entry-level position into the Colonial side of the Colonial The Colonial Engineer works under a Senior Colonial Engineer to execute on the safe operation of a BendroCorp Pioneer vessel. Engineers are responsible for ensuring the safe construction for homesteads, outposts, and colonies. ",read_only:false,op_eligible:true,checks_max_headcount_from_id:32},
                    { id:34,title:"Colonial Division (Inactive)",description:"An inactive member of the Colonial Division.",recruit_job_id:nil,next_job_id:nil,division_id:2,hiring:false,job_level_id:-1,max:-1,hiring_description:nil,read_only:true,op_eligible:false,checks_max_headcount_from_id:nil},
                    { id:35,title:"Security Division (Inactive)",description:"An inactive member of the Security Division.",recruit_job_id:nil,next_job_id:nil,division_id:3,hiring:false,job_level_id:-1,max:-1,hiring_description:nil,read_only:true,op_eligible:false,checks_max_headcount_from_id:nil},
                    { id:36,title:"Research Division (Inactive)",description:"An inactive member of the Research Division.",recruit_job_id:nil,next_job_id:nil,division_id:4,hiring:false,job_level_id:-1,max:-1,hiring_description:nil,read_only:true,op_eligible:false,checks_max_headcount_from_id:nil},
                    { id:37,title:"Medical Division (Inactive)",description:"An inactive member of the Medical Division.",recruit_job_id:nil,next_job_id:nil,division_id:7,hiring:false,job_level_id:-1,max:-1,hiring_description:nil,read_only:true,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:39,title:"Assistant to the CEO",description:"The administrative right hand of the CEO. Responsible for supporting the CEO in their duties. Performs all duties and tasks assigned by the CEO and reports only to the CEO.",recruit_job_id:nil,next_job_id:nil,division_id:1,hiring:false,job_level_id:5,max:1,hiring_description:"The administrative right hand of the CEO. Responsible for supporting the CEO in their duties. Performs all duties and tasks assigned by the CEO and reports only to the CEO.",read_only:false,op_eligible:true,checks_max_headcount_from_id:nil},
                    { id:40,title:"Assistant to the COO",description:"The administrative right hand of the COO. Responsible for supporting the COO in their duties. Performs all duties and tasks assigned by the COO and reports only to the COO.",recruit_job_id:nil,next_job_id:nil,division_id:1,hiring:false,job_level_id:5,max:1,hiring_description:"The administrative right hand of the COO. Responsible for supporting the COO in their duties. Performs all duties and tasks assigned by the COO and reports only to the COO.",read_only:false,op_eligible:true,checks_max_headcount_from_id:nil}])

acttype = UserAccountType.create([{ id: 1, title: 'Membership', ordinal: 1}, { id: 2, title: 'Diplomat', ordinal: 2}, { id: 3, title: 'Customer', ordinal: 3}])

apptypes = ApplicationStatus.create([{ id: 1, title: 'Submitted', description: 'Your application has been submitted and is undergoing initial checks before being made available for initial review.', ordinal: 1},
                                    { id: 2, title: '360 Review', description: 'Your application is currently undergoing a 360 review by our membership. During this period all of the current membership has the opportunity to comment on your application.', ordinal: 2},
                                    { id: 3, title: 'Referred for Interview', description: 'Your application has been referred for an interview. You should be contacted within 1-2 days via email to schedule an interview.', ordinal: 3},
                                    { id: 4, title: 'Executive Review', description: 'Your application is currently under review by the Executive Board for a near final review of all application materials. The Executive Board makes the final recomendation on who is and is not accepted as a member into BendroCorp.', ordinal: 4},
                                    { id: 5, title: 'CEO Review', description: 'Your application is currently under review of the Chief Executive Officer of BendroCorp. The CEO reviews all previous reccomendations from employees and the Executive Board to make a final determination on who is and is not accepted as a member into BendroCorp.', ordinal: 5},
                                    { id: 6, title: 'Accepted', description: 'Your application has been accepted. You will be contacted by the Director of Human Resources and your respective division Director shortly.', ordinal: 6},
                                    { id: 7, title: 'Declined', description: 'Your application to BendroCorp has been declined. A member of our HR team will be following up with you to explain the reasoning.', ordinal: 7},
                                    { id: 8, title: 'Withdrawn', description: 'You have withdrawn your application.', ordinal:8}])

user_sys = User.create(id: 0, username: 'System', email: 'no-reply@bendrocorp.com', password: 'gqsUIhu2uUhghJiMIdNr', password_confirmation: 'gqsUIsdfgdsfghu2uUhghJiMIdNrdsfg45', is_member: true, is_admin: true, email_verified: true, locked: true, login_allowed: false)
user2 = User.create(id: 2, username: 'Stevo', email: 'dale@daleslab.com', password: 'Password12345', password_confirmation: 'Password12345', is_member: true, is_admin: true, email_verified: true)
user1 = User.create(id: 1, username: 'Rindzer', email: 'dale.myszewski@gmail.com', password: 'Password12345', password_confirmation: 'Password12345', is_member: true, is_admin: true, email_verified: true)

user1.roles << roles[8]
user1.roles << Role.find_by_id(0)
user2.roles << Role.find_by_id(0)

Badge.create([{ id: 1, title: 'Member', image_link: '/assets/imgs/badges/member.png', ordinal: 1, created_by_id: 1 },
              { id: 2, title: 'Founder', image_link: '/assets/imgs/badges/founder.png', ordinal: 2, created_by_id: 1 },
              { id: 3, title: 'Executive Board', image_link: '/assets/imgs/badges/eb.png', ordinal: 3, created_by_id: 1 },
              { id: 4, title: 'Pilot Certification', image_link: '/assets/imgs/badges/pilot.png', ordinal: 4, created_by_id: 1 },
              { id: 5, title: 'Donor', image_link: '/assets/imgs/badges/donor.png', ordinal: 5, created_by_id: 1 }])

user1.badges << Badge.find_by_id(1)
user2.badges << Badge.find_by_id(1)

character1 = Character.create(id: 1, first_name: 'Rindzer', last_name: 'Aayhan', description: 'Tall blonde and handsome.', background: 'One seriously awesome dude who helps people...', user_id: 1, is_main_character: true, gender_id: 1, species_id: 1)
character2 = Character.create(id: 2, first_name: 'Steve', last_name: 'Awesome', description: 'Tall blonde and handsome.', background: 'One seriously awesome dude who helps people...', user_id: 2, is_main_character: true, gender_id: 1, species_id: 1)



app_interview1 = ApplicationInterview.new(tell_us_about_yourself: 'Great guy!',applicant_has_read_soc: true,applicant_agrees_to_respect_for_leadership:true,applicant_agrees_to_voice_policy:true,applicant_agrees_to_roleplay_style:true,applicant_agrees_to_follow_all_policies:true,applicant_agrees_to_understands_participation:true,why_selected_division: 'Because Im the boss...',why_join_bendrocorp: 'Again...Im the boss...',applicant_questions: 'None',interview_consensous:'Great guy! ;)',locked_for_review: true)

app_interview2 = ApplicationInterview.new(
tell_us_about_yourself: 'Great guy!',
applicant_has_read_soc: true,
applicant_agrees_to_respect_for_leadership:true,
applicant_agrees_to_voice_policy:true,
applicant_agrees_to_roleplay_style:true,
applicant_agrees_to_follow_all_policies:true,
applicant_agrees_to_understands_participation:true,
why_selected_division: 'Because Im the boss...',
why_join_bendrocorp: 'Again...Im the boss...',
applicant_questions: 'None',
interview_consensous:'Great guy! ;)',
locked_for_review: true)

# a=Application.new(interview: app_interview1, tell_us_about_the_real_you: 'I invented this beast', why_do_want_to_join: 'Again...I invented this beast.', how_did_you_hear_about_us: 'I repeat I was the inventor of this crazy band of misfits.', job: Job.all[0], application_status_id: 6, character: Character.all[0], last_status_changed_by: User.all[1])

Application.create(interview: app_interview1, tell_us_about_the_real_you: 'I invented this beast', why_do_want_to_join: 'Again...I invented this beast.', how_did_you_hear_about_us: 'I repeat I was the inventor of this crazy band of misfits.', job: Job.all[0], application_status_id: 6, character: Character.all[0], last_status_changed_by: User.all[1]) #application_interview: app_interview application_interview_id: 1
Application.create(interview: app_interview2, tell_us_about_the_real_you: 'I invented this beast', why_do_want_to_join: 'Again...I invented this beast.', how_did_you_hear_about_us: 'I repeat I was the inventor of this crazy band of misfits.', job: Job.all[2], application_status_id: 6, character: Character.all[1], last_status_changed_by: User.all[1]) #application_interview: app_interview application_interview_id: 1


character1.jobs << [jobs[20]]
character1.jobs << [jobs[11]]
character1.jobs << [jobs[5]]
character1.jobs << [jobs[0]]

character1.owned_ships << OwnedShip.new(title: 'Anders', ship_id: Ship.find_by_name('Carrack'))

character2.jobs << [jobs[20]]
character2.jobs << [jobs[13]]

# Create some test events
Event.create([{name: 'Test Event 1', description: 'This is a test event (1)', start_date: Time.now + 16.hours, end_date: Time.now + 18.hours, event_type_id: 1, briefing: EventBriefing.new, debriefing: EventDebriefing.new },
              {name: 'Test Event 2', description: 'This is a test event (2)', start_date: Time.now + 2.days + 16.hours, end_date: Time.now + 2.days + 18.hours, event_type_id: 1, briefing: EventBriefing.new, debriefing: EventDebriefing.new },
              {name: 'Test Event 3', description: 'This is a test expired event (3)', start_date: Time.now - 2.days - 16.hours, end_date: Time.now - 2.days - 14.hours, event_type_id: 1, briefing: EventBriefing.new, debriefing: EventDebriefing.new }])

# Create some system map data
SystemMapSystem.create([{ title: 'Stanton', description: 'Stanton details to be filled in...', discovered_by: user1 }])
SystemMapSystemGravityWell.create([{ title: 'Stanton', description: 'Stanton\'s star', system: SystemMapSystem.first, gravity_well_type: FieldDescriptor.find_by_id('98e7673d-99f2-4e76-bf08-f4e94abc303c'), luminosity_class: FieldDescriptor.find_by_id('dbfeb49c-4bff-4f2d-812d-f09685ba7c96'), discovered_by: user1 }])
SystemMapSystemPlanetaryBody.create([{ orbits_system: SystemMapSystem.first, title: 'Crusader', description: 'A gas giant. Home to Crusader Industries and BendroCorp.', discovered_by: user1  },
                                     { orbits_system: SystemMapSystem.first, title: 'Hurston', description: 'Home to Hurston Dynamics.', discovered_by: user1  }])
SystemMapSystemPlanetaryBodyMoon.create([{ title: 'Yela', orbits_planet: SystemMapSystemPlanetaryBody.first, discovered_by: user1 },
                                         { title: 'Daymar', orbits_planet: SystemMapSystemPlanetaryBody.first, discovered_by: user1 },
                                         { title: 'Cellin', orbits_planet: SystemMapSystemPlanetaryBody.first, discovered_by: user1 }])

# keep this at the bottom
UserCountry.create([{ code: 'BD', title:'Bangladesh' },
{ code: 'BE', title:'Belgium' },
{ code: 'BF', title:'Burkina Faso' },
{ code: 'BG', title:'Bulgaria' },
{ code: 'BA', title:'Bosnia and Herzegovina' },
{ code: 'BB', title:'Barbados' },
{ code: 'WF', title:'Wallis and Futuna' },
{ code: 'BL', title:'Saint Barthelemy' },
{ code: 'BM', title:'Bermuda' },
{ code: 'BN', title:'Brunei' },
{ code: 'BO', title:'Bolivia' },
{ code: 'BH', title:'Bahrain' },
{ code: 'BI', title:'Burundi' },
{ code: 'BJ', title:'Benin' },
{ code: 'BT', title:'Bhutan' },
{ code: 'JM', title:'Jamaica' },
{ code: 'BV', title:'Bouvet Island' },
{ code: 'BW', title:'Botswana' },
{ code: 'WS', title:'Samoa' },
{ code: 'BQ', title:'Bonaire' },
{ code: 'Saint Eustatius and Saba' },
{ code: 'BR', title:'Brazil' },
{ code: 'BS', title:'Bahamas' },
{ code: 'JE', title:'Jersey' },
{ code: 'BY', title:'Belarus' },
{ code: 'BZ', title:'Belize' },
{ code: 'RU', title:'Russia' },
{ code: 'RW', title:'Rwanda' },
{ code: 'RS', title:'Serbia' },
{ code: 'TL', title:'East Timor' },
{ code: 'RE', title:'Reunion' },
{ code: 'TM', title:'Turkmenistan' },
{ code: 'TJ', title:'Tajikistan' },
{ code: 'RO', title:'Romania' },
{ code: 'TK', title:'Tokelau' },
{ code: 'GW', title:'Guinea-Bissau' },
{ code: 'GU', title:'Guam' },
{ code: 'GT', title:'Guatemala' },
{ code: 'GS', title:'South Georgia and the South Sandwich Islands' },
{ code: 'GR', title:'Greece' },
{ code: 'GQ', title:'Equatorial Guinea' },
{ code: 'GP', title:'Guadeloupe' },
{ code: 'JP', title:'Japan' },
{ code: 'GY', title:'Guyana' },
{ code: 'GG', title:'Guernsey' },
{ code: 'GF', title:'French Guiana' },
{ code: 'GE', title:'Georgia' },
{ code: 'GD', title:'Grenada' },
{ code: 'GB', title:'United Kingdom' },
{ code: 'GA', title:'Gabon' },
{ code: 'SV', title:'El Salvador' },
{ code: 'GN', title:'Guinea' },
{ code: 'GM', title:'Gambia' },
{ code: 'GL', title:'Greenland' },
{ code: 'GI', title:'Gibraltar' },
{ code: 'GH', title:'Ghana' },
{ code: 'OM', title:'Oman' },
{ code: 'TN', title:'Tunisia' },
{ code: 'JO', title:'Jordan' },
{ code: 'HR', title:'Croatia' },
{ code: 'HT', title:'Haiti' },
{ code: 'HU', title:'Hungary' },
{ code: 'HK', title:'Hong Kong' },
{ code: 'HN', title:'Honduras' },
{ code: 'HM', title:'Heard Island and McDonald Islands' },
{ code: 'VE', title:'Venezuela' },
{ code: 'PR', title:'Puerto Rico' },
{ code: 'PS', title:'Palestinian Territory' },
{ code: 'PW', title:'Palau' },
{ code: 'PT', title:'Portugal' },
{ code: 'SJ', title:'Svalbard and Jan Mayen' },
{ code: 'PY', title:'Paraguay' },
{ code: 'IQ', title:'Iraq' },
{ code: 'PA', title:'Panama' },
{ code: 'PF', title:'French Polynesia' },
{ code: 'PG', title:'Papua New Guinea' },
{ code: 'PE', title:'Peru' },
{ code: 'PK', title:'Pakistan' },
{ code: 'PH', title:'Philippines' },
{ code: 'PN', title:'Pitcairn' },
{ code: 'PL', title:'Poland' },
{ code: 'PM', title:'Saint Pierre and Miquelon' },
{ code: 'ZM', title:'Zambia' },
{ code: 'EH', title:'Western Sahara' },
{ code: 'EE', title:'Estonia' },
{ code: 'EG', title:'Egypt' },
{ code: 'ZA', title:'South Africa' },
{ code: 'EC', title:'Ecuador' },
{ code: 'IT', title:'Italy' },
{ code: 'VN', title:'Vietnam' },
{ code: 'SB', title:'Solomon Islands' },
{ code: 'ET', title:'Ethiopia' },
{ code: 'SO', title:'Somalia' },
{ code: 'ZW', title:'Zimbabwe' },
{ code: 'SA', title:'Saudi Arabia' },
{ code: 'ES', title:'Spain' },
{ code: 'ER', title:'Eritrea' },
{ code: 'ME', title:'Montenegro' },
{ code: 'MD', title:'Moldova' },
{ code: 'MG', title:'Madagascar' },
{ code: 'MF', title:'Saint Martin' },
{ code: 'MA', title:'Morocco' },
{ code: 'MC', title:'Monaco' },
{ code: 'UZ', title:'Uzbekistan' },
{ code: 'MM', title:'Myanmar' },
{ code: 'ML', title:'Mali' },
{ code: 'MO', title:'Macao' },
{ code: 'MN', title:'Mongolia' },
{ code: 'MH', title:'Marshall Islands' },
{ code: 'MK', title:'Macedonia' },
{ code: 'MU', title:'Mauritius' },
{ code: 'MT', title:'Malta' },
{ code: 'MW', title:'Malawi' },
{ code: 'MV', title:'Maldives' },
{ code: 'MQ', title:'Martinique' },
{ code: 'MP', title:'Northern Mariana Islands' },
{ code: 'MS', title:'Montserrat' },
{ code: 'MR', title:'Mauritania' },
{ code: 'IM', title:'Isle of Man' },
{ code: 'UG', title:'Uganda' },
{ code: 'TZ', title:'Tanzania' },
{ code: 'MY', title:'Malaysia' },
{ code: 'MX', title:'Mexico' },
{ code: 'IL', title:'Israel' },
{ code: 'FR', title:'France' },
{ code: 'IO', title:'British Indian Ocean Territory' },
{ code: 'SH', title:'Saint Helena' },
{ code: 'FI', title:'Finland' },
{ code: 'FJ', title:'Fiji' },
{ code: 'FK', title:'Falkland Islands' },
{ code: 'FM', title:'Micronesia' },
{ code: 'FO', title:'Faroe Islands' },
{ code: 'NI', title:'Nicaragua' },
{ code: 'NL', title:'Netherlands' },
{ code: 'NO', title:'Norway' },
{ code: 'NA', title:'Namibia' },
{ code: 'VU', title:'Vanuatu' },
{ code: 'NC', title:'New Caledonia' },
{ code: 'NE', title:'Niger' },
{ code: 'NF', title:'Norfolk Island' },
{ code: 'NG', title:'Nigeria' },
{ code: 'NZ', title:'New Zealand' },
{ code: 'NP', title:'Nepal' },
{ code: 'NR', title:'Nauru' },
{ code: 'NU', title:'Niue' },
{ code: 'CK', title:'Cook Islands' },
{ code: 'XK', title:'Kosovo' },
{ code: 'CI', title:'Ivory Coast' },
{ code: 'CH', title:'Switzerland' },
{ code: 'CO', title:'Colombia' },
{ code: 'CN', title:'China' },
{ code: 'CM', title:'Cameroon' },
{ code: 'CL', title:'Chile' },
{ code: 'CC', title:'Cocos Islands' },
{ code: 'CA', title:'Canada' },
{ code: 'CG', title:'Republic of the Congo' },
{ code: 'CF', title:'Central African Republic' },
{ code: 'CD', title:'Democratic Republic of the Congo' },
{ code: 'CZ', title:'Czech Republic' },
{ code: 'CY', title:'Cyprus' },
{ code: 'CX', title:'Christmas Island' },
{ code: 'CR', title:'Costa Rica' },
{ code: 'CW', title:'Curacao' },
{ code: 'CV', title:'Cape Verde' },
{ code: 'CU', title:'Cuba' },
{ code: 'SZ', title:'Swaziland' },
{ code: 'SY', title:'Syria' },
{ code: 'SX', title:'Sint Maarten' },
{ code: 'KG', title:'Kyrgyzstan' },
{ code: 'KE', title:'Kenya' },
{ code: 'SS', title:'South Sudan' },
{ code: 'SR', title:'Suriname' },
{ code: 'KI', title:'Kiribati' },
{ code: 'KH', title:'Cambodia' },
{ code: 'KN', title:'Saint Kitts and Nevis' },
{ code: 'KM', title:'Comoros' },
{ code: 'ST', title:'Sao Tome and Principe' },
{ code: 'SK', title:'Slovakia' },
{ code: 'KR', title:'South Korea' },
{ code: 'SI', title:'Slovenia' },
{ code: 'KP', title:'North Korea' },
{ code: 'KW', title:'Kuwait' },
{ code: 'SN', title:'Senegal' },
{ code: 'SM', title:'San Marino' },
{ code: 'SL', title:'Sierra Leone' },
{ code: 'SC', title:'Seychelles' },
{ code: 'KZ', title:'Kazakhstan' },
{ code: 'KY', title:'Cayman Islands' },
{ code: 'SG', title:'Singapore' },
{ code: 'SE', title:'Sweden' },
{ code: 'SD', title:'Sudan' },
{ code: 'DO', title:'Dominican Republic' },
{ code: 'DM', title:'Dominica' },
{ code: 'DJ', title:'Djibouti' },
{ code: 'DK', title:'Denmark' },
{ code: 'VG', title:'British Virgin Islands' },
{ code: 'DE', title:'Germany' },
{ code: 'YE', title:'Yemen' },
{ code: 'DZ', title:'Algeria' },
{ code: 'US', title:'United States' },
{ code: 'UY', title:'Uruguay' },
{ code: 'YT', title:'Mayotte' },
{ code: 'UM', title:'United States Minor Outlying Islands' },
{ code: 'LB', title:'Lebanon' },
{ code: 'LC', title:'Saint Lucia' },
{ code: 'LA', title:'Laos' },
{ code: 'TV', title:'Tuvalu' },
{ code: 'TW', title:'Taiwan' },
{ code: 'TT', title:'Trinidad and Tobago' },
{ code: 'TR', title:'Turkey' },
{ code: 'LK', title:'Sri Lanka' },
{ code: 'LI', title:'Liechtenstein' },
{ code: 'LV', title:'Latvia' },
{ code: 'TO', title:'Tonga' },
{ code: 'LT', title:'Lithuania' },
{ code: 'LU', title:'Luxembourg' },
{ code: 'LR', title:'Liberia' },
{ code: 'LS', title:'Lesotho' },
{ code: 'TH', title:'Thailand' },
{ code: 'TF', title:'French Southern Territories' },
{ code: 'TG', title:'Togo' },
{ code: 'TD', title:'Chad' },
{ code: 'TC', title:'Turks and Caicos Islands' },
{ code: 'LY', title:'Libya' },
{ code: 'VA', title:'Vatican' },
{ code: 'VC', title:'Saint Vincent and the Grenadines' },
{ code: 'AE', title:'United Arab Emirates' },
{ code: 'AD', title:'Andorra' },
{ code: 'AG', title:'Antigua and Barbuda' },
{ code: 'AF', title:'Afghanistan' },
{ code: 'AI', title:'Anguilla' },
{ code: 'VI', title:'U.S. Virgin Islands' },
{ code: 'IS', title:'Iceland' },
{ code: 'IR', title:'Iran' },
{ code: 'AM', title:'Armenia' },
{ code: 'AL', title:'Albania' },
{ code: 'AO', title:'Angola' },
{ code: 'AQ', title:'Antarctica' },
{ code: 'AS', title:'American Samoa' },
{ code: 'AR', title:'Argentina' },
{ code: 'AU', title:'Australia' },
{ code: 'AT', title:'Austria' },
{ code: 'AW', title:'Aruba' },
{ code: 'IN', title:'India' },
{ code: 'AX', title:'Aland Islands' },
{ code: 'AZ', title:'Azerbaijan' },
{ code: 'IE', title:'Ireland' },
{ code: 'ID', title:'Indonesia' },
{ code: 'UA', title:'Ukraine' },
{ code: 'QA', title:'Qatar' },
{ code: 'MZ', title:'Mozambique' }])
