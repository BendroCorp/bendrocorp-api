puts ""
puts "Seeding things..."
puts ""

UserDeviceType.create([{ id: 1, title: 'ios_app' } ])
ChatRoom.create([{id: 1, title: 'General'}])

SiteLogType.create([{id: 1, title: 'Authentication'}, {id: 2, title: 'General'}, {id: 3, title: 'Error'}])

TrainingItemType.create([{ id: 1, title: 'Text' }, { id: 2, title: 'Link' }, { id: 3, title: 'Video' }, { id: 4, title: 'Instructor Approval' }])

MenuItem.create([{ id: 1, title: 'Dashboard', icon: 'fa-star', link: '/', ordinal: 1 },
                 { id: 2, title: 'Profiles', icon: 'fa-users', link: '/profiles', ordinal: 2 },
                 { id: 3, title: 'Events', icon: 'fa-calendar', link: '/events', ordinal: 3 },
                 { id: 4, title: 'Job Board', icon: 'fa-briefcase', link: '/job-board', ordinal: 4 },
                 { id: 5, title: 'Flight Logs', icon: 'fa-book', link: '/flight-logs', ordinal: 5 },
                 { id: 6, title: 'Reports', icon: 'fa-file-alt', link: '/reports', ordinal: 6 },
                 { id: 8, title: 'Alerts', icon: 'fa-bell', link: '/alerts', ordinal: 8 },
                 { id: 9, title: 'Commodities', icon: 'fa-hand-holding-usd', link: '/commodities', ordinal: 9 },
                 { id: 10, title: 'Offender Reports', icon: 'fa-shield-alt', link: '/offender-reports', ordinal: 10 },
                 { id: 11, title: 'System Map', icon: 'fa-globe', link: '/system-map', ordinal: 11 },
                 { id: 12, title: 'Admin', icon: 'fas fa-user', ordinal: 13 },
                 { id: 13, title: 'Requests', icon: 'fa-folder-open', link: '/requests', ordinal: 12 },
                 { id: 14, title: 'Impersonation', icon: 'fas fa-user', link: '/impersonate', ordinal: 1, nested_under_id: 12 },
                 { id: 15, title: 'Site Logs', icon: 'fas fa-user', link: '/site-logs', ordinal: 2, nested_under_id: 12 },
                 { id: 16, title: 'Roles', icon: 'fas fa-key', link: '/roles', ordinal: 3, nested_under_id: 12 },
                 { id: 17, title: 'Liabilities', icon: 'fas fa-chart-line', link: '/liabilities', ordinal: 4, nested_under_id: 12 },
                 { id: 18, title: 'Jobs Admin', icon: 'fas fa-building', link: '/jobs', ordinal: 5, nested_under_id: 12 },
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
                     { id: 6, menu_item_id: 18, role_id: 38 },])

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

JobBoardMissionCompletionCriterium.create([{id: 1, title: 'Escort', description: 'Escort a fellow employee during a non-event cargo run.'},
                                           {id: 2, title: 'Bounty', description: 'TBA'},
                                           {id: 3, title: 'Catalogue', description: 'TBA'},
                                           {id: 4, title: 'Recovery', description: 'TBA'},
                                           {id: 5, title: 'Other', description: 'See mission description'}])

JobBoardMissionStatus.create([{id: 1, title: 'Open', description: 'A mission that is open for acceptance.'},
                              {id: 2, title: 'Closed', description: 'A mission that has been closed.'},
                              {id: 3, title: 'Success', description: 'A mission where the objective(s) were met.'},
                              {id: 4, title: 'Failed', description: 'A mission where the objective(s) could not be met.'}])

JobLevel.create([{id: 1, title: 'CEO', ordinal: 1},
                 {id: 2, title: 'Executive', ordinal: 2},
                 {id: 3, title: 'Director', ordinal: 3},
                 {id: 4, title: 'Manager', ordinal: 4},
                 {id: 5, title: 'Grade 4', ordinal: 5},
                 {id: 6, title: 'Grade 3', ordinal: 6},
                 {id: 7, title: 'Grade 2', ordinal: 7},
                 {id: 8, title: 'Grade 1', ordinal: 8},
                 {id: 9, title: 'Applicant', ordinal: 9}])

ReportStatusType.create([{ id: 1, title: 'Created'},
                         { id: 2, title: 'Submitted'},
                         { id: 3, title: 'Returned'},
                         { id: 4, title: 'Approved'}])

StoreCurrencyType.create([{id: 1, title: 'Dollars', description: 'Good ole\' U.S.A. green backs. Used for real life items.', currency_symbol: '$' },
                          {id: 2, title: 'Operations Points', description: 'Internal BendroCorp currency. Redeemable for in-game items', currency_symbol: '(op)' }])

# Open, Processing, Shipped|Fulfilled, Cancelled, Refunded
StoreOrderStatus.create([{id: 1, title: 'Open', description: 'Order is complete and awaiting intial processing. For real life items international shipping will be calculated during this time and you may be asked to pay additional shipping if you do not live in the continental U.S.A.'},
                         {id: 2, title: 'Processing', description: 'Your order is being processed by a real person.'},
                         {id: 3, title: 'Shipped/Fulfilled', description: 'Your order has been shipped and/or fulfilled.'},
                         {id: 4, title: 'Cancelled', description: 'This order has been cancelled and is awaiting refund.'},
                         {id: 5, title: 'Refunded', description: 'This order has been refunded.', can_select: false }])

alert_types = AlertType.create([{id: 1, title: 'Notice', sub_title: '', description: 'Informational alerts for employees', selectable:true },
                                {id: 2, title: 'Travel Advisory', sub_title: 'Short-Term', description: 'Typically issued if an offender report was recently logged in the system. Has an expiration.'},
                                {id: 3, title: 'Travel Advisory', sub_title: 'Long-Term', description: 'Indicates that employees should exercise extreme caution when entering the system, planet (eventually moon or system object)'},
                                {id: 4, title: 'Travel Ban', sub_title: 'Long-Term', description: 'Indicates that employees are not allowed to operate in the system in an official capacity without an escort or Executive approval'},
                                {id: 5, title: 'CSAR', sub_title: 'Rescue Request', description: 'An employee is requesting emergency assistance.', selectable:true }])

connectionsizes = SystemMapSystemConnectionSize.create([{ id: 1, size: "Small Jump Point", size_short: "Small", description: "A jump point capable of supporting a small ship."},
                                                        { id: 2, size: "Medium Jump Point", size_short: "Medium", description: "A jump point capable of supporting medium size and smaller ships."},
                                                        { id: 3, size: "Large Jump Point", size_short: "Large", description: "A jump point capable of supporting large size and smaller ships."}])

connectionstatuses = SystemMapSystemConnectionStatus.create([{ id: 1, title: "Collapsed", description: "A collapsed jump point."},
                                                             { id: 2, title: "Active", description: "An active jump point."},
                                                             { id: 3, title: "Active - Not Public", description: "An active but not published jump point."},
                                                             { id: 4, title: "Suspected", description: "A jump point which is suspected to exist but is not confirmed."}])

systemmapobjecttypes1 = SystemMapSystemObjectType.create([{ id: 1, title: "Station", description: ""},
                                                       { id: 2, title: "Satelite", description: ""},
                                                       { id: 3, title: "Communications Satelite", description: ""},
                                                       { id: 4, title: "Derelict Ship", description: ""},
                                                       { id: 5, title: "Derelict Cargo", description: ""},
                                                       { id: 6, title: "Debris", description: ""},
                                                       { id: 7, title: "Other", description: ""}])

systemmapobjecttypes1 = SystemMapSystemPlanetaryBodyLocationType.create([{ id: 1, title: "Homestead", description: ""},
                                                      { id: 2, title: "Base (Mercenary)", description: ""},
                                                      { id: 3, title: "Base (UEE)", description: ""},
                                                      { id: 4, title: "City", description: ""},
                                                      { id: 5, title: "Derelict", description: ""},
                                                      { id: 6, title: "Debris", description: ""},
                                                      { id: 7, title: "Ruins", description: ""},
                                                      { id: 8, title: "Other", description: ""},
                                                      { id: 9, title: "Base (Pirate)", description: ""}])

systemmapobjecttypes2 = SystemMapSystemPlanetaryBodyType.create([{ id: 1, title: "Temperate", description: ""},
                                                                { id: 2, title: "Rocky/Barren", description: ""},
                                                                { id: 3, title: "Toxic", description: ""},
                                                                { id: 4, title: "Ocean", description: ""},
                                                                { id: 5, title: "Ice", description: ""},
                                                                { id: 6, title: "Lava/Proto", description: ""},
                                                                { id: 7, title: "City", description: ""},
                                                                { id: 8, title: "Artificial", description: ""},
                                                                { id: 9, title: "Asteroid Cluster", description: ""},
                                                                { id: 10, title: "Gas Giant", description:""}])

systemmapobjecttypes3 = SystemMapSystemPlanetaryBodyMoonType.create([{ id: 1, title: "Temperate", description: ""},
                                                                { id: 2, title: "Rocky/Barren", description: ""},
                                                                { id: 3, title: "Toxic", description: ""},
                                                                { id: 4, title: "Ocean", description: ""},
                                                                { id: 5, title: "Ice", description: ""},
                                                                { id: 6, title: "Lava/Proto", description: ""},
                                                                { id: 7, title: "City", description: ""},
                                                                { id: 8, title: "Artificial", description: ""},
                                                                { id: 9, title: "Asteroid Belt/Planetary Ring", description: ""}])

gravitywelltypes = SystemMapSystemGravityWellType.create([{ id: 1, title: "Black Hole", well_type: "N/A", approx_surface_temperature: "???", color: "None", main_characteristics: "Black hole quote here"},
                                                          { id: 2, title: "Star", well_type: "O", approx_surface_temperature: "Over 25,000 K", color: "Blue", main_characteristics: "Singly ionized helium lines (H I) either in emission or absorption. Strong UV continuum."},
                                                          { id: 3, title: "Star", well_type: "B", approx_surface_temperature: "11,000 - 25,000 K", color: "Blue", main_characteristics: "Neutral helium lines (H II) in absorption."},
                                                          { id: 4, title: "Star", well_type: "A", approx_surface_temperature: "7,500 - 11,000 K", color: "Blue", main_characteristics: "Hydrogen (H) lines strongest for A0 stars, decreasing for other A's."},
                                                          { id: 5, title: "Star", well_type: "F", approx_surface_temperature: "6,000 - 7,500 K", color: "Blue to White", main_characteristics: "Ca II absorption. Metallic lines become noticeable."},
                                                          { id: 6, title: "Star", well_type: "G", approx_surface_temperature: "5,000 - 6,000 K", color: "White to Yellow", main_characteristics: "Absorption lines of neutral metallic atoms and ions (e.g. once-ionized calcium)."},
                                                          { id: 7, title: "Star", well_type: "K", approx_surface_temperature: "3,500 - 5,000 K", color: "Orange to Red", main_characteristics: "Metallic lines, some blue continuum."},
                                                          { id: 8, title: "Star", well_type: "M", approx_surface_temperature: "under 3,500 K", color: "Red", main_characteristics: "Some molecular bands of titanium oxide."}])

gravitywelllums = SystemMapSystemGravityWellLuminosityClass.create([{ id: 1, title: "Ia", description: "Very luminous supergiants"},
                                                                    { id: 2, title: "Ib", description: "Less luminous supergiants" },
                                                                    { id: 3, title: "II", description: "Luminous giants" },
                                                                    { id: 4, title: "III", description: "Giants" },
                                                                    { id: 5, title: "IV", description: "Subgiants" },
                                                                    { id: 6, title: "V", description: "Main sequence stars (dwarf stars)" },
                                                                    { id: 7, title: "VI", description: "Subdwarf" },
                                                                    { id: 8, title: "VII", description: "White Dwarf" }])

factions = FactionAffiliation.create([{ id: 1, title: "UEE" },
                                      { id: 2, title: "Banu" },
                                      { id: 3, title: "Vanduul" },
                                      { id: 4, title: "Xi'an" },
                                      { id: 5, title: "Developing" },
                                      { id: 6, title: "Unclaimed" }])

CharacterGender.create([{ id: 1, title: 'Male'},
                        { id: 2, title: 'Female'}])

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

SystemMapSystemSafetyRating.create([{ id: 1, title: "No Threat", description: "There have been no recent reports of BendroCorp ships being attacked here.", color:"green" },
                                   { id: 2, title: "Threat Exists", description: "There have been recent but non-frequent reports of BendroCorp ships being fired on this area or along this flight path. Exercise caution.", color:"yellow" },
                                   { id: 3, title: "Escort Required", description: "There have been recent and frequent reports of BendroCorp ships being attacked in this area or along this flight path. Corporate freighters and medium-large ships on sanctioned missions are required to have an escort in this area.", color:"red" }])

SystemMapObjectKind.create([{ id: 1, title: "System", class_name: "SystemMapSystem"},
                            { id: 2, title: "Gravity Well", class_name: "SystemMapSystemGravityWell"},
                            { id: 3, title: "Planet", class_name: "SystemMapSystemPlanetaryBody"},
                            { id: 4, title: "Moon", class_name: "SystemMapSystemPlanetaryBodyMoon"},
                            { id: 5, title: "System Object", class_name: "SystemMapSystemObject"},
                            { id: 6, title: "Settlement", class_name: "SystemMapSystemSettlement"},
                            { id: 7, title: "Location", class_name: "SystemMapSystemPlanetaryBodyLocation"},
                            { id: 8, title: "Fauna", class_name: "SystemMapFauna"},
                            { id: 9, title: "Flora", class_name: "SystemMapFlora"},
                            { id: 10, title: "Jump Point", class_name: "SystemMapSystemConnection"}])

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

event_types = EventType.create([{id: 1, title: 'Operation'},
                                {id: 2, title: 'Livestream'}])

attendence_types = AttendenceType.create([{id: 1, title: "Attending"},
                                          {id: 2, title: 'Not Attending'},
                                          {id: 3, title: 'No Response'}])

approval_types = ApprovalType.create([{id: 1, title: 'Pending', description: 'Not yet approved or declined request.'},
                                      {id: 2, title: 'Pending (Unseen)', description: 'Not yet approved or declined request and not viewed.'},
                                      {id: 3, title: 'Pending (Seen)', description: 'Not yet approved or declined request and viewed.'},
                                      {id: 4, title: 'Approved', description: 'Approved request'},
                                      {id: 5, title: 'Declined', description: 'Declined request'},
                                      {id: 6, title: 'Feedback not needed', description: 'Feedback not needed.'}])

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
                     { id: 42, name: 'Admin Menu', description: 'Allows access to the admin menu' }])

ReportType.create([{ id: 1, title: 'General', description: 'A general report type for reports that do not fit into other categories.'},
                   { id: 2, title: 'Use of Force', description: 'description here', submit_to_role_id: 2 },
                   { id: 3, title: 'Policy Violation', description: 'description here', submit_to_role_id: 2 },
                   { id: 4, title: 'Attendence Report', description: 'description here', submit_to_role_id: 2 },
                   { id: 5, title: 'Training Report', description: 'description here', submit_to_role_id: 2 }])

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

approval_kinds = ApprovalKind.create([{id: 1, title: 'Role Request'},
                                     {id: 2, title: 'Application Approval Request'},
                                     {id: 3, title: 'Award Approval'},
                                     {id: 4, title: 'Role Removal'},
                                     {id: 5, title: 'Claim Request'},
                                     {id: 6, title: 'Event Certification'},
                                     {id: 7, title: 'Offender Report'},
                                     {id: 8, title: 'Training Report'},
                                     {id: 9, title: 'Flight Log Entry'}, #only if event related - may not use
                                     {id: 10, title: 'System Map Entry'},
                                     {id: 11, title: 'Organization Ship Request'},
                                     {id: 12, title: 'Role Removal Request'},
                                     {id: 13, title: 'Research Project Approval Request'},
                                     {id: 14, title: 'Research Project Change Lead Request'},
                                     {id: 15, title: 'Offender Bounty Approval Request'},
                                     {id: 16, title: 'Organization Ship Crew Request'},
                                     {id: 17, title: 'Job Change Request'},
                                     {id: 18, title: 'Job Board Completion Request'},
                                     {id: 19, title: 'Job Board Creation Request'},
                                     {id: 20, title: 'Add System Map Item Request'},
                                     {id: 21, title: 'Report Approval Request'},
                                     {id: 22, title: 'Position Change Request'},
                                     {id: 23, title: 'Applicant Approval Request'},
                                     {id: 24, title: 'Training Item Completion Request'}])

ResearchProjectStatus.create([{id: 1, title: 'Created/Approval Pending'},
                              {id: 2, title: 'Project Not Approved/Request Denied'},
                              {id: 3, title: 'In-Progress'},
                              {id: 4, title: 'Completed'},
                              {id: 5, title: 'Cancelled'}])

ResearchProjectTaskStatus.create([{id: 1, title: 'In-Progress'},
                                  {id: 2, title: 'Completed'},
                                  {id: 3, title: 'Cancelled'}])

TradeItemType.create([{id: 1, title: 'Resource Mineral'},
                      {id: 2, title: 'Resource Liquid'},
                      {id: 3, title: 'Resource Gas'},
                      {id: 4, title: 'Organic Other'},
                      {id: 5, title: 'Waste'},
                      {id: 6, title: 'Foodstuff'},
                      {id: 7, title: 'Technology'},
                      {id: 8, title: 'Component'},
                      {id: 9, title: 'Passenger'},
                      {id: 10, title: 'Metal'},
                      {id: 11, title: 'Salvage'},
                      {id: 12, title: 'Industrial'},
                      {id: 13, title: 'Vehicle'},
                      {id: 14, title: 'Pharma'},
                      {id: 15, title: 'Consumer Item'},
                      {id: 16, title: 'Other Item'},
                      {id: 17, title: 'Other'},
                      {id: 18, title: 'Rare'}])

approval_kinds[0].roles << roles[1] #execs - Role Request
approval_kinds[1].roles << roles[1] #execs - Application Approval Request
approval_kinds[2].roles << roles[1] #execs - Award Approval
approval_kinds[3].roles << roles[1] #execs - Role Removal
approval_kinds[4].roles << roles[10] #CFO {id: 5, title: 'Claim Request'}
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
                               name: 'Logistics Division',
                               short_name: 'Logistics & Cartage Division',
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

jobs = Job.create([ { id:1, title: 'Chief Executive Officer', description: 'The boss', division: divisions[0], job_level_id: 1 },
                     { id:2, title: 'Chief Operations Officer', description: 'The boss', division: divisions[0], job_level_id: 2 },
                     { id:3, title: 'Chief Financial Officer', description: 'The boss', division: divisions[0], job_level_id: 2 },
                     { id:4, title: 'Director of Human Resources', description: 'The boss', division: divisions[0], job_level_id: 2 },
                     { id:5, title: 'Customer Service Manager', description: 'The boss', division: divisions[0], job_level_id: 2 },
                     { id:6, title: 'Director of Logistics', description: 'The boss', division: divisions[1], job_level_id: 3 },
                     { id:7, title: 'Director of Security', description: 'The boss', division: divisions[2], job_level_id: 3 },
                     { id:8, title: 'Director of Research', description: 'The boss', division: divisions[3], job_level_id: 3 },
                     { id:9, title: 'Logistics Recruit', description: 'The boss', division: divisions[1], job_level_id: 8 },
                     { id:10, title: 'Security Recruit', description: 'The boss', division: divisions[2], job_level_id: 8 },
                     { id:11, title: 'Research Recruit', description: 'The boss', division: divisions[3], job_level_id: 8 },
                     { id:12, title: 'Logistics Captain', description: 'The boss', division: divisions[1], job_level_id: 4 },
                     { id:13, title: 'Logistics Operator', description: 'The boss', division: divisions[1], job_level_id: 8, hiring: true },
                     { id:14, title: 'Security Officer', description: 'The boss', division: divisions[2], job_level_id: 8, hiring: true, next_job_id:15 },
                     { id:15, title: 'Security Sergeant', description: 'The boss', division: divisions[2], job_level_id: 6, next_job_id:16 },
                     { id:16, title: 'Security Lieutenant', description: 'The boss', division: divisions[2], job_level_id: 5 },
                     { id:17, title: 'Research Recruit', description: 'The boss', division: divisions[3], job_level_id: 8, next_job_id: 17 },
                     { id:18, title: 'Junior Technician', description: 'The boss', division: divisions[3], job_level_id: 2, hiring: true, next_job_id:19 },
                     { id:19, title: 'Technician', description: 'The boss', division: divisions[3], job_level_id: 3, next_job_id:20 },
                     { id:20, title: 'Senior Technician', description: 'The boss', division: divisions[3], job_level_id: 4 },
                     { id:21, title: 'Applicant', description: 'An individual who has applied to BendroCorp', job_level_id: 9, division: divisions[4]},
                     { id:22, title: 'Retired', description: 'A person who has voluntarily left BendroCorp.', job_level_id: 9, division_id: divisions[5]},
                     { id:23, title: 'Discharged', description: 'A person who has involuntarily been removed from BendroCorp.', job_level_id: 9, division_id: divisions[5]},
                     { id:24, title: 'Withdrawn', description: 'An individual who has withdrawn their application to BendroCorp', job_level_id: 9, division_id: divisions[5]},
                     { id:25, title: 'Chief Medical Officer', description: 'Is the senior physician within BendroCorp and directly responsible for the execution of proper medical care within BendroCorp. Responsible for developing the policies defined by the purpose for this division with input from other Directors and Executives. Develops training curriculum to train medical division staff in proper medical and patient care. Supervises, directs and is responsible for the day-to-day activities of the medical division. The Chief Medical Officer reports to the Chief Executive Officer.', job_level_id: 3, division_id: divisions[6]},
                     { id:26, title: 'Physician', description: 'Provides Tier 1 and Tier 2 medical care. Manages clinical teams as required. Assists the Chief Medical Officer as required in their duties.', job_level_id: 4, division_id: divisions[6]},
                     { id:27, title: 'First Responder', description: 'Provides Tier 3 medical care. Assists in the stabilization of patients for Tier 1 and Tier 2 medical care. Participates in rescue and recovery operations. Performs other duties as directed by BendroCorp executives, Chief Medical Officer and medical division physicians.', next_job_id: 25, job_level_id: 7, division_id: divisions[6]},
                     { id:28, title: 'Junior First Responder', description: 'Probationary position. Provides Tier 3 medical care. Assists in the stabilization of patients for Tier 1 and Tier 2 medical care. Participates in rescue and recovery operations. Performs other duties as directed by BendroCorp executives, Chief Medical Officer and medical division physicians.', next_job_id: 26, job_level_id: 8, division_id: divisions[6]} ])

acttype = UserAccountType.create([{id: 1, title: 'Membership', ordinal: 1}, {id: 2, title: 'Diplomat', ordinal: 2}, {id: 3, title: 'Customer', ordinal: 3}])

apptypes = ApplicationStatus.create([{id: 1, title: 'Submitted', description: 'Your application has been submitted and is undergoing initial checks before being made available for initial review.', ordinal: 1},
                                    {id: 2, title: '360 Review', description: 'Your application is currently undergoing a 360 review by our membership. During this period all of the current membership has the opportunity to comment on your application.', ordinal: 2},
                                    {id: 3, title: 'Referred for Interview', description: 'Your application has been referred for an interview. You should be contacted within 1-2 days via email to schedule an interview.', ordinal: 3},
                                    {id: 4, title: 'Executive Review', description: 'Your application is currently under review by the Executive Board for a near final review of all application materials. The Executive Board makes the final recomendation on who is and is not accepted as a member into BendroCorp.', ordinal: 4},
                                    {id: 5, title: 'CEO Review', description: 'Your application is currently under review of the Chief Executive Officer of BendroCorp. The CEO reviews all previous reccomendations from employees and the Executive Board to make a final determination on who is and is not accepted as a member into BendroCorp.', ordinal: 5},
                                    {id: 6, title: 'Accepted', description: 'Your application has been accepted. You will be contacted by the Director of Human Resources and your respective division Director shortly.', ordinal: 6},
                                    {id: 7, title: 'Declined', description: 'Your application to BendroCorp has been declined. A member of our HR team will be following up with you to explain the reasoning.', ordinal: 7},
                                    {id: 8, title: 'Withdrawn', description: 'You have withdrawn your application.', ordinal:8}])

user_sys = User.create(id: 0, username: 'System', email: 'no-reply@bendrocorp.com', password: 'gqsUIhu2uUhghJiMIdNr', password_confirmation: 'gqsUIsdfgdsfghu2uUhghJiMIdNrdsfg45', is_member: true, is_admin: true, email_verified: true, locked: true, login_allowed: false)
user2 = User.create(id: 2, username: 'Stevo', email: 'dale@daleslab.com', password: 'Password12345', password_confirmation: 'Password12345', is_member: true, is_admin: true, email_verified: true)
user1 = User.create(id: 1, username: 'Rindzer', email: 'dale.myszewski@gmail.com', password: 'Password12345', password_confirmation: 'Password12345', is_member: true, is_admin: true, email_verified: true)

user1.roles << roles[8]
user1.roles << Role.find_by_id(0)
user2.roles << Role.find_by_id(0)

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
SystemMapSystem.create([{ id: 1, title: 'Stanton', description: 'Stanton details to be filled in...', discovered_by: user1 }])
SystemMapSystemGravityWell.create([{id: 1, title: 'Stanton', description: 'Stanton\'s star', system: SystemMapSystem.find_by_id(1), gravity_well_type: SystemMapSystemGravityWellType.find_by_id(6), luminosity_class: SystemMapSystemGravityWellLuminosityClass.find_by_id(6), discovered_by: user1 }])
SystemMapSystemPlanetaryBody.create([{ id: 1, orbits_system: SystemMapSystem.find_by_id(1), title: 'Crusader', description: 'A gas giant. Home to Crusader Industries and BendroCorp.', discovered_by: user1  },
                                     { id: 2, orbits_system: SystemMapSystem.find_by_id(1), title: 'Hursten', description: 'A gas giant. Home to Crusader Industries and BendroCorp.', discovered_by: user1  }])
SystemMapSystemPlanetaryBodyMoon.create([{ id: 1, title: 'Yela', orbits_planet: SystemMapSystemPlanetaryBody.find_by_id(1), discovered_by: user1 },
                                         { id: 2, title: 'Daymar', orbits_planet: SystemMapSystemPlanetaryBody.find_by_id(1), discovered_by: user1 },
                                         { id: 3, title: 'Cellin', orbits_planet: SystemMapSystemPlanetaryBody.find_by_id(1), discovered_by: user1 }])

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
