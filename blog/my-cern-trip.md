+++
date = "2017-02-11"
tags = ["CERN", "LV", "research"]
title = "My CERN internship"
rss = "For two months this summer, I was part of the CERN summer student program. Upon arrival, my supervisor tasked me with exploring possibilities to capture or push the boundaries of one of the supersymmetry particles in the ATLAS experiment, following the major CERN breakthroughs. As there are also opportunities for you to apply this year I decided to share a little bit of my experience being there."
+++

# Mans CERN piedzīvojums

Divus mēnešus šajā vasarā es biju CERN vasaras studentu programmas ietvaros (CERN summer students programme). Mani tur sagaidīja darba vadītājs ar uzdevumu izpētīt iespējas noķert vai pavirzīt zināmās robežas vienai no supersimetrijas daļiņām ATLAS eksperimentā pēc lielajiem CERN jauninājumiem. Arī šogad ir iespējas pieteikties šai apmaiņas programmai, tādēļ nolēmu šo iespēju pareklamēt, izstāstot savu stāstu. Tātad, kas mani aizveda uz CERN...

Stāsts sākās ar apmaiņas studijām Umea universitātē, kur cerēju apgūt vairāk teorētiska rakstura kursus. Viens no šiem kursiem bija kvantu lauku teorija, kuru izvēlējos par spīti manai kvantu mehānikas nezināšanai (ko nevienam tur neteicu :)). Lai arī kurss bija ļoti nopietns, kas beidzās man ar rakstisku 6h eksāmenu svētdienā, tas mani aizrāva ar to, kā no dažām bērnam zināmām patiesībām (varbūt ne tik vienkāršām) varam nonākt pie Dīraka vienādojuma, izskaidrot spontāno sabrukšanu un nonākt līdz lagranžiāna kvantu elektrodinamikai. Šo izziņas procesu gribēju vēl paturpināt un zināšanām atrast pielietojumu. Par laimi Jevgēņijs Kločāns iepriekš bija pastāstījis par CERN vasaras skolu.

Pirms Žeņa atgriezās no Skotijas, viņš apmeklēja CERN studentu vasaras skolu un atgriezās Latvijā ar nelielu stāstu par to, kā viņam tur gāja. Iepriekš par CERN biju dzirdējis jau no skolas laikiem, kad lasīju
Ilustrēto Zinātni par ziliem elektroniem un sarkaniem protoniem, paralēliem visumiem, supersimetriju, tumšo matēriju, utt. Bet nebiju pat aizdomājies, ka mani, kā studentu, tur kādam varētu arī vajadzēt. Tā savas zinātkāres vadīts divus gadus pēc Žeņas prezentācijas pieteicos CERN vasaras skolai.

## Par Zinātni CERN

Lielais hadronu kolaideris (Large Hadron Collider) viens otram pretī triec protonus ar 7 TeV kinētisko enerģiju katram. Sadursmes var būt elastīgas un neelastīgas. Otrajās protoni izšķīst par visdažādākajām daļiņām diezgan patvaļīgā veidā, ko raksturo varbūtību sadalījums par to, cik un kādas daļiņas rodas procesā, un kāds tām ir varbūtību sadalījums pa leņķiem, impulsiem. Tie arī ir eksperimentālie dati, kurus vāc detektori CMS, ATLAS, LHCb, un arī svina protona sadursmes detektorā ALICE.

Kad ievāktā statistika ir pietiekama, ko mēra femtobarnos jeb fb, to izmanto, lai testētu elementārdaļiņu standartmodeli vai kādu citu teoriju, kas to paplašina. Piemēram CERNā testē hipotēzi par galīgu elektrona izmēru, par supersimetrijas esamību un citas. Visas šīs teorijas ieskaitot standartmodeli ir pierakstītas lagražiāņu formā, kuru pareizību tad arī testē mērot to parametru vērtības.

Lai lagranžiāni salīdzinātu ar eksperimentu, veido ļoti sarežģītas simulācijas sadursmes procesiem. Vispirms, ir jāizvēlas uz kādu processu skatīties (signāls), kuru nosaka atbilstošais lagranžiāņa loceklis ar
nezināmo koeficientu. Nākamais solis ir izdomāt, kādi procesi traucē ieraudzīt signālu (fons). Un visbeidzot ir jāpalaiž attiecīgās simulācijas ar izvēlētu algoritmu. Tā iegūstam varbūtību sadalījumus, kuros nav ņemta vērā detektora ierobežotā izšķirtspēja.

Pēc simulāciju veikšanas, ko veica mans CERN vadītājs un vēl divi kolēģi, es veicu datu analīzi. No sākuma man bija jāveic pliko sadursmju izsmērēšana atbilstoši vienkāršotam detektora modelim, jo pilnas detektora simulācijas ir ļoti dārgas. No tām man bija jāapskata dažādi kritēriji, pēc kuriem varētu iegūt pēc iespējas vairāk signāla un mazāk fonu, kas principā ir uzdevums par globālā maksimuma atrašanu.

## Mans uzdevums

Man bija uzticēts apskatīt vienu no daudzajiem supersimetrijas signāliem, tādēļ centos par šo teoriju ko vairāk arī uzzināt. Pirmais mans jautājums bija un vēl joprojām ir - kādēļ standartmodelis nevar būt
galīgā teorija, ja neskaita gravitācijas neiekļaušanu pie Planka enerģijām aptuveni 1016 TeV (LHC kolaiderī tagad sadursmes pie 14 TeV). Uz šo jautājumu šķiet, ka atbild dabiskuma princips (naturalness
principle), kuru savas nesaprašanas dēļ nekomentēšu, bet došu atsauci uz interesantu filozofiska tipa rakstu un pašu esenci video formā skati raksta beigās.

Viena no teorijām, kura šo problēmu (pliks standartmodelis ir nedabisks) atrisina, ir supersimetrija. Būtībā tā katrai zināmajai elementārdaļiņai standartmodelī pievieno superpartneri, kur neviena no tām šim nav bijusi noķerta. Tā arī ir nepieciešamība stīgu teorijai, kura paredz vispārīgo relativitātes teoriju, prasot attiecīgo simetriju no lagranžiāņa.

Zinot, kāda izskatās supersimetrijas Lagranža funkcija, ar simulāciju un eksperimentālo datu palīdzību var izslēgt, kādas nav jaunievesto elementārdaļiņu masas. Mana sajūta bija, ka tā tas varētu turpināties mūžīgi, tomēr par laimi tam ir ierobežojums no dabiskuma principa. Piemēram higgsino daļiņu masām vajadzētu būt mazākām par TeV, lai pati supersimetrija būtu dabiska, kuras ķeršanai es biju pieķēries ar vienu no tās signāliem.

## Gūtā pieredze

Ir fascinējoši, ka vari uzdot tādus jautājumus kā "cik liels ir elektrons?", "vai standartmodelis ir konsekvents savos pareģojumos?", testēt supersimetriju un citas teorijas tikai no LHC sadursmju datiem. Tomēr, tas ir diezgan algoritmisks process un eksperimentālajā fizikā (datu analīzē un citos) tādā vai šādā veidā mērķis ir iegūt maksimumu. Tad parasti raksti arī ir par to, kādos apstākļos un pie kādiem parametriem maksimums ir iegūts, kuri man šķita kā rakstīti pēc parauga. To kāds var uzskatīt arī par bonusu, jo vienas zināšanas datu analīzē der visām problēmām un eksperimentiem, citiem ir viegli saprast tavu darbu un tevi ar citiem vieno kopīgi mērķi.

Par spīti tam, ka uzdevums man CERNā bija iegūt maksimumu, es guvu ļoti vērtīgu pieredzi arī zinātnē. Tā ir vislabākā vieta, kur mācīties sadarboties, izprast kā Higsa bozons tika atklāts un atklājuma nozīmību, redzēt kā ar zinātni nodarbojās citur, izprast kā CERN organizē savu infrastruktūru, apgūt C++ programmēšanas valodu. Saskarsme ar to, kā lietas dara CERNā, deva man radošu impulsu, lai pārstrādātu savu simulācijas kodu, kas pēc tam bija efektīvs arī manām 3 nedēļu garajām simulācijām.

Bet vispatīkamākais bija satikt augsta ranga studentus no visām pasaules valstīm, no kuriem varēja smelties fizikas skaistumu un viņu pieredzi ar fiziku nodarbojoties māju zemēs. Piemēram, kāds japānis mājās bija iesaistīts fotona polarizācijas eksperimentā ar magnētisko lauku! Tāpat, tā ir labākā iespēja redzēt, kā neatkarīgi no savas nacionālās pārliecības mēs visi varējām sadarboties un sadraudzēties.

Tādēļ, ja šogad beigsi bakalauru vai maģistra pirmo vai otro gadu un ja tev ir interese par CERNā notiekošo, tad iesaku tev pašam to piedzīvot, [piesakoties CERN vasaras skolas programmā līdz 27.janvārim](http://jobs.web.cern.ch/join-us/studentships-summer-non-member-state-nationals). Brīvajā laikā tev būs iespēja apceļot Šveici, staigāt pa kalniem un pilsētām, ar vasaras studentiem spēlēt volejbolu un peldēt dzidrajā Ženēvas ezerā. Ja tev rodas kādi jautājumi vai gribi padomu, tad sūti e-pastu uz manu kasti `akels14@gmail.com`.

# Atsauces

- Porter Williams (2015) Naturalness, the autonomy of scales, and the 125 GeV Higgs. Studies in History and Philosophy of Modern Sciences.
- [Youtube par "dabiskuma principu"](https://www.youtube.com/watch?v=77Y5K5PM53Y)
- [Supersimetrijas argumenti](http://web.mit.edu/redingtn/www/netadv/specr/6/node2.html)
