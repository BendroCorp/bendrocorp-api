puts ""
puts "Seeding things..."
puts ""

# TODO add ApprovalWorkflow

UserDeviceType.create([{ id: 1, title: 'ios_app' } ])
ChatRoom.create([{ id: 1, title: 'General'}])

SiteLogType.create([{ id: 1, title: 'Authentication'}, { id: 2, title: 'General'}, { id: 3, title: 'Error'}])

TrainingItemType.create([{ id: 1, title: 'Text' }, { id: 2, title: 'Link' }, { id: 3, title: 'Video' }, { id: 4, title: 'Instructor Approval' }])

ReportHandler.create([{ name: 'Generic Approval', ordinal: 1 }])

# make a base field
ynm_field = Field.create({ id: '616c3df9-4c5e-4882-bab4-08ec04c4f2da', name: 'Yes/No/Maybe' })
FieldDescriptor.create([{ title: 'Yes', field: ynm_field }, { title: 'No', field: ynm_field }, { title: 'Maybe', field: ynm_field }])
FieldDescriptorClass.create([{ title: 'Character Full Names', class_name: 'Character', class_field: 'full_name' },
                             { title: 'Roles', class_name: 'Role', class_field: 'name' },
                             { title: 'Jobs', class_name: 'Job', class_field: 'title' }])

so_fdc = FieldDescriptorClass.create({ id: 'e1b7d9cc-d926-40e5-a4a1-e1bf1c104b02', title: 'Star Objects', class_name: 'SystemMapStarObject', class_field: 'title_with_kind'})
Field.create({id: '65c22ae1-d724-409f-9d66-d9f544cc6be6', name: 'Star Objects', field_descriptor_class: so_fdc })

ff_field = Field.create({ id: 'c08e36f8-d62d-4c8d-a631-835fa9336105', name: 'Force Levels'})
FieldDescriptor.create([{ id: '9d480a31-1537-41c0-a553-fb7a983d1067', field: ff_field, title: 'None', description: 'No force was used to stop the offender (ex. verbal) (explain)', ordinal: 1 },
                      { id: '336080b9-93df-4b9a-8131-f670d54e11e1', field: ff_field, title: 'Non-Lethal', description: 'Force not designed to cause harm was used to stop the offender.', ordinal: 2 },
                      { id: '7e470edf-3830-4bb6-b34b-7f6120455bc5', field: ff_field, title: 'Less-than-lethal', description: 'Less-than-lethal force was used to subdue the offender. (ex. stun weapons, disrupters, warning shot)', ordinal: 3 },
                      { id: 'a7f02954-1808-4230-8b5b-d3c8dbc3bec4', field: ff_field, title: 'Lethal', description: 'Lethal force was used to stop the offender', ordinal: 4 },
                      { id: '938b3b26-bf9b-4f13-a8fe-41c2a0ac4b5a', field: ff_field, title: 'None (Unable)', description: 'Force could not be used to stop the offender (explain)', ordinal: 5 }])

SystemMapMappingRule.create([{ id:"3f132e7f-9218-4189-a312-1b22fbe586f3", parent_id:"ba0fd9ae-a371-49de-9f78-0f58153dd4c4", note:"system object to system"}, 
  { id:"d2b10d5a-e20e-4ead-9f12-2e1481a54c4c", parent_id:"ba0fd9ae-a371-49de-9f78-0f58153dd4c4", child_id:"7a4697fc-8c8d-4443-8aa0-0d9451156e1e", note:"jump point to system"}, 
  { id:"f9a09b83-7ff0-409e-aea5-2d9f7bc7dfe2", parent_id:"ba0fd9ae-a371-49de-9f78-0f58153dd4c4", child_id:"b1c3ce36-b924-4b25-8fa7-dd5ad8cbe969", note:"planet to system"}, 
  { id:"b36c045f-3256-4804-be72-49c89d448972", parent_id:"b1c3ce36-b924-4b25-8fa7-dd5ad8cbe969", child_id:"8e2671c0-2048-4743-b9b3-631752de93eb", note:"moon to planet"}, 
  { id:"e72f011c-f6b5-409c-9292-3c95690eae79", parent_id:"b1c3ce36-b924-4b25-8fa7-dd5ad8cbe969", child_id:"941a1835-e901-4184-af59-8c91daa73c5d", note:"settlement to planet"}, 
  { id:"ce93f75b-1fe4-46f2-9579-f5d6d7d9e44d", parent_id:"8e2671c0-2048-4743-b9b3-631752de93eb", child_id:"941a1835-e901-4184-af59-8c91daa73c5d", note:"settlement to moon"}, 
  { id:"444b344b-5703-4c04-8571-5c4c95fb5a3d", parent_id:"8e2671c0-2048-4743-b9b3-631752de93eb", child_id:"99839260-6bc6-4c11-8129-fa2c6908cb9d", note:"location to moon"}, 
  { id:"5475a642-0293-49e3-8206-cd7cc81a0acd", parent_id:"b1c3ce36-b924-4b25-8fa7-dd5ad8cbe969", child_id:"99839260-6bc6-4c11-8129-fa2c6908cb9d", note:"location to planet"}, 
  { id:"12c05e36-0a59-49cb-8f94-830e9022b942", parent_id:"53902d5c-4cb5-46f7-ae57-b2d9b1df1cde", child_id:"99839260-6bc6-4c11-8129-fa2c6908cb9d", note:"location to system object"}, 
  { id:"d3289104-8172-4844-83bd-c0bbeb275d3b", parent_id:"941a1835-e901-4184-af59-8c91daa73c5d", child_id:"99839260-6bc6-4c11-8129-fa2c6908cb9d", note:"location to settlement"}, 
  { id:"91d328dd-cf82-4565-b19b-f5493618f42e", parent_id:"99839260-6bc6-4c11-8129-fa2c6908cb9d", child_id:"05f25434-da25-4800-9db6-9bae84a28736", note:"mission giver to location"}, 
  { id:"9fc17503-fbf3-4c63-95b5-e2297eeb40db", parent_id:"b1c3ce36-b924-4b25-8fa7-dd5ad8cbe969", child_id:"53902d5c-4cb5-46f7-ae57-b2d9b1df1cde", note:"system object to planet"}, 
  { id:"b6b0da6e-4db6-41b6-990b-629e370557e2", parent_id:"8e2671c0-2048-4743-b9b3-631752de93eb", child_id:"53902d5c-4cb5-46f7-ae57-b2d9b1df1cde", note:"system object to moon"}])

# make all the other fields
Field.create([{ id: '60152083-97c5-4262-9c88-2903cc8c44ad', name: 'Jump Point Connection Size' },
  { id: '62fdb35f-39ab-47f8-9fc0-0c690793e076', name: 'Jump Point Connection Status' },
  { id: 'ce45fca0-80c1-4969-84d4-2449eb0f5164', name: 'Gravity Well Luminosity Class' },
  { id: 'e5d23d1f-13bc-42b9-949f-383097773727', name: 'Gravity Well Type' },
  { id: '9393a4e0-210b-43db-a5e7-92d7d0226066', name: 'Location Type' },
  { id: '62ac3a07-ece3-4079-8da1-3e88617032fd', name: 'System Object Kind' },
  { id: "0f65a426-aa0e-4589-88b6-6bb54247e0bf", name: "System Map Kinds" },
  { id: "16c4cbbb-aeaa-4504-84cd-852c7757a5b8", name: "MasterId Types", read_only: true },
  { id: "de4df4ca-b124-4171-a77b-770bdd81da72", name:	"Donation Type" },
  { id: 'ebf80864-d8f6-4b1d-8cd2-62bfde86f2d9', name:	'Field Value Presentation Types', read_only: true }])

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
    { id:'53923cf1-087c-4437-a5ad-2e4549e31ce8',field_id:'9393a4e0-210b-43db-a5e7-92d7d0226066',title:'Other',description:'Location types which do not fit into the current set of location classifications.',ordinal:99 },
    { id:"ba0fd9ae-a371-49de-9f78-0f58153dd4c4", field_id:"0f65a426-aa0e-4589-88b6-6bb54247e0bf", title:"System", description:"A star system", ordinal:1, read_only:true, archived:false}, 
  { id:"b1c3ce36-b924-4b25-8fa7-dd5ad8cbe969", field_id:"0f65a426-aa0e-4589-88b6-6bb54247e0bf", title:"Planet", description:"A planet within in a star system", ordinal:2, read_only:true, archived:false}, 
  { id:"8e2671c0-2048-4743-b9b3-631752de93eb", field_id:"0f65a426-aa0e-4589-88b6-6bb54247e0bf", title:"Moon", description:"A moon which orbits a planet. These are planetary bodies separate from other orbital objects.", ordinal:3, read_only:true, archived:false}, 
  { id:"53902d5c-4cb5-46f7-ae57-b2d9b1df1cde", field_id:"0f65a426-aa0e-4589-88b6-6bb54247e0bf", title:"System Object", description:"Other orbital objects. Space stations, celestial objects, etc", ordinal:4, read_only:true, archived:false}, 
  { id:"941a1835-e901-4184-af59-8c91daa73c5d", field_id:"0f65a426-aa0e-4589-88b6-6bb54247e0bf", title:"Settlement", description:"Settlements are considered to be meta-locations with multiple child locations. (ie. Lorville)", ordinal:5, read_only:true, archived:false}, 
  { id:"99839260-6bc6-4c11-8129-fa2c6908cb9d", field_id:"0f65a426-aa0e-4589-88b6-6bb54247e0bf", title:"Location", description:"A distinct point of interest", ordinal:6, read_only:true, archived:false}, 
  { id:"05f25434-da25-4800-9db6-9bae84a28736", field_id:"0f65a426-aa0e-4589-88b6-6bb54247e0bf", title:"Mission Giver", description:"A individual who provides missions on behalf of themselves or an organization", ordinal:7, read_only:true, archived:false}, 
  { id:"75077527-be54-4c06-87f4-a73026438305", field_id:"0f65a426-aa0e-4589-88b6-6bb54247e0bf", title:"Gravity Well", description:"A gravity well which is a part of a Star System", ordinal:8, read_only:true, archived:false}, 
  { id:"7a4697fc-8c8d-4443-8aa0-0d9451156e1e", field_id:"0f65a426-aa0e-4589-88b6-6bb54247e0bf", title:"Jump Point", description:"A jump point (ie wormhole) which allows traversal between Star Systems.", ordinal:9, read_only:true, archived:false}, 
  { id:"384f7e96-d7db-4154-b36f-79343e59d9a6", field_id:"0f65a426-aa0e-4589-88b6-6bb54247e0bf", title:"Flora", description:"A plant entity found within a given biome or system body", ordinal:10, read_only:true, archived:true}, 
  { id:"ef61a50e-03ff-4db4-82e1-71858edac976", field_id:"0f65a426-aa0e-4589-88b6-6bb54247e0bf", title:"Fauna", description:"An animal entity found within a given biome or system body", ordinal:11, read_only:true, archived:true}, 
  { id:"8b91273e-d133-4b8c-a809-af9c26c5c7ad", field_id:"0f65a426-aa0e-4589-88b6-6bb54247e0bf", title:"Biome", description:"A given climate zone on a planet or moon", ordinal:12, read_only:true, archived:true},
  { id: '209a90cd-5546-4353-83f6-36d7b025a96f', field_id: '16c4cbbb-aeaa-4504-84cd-852c7757a5b8', title: 'SystemMapStarObject', ordinal: 1, read_only: true },
  { id: "e7932112-1e6c-4d54-986f-9c4bfa312f9f", field_id: "de4df4ca-b124-4171-a77b-770bdd81da72", title:	"Operating Expenses", ordinal:	1, read_only: true },
  { id: "c6a4a515-09a1-438e-a9f5-9227d7c9ee54",	field_id: "de4df4ca-b124-4171-a77b-770bdd81da72",	title:	"Ship", ordinal:	2, read_only: true },
  { id: "b80d9b75-ba4d-4a0d-9860-1aca23a062d3",	field_id: "de4df4ca-b124-4171-a77b-770bdd81da72",	title:	"Other", ordinal:	3, read_only: true },
  { id: '246e8225-2224-454c-a972-4af521f6736e', field_id:	'ebf80864-d8f6-4b1d-8cd2-62bfde86f2d9', title: 'String', ordinal: 1, read_only: true  },
  { id: 'e5bd60e6-9e09-4eb3-b57a-9e22cae7a7d9', field_id:	'ebf80864-d8f6-4b1d-8cd2-62bfde86f2d9', title:	'Number', ordinal: 2, read_only: true  },
  { id: '9be837b4-fbec-429e-bb2e-7b16fc5e0b4e', field_id: 'ebf80864-d8f6-4b1d-8cd2-62bfde86f2d9', title:	'Date', ordinal: 3, read_only: true },
  { id: 'bcdff581-72fd-4538-b756-39802a0ed7be', field_id: 'ebf80864-d8f6-4b1d-8cd2-62bfde86f2d9', title:	'LongString', ordinal: 3, read_only: true }])

page_categories_field = Field.create(id: '95ba5b0c-cbfb-4fe7-ab39-75010a30b20f', name: 'Page Categories')
FieldDescriptor.create([{ id: '951513f7-2d16-4234-a26a-aa521169b1e2', field_id: page_categories_field.id, title: 'Featured', read_only: true },
                        { id: 'b8bdff1d-237e-4812-9e2d-ef33cc2bd76d', field_id: page_categories_field.id, title: 'Guides', read_only: true },
                        { id: 'f9b194cc-7ec3-48d5-93b9-467a6227823e', field_id: page_categories_field.id, title: 'Policy', read_only: true }])

MenuItem.create([{ id: 1, title: 'Dashboard', icon: 'star', link: '/dashboard', ordinal: 1 },
                 { id: 2, title: 'Profiles', icon: 'people-circle', link: '/profiles', ordinal: 2 },
                 { id: 3, title: 'Events', icon: 'calendar', link: '/events', ordinal: 3 },
                 { id: 4, title: 'Job Board', icon: 'clipboard', link: '/job-board', ordinal: 4 },
                 { id: 5, title: 'Flight Logs', icon: 'book', link: '/flight-logs', ordinal: 5 },
                 { id: 6, title: 'Forms', icon: 'document-text', link: '/forms', ordinal: 6 },
                 { id: 22, title: 'Pages', icon: 'documents', link: '/pages', ordinal: 7 },
                 { id: 8, title: 'Alerts', icon: 'alert-circle', link: '/alerts', ordinal: 8 },
                 { id: 11, title: 'System Map', icon: 'planet', link: '/system-map', ordinal: 11 },
                #  { id: 12, title: 'Admin', icon: 'fas fa-user', ordinal: 13 },
                #  { id: 13, title: 'Approvals', icon: 'far fa-check-circle', link: '/approvals', ordinal: 12 },
                #  { id: 14, title: 'Impersonation', icon: 'fas fa-user', link: '/impersonate', ordinal: 1, nested_under_id: 12 },
                #  { id: 15, title: 'Site Logs', icon: 'fas fa-user', link: '/site-logs', ordinal: 2, nested_under_id: 12 },
                #  { id: 16, title: 'Roles', icon: 'fas fa-key', link: '/roles', ordinal: 3, nested_under_id: 12 },
                #  { id: 17, title: 'Liabilities', icon: 'fas fa-chart-line', link: '/liabilities', ordinal: 4, nested_under_id: 12 },
                #  { id: 18, title: 'Jobs Admin', icon: 'fas fa-building', link: '/jobs', ordinal: 5, nested_under_id: 12 },
                #  { id: 19, title: 'Law Library', icon: 'fas fa-gavel', link: '/law-library', ordinal: 6, nested_under_id: 12 },
                #  { id: 20, title: 'Faction', icon: 'fas fa-gavel', link: '/faction-admin', ordinal: 7, nested_under_id: 12 },
                #  { id: 21, title: 'Field Admin', icon: 'fas fa-toilet-paper', link: '/field-admin', ordinal: 8, nested_under_id: 12 },
                 { id: 23, title: 'Application', icon: 'id-card', link: '/application', ordinal: 1}
                 ])
# { id: 37, name: 'Roles Administrator', description: 'Can administrate roles.' },
# { id: 38, name: 'Jobs Administrator', description: 'Can view the jobs administrative panel.' },
# { id: 39, name: 'Logs Viewer', description: 'Can view site logs' },
# { id: 40, name: 'Liabilities Viewer', description: 'Can view the liabilites' },

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

ships = Ship.create([{ title: 'M50 Intercepter', manufacturer: 'ORIG'},
                      { title: 'Mustang Beta', manufacturer: 'CNOU'},
                      { title: 'Mustang Gamma', manufacturer: 'CNOU'},
                      { title: 'Mustang Delta', manufacturer: 'CNOU'},
                      { title: 'Mustang Omega', manufacturer: 'CNOU'},
                      { title: 'Mustang Alpha', manufacturer: 'CNOU'},
                      { title: 'Redeemer', manufacturer: 'AEGS'},
                      { title: 'Gladius', manufacturer: 'AEGS'},
                      { title: 'Aurora ES', manufacturer: 'RSI'},
                      { title: 'Aurora LX', manufacturer: 'RSI'},
                      { title: 'Aurora MR', manufacturer: 'RSI'},
                      { title: 'Aurora CL', manufacturer: 'RSI'},
                      { title: 'Aurora LN', manufacturer: 'RSI'},
                      { title: '300i', manufacturer: 'ORIG'},
                      { title: '315p', manufacturer: 'ORIG'},
                      { title: '325a', manufacturer: 'ORIG'},
                      { title: '350R', manufacturer: 'ORIG'},
                      { title: 'F7C Hornet', manufacturer: 'ANVL'},
                      { title: 'F7C-S Hornet Ghost', manufacturer: 'ANVL'},
                      { title: 'F7C-R Hornet Tracker', manufacturer: 'ANVL'},
                      { title: 'F7C-M Super Hornet', manufacturer: 'ANVL'},
                      { title: 'F7CA Hornet', manufacturer: 'ANVL'},
                      { title: 'Constellation Andromeda', manufacturer: 'RSI'},
                      { title: 'Constellation Aquila', manufacturer: 'RSI'},
                      { title: 'Constellation Taurus', manufacturer: 'RSI'},
                      { title: 'Constellation Phoenix', manufacturer: 'RSI'},
                      { title: 'Freelancer', manufacturer: 'MISC'},
                      { title: 'Freelancer DUR', manufacturer: 'MISC'},
                      { title: 'Freelancer MAX', manufacturer: 'MISC'},
                      { title: 'Freelancer MIS', manufacturer: 'MISC'},
                      { title: 'Cutlass Black', manufacturer: 'DRAK'},
                      { title: 'Cutlass Red', manufacturer: 'DRAK'},
                      { title: 'Cutlass Blue', manufacturer: 'DRAK'},
                      { title: 'Avenger Stalker', manufacturer: ''},
                      { title: 'Avenger Warlock', manufacturer: 'AEGS'},
                      { title: 'Avenger Titan', manufacturer: 'AEGS'},
                      { title: 'Gladiator', manufacturer: 'ANVL'},
                      { title: 'Starfarer', manufacturer: 'MISC'},
                      { title: 'Starfarer Gemini', manufacturer: 'MISC'},
                      { title: 'Caterpillar', manufacturer: 'DRAK'},
                      { title: 'Retaliator', manufacturer: 'AEGS'},
                      { title: 'Scythe', manufacturer: 'VANDUUL'},
                      { title: 'Idris-M', manufacturer: 'AEGS'},
                      { title: 'Idris-P', manufacturer: 'AEGS'},
                      { title: 'Khartu-al', manufacturer: 'XIAN'},
                      { title: 'Merchantman', manufacturer: 'BANU'},
                      { title: '890 Jump', manufacturer: 'ORIG'},
                      { title: 'Carrack', manufacturer: 'ANVL'},
                      { title: 'Herald', manufacturer: 'DRAK'},
                      { title: 'Hull C', manufacturer: 'MISC'},
                      { title: 'Hull A', manufacturer: 'MISC'},
                      { title: 'Hull B', manufacturer: 'MISC'},
                      { title: 'Hull D', manufacturer: 'MISC'},
                      { title: 'Hull E', manufacturer: 'MISC'},
                      { title: 'Orion', manufacturer: 'RSI'},
                      { title: 'Reclaimer', manufacturer: 'AEGS'},
                      { title: 'Javelin Class Destroyer', manufacturer: 'AEGS'},
                      { title: 'Vanguard Warden', manufacturer: 'AEGS'},
                      { title: 'Vanguard Harbinger', manufacturer: 'AEGS'},
                      { title: 'Vanguard Sentinel', manufacturer: 'AEGS'},
                      { title: 'Reliant Kore', manufacturer: 'MISC'},
                      { title: 'Reliant Mako', manufacturer: 'MISC'},
                      { title: 'Reliant Sen', manufacturer: 'MISC'},
                      { title: 'Reliant Tana', manufacturer: 'MISC'},
                      { title: 'Genesis Starliner', manufacturer: 'CRSD'},
                      { title: 'Glaive', manufacturer: 'ESPERIA'},
                      { title: 'Endeavor', manufacturer: 'MISC'},
                      { title: 'Sabre', manufacturer: 'AEGS'},
                      { title: 'Crucible', manufacturer: 'ANVL'},
                      { title: 'Terrapin', manufacturer: 'ANVL'}])

# page_categories = PageCategory.create([{ id: '951513f7-2d16-4234-a26a-aa521169b1e2', title: 'Featured', read_only: true },
#                                        { id: 'b8bdff1d-237e-4812-9e2d-ef33cc2bd76d', title: 'Guides', read_only: true },
#                                        { id: 'f9b194cc-7ec3-48d5-93b9-467a6227823e', title: 'Policy', read_only: true }])

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
                         { id: 3, title: 'Standard - Do Nothing', description: 'This approval is similiar to standard except that nothing happens if the approval passes' },
                         { id: 4, title: 'Standard - Single Consent', description: 'The same as the standard flow except that it allows single consent of an approval' }])
#page = Page.create([{ title: 'Test page',
#                      subtitle: 'This is a catchy sub title',
#                      content: 'This is some page content its kinda cool and will allow HTML. Trust will be important here.',
#                      url_link: 'test-page',
#                      tags: 'testing guild',
#                      is_published: true,
#                      published_when: Time.now,
#                      page_category: page_categories[0] }])
#create default roles
roles = Role.create([{ id: -99, name: 'Debug', description: 'Putting someone in this role will cause the app to get extremely chatty...' },
                     { id:-3, name: 'Client', description: 'Used to give external users access to the application for tool access.' },
                     { id:-2, name: 'Applicant', description: 'Applicant role.' },
                     { id:-1, name: 'Bot', description: 'a bot.' },
                     { id:1, name: 'Editor', description: 'Access to administrative controller.' },
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

MenuItemRole.create([{ menu_item_id: 12, role_id: 42 },
{ menu_item_id: 14, role_id: 32 },
{ menu_item_id: 15, role_id: 39 },
{ menu_item_id: 16, role_id: 37 },
{ menu_item_id: 17, role_id: 40 },
{ menu_item_id: 18, role_id: 38 },
{ menu_item_id: 19, role_id: 43 },
{ menu_item_id: 23, role_id: -2 }])

# NOTE: watch out for this
MenuItem.where('id NOT IN (12,14,15,16,17,18,19,23,25)').each { |item| MenuItemRole.create(menu_item_id: item.id, role_id: 0) }

ClassificationLevel.create([{ id: 1, title: 'Unclassified', description: 'Publically available corporate information.', ordinal: 1 },
                           { id: 2, title: 'Internal', description: 'Not publically available information. Available to all members.', ordinal: 2 },
                           { id: 3, title: 'Confidential', description: 'Sensitive non-compartmentalized information.', ordinal: 3 },
                           { id: 4, title: 'Special Handling', description: 'Highly sensitive non-compartmentalized information.', ordinal: 4 },
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

# base class roles
ClassificationLevelRole.create([{ classification_level_id: 2, role_id: 0 },{ classification_level_id: 3, role_id: 0 }])

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


user_sys = User.create(id: 0, username: 'System', email: 'no-reply@bendrocorp.com', password: 'gqsUIsdfgdsfghu2uUhghJiMIdNrdsfg45', password_confirmation: 'gqsUIsdfgdsfghu2uUhghJiMIdNrdsfg45', is_member: true, is_admin: true, email_verified: true, locked: true, login_allowed: false)
user2 = User.create(id: 2, username: 'Stevo', email: 'dale@daleslab.com', password: 'Password12345', password_confirmation: 'Password12345', is_member: true, is_admin: true, email_verified: true)
user1 = User.create(id: 1, rsi_handle:'Aayhan', username: 'Rindzer', email: 'dale.myszewski@gmail.com', password: 'Password12345', password_confirmation: 'Password12345', is_member: true, is_admin: true, email_verified: true)

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

handler = ReportHandler.create({ name: 'Add Role Handler', for_class: 'RoleRequest', approval_kind_id: 1, ordinal: 2 })
handler_two = ReportHandler.create({ name: 'Remove Role Handler', for_class: 'RoleRemovalRequest', approval_kind_id: 12, ordinal: 3 })
handler_three = ReportHandler.create({ name: 'Position Change Request', for_class: 'RoleRemovalRequest', approval_kind_id: 22, ordinal: 4 })
ReportHandlerVariable.create([{ handler_id: handler.id, name: 'Role', object_name: 'role_id' },
                              { handler_id: handler.id, name: 'On Behalf Of', object_name: 'on_behalf_of_id' },
                              { handler_id: handler_two.id, name: 'Role', object_name: 'role_id' },
                              { handler_id: handler_two.id, name: 'On Behalf Of', object_name: 'on_behalf_of_id' },
                              { handler_id: handler_three.id, name: 'Job', object_name: 'job_id' },
                              { handler_id: handler_three.id, name: 'Member Character', object_name: 'character_id' }])
# on_behalf_of
# RoleRemovalRequest
# { id: 1, title: 'Role Request'},
# { id: 2, title: 'Application Approval Request'},
# { id: 3, title: 'Award Approval'},
# { id: 4, title: 'Role Removal'},

DonationItem.create([{ title: 'Operating Budget 1', description: 'test data', goal: 5, goal_date: Time.now - 2.days, ordinal: 1, donation_type_id: "e7932112-1e6c-4d54-986f-9c4bfa312f9f", created_by_id: 1 },
  { title: 'Operating Budget 2', description: 'test data', goal: 10, goal_date: Time.now + 2.days, ordinal: 2, donation_type_id: "e7932112-1e6c-4d54-986f-9c4bfa312f9f", archived: true, created_by_id: 1 },
  { title: 'Ship 1', description: 'test data', goal: 14, goal_date: Time.now + 4.days, ordinal: 3, donation_type_id: "c6a4a515-09a1-438e-a9f5-9227d7c9ee54", created_by_id: 1 },
  { title: 'Operating Budget 3', description: 'test data', goal: 50, goal_date: Time.now + 4.days, ordinal: 4, donation_type_id: "e7932112-1e6c-4d54-986f-9c4bfa312f9f", created_by_id: 1 },
  { title: 'Operating Budget 4', description: 'test data', goal: 500, goal_date: Time.now + 10.days, ordinal: 5, donation_type_id: "e7932112-1e6c-4d54-986f-9c4bfa312f9f", created_by_id: 1 }])

SystemMapStarObject.create({ title: 'Stanton', description: 'The Stanton system', object_type_id: 'ba0fd9ae-a371-49de-9f78-0f58153dd4c4' })

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
