#!/usr/bin/env bash

declare -a artists=(
"30 Seconds To Mars"
"A-Ha"
"ABBA"
"Above & Beyond"
"AC_DC"
"Ace of Base"
"Adele"
"Alanis Morissette"
"Alex M.O.R.P.H. & Paul Van Dyk"
"Alex Parks"
"Alexander O'Neal"
"Alexandra Stan"
"Alisha's Attic"
"Alison Krauss"
"Amalia Rodrigues"
"Amy Winehouse"
"Andrew Bayer"
"Anggun"
"Annie Lennox"
"Ariana Grande"
"Arcade Fire"
"Armin van Buuren"
"Arthur Conley"
"Athlete"
"Aurora"
"B-Witched"
"Bad Company"
"Band of Horses"
"Barenaked Ladies"
"Bat For Lashes"
"Bee Gees"
"Belinda Carlisle"
"Ben & Jason"
"Ben Folds"
"Betty Who"
"Beyoncé"
"Big Audio Dynamite"
"Billie Holiday"
"Billy Joel"
"Birdy"
"Bjorn Akesson"
"Blackstreet"
"Blondie"
"Blur"
"Bob Marley and the Wailers"
"Bob Seger & The Silver Bullet Band"
"Bomb The Bass"
"Bon Jovi"
"Brandon Flowers"
"Bruce Hornsby & The Range"
"Bruce Springsteen"
"Bryan Ferry"
"Buena Vista Social Club"
"Calvin Harris"
"Cara Dillon"
"Carole King"
"Cass Fox"
"Catatonia"
"Charli XCX"
"Chase & Status"
"Cher"
"Chicane"
"Choir of Young Believers"
"Christina Aguilera"
"Christine and the Queens"
"CHVRCHES"
"Clean Bandit"
"Cocovan"
"Coldplay"
"Cosmic Gate"
"Corinne Bailey Rae"
"Creedence Clearwater Revival"
"Crowded House"
"Crystal Bowersox"
"D.Kay & Epsilon"
"Dagny"
"Daft Punk"
"Daryl Hall & John Oates"
"Daughter"
"Dave Matthews Band"
"David Bowie"
"David Mead"
"Deacon Blue"
"deadmau5"
"Def Leppard"
"Delta Goodrem"
"Depeche Mode"
"Dire Straits"
"Divine Inspiration"
"Don Henley"
"Donna Lewis"
"Doobie Brothers"
"Dragonette"
"Drive-By Truckers"
"Duran Duran"
"Eddi Reader"
"Elbow"
"Electric Light Orchestra"
"Electric Six"
"Ella Fitzgerald"
"Ella Henderson"
"Ellen And The Escapades"
"Eliza Carthy"
"Ellie Goulding"
"Elton John"
"Elvis Costello"
"Elvis Presley"
"Enigma"
"Erasure"
"Eric Clapton"
"Eve 6"
"Everything Everything"
"Fabiana Palladino"
"Faithless"
"Fall Out Boy"
"Father John Misty"
"Feeder"
"Feist"
"Fergie"
"First Aid Kit"
"Fleet Foxes"
"Fleetwood Mac"
"Flight Of The Conchords"
"Florence + the Machine"
"Foo Fighters"
"Fragma"
"Frank Sinatra"
"Fredericks, Goldman, Jones"
"Frenship"
"Garbage"
"Garth Brooks"
"Ghostpoet"
"Gloria Estefan"
"Go West"
"Goldfrapp"
"Goo Goo Dolls"
"Gorillaz"
"Gotan Project"
"Groove Armada"
"Gun"
"Gwen Stefani"
"Gypsy & the Cat"
"Haim"
"Headway"
"Heather Nova"
"Honeyz"
"Hot 8 Brass Band"
"Hot Rats"
"I Blame Coco"
"Icona Pop"
"Iggy Azalea"
"Imelda May"
"Inna"
"Indiana"
"INXS"
"Jackie Oates"
"Jaki Graham"
"James"
"Janet Devlin"
"Janis Joplin"
"Jean-Michel Jarre"
"Jeff Beck"
"Jet"
"Jewel"
"Jessie J"
"Jimi Hendrix"
"John Cooper Clarke"
"John Moreland"
"John 00 Fleming"
"Joni Mitchell"
"Josefin Öhrn + The Liberation"
"Juliet Turner"
"Junior Senior"
"Justin Timberlake"
"Kasabian"
"Kate Bush"
"Kate Rusby"
"Katy B"
"Katy Perry"
"Keane"
"Kid Wave"
"Kids In Glass Houses"
"Kimbra"
"King Creosote"
"Kings Of Leon"
"Kirsty MacColl"
"Kitten"
"Kool & The Gang"
"KT Tunstall"
"Kylie Minogue"
"Lady Gaga"
"Ladyhawke"
"Lana Del Rey"
"Lapsley"
"Laura Branigan"
"Léa Ivanne"
"Len"
"Lily Allen"
"Lindsay Mac"
"Lissie"
"Little Mix"
"Lloyd Cole"
"London Grammar"
"Lorde"
"Lost In The Fog"
"Luciana"
"Lucie Silvas"
"M83"
"Matuki"
"M.I.A."
"Macy Gray"
"Madeleine Peyroux"
"Madonna"
"Malcolm McLaren"
"Manic Street Preachers"
"Manu Chao"
"Marc Cohn"
"Maria Nayler"
"Mariah Carey"
"Marina and The Diamonds"
"Mark Ronson"
"Martha Wainwright"
"Martina McBride"
"Mary Chapin Carpenter"
"Mat Zo"
"matchbox twenty"
"Maximo Park"
"Meat Loaf"
"Megan Henwood"
"Meghan Trainor"
"Meja"
"Melody Gardot"
"Meredith Brooks"
"Michael Jackson"
"Mika"
"Morcheeba"
"Mott The Hoople"
"Muse"
"My Baby"
"Mylo"
"Naimee Coleman"
"Natalie Imbruglia"
"Nelly Furtado"
"New Order"
"Newton Faulkner"
"Nitin Sawhney"
"Noa"
"Noah And The Whale"
"Norah Jones"
"Oh Land"
"Orson"
"Paul Carrack"
"Paul McCartney"
"Paul Simon"
"Paula Abdul"
"Pet Shop Boys"
"Peter Gabriel"
"Petite Meller"
"Pharrell Williams"
"Picture House"
"Plumb"
"Prefab Sprout"
"Prince"
"Professor Elemental"
"Public Service Broadcasting"
"Pulp"
"Pumarosa"
"Queen"
"R.E.M."
"R¢is¡n Murphy"
"Radiohead"
"Razorlight"
"Roachford"
"Rob Thomas"
"Robbie Williams"
"Robyn"
"Roisin Murphy"
"Roxette"
"Roy Ayers"
"Royksopp"
"Royworld"
"Rufus Wainwright"
"Rumer"
"Ryan Adams"
"Samim"
"Santigold"
"Sara Bareilles"
"Sara Taveres"
"Sarah Jarosz"
"Scarlet"
"School Of Seven Bells"
"Scissor Sisters"
"Shakespear's Sister"
"Shakira"
"Sharon Shannon"
"Shawn Colvin"
"Sheryl Crow"
"Show of Hands"
"Sia"
"Sigala"
"Simple Minds"
"Siobhan Donaghy"
"Sleeper"
"Smoke City"
"Smoke Fairies"
"Snow Patrol"
"Sophie B. Hawkins"
"Sophie Ellis-Bextor"
"Squeeze"
"Squirrel Nut Zippers"
"Steely Dan"
"Steps"
"Steve Winwood"
"Sting"
"Sugababes"
"Sugar"
"Sugarland"
"Supertramp"
"Super8 & Tab"
"Suzanne Vega"
"T'Pau"
"Take That"
"Talking Heads"
"Tanita Tikaram"
"Taylor Swift"
"The Alan Parsons Project"
"The Bangles"
"The Beatles"
"The Carpenters"
"The Clash"
"The Cooper Temple Clause"
"The Corrs"
"The Cure"
"The Darkness"
"The Divine Comedy"
"The Eagles"
"The Feeling"
"The Go! Team"
"The Gossip"
"The Hold Steady"
"The Hot Rats"
"The Imagined Village"
"The Isley Brothers"
"The Killers"
"The Kinks"
"The Mamas & the Papas"
"The Mighty Mighty Bosstones"
"The O'Jays"
"The Pretty Reckless"
"The Rolling Stones"
"The Script"
"The Seekers"
"The Strokes"
"The Vaccines"
"The White Stripes"
"The Who"
"Then Jerico"
"Thievery Corporation"
"Thomas Dolby"
"Thorns"
"Tina Arena"
"Tina Turner"
"Tom Petty"
"Tom Petty & The Heartbreakers"
"Tom Tom Club"
"Tom Waits"
"Tori Amos"
"Toto"
"Tracy Chapman"
"Train"
"Turin Brakes"
"Two Door Cinema Club"
"U2"
"Ulrich Schnauss"
"Various"
"Voice of the Beehive"
"VV Brown"
"Ward Thomas"
"Warren Zevon"
"Wham!"
"Wheat"
"Whitney Houston"
"Will Young"
"Wye Oak"
"X&Y"
"Yazoo"
"Zlata Ognevich"
"ZZ Top"
)

start_path="/Volumes/Kiruna"
for artist in "${artists[@]}"
do
	initial=${artist:0:1}
	intital=$(echo $initial | tr 'a-z' 'A-Z') 
	mkdir -p "$start_path/$initial"
	rsync -r --progress --delete --delete-excluded --exclude '*.ini' --exclude '*.jpg' --exclude '*.wav' --exclude '*.wma' --exclude '*.db' "/volumes/music/Music/$artist/" "$start_path/$initial/$artist"
done
