+++
date = "2018-06-22"
rss = "Every time when I hear about upcoming elections, I imagine a future where I can vote from anywhere for officials who truly represent our state's interests. However, the trust issues inherent in conventional centralized or blockchain-based electronic voting systems quickly dampen this dream. Despite these challenges, I believe trust concerns can be overcome and have embarked on the intellectual challenge of designing a solution based on modern cryptographic algorithms."
tags = ["evote", "invisible"]
+++

# Some thoughts on electronic voting

Sometimes when I hear about new upcomming elections I dream that in future I could vote from my home or abroad for officials who would represent best the interests of our state. But this dream quickly becomes spoiled into nightmare by issues of trust such system could bring in if implemented into straighforward way with a central server or as a blockchain network (as it could suffer 51% attack which now becomes regularity). However in spite of this setting I believe that the issues of trust can be designed away and so I started this intelectual challenge as diletant assuming that all new cryptographic algorithms available are safe for production use.

The requrements more or less for an ideal electronic voting scheeme habve been known for a long time namelly:

- Anonimity. No one being able to recognize the correlations between bailouts and voters (sex, age, color whcih could be used for developing marketing strategies for elelctions, for public shaming and for affecting a free will).
- Legitimacy. Only and all citizens can vote.
- Uniqnuess. Legitimate voter could vote only once.
- Verifibality. Voter can check his vote to be counted corectly
- Mobility. Voting form anywhere.
- Oppennness and transparency. Citizens are able to participate in the counting of the votes. A critical amount of citizens are able to understand the essesntials of voting mechanism and are able to look and experiment with the election code.
- Security. The cryptographic methods used are safe from hacks and brute force hacks.
- Non-bribery and coercion in the voting process. 

The last point is rather difficult to achieve with electronic voting, because a villan can closelly monitor the subject who he wants to coerce or bribe. However what electronice voting can do is to prevent anonymous bribing being able to know the choice of the voter from voters given receipt. From theese requiremnts also follows that Estonian electronic eections are not trustworthy or are trusted on a good will of the company/admin maintaining the system. 

A real inspiration came whne I came accross Monero cryptocurency. The sucess of it, but not for the benefit of all society, is practival use for drug dealers, human trafficing and everything else you might find in darknet. Basically supper dark, ilegal stufff but intriguingly at the same time transparent and available for everyone to participate in the network. So ho does it comes that merchants feel safe from police behind this cryptocurency? That's how I found about universal ring signatures.

An ordinary ring signature is one where a person with his secret private key encrypts message (usually it is a hash) and then serves message with this encryption as a valid signature which only he/she could have made. Then to veryfy the signateure the other person is checking for public key of the the signer, perhaps with help of authority, and executes verification algorithm whcih decrypts encrypted message with public key and compares the result with given message if they do concide. If such system is used for voting a drawback is that administration of such a system vould have to give a privelegies for admin to see bwho have voted for whom and not being able to be open and anonymous at the same time. And that is where ring signature shines.

The ring signature scheme works similarly as ordinarly ring signature scheme except that also public keys of all group members are needed uppon signing on whose behalf the signature would be made. Although each memebr of the group uses his own private key the signature is not traceable to a paricular memeber. Thus this method could also be used to leak a legit secret on behalf of the group. The verification algorithmas expected takes all public keys of the group and the testable signature. When person tries to sign the message but is outside the group the algorithm would test it to be invalid. Also a person is limited to a one unique signature for a message which naturally solves double voting problem. 

## The Design

The fist step for society is to establis a valid authority who would give each citizen ID card where private key sits and ring signature algorithm would be executed. The authority would have a responsibility to publish all valid public keys together with names, birth dates, postal indexes, etc for citiziens to have an opportunity to test validity of the given identitites (another benefit would be that vould protect individuals by comunities when secret would be leaked). Then when ellections arises it publishes list of parties with corresponding messages which are needed to be signed to make a corresponding vote like "PartyA2018", "PartyB2018", and so on. 

The citizen would choose their preferences and sign coreponding message with their ID card by uploading to it a message and all public keys in the group. To protect from a malcius use a PIN code would be asked before the signature (which would also be saved on the card) would be given. Then the voter delivers his vote either in a printed format by a mail, over HTTPS conection with a central election server or with other means. Importantly in the delivery process anonimity is preserved. Then the voter would be responsible to check that his vote is on the central server and have been correctly counted.

When vote would have ended the authority would anounce the elecetion results which would be already counted by citizens and check if they have happened in trustworthy fashion. 

## Afterthought

Real life is more complex for the system to work. First of all ring signatures are demanding to generate and the length of it grows with number of members in the grpup. Worms and viruses could use a correct voting mechanims to get the desired vote in the elections. The scheme above also does not discuss a way to vote also for a paricular members inthe party.

To deal with the first issue the authority could randomly group all state population in the groups who are voting together. THe vote would still remain anonymous because if it were not theb a vote made in a small election place is also not anonymous as they post their election results. The actual group size however would depend on how we are interepreting anonimity.

The second can be delat if we allow users to cancell their vote if they had detected a malcius behaviour against their interests. For that to work the signet message also needs to be stored on the ID card which would stay there and would be possible to see in authorized hardware (to avoid easy bribery). Also the user would be able to check if the message which he sends corresponds to a party he/she would want to vote for. 

To vote for specific people the messafge is linked together with the vothe which would produce a desired result.
