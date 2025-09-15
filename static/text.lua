local blue = { r = 30, g = 130, b = 252 }
local yellow = { r = 249, g = 245, b = 14 }
local grey = { r = 150, g = 150, b = 150 }

-- for "line" indicators, heights are generally 20 higher than the player's standing position,
-- accel should be 1650 higher than the standing position and preceded by an arrow that's 1200 higher,
-- dig should be 1600 higher and preceded by an arrow that's 1200 higher
local clues = {
  ["This anagram reveals who to speak to next: AHA JAR"] = {},
  ["This anagram reveals who to speak to next: ARC O LINE"] = {},
  ["This anagram reveals who to speak to next: ARE COL"] = {},
  ["This anagram reveals who to speak to next: BAIL TRIMS"] = {},
  ["This anagram reveals who to speak to next: BOAST B"] = {},
  ["This anagram reveals who to speak to next: DT RUN B"] = {},
  ["This anagram reveals who to speak to next: EEK ZERO OP"] = {},
  ["This anagram reveals who to speak to next: EL OW"] = {},
  ["This anagram reveals who to speak to next: ERR CURE IT"] = {},
  ["This anagram reveals who to speak to next: GOBLIN KERN"] = {},
  ["This anagram reveals who to speak to next: GOT A BOY"] = {},
  ["This anagram reveals who to speak to next: HALT US"] = {},
  ["This anagram reveals who to speak to next: ICY FE"] = {},
  ["This anagram reveals who to speak to next: IM KROM"] = {},
  ["This anagram reveals who to speak to next: IZ A AMMO LOAD FOR MRS YAKKERS"] = {},
  ["This anagram reveals who to speak to next: LARK IN DOG"] = {},
  ["This anagram reveals who to speak to next: ME IF"] = {},
  ["This anagram reveals who to speak to next: NOD MED"] = {},
  ["This anagram reveals who to speak to next: OK CO"] = {},
  ["This anagram reveals who to speak to next: OR A VILE"] = {},
  ["This anagram reveals who to speak to next: PEATY PERT"] = {},
  ["This anagram reveals who to speak to next: R AK MI"] = {},
  ["This anagram reveals who to speak to next: SOY DRAIN"] = {},
  ["This anagram reveals who to speak to next: STAB OB"] = {},
  ["This anagram reveals who to speak to next: WINSTON LANE"] = {},
  ["This anagram reveals who to speak to next: A ZEN SHE"] = {},
  ["This anagram reveals who to speak to next: ACE MATCH ELM"] = {},
  ["This anagram reveals who to speak to next: AN PAINT TONIC"] = {},
  ["This anagram reveals who to speak to next: ARR! SO I AM A CRUST, AND?"] = {},
  ["This anagram reveals who to speak to next: BY LOOK"] = {},
  ["This anagram reveals who to speak to next: C ON GAME HOC"] = {},
  ["This anagram reveals who to speak to next: GULAG RUN"] = {},
  ["This anagram reveals who to speak to next: HE DO POSE. IT IS CULTRRL, MK?"] = {},
  ["This anagram reveals who to speak to next: I EAT ITS CHART HINTS DO U"] = {},
  ["This anagram reveals who to speak to next: I FAFFY RUN"] = {},
  ["This anagram reveals who to speak to next: LAND DOOMD"] = {},
  ["This anagram reveals who to speak to next: O BIRDZ A ZANY EN PC"] = {},
  ["This anagram reveals who to speak to next: OR ZINC FUMES WARD"] = {},
  ["This anagram reveals who to speak to next: PROFS LOSE WRONG PIE"] = {},
  ["This anagram reveals who to speak to next: RED ART TANS"] = {},
  ["This anagram reveals who to speak to next: SEQUIN DIRGE"] = {},
  ["00 degrees 05 minutes south 01 degrees 13 minutes east"] = {},
  ["00 degrees 13 minutes south 14 degrees 00 minutes east"] = {},
  ["00 degrees 18 minutes south 09 degrees 28 minutes east"] = {},
  ["00 degrees 20 minutes south 23 degrees 15 minutes east"] = {},
  ["00 degrees 31 minutes south 17 degrees 43 minutes east"] = {},
  ["00 degrees 50 minutes north 24 degrees 16 minutes east"] = {},
  ["01 degrees 18 minutes south 14 degrees 15 minutes east"] = {},
  ["01 degrees 26 minutes north 08 degrees 01 minutes east"] = {},
  ["01 degrees 35 minutes south 07 degrees 28 minutes east"] = {},
  ["02 degrees 50 minutes north 06 degrees 20 minutes east"] = {},
  ["02 degrees 50 minutes north 21 degrees 46 minutes east"] = {},
  ["03 degrees 35 minutes south 13 degrees 35 minutes east"] = {},
  ["04 degrees 00 minutes south 12 degrees 46 minutes east"] = {},
  ["04 degrees 13 minutes north 12 degrees 45 minutes east"] = {},
  ["05 degrees 20 minutes south 04 degrees 28 minutes east"] = {},
  ["05 degrees 43 minutes north 23 degrees 05 minutes east"] = {},
  ["06 degrees 31 minutes north 01 degrees 46 minutes west"] = {},
  ["07 degrees 05 minutes north 30 degrees 56 minutes east"] = {},
  ["07 degrees 33 minutes north 15 degrees 00 minutes east"] = {},
  ["08 degrees 33 minutes north 01 degrees 39 minutes west"] = {},
  ["09 degrees 33 minutes north 02 degrees 15 minutes east"] = {},
  ["09 degrees 48 minutes north 17 degrees 39 minutes east"] = {},
  ["11 degrees 03 minutes north 31 degrees 20 minutes east"] = {},
  ["11 degrees 05 minutes north 00 degrees 45 minutes west"] = {},
  ["11 degrees 41 minutes north 14 degrees 58 minutes east"] = {},
  ["14 degrees 54 minutes north 09 degrees 13 minutes east"] = {},
  ["22 degrees 30 minutes north 03 degrees 01 minutes east"] = {},
  ["00 degrees 00 minutes north 07 degrees 13 minutes west"] = {},
  ["01 degrees 24 minutes north 08 degrees 05 minutes west"] = {},
  ["02 degrees 33 minutes north 28 degrees 45 minutes east"] = {},
  ["03 degrees 03 minutes south 05 degrees 03 minutes east"] = {},
  ["03 degrees 39 minutes south 13 degrees 58 minutes east"] = {},
  ["03 degrees 45 minutes south 22 degrees 45 minutes east"] = {},
  ["04 degrees 03 minutes south 03 degrees 11 minutes east"] = {},
  ["04 degrees 05 minutes south 04 degrees 24 minutes east"] = {
    x = 2581,
    y = 3030,
    level = 0,
    radius = 2,
    indicators = {
      { type = "line", col = yellow, x1 = 2571, y1 = 2956, x2 = 2561, y2 = 2946, h1 = 1521, h2 = 1409 },
      { type = "line", col = blue, x1 = 2561, y1 = 2946, x2 = 2551, y2 = 2936, h1 = 1409, h2 = 1225 },
      { type = "line", col = yellow, x1 = 2551, y1 = 2936, x2 = 2541, y2 = 2936, h1 = 1225, h2 = 377 },
      { type = "line", col = blue, x1 = 2541, y1 = 2936, x2 = 2531, y2 = 2936, h1 = 377, h2 = 889 },
      { type = "line", col = yellow, x1 = 2531, y1 = 2936, x2 = 2521, y2 = 2946, h1 = 889, h2 = 1193 },
      { type = "line", col = blue, x1 = 2521, y1 = 2946, x2 = 2511, y2 = 2956, h1 = 1193, h2 = 2513 },
      { type = "line", col = blue, x1 = 2511, y1 = 2956, x2 = 2501, y2 = 2966, h1 = 2513, h2 = 1473 },
      { type = "line", col = yellow, x1 = 2501, y1 = 2966, x2 = 2501, y2 = 2976, h1 = 1473, h2 = 937 },
      { type = "line", col = blue, x1 = 2501, y1 = 2976, x2 = 2501, y2 = 2986, h1 = 937, h2 = 1121 },
      { type = "line", col = grey, x1 = 2501, y1 = 2986, x2 = 2500, y2 = 2989, h1 = 1121, h2 = 1297 },
      { type = "arrow", x = 2551, y = 2936, h = 2405 },
      { type = "accel", x = 2551, y = 2936, h = 2855 },
      { type = "arrow", x = 2499.5, y = 2989, h = 1785 },
      -- travel through tunnel
      { type = "line", col = blue, x1 = 2576, y1 = 3029, x2 = 2573, y2 = 3026, h1 = 2401, h2 = 2145 },
      { type = "line", col = yellow, x1 = 2573, y1 = 3026, x2 = 2580, y2 = 3019, h1 = 2145, h2 = 209 },
      { type = "line", col = grey, x1 = 2580, y1 = 3019, x2 = 2583, y2 = 3024, h1 = 209, h2 = 241 },
      { type = "line", col = blue, x1 = 2583, y1 = 3024, x2 = 2583, y2 = 3031, h1 = 241, h2 = 105 },
      { type = "arrow", x = 2581, y = 3030, h = 2189 },
      { type = "dig", x = 2581, y = 3030, h = 2589 },
    },
  },
  ["04 degrees 16 minutes south 16 degrees 16 minutes east"] = {},
  ["04 degrees 41 minutes north 03 degrees 09 minutes west"] = {},
  ["05 degrees 37 minutes north 31 degrees 15 minutes east"] = {},
  ["05 degrees 50 minutes south 10 degrees 05 minutes east"] = {},
  ["06 degrees 00 minutes south 21 degrees 48 minutes east"] = {},
  ["06 degrees 11 minutes south 15 degrees 07 minutes east"] = {},
  ["07 degrees 22 minutes north 14 degrees 15 minutes east"] = {
    x = 2896,
    y = 3397,
    level = 0,
    radius = 2,
    indicators = {
      { type = "line", col = yellow, x1 = 2915, y1 = 3420, x2 = 2905, y2 = 3410, h1 = 233, h2 = 377 },
      { type = "line", col = blue, x1 = 2905, y1 = 3410, x2 = 2895, y2 = 3400, h1 = 377, h2 = 489 },
      { type = "line", col = grey, x1 = 2895, y1 = 3400, x2 = 2895, y2 = 3398, h1 = 489, h2 = 521 },
      { type = "arrow", x = 2896, y = 3397, h = 1677 },
      { type = "dig", x = 2896, y = 3397, h = 2077 },
    },
  },
  ["07 degrees 41 minutes north 06 degrees 00 minutes east"] = {},
  ["07 degrees 43 minutes south 12 degrees 26 minutes east"] = {},
  ["08 degrees 03 minutes north 31 degrees 16 minutes east"] = {},
  ["08 degrees 05 minutes south 15 degrees 56 minutes east"] = {},
  ["08 degrees 26 minutes south 10 degrees 28 minutes east"] = {},
  ["09 degrees 22 minutes north 02 degrees 24 minutes west"] = {},
  ["12 degrees 48 minutes north 20 degrees 20 minutes east"] = {},
  ["13 degrees 46 minutes north 21 degrees 01 minutes east"] = {},
  ["15 degrees 48 minutes north 13 degrees 52 minutes east"] = {},
  ["16 degrees 20 minutes north 12 degrees 45 minutes east"] = {},
  ["16 degrees 30 minutes north 16 degrees 28 minutes east"] = {},
  ["16 degrees 35 minutes north 27 degrees 01 minutes east"] = {},
  ["17 degrees 50 minutes north 08 degrees 30 minutes east"] = {},
  ["18 degrees 03 minutes north 25 degrees 16 minutes east"] = {},
  ["18 degrees 22 minutes north 16 degrees 33 minutes east"] = {},
  ["19 degrees 43 minutes north 25 degrees 07 minutes east"] = {},
  ["20 degrees 05 minutes north 21 degrees 52 minutes east"] = {},
  ["20 degrees 07 minutes north 18 degrees 33 minutes east"] = {},
  ["20 degrees 33 minutes north 15 degrees 48 minutes east"] = {},
  ["21 degrees 24 minutes north 17 degrees 54 minutes east"] = {},
  ["22 degrees 35 minutes north 19 degrees 18 minutes east"] = {},
  ["22 degrees 45 minutes north 26 degrees 33 minutes east"] = {},
  ["24 degrees 26 minutes north 26 degrees 24 minutes east"] = {},
  ["24 degrees 56 minutes north 22 degrees 28 minutes east"] = {},
  ["24 degrees 58 minutes north 18 degrees 43 minutes east"] = {},
  ["25 degrees 03 minutes north 17 degrees 05 minutes east"] = {},
  ["25 degrees 03 minutes north 23 degrees 24 minutes east"] = {},
  ["A crate found in the tower of a church is your next location."] = {},
  ["One of the sailors in Port Sarim is your next destination."] = {},
  ["Someone watching Het's Oasis is your next destination."] = {},
  ["A town with a different sort of night-life is your destination. Search for some crates in one of the houses."] = {},
  ["After a hard day of spraying back the vegetation, you mite want to pop to the nearby forge and search the crates."] = {},
  ["After trawling for bars, go to the nearest place to smith them and dig by the door."] = {},
  ["Being this far north has meant that these crates have escaped being battled over."] = {},
  ["Brush off the sand and dig in the quarry. There is a wheely handy barrow to the east. Don't worry, permission has been granite to dig there."] = {},
  ["By the town of the dead, walk south down a rickety bridge, then dig near the spotted fungus."] = {},
  ["Dig here if you are not feeling too well after travelling through the desert. Ali heartily recommends it."] = {},
  ["Don't skip here, it's too muddy. You'll feel like a star if you dig here, though."] = {},
  ["Find a crate close to the monks that like to paaarty!"] = {},
  ["For any aspiring mage, I'm sure searching this bookcase will be a rewarding experience."] = {},
  ["Go to the village being attacked by trolls and search the drawers in one of the houses."] = {},
  ["Go to this building to be illuminated, and check the drawers while you are there."] = {},
  ["Hay! Stop for a bit and admire the scenery, just like the tourism promoter says."] = {},
  ["In a town where everyone has perfect vision, seek some locked drawers in a house that sits opposite a workshop."] = {},
  ["In a town where thieves steal from stalls, search for some drawers upstairs of a house near the bank."] = {},
  ["In a town where wizards are known to gather, search upstairs in a large house to the north."] = {},
  ["In a town where the guards are armed with maces, search the upstairs rooms of the public house."] = {},
  ["In a village made of bamboo, look for some crates under one of the houses."] = {},
  ["North of the best monkey restaurant on Karamja, look for the centre of the triangle of boats and search there."] = {},
  ["Observe: in the crate just north of the stairs leading down, you will find the answer."] = {},
  ["Probably filled with wizards' socks."] = {},
  ["Search the upstairs drawers of a house in a village where pirates are known to have a good time."] = {},
  ["Sophind yourself some treasure by searching these boxes."] = {},
  ["The dead, red dragon watches over this chest. He must really dig the view."] = {},
  ["The gnomes' nearby cart must have collapsed under the weight of all the treasure in these boxes!"] = {},
  ["The owner of this crate has a hunch that he put more than fish inside."] = {},
  ["The rock cakes to the south are definitely more edible than the two rocks I buried the treasure between."] = {},
  ["The socks in these drawers are holier than thine, according to the tonsured owners."] = {},
  ["The treasure is buried in a small building full of bones. Here is a hint: it's not near a graveyard."] = {},
  ["This crate clearly marks the end of the line for coal."] = {},
  ["This crate holds a better reward than a broken arrow."] = {},
  ["This crate is mine, all mine, even if it is in the middle of the desert."] = {},
  ["This cupboard has treasure, pirate pots and corsair cutlery!"] = {},
  ["This temple is rather sluggish. The chest just inside the entrance, however, is filled with goodies."] = {},
  ["Try not to step on any aquatic nasties while searching this crate."] = {},
  ["While a sea view is nice, it seems this church has not seen visitors in a while. Dig outside the westmost wall by the broken fence for a reward."] = {},
  ["You'll need to look for a city with a central fountain. Look for a locked chest in the city's chapel."] = {},
  ["You'll need to have Doug deep into the distant past to get to these sacks."] = {},
  ["46 is my number. My body is the colour of burnt orange and crawls among those with eight. Three mouths I have, yet I cannot eat. My blinking blue eye hides my grave."] = {},
  ["'A bag belt only?', he asked his balding brothers."] = {},
  ["A great view: watch the rapidly drying hides get splashed. Check the box you are sitting on."] = {},
  ["A strange little man who sells armour only to those who've proven themselves to be unafraid of dragons."] = {
    x = 3068,
    y = 3516,
    level = 0,
    radius = 3,
    indicators = {
      { type = "line", col = grey, x1 = 3087, y1 = 3496, x2 = 3086, y2 = 3495, h1 = 1689, h2 = 1689 },
      { type = "line", col = yellow, x1 = 3086, y1 = 3495, x2 = 3078, y2 = 3503, h1 = 1689, h2 = 1705 },
      { type = "line", col = blue, x1 = 3078, y1 = 3503, x2 = 3068, y2 = 3513, h1 = 1705, h2 = 1017 },
      { type = "line", col = grey, x1 = 3068, y1 = 3513, x2 = 3068, y2 = 3515, h1 = 1017, h2 = 1049 },
      { type = "model", anim = true, vertices = 306, x1 = -126, y1 = 388, z1 = -26, h = 1100 },
    },
  },
  ["Aggie I see. Lonely and southern I feel. I am neither inside nor outside the house, yet no home would be complete without me. The treasure lies beneath me!"] = {},
  ["And so on, and so on, and so on. Walking from the land of many unimportant things leads to a choice of paths."] = {},
  ["As you desert this town, keep an eye out for a set of spines that could ruin nearby rugs: dig carefully around the greenery."] = {},
  ["Citric cellar."] = {},
  ["Come to the evil ledge, Yew know yew want to. Try not to get stung."] = {},
  ["Covered in shadows, the centre of the circle is where you will find the answer."] = {},
  ["Four blades I have, yet draw no blood; Still I turn my prey to powder. If you are brave, come search my roof; It is there my blades are louder."] = {},
  ["Generally speaking, his nose was very bent."] = {},
  ["His head might be hollow, but the crates nearby are filled with surprises."] = {},
  ["I am a token of the greatest love. I have no beginning or end. My eye is red, I can fit like a glove. Go to the place where it's money they lend, And dig by the gate to be my friend."] = {},
  ["I am head of the abbey with a cold breeze from the west."] = {},
  ["I'm sure they will let ya buy some things here, as long as you are in good 'ealth"] = {},
  ["Identify the back of this over-acting brother. (He's a long way from home.)"] = {},
  ["If a man carried my burden, he would break his back. I am not rich, but leave silver in my track. Speak to the keeper of my trail."] = {},
  ["If you didn't want to be here and in danger, you should lever things well enough alone."] = {},
  ["If you look closely enough, it seems that the archers have lost more than their needles."] = {},
  ["I lie lonely and forgotten in mid wilderness, where the dead rise from their beds. Feel free to quarrel and wind me up, and dig while you shoot their heads."] = {},
  ["It seems to have reached the end of the line, and it's still empty."] = {},
  ["Mine was the strangest birth under the sun. I left the crimson sack, yet life had not begun. Entered the world, and yet was seen by none."] = {},
  ["Must be full of railings."] = {},
  ["My giant guardians below the market streets would be fans of rock and roll, if only they could grab hold of it. Dig near my purple smoke!"] = {},
  ["My home is grey, and made of stone; A castle with a search for a meal. Hidden in some drawers I am, across from a wooden wheel."] = {},
  ["My name is like a tree, yet it is spelt with a 'g', come see the fur which is right near me."] = {},
  ["Navigating to this crate will be a trial."] = {},
  ["Often sought out by scholars of histories past, find me where words of wisdom speak volumes."] = {},
  ["Probably filled with books on magic."] = {},
  ["Read 'How to Breed Scorpions' By O.W. Thathurt."] = {},
  ["'Small shoe.' Often found with rod on mushroom."] = {},
  ["Snah? I feel all confused, like one of those cakes."] = {},
  ["Surprising? I bet he is..."] = {},
  ["The beasts to my east snap claws and tails, The rest to my west can slide and eat fish. The force to my north will jump and they'll wail, Come dig by my fire and make a wish."] = {},
  ["The cheapest water for miles around, but they react badly to religious icons."] = {},
  ["There is no 'worthier' lord."] = {},
  ["This aviator is at the peak of his profession"] = {},
  ["This village has a problem with cartloads of the undead. Try checking the bookcase to find an answer."] = {},
  ["Throat mage seeks companionship. Seek answers inside my furniture if interested."] = {},
  ["Try not to let yourself be dazzled when you search these drawers."] = {},
  ["When no weapons are at hand, then is the time to reflect. In Saradomin's name, redemption draws closer."] = {},
  ["When you get tired of fighting, go deep, deep down until you need an antidote."] = {},
  ["You can cook food on me, but don't cook any foodles - that would just be wrong."] = {},
  ["You don't need to go hopping mad - or take steps - to get to this treasure: just be totally shellfish."] = {},
  ["You have all of the elements available to solve this clue. Fortunately you do not have to go as far as to stand in a draft."] = {},
  ["You will need to under-cook to solve this one."] = {},
  ["You will need to wash the old ash off your spade when you dig here, but the only water nearby is stagnant."] = {},
  ["Blow a raspberry at the monkey cage in Ardougne Zoo"] = {},
  ["Blow raspberries outside the entrance to Keep Le Faye"] = {},
  ["Bow or curtsy at the entrance to Het's Oasis"] = {},
  ["Bow or curtsy outside the entrance to the Legends' Guild"] = {},
  ["Cheer at the Druids' Circle"] = {},
  ["Cheer for the monks at Port Sarim"] = {},
  ["Cheer in the centre of the Burthorpe Games Room"] = {},
  ["Clap in the main exam room of the Exam Centre"] = {},
  ["Clap on the causeway to the Wizards' Tower"] = {},
  ["Clap on the top level of the mill north of east Ardougne"] = {},
  ["Cry outside the south gates of Fort Forinthry"] = {},
  ["Dance a jig by the entrance to the Fishing Guild"] = {},
  ["Dance at the crossroads north of Draynor"] = {},
  ["Dance in the Party Room"] = {},
  ["Dance in the shack in Lumbridge Swamp"] = {},
  ["Headbang in the mine north of Al Kharid"] = {},
  ["Jump for joy at the beehives"] = {},
  ["Laugh at the crossroads south of Sinclair Mansion"] = {},
  ["Panic in the Limestone Mine"] = {},
  ["Panic on the pier where you catch the Fishing trawler"] = {},
  ["Shrug in the mine near Rimmington"] = {},
  ["Think in the middle of the wheat field by the Lumbridge mill"] = {},
  ["Twirl at the crossroads north of Rimmington"] = {},
  ["Twirl in Draynor Manor by the fountain"] = {},
  ["Wave on Mudskipper Point"] = {},
  ["Yawn in Draynor Marketplace"] = {},
  ["Yawn near the census in Varrock Palace library"] = {},
  ["Beckon at Varrock Dig Site, near the eastern winch"] = {},
  ["Beckon in Tai Bwo Wannai"] = {},
  ["Cheer in the Barbarian Agility Arena"] = {},
  ["Cheer in the Ogre Pen in the Training Camp"] = {},
  ["Cry in the Catherby archery shop"] = {},
  ["Cry on the platform of the south-west tree in the Gnome Agility Arena"] = {},
  ["Dance a jig under Shantay's Awning"] = {},
  ["Dance in the centre of Canifis"] = {},
  ["Jump for joy in Yanille bank"] = {},
  ["Panic by the mausoleum in Morytania"] = {},
  ["Think under the lens in the Observatory"] = {},
  ["Twirl on the bridge by Barbarian Village"] = {},
  ["Yawn in the Castle Wars lobby"] = {},
  ["Blow a kiss between the tables in Shilo Village bank"] = {},
  ["Blow a raspberry in the Fishing Guild bank"] = {},
  ["Bow or curtsy at the top of the Lighthouse"] = {},
  ["Dance at the cat-doored pyramid in Sophanem"] = {},
  ["Laugh at Jokul's tent in the Mountain Camp"] = {},
  ["Panic by the pilot on White Wolf Mountain"] = {},
  ["Panic in the heart of the Haunted Woods"] = {},
  ["Salute in the banana plantation"] = {},
  ["Shrug in the Zamorak temple"] = {},
  ["Yawn near the Wilderness Bandit camp obelisk"] = {},
  ["Blow a Raspberry at the celestial dragons on Dragontooth Island"] = {},
  ["Bow or curtsy at the charm sprite hunter area"] = {},
  ["Cheer by the sulphur pit in the TzHaar City"] = {},
  ["Dance on an Uncharted Isle"] = {},
  ["Dare to laugh in the Green Ghost inn at Port Phasmatys"] = {},
  ["Have an idea inside the Invention Guild"] = {},
  ["Headbang inside the Slayer Tower"] = {},
  ["Jig in the Edgeville Monastery garden"] = {},
  ["Salute in the Max Guild Garden"] = {},
  ["Shrug in the Lumbridge Fishing Supplies shop"] = {},
  ["Think in the Hefin district of Prifddinas"] = {},
  ["Wave in front of the entrance to the Grand Library of Menaphos"] = {},
  ["Dig near some giant mushrooms, behind the Grand Tree."] = {},
  ["Look in the ground floor crates of houses in Falador"] = {},
  ["Search a barrel east of Mission Mistress Fara, in Burthorpe."] = {},
  ["Search a barrel outside the mill in Taverley."] = {},
  ["Search a barrel outside the Pick and Lute inn, in Taverley."] = {},
  ["Search chests found in the upstairs of shops in Port Sarim."] = {},
  ["Search for a crate in a building in Hemenster."] = {},
  ["Search for a crate in Varrock Palace."] = {},
  ["Search for a crate on the ground floor of a house in Seers' Village"] = {},
  ["Search in the south-east corner of the Artisan Dwarves' workshop in Falador"] = {},
  ["Search the boxes in one of the tents in Al Kharid"] = {},
  ["Search the boxes in the goblin house near Lumbridge"] = {},
  ["Search the boxes in the house in Al Kharid with racks of silk."] = {},
  ["Search the boxes in the house near the south entrance of Varrock."] = {},
  ["Search the chest in the Duke of Lumbridge's bedroom"] = {},
  ["Search the chest in the left-hand tower of Camelot Castle."] = {},
  ["Search the chests in Al Kharid palace."] = {},
  ["Search the chests in the Dwarven Mine."] = {},
  ["Search the crate in the left-hand tower of Lumbridge Castle"] = {},
  ["Search the crate near a cart in Port Khazard"] = {},
  ["Search the crates in a house in Yanille that has a piano."] = {},
  ["Search the crates in Canifis."] = {},
  ["Search the crates in Draynor Manor."] = {},
  ["Search the crates in East Ardougne's general store"] = {},
  ["Search the crates in Horvik's armoury."] = {},
  ["Search the crates in the Barbarian Village helmet shop."] = {},
  ["Search the crates in the chicken coop in the farm north of Port Sarim."] = {},
  ["Search the crates in the house at the north end of East Ardougne Market."] = {},
  ["Search the crates in the Port Sarim Fishing shop."] = {},
  ["Search the crates in the yard of Citharede Abbey"] = {},
  ["Search the crates just outside the armour shop in East Ardougne."] = {},
  ["Search the crates near a cart in Varrock"] = {},
  ["Search the crates near the Lumbridge Market."] = {},
  ["Search the crates of Falador's general store"] = {},
  ["Search the crates outside the bank in the north of East Ardougne"] = {},
  ["Search the drawers above the shops in Varrock"] = {},
  ["Search the drawers found upstairs in the Westernmost Inn of East Ardougne"] = {},
  ["Search the drawers in a house in Catherby"] = {},
  ["Search the drawers in a house in Draynor Village"] = {},
  ["Search the drawers in Catherby's Archery shop"] = {},
  ["Search the drawers in Falador's chain mail shop."] = {},
  ["Search the drawers in Ivy's house in Taverley"] = {},
  ["Search the drawers in one of Gertrude's bedrooms"] = {},
  ["Search the drawers in the ground floor of a shop in Yanille"] = {},
  ["Search the drawers of Hild and Penda's house in Burthorpe"] = {},
  ["Search the drawers on the first floor of a building overlooking Ardougne Market"] = {},
  ["Search the drawers upstairs in Falador's shield shop"] = {},
  ["Search the drawers upstairs in the bank in the East of Varrock."] = {},
  ["Search through chests found in the upstairs of houses in eastern Falador."] = {},
  ["Search through some drawers in the upstairs of a house in Rimmington"] = {},
  ["Search upstairs in the houses of Seers' Village for some drawers."] = {},
  ["Speak to Arhein in Catherby."] = {},
  ["Speak to Doric, who lives north of Falador."] = {},
  ["Speak to Ellis in Al Kharid"] = {},
  ["Speak to Gaius in Burthorpe."] = {},
  ["Speak to Hans to solve the clue"] = {},
  ["Speak to Ned in Draynor Village"] = {},
  ["Speak to Sir Kay in Camelot Castle"] = {},
  ["Speak to the bartender of the Blue Moon Inn in Varrock"] = {},
  ["Speak to the Challenge Mistress in Burthorpe."] = {},
  ["Speak to the staff of Sinclair mansion"] = {},
  ["Talk to the bartender of the Rusty Anchor in Port Sarim."] = {},
  ["Talk to the Squire in the White Knights' castle in Falador."] = {},
  ["Talk to Zeke in Al Kharid."] = {},
  ["Speak to a referee."] = {},
  ["Speak to Brimstail."] = {},
  ["Speak to Donovan, the family handyman."] = {},
  ["Speak to Hajedy."] = {},
  ["Speak to Hazelmere."] = {},
  ["Speak to Kangai Mau."] = {},
  ["Speak to Roavar."] = {},
  ["Speak to Ulizius."] = {},
  ["A view of the city from high above. I can hear their prayers below."] = {},
  ["Being open to Chaos can raise your defences. It may also bring you closer to death. Take a moment to bottle this feeling."] = {},
  ["Catching only one shark. That don't impress me much."] = {},
  ["Charm me and I shall unlock. But be brave in the darkness."] = {},
  ["Corruption seeps from this stone but there are those who work to cleanse it. Lend your voice."] = {},
  ["Crossing the desert I met a crocodile. She gave me a dazzling smile but she had something in her teeth."] = {},
  ["Ernie once mentioned to me a secret to improve my cooking. His idea was strong but I went the extra mile."] = {},
  ["Head protection is never a bad thing. Make it from rune for the best chance of survival."] = {},
  ["I have all the ingredients for soup but sometimes a simple meal tastes the best."] = {},
  ["In a station of power someone requires assistance. Do a good deed to spread some happiness."] = {},
  ["I once met a man returning from market. He showed me the spoils of his day. It's precious to see what people pay for."] = {},
  ["I once met an ancient warrior who told me tales of his adventures. His eyes lit up as he spoke."] = {},
  ["Keeping all your gold together. That's a good idea. It shall be mine."] = {},
  ["Magical energy floats unleashed. The fluid of life that flows through us all. Span the gap to capture this energy."] = {},
  ["Round and round we go, burning, burning all aglow."] = {},
  ["Rowdy Unruly Boisterous I am pie."] = {},
  ["Rumours of a great shark continue to spread. Catch me one and I will be fed."] = {},
  ["Stare into the flames for long enough and you may see something you didn't realise was there."] = {},
  ["Take the journey to a distant mining site. Become a blight to your foes."] = {},
  ["The crystals tempt most however, there are other riches to gain for the quick-fingered."] = {},
  ["The God of Order requires a sacrifice of strength but in return restores me. If only we could keep that feeling in his absence."] = {},
  ["The spell struck me in the chest. Perhaps if I had worn armour today. Black looks better than red."] = {},
  ["There are those who prove themselves and become a beacon of light in the darkness. Come to the crystal city and become that figure."] = {},
  ["There is a temple where there are rivers of red. Bind the magic to get ahead."] = {},
  ["Those things I once held dear continue to fade. I look upon her face and barely know who she is. But her eyes... They are still so radiant."] = {},
  ["When I encountered this individual, she had more rings than any I had seen before."] = {},
  ["Where there is Light there is also Death. Should you contain this you may progress."] = {},
  ["This anagram reveals who to speak to next: They seek spirits O EASTERN WISHES"] = {},
  ["This anagram reveals who to speak to next: In his youth, this adventurer was a WINSOME LAD"] = {},
  ["This anagram reveals who to speak to next: If distracted from their work AH; WET ARM"] = {},
  ["This anagram reveals who to speak to next: Young but stylish PIN HEIR ALL IN PLACE"] = {},
  ["This anagram reveals who to speak to next: With her age, it's no surprise to HEAR A LADY RANT"] = {},
  ["This anagram reveals who to speak to next: He claimed to be a human scholar but I SAW THE LIE"] = {},
  ["This anagram reveals who to speak to next: The cabbage diet must work because he has A PURE GLOW"] = {},
  ["This anagram reveals who to speak to next: Master of the elements, he may REIGN US IF IMMORTAL"] = {},
  ["This anagram reveals who to speak to next: His job leaves him kind of HATED"] = {},
  ["This anagram reveals who to speak to next: An exile that isn't wholly free WE IRK OVER NAMESAKE"] = {},
  ["This anagram reveals who to speak to next: Age allows a new perspective in this vital place TABOO RISES SHYLY"] = {},
  ["This anagram reveals who to speak to next: This lady wants me to find ancient scrolls ERGO I DIG CLAY"] = {},
  ["This anagram reveals who to speak to next: He often preaches of QUIT THY BRINE RAT ROLL"] = {},
}

-- all characters in this font are 30 pixels high, and these are row 20 (zero-indexed) from each one.
-- row 20 was chosen because it's the most distinctive row of pixels, having only one collision.
-- notably missing entries are 'X', which doesn't feature in any text clue, and 'd' and 'q', which have the exact same 20th row.
local chars = {
  L = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x77\xff\xff\xff\x77\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x22\xff\xff\xff\x22\x00\x00\x01\x00\x00\x00\x01\x00",
  K = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xcc\xff\xff\xff\xcc\xff\xff\xff\x99\xff\xff\xff\x99\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  J = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\x22\xff\xff\xff\x22\xff\xff\xff\x22\xff\xff\xff\x22\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\xbb\x00\x00\x01\x00\x00\x00\x01\x00",
  I = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x66\xff\xff\xff\x66\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  H = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44",
  G = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x11\xff\xff\xff\x11\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x77\xff\xff\xff\x77\xff\xff\xff\xee\xff\xff\xff\xee\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\x00\x00\x01\x00",
  F = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  E = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x77\xff\xff\xff\x77\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x11\xff\xff\xff\x11\x00\x00\x01\x00\x00\x00\x01\x00",
  D = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x77\xff\xff\xff\x77\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x55\xff\xff\xff\x55\xff\xff\xff\xcc\xff\xff\xff\xcc\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\x11\xff\xff\xff\x11\x00\x00\x01\x00\x00\x00\x01\x00",
  C = "\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xcc\xff\xff\xff\xcc\xff\xff\xff\xcc\xff\xff\xff\xcc\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\x88\xff\xff\xff\x88\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x33\xff\xff\xff\x33",
  B = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x77\xff\xff\xff\x77\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x99\xff\xff\xff\x99\xff\xff\xff\xee\xff\xff\xff\xee\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  A = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x99\xff\xff\xff\x99\xff\xff\xff\xcc\xff\xff\xff\xcc\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xaa\xff\xff\xff\xaa\xff\xff\xff\xbb\xff\xff\xff\xbb\x00\x00\x01\x00\x00\x00\x01\x00",
  Z = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x33\xff\xff\xff\x33\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  Y = "\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  W = "\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x11\xff\xff\xff\x11\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x11\xff\xff\xff\x11\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  V = "\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x22\xff\xff\xff\x22\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\xff\xff\xff\x22\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  U = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x66\xff\xff\xff\x66\xff\xff\xff\xee\xff\xff\xff\xee\xff\xff\xff\x66\xff\xff\xff\x66\xff\xff\xff\x11\xff\xff\xff\x11\xff\xff\xff\x11\xff\xff\xff\x11\xff\xff\xff\x66\xff\xff\xff\x66\xff\xff\xff\xee\xff\xff\xff\xee\xff\xff\xff\x66\xff\xff\xff\x66\x00\x00\x01\x00\x00\x00\x01\x00",
  T = "\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  S = "\xff\xff\xff\x22\xff\xff\xff\x22\xff\xff\xff\xee\xff\xff\xff\xee\xff\xff\xff\x66\xff\xff\xff\x66\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x88\xff\xff\xff\x88\xff\xff\xff\xee\xff\xff\xff\xee\x00\x00\x01\x00\x00\x00\x01\x00",
  R = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x66\xff\xff\xff\x66\xff\xff\xff\xee\xff\xff\xff\xee\xff\xff\xff\x11\xff\xff\xff\x11\x00\x00\x01\x00\x00\x00\x01\x00",
  Q = "\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xcc\xff\xff\xff\xcc\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\x11\xff\xff\xff\x11\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00",
  P = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  O = "\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xcc\xff\xff\xff\xcc\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\xaa\xff\xff\xff\xaa\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  N = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00",
  M = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x55\xff\xff\xff\x55\xff\xff\xff\xee\xff\xff\xff\xee\x00\x00\x01\x00\x00\x00\x01\x00",
  l = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x77\xff\xff\xff\x77\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  k = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x11\xff\xff\xff\x11\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\x77\xff\xff\xff\x77\x00\x00\x01\x00\x00\x00\x01\x00",
  j = "\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00",
  i = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x66\xff\xff\xff\x66\x00\x00\x01\x00\x00\x00\x01\x00",
  h = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00",
  g = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\xaa\xff\xff\xff\xaa\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x88\xff\xff\xff\x88\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00",
  f = "\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  e = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x99\xff\xff\xff\x99\xff\xff\xff\xcc\xff\xff\xff\xcc\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x55\xff\xff\xff\x55\xff\xff\xff\x77\xff\xff\xff\x77\x00\x00\x01\x00\x00\x00\x01\x00",
  c = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x88\xff\xff\xff\x88\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\x55\xff\xff\xff\x55\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x66\xff\xff\xff\x66\xff\xff\xff\xcc\xff\xff\xff\xcc\x00\x00\x01\x00\x00\x00\x01\x00",
  b = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\x22\xff\xff\xff\x22\xff\xff\xff\x22\xff\xff\xff\x22\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\xaa\xff\xff\xff\xaa\x00\x00\x01\x00\x00\x00\x01\x00",
  a = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x77\xff\xff\xff\x77\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\xcc\xff\xff\xff\xcc\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\x00\x00\x01\x00",
  z = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x88\xff\xff\xff\x88\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\x22\xff\xff\xff\x22\x00\x00\x01\x00\x00\x00\x01\x00",
  y = "\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xee\xff\xff\xff\xee\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x77\xff\xff\xff\x77\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  x = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x22\xff\xff\xff\x22\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\xff\xff\xff\x22\x00\x00\x01\x00\x00\x00\x01\x00",
  w = "\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x88\xff\xff\xff\x88\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  v = "\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x11\xff\xff\xff\x11\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x55\xff\xff\xff\x55\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  u = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xee\xff\xff\xff\xee\xff\xff\xff\x88\xff\xff\xff\x88\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x55\xff\xff\xff\x55\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00",
  t = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\x88\xff\xff\xff\x88\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  s = "\xff\xff\xff\x22\xff\xff\xff\x22\xff\xff\xff\x99\xff\xff\xff\x99\xff\xff\xff\x22\xff\xff\xff\x22\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\xff\xff\xff\x22",
  r = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  p = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\x22\xff\xff\xff\x22\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\xaa\xff\xff\xff\xaa\x00\x00\x01\x00\x00\x00\x01\x00",
  o = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x77\xff\xff\xff\x77\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x55\xff\xff\xff\x55\xff\xff\xff\xee\xff\xff\xff\xee\xff\xff\xff\x55\xff\xff\xff\x55\x00\x00\x01\x00\x00\x00\x01\x00",
  n = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44",
  m = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44",
  ["."] = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x66\xff\xff\xff\x66\xff\xff\xff\x22\xff\xff\xff\x22\x00\x00\x01\x00\x00\x00\x01\x00",
  ["-"] = "\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  [","] = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x66\xff\xff\xff\x66\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\x00\x00\x01\x00",
  ["'"] = "\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  ["!"] = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x77\xff\xff\xff\x77\xff\xff\xff\x11\xff\xff\xff\x11\x00\x00\x01\x00\x00\x00\x01\x00",
  [";"] = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x22\xff\xff\xff\x22\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x11\xff\xff\xff\x11",
  [":"] = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44",
  ["9"] = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x11\xff\xff\xff\x11\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\xcc\xff\xff\xff\xcc\xff\xff\xff\xcc\xff\xff\xff\xcc\xff\xff\xff\x11\xff\xff\xff\x11\x00\x00\x01\x00\x00\x00\x01\x00",
  ["8"] = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x99\xff\xff\xff\x99\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\x55\xff\xff\xff\x55\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x55\xff\xff\xff\x55\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\x99\xff\xff\xff\x99\x00\x00\x01\x00\x00\x00\x01\x00",
  ["7"] = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x11\xff\xff\xff\x11\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  ["6"] = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x88\xff\xff\xff\x88\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\xdd\xff\xff\xff\xdd\xff\xff\xff\x99\xff\xff\xff\x99\x00\x00\x01\x00\x00\x00\x01\x00",
  ["5"] = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x99\xff\xff\xff\x99\xff\xff\xff\x99\xff\xff\xff\x99\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\xbb\x00\x00\x01\x00\x00\x00\x01\x00",
  ["4"] = "\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x66\xff\xff\xff\x66\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00",
  ["3"] = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\xaa\xff\xff\xff\xaa\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\xbb\xff\xff\xff\xbb\x00\x00\x01\x00\x00\x00\x01\x00",
  ["2"] = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00",
  ["1"] = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x33\xff\xff\xff\x33\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x77\xff\xff\xff\x77\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00",
  ["0"] = "\x00\x00\x01\x00\x00\x00\x01\x00\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x66\xff\xff\xff\x66\xff\xff\xff\x44\xff\xff\xff\x44\xff\xff\xff\x66\xff\xff\xff\x66\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x44\xff\xff\xff\x44\x00\x00\x01\x00\x00\x00\x01\x00",
}
local charrow = 20
local charheight = 30

local function orderrecursive (input)
  local inputcount = 0
  for _, _ in pairs(input) do inputcount = inputcount + 1 end

  -- if there's exactly one input, then there's no need to find any distinctions
  if inputcount == 1 then
    local _, val = next(input)
    return {exact = true, value = val}
  end
 
  -- find the most distinctive byte
  local dindex = nil
  local dcount = 0
  local i = 1
  while true do
    local distinctbytes = {}
    local count = 0
    for key, val in pairs(input) do
      if i > #key then goto c1 end
      local byte = string.sub(key, i, i)
      local index = chars[byte] and byte or 0
      local b = distinctbytes[index]
      if not b then
        distinctbytes[index] = 1
        count = count + 1
      else
        distinctbytes[index] = b + 1
      end
    end
    if count > dcount then
      dindex = i
      dcount = count
      if count == inputcount then goto c1 end
    end
    i = i + 1
  end
  ::c1::
 
  -- handle any invalid cases
  if dcount <= 1 then return nil end
 
  -- make a table of each byte that may be found at this position in the string.
  -- each value will be passed recursively to this function
  local bytes = {}
  for key, val in pairs(input) do
    local byte = string.sub(key, dindex, dindex)
    local index = chars[byte] or 0
    local t = bytes[index]
    if not t then
      bytes[index] = {[key] = val}
    else
      t[key] = val
    end
    ::continue::
  end
 
  -- map these values to a table that we can return
  local ret = {}
  for key, val in pairs(bytes) do
    local v = orderrecursive(val)
    if not v then return nil end
    ret[key] = v
  end
  return {exact = false, index = dindex, value = ret}
end
 
return {
  get = function (bolt)
    -- remove non-string keys, and remove space characters from strings
    local input = {}
    for key, val in pairs(clues) do
      if type(key) ~= "string" then goto continue end
      val.text = key
      input[string.gsub(key, "%s", "")] = val
      ::continue::
    end
    
    local data = orderrecursive(input)
    return {
      data = data,

      -- try to resolve a render2d event to a solution object from the "clues" table
      lookup = function (this, event, backgroundindex)
        local vertexcount = event:vertexcount()
        local verticesperimage = event:verticesperimage()

        local match = this.data
        while true do
          if match.exact then return match.value end
          local index = backgroundindex + (match.index * verticesperimage)
          if vertexcount < index then return nil end
          local ax, ay, aw, ah, _, _ = event:vertexatlasdetails(index)
          if ah ~= charheight then return nil end
          
          local m = match.value[event:texturedata(ax, ay + charrow, aw * 4)]
          if m then
            match = m
          else
            match = match.value[0]
            if not match then return nil end
          end
        end
      end,
    }
  end
}
