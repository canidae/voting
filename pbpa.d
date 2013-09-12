import std.algorithm: sort;
import std.conv: to;
import std.stdio;
import std.string: stripLeft, stripRight, indexOf;

import rational;

class Party {
    string name;
    ulong seats; // seats assigned in upper apportionment
    bool excluded;

    this(string name) {
        this.name = name;
    }
}

class District {
    string name;
    ulong seats; // seats assigned in upper apportionment
    Vote[] votes;

    this(string name, ulong seats) {
        this.name = name;
        this.seats = seats;
    }
}

struct Vote {
    Party[] parties;
}

void main() {
    /* constants */
    immutable first_divisor = 1.0; // first divisor in modified sainte-lague, arguably not necessary.
    immutable seat_threshold = 1; // the minimum amount of seats a party must win
    auto percentage_threshold = Rational(1, 1000); // percentage of votes needed to win seats (value from 0.0 to 1.0)
    auto border_delta_percentage = Rational(1, 100); // how near the min/max multiplier we want to go. value must be greater than 0 and less than 1

    /* read file with election results */
    auto file = File("election_2013.txt");
    scope(exit)
        file.close();
    District readDistrict;
    Party[string] readParties;
    Party[] parties;
    District[] districts;
    ulong maxSeats;
    ulong maxVotes;
    foreach (inputLine; file.byLine) {
        string line = to!(string)(inputLine);
        if (stripRight(stripLeft(line)) == "") {
            readDistrict = null;
            continue; // empty line
        }
        auto delimPos = line.indexOf(",");
        if (delimPos == -1) {
            writefln("No comma in line '%s', can't parse file", line);
            return;
        }
        string text = line[0 .. delimPos];
        ulong value = to!(ulong)(line[delimPos + 1 .. $]);
        if (readDistrict is null) {
            /* first entry after an empty line is a district */
            readDistrict = new District(text, value);
            districts ~= readDistrict;
            maxSeats += value;
        } else {
            /* otherwise it's a party */
            Party readParty;
            if (text in readParties) {
                readParty = readParties[text];
            } else {
                readParty = new Party(text);
                readParties[text] = readParty;
                parties ~= readParty;
            }
            foreach (i; 0 .. value)
                readDistrict.votes ~= Vote([readParty]);
            maxVotes += value;
        }
    }

    /* tally district votes and reset counters */
    ulong[Party][District] districtPartyVotes;
    ulong[Party][District] districtPartySeats;
    ulong[Party] partyVotes;
    ulong[District] districtVotes;
    ulong voteCount;
    while (true) {
        voteCount = 0;
        foreach (party; parties)
            partyVotes[party] = 0;
        foreach (district; districts) {
            foreach (party; parties) {
                districtPartyVotes[district][party] = 0;
                party.seats = 0;
            }
            districtVotes[district] = 0;
            foreach (vote; district.votes) {
                foreach (party; vote.parties) {
                    if (party.excluded)
                        continue; // party did not receive enough votes and has been removed
                    ++districtPartyVotes[district][party];
                    ++partyVotes[party];
                    ++districtVotes[district];
                    ++voteCount;
                    break;
                }
            }
        }

        /* assign seats (upper apportionment) */
        foreach (seats; 0 .. maxSeats) {
            Party winner = parties[0];
            foreach (party; parties[1 .. $]) {
                if (partyVotes[winner] / (winner.seats == 0 ? first_divisor : 2 * winner.seats + 1) < partyVotes[party] / (party.seats == 0 ? first_divisor : 2 * party.seats + 1))
                    winner = party;
            }
            ++winner.seats;
            //writefln("Assigning seat to %s", winner.name);
        }
        Party loser;
        foreach (party; parties) {
            if (loser is null || partyVotes[party] < partyVotes[loser])
                loser = party;
        }
        if (loser !is null && (loser.seats < seat_threshold || Rational(partyVotes[loser], maxVotes) < percentage_threshold)) {
            loser.excluded = true;
            // remove from "parties" list too
            Party[] tmp;
            foreach (party; parties) {
                if (!party.excluded)
                    tmp ~= party;
            }
            parties = tmp;
            writefln("Party %s didn't reach all the election thresholds (%s of %s seats, %s of %s vote percentage) and is excluded from the election", loser.name, loser.seats, seat_threshold, cast(real) partyVotes[loser] * 100 / maxVotes, percentage_threshold * 100);
        } else {
            // all remaining parties received enough votes, upper apportionment is done, break loop
            break;
        }
    }

    /* lower apportionment */
    /* set initial multipliers */
    Rational[Party] partyMultipliers;
    Rational[District] districtMultipliers;
    foreach (party; parties)
        partyMultipliers[party] = Rational(1);
    foreach (district; districts)
        districtMultipliers[district] = Rational(district.seats, districtVotes[district]);

    /* assign initial seats in districts, which likely will be wrong, but corrected in later stages */
    foreach (district; districts) {
        foreach (party; parties)
            districtPartySeats[district][party] = cast(long) (districtPartyVotes[district][party] * partyMultipliers[party] * districtMultipliers[district] + Rational(1, 2));
    }

    /* correction stages */
    /* sum up party seats for parties & districts */
    ulong[Party] partySeats;
    ulong[District] districtSeats;
    ulong iterationCounter = 0;
    while (++iterationCounter < 100) {
        foreach (party; parties)
            partySeats[party] = 0;
        foreach (district; districts)
            districtSeats[district] = 0;
        foreach (party; parties) {
            foreach (district; districts) {
                districtSeats[district] += districtPartySeats[district][party];
                partySeats[party] += districtPartySeats[district][party];
            }
        }
        /* are we finished? */
        bool finished = true;
        foreach (party; parties) {
            finished = party.seats == partySeats[party];
            if (!finished)
                break;
        }
        if (finished) {
            foreach (district; districts) {
                finished = district.seats == districtSeats[district];
                if (!finished)
                    break;
            }
            if (finished)
                break; // we're done, break out of loop
        }

        /* check if seats are correctly apportioned */
        if (iterationCounter % 2 == 1) {
            /* modify party multipliers */
            writeln();
            writefln("Modifying multipliers for parties (round %s):", iterationCounter);
            foreach (party; parties) {
                if (party.seats == partySeats[party])
                    continue; // this party got the right amount of seats, no need to modify multiplier

                // find minMultiplier & maxMultiplier
                Rational multiplier;
                Rational multipliers[];
                foreach (district; districts) {
                    if (districtPartyVotes[district][party] == 0)
                        continue; // no votes in district
                    auto border = Rational(1, 2);
                    while (true) {
                        multiplier = border / (districtPartyVotes[district][party] * partyMultipliers[party] * districtMultipliers[district]);
                        long tmpSeats = 0;
                        foreach (tmpDistrict; districts)
                            tmpSeats += cast(long) (districtPartyVotes[tmpDistrict][party] * partyMultipliers[party] * districtMultipliers[tmpDistrict] * multiplier + Rational(1, 2));
                        //writefln("%s: %3s | %s (%s: %s)", border, tmpSeats, multiplier, district.name, districtPartySeats[district][party]);
                        if (tmpSeats > party.seats + 1)
                            break;
                        multipliers ~= multiplier;
                        ++border;
                    }
                }
                sort!("a < b")(multipliers);
                /*
                foreach (i, m; multipliers)
                    writefln("Multiplier for %2s seats: %s", i + 1, m);
                */
                auto minMultiplier = multipliers[party.seats - 1];
                auto maxMultiplier = multipliers[party.seats];

                /* this source: http://www.math.uni-augsburg.de/stochastik/pukelsheim/2008f.pdf
                   says that when increasing, you should use the highest possible multiplier.
                   other sources says use the average: http://www.uusikaupunki.fi/~olsalmi/vaalit/Biproportional_Elections.html
                   average is easier, because:
                   - minMultiplier may due to rounding errors result in party.seats - 1
                   - maxMultiplier may due to rounding errors result in party.seats, but we're expecting it to end in
                     party.seats + 1, and in that case we need to reduce it with "smallest possible value".
                   "smallest possible value" depends on the value of maxMultiplier.

                   for now, we're using average */

                //multiplier = minMultiplier < 1 ? minMultiplier : maxMultiplier - 0.0001; // TODO: if we're using highest possible multiplier we need to reduce it with smallest possible value (which is difficult)
                long denominator = cast(long) (1 / (maxMultiplier - minMultiplier)).ceil();
                long numerator = cast(long) (maxMultiplier * denominator);
                multiplier = Rational(numerator, denominator);
                if (multiplier < minMultiplier || multiplier >= maxMultiplier)
                    writefln("ERROR!!! multiplier is outside of range!"); // TODO: this may equal maxMultiplier, we must prevent that
                //Rational multiplierDelta = (maxMultiplier - minMultiplier) * border_delta_percentage;
                //multiplier = minMultiplier < 1 ? minMultiplier + multiplierDelta : maxMultiplier - multiplierDelta;
                //multiplier = (minMultiplier + maxMultiplier) / 2;
                writefln("Multiplier for %-7s: %s (%s/%s)", party.name, multiplier, minMultiplier, maxMultiplier);
                partyMultipliers[party] *= multiplier;
                foreach (district; districts)
                    districtPartySeats[district][party] = cast(long) (districtPartyVotes[district][party] * partyMultipliers[party] * districtMultipliers[district] + Rational(1, 2));
            }
        } else {
            /* modify district multipliers */
            writeln();
            writefln("Modifying multipliers for districts (round %s):", iterationCounter);
            foreach (district; districts) {
                if (district.seats == districtSeats[district])
                    continue; // this district got the right amount of seats, no need to modify multiplier

                // find minMultiplier & maxMultiplier
                Rational multiplier;
                Rational multipliers[];
                foreach (party; parties) {
                    if (districtPartyVotes[district][party] == 0)
                        continue; // no votes for party
                    auto border = Rational(1, 2);
                    while (true) {
                        multiplier = border / (districtPartyVotes[district][party] * partyMultipliers[party] * districtMultipliers[district]);
                        long tmpSeats = 0;
                        foreach (tmpParty; parties)
                            tmpSeats += cast(long) (districtPartyVotes[district][tmpParty] * partyMultipliers[tmpParty] * districtMultipliers[district] * multiplier + Rational(1, 2));
                        //writefln("%s: %3s | %s (%s: %s)", border, tmpSeats, multiplier, party.name, districtPartySeats[district][party]);
                        if (tmpSeats > district.seats + 1)
                            break;
                        multipliers ~= multiplier;
                        ++border;
                    }
                }
                sort!("a < b")(multipliers);
                /*
                foreach (i, m; multipliers)
                    writefln("Multiplier for %2s seats: %s", i + 1, m);
                */
                auto minMultiplier = multipliers[district.seats - 1];
                auto maxMultiplier = multipliers[district.seats];

                //multiplier = minMultiplier < 1 ? minMultiplier : maxMultiplier - 0.0001; // TODO: if we're using highest possible multiplier we need to reduce it with smallest possible value (which is difficult)
                long denominator = cast(long) (1 / (maxMultiplier - minMultiplier)).ceil();
                long numerator = cast(long) (maxMultiplier * denominator);
                multiplier = Rational(numerator, denominator);
                if (multiplier < minMultiplier || multiplier >= maxMultiplier)
                    writefln("ERROR!!! multiplier is outside of range!"); // TODO: this may equal maxMultiplier, we must prevent that
                //Rational multiplierDelta = (maxMultiplier - minMultiplier) * border_delta_percentage;
                //multiplier = minMultiplier < 1 ? minMultiplier + multiplierDelta : maxMultiplier - multiplierDelta;
                //multiplier = (minMultiplier + maxMultiplier) / 2;
                writefln("Multiplier for %-16s: %s (%s/%s)", district.name, multiplier, minMultiplier, maxMultiplier);
                districtMultipliers[district] *= multiplier;
                foreach (party; parties)
                    districtPartySeats[district][party] = cast(long) (districtPartyVotes[district][party] * partyMultipliers[party] * districtMultipliers[district] + Rational(1, 2));
            }
        }

        /* print result */
        writeln();
        write("                  ");
        foreach (party; parties)
            writef("| %13.13s ", party.name);
        writefln("| %7.7s", "Total");
        write("------------------");
        foreach (party; parties)
            write("+---------------");
        write("+---------");
        writeln();
        ulong totalSeatCount;
        foreach (district; districts) {
            writef(" %16.16s ", district.name);
            ulong districtSeatCount;
            foreach (party; parties) {
                ulong tmpSeats = cast(long) (districtPartySeats[district][party] + Rational(1, 2));
                //writef("| %7s ", tmpSeats);
                writef("| %7s -> %2s ", districtPartyVotes[district][party], tmpSeats);
                //writef("| %7.06f", districtPartySeats[district][party]);
                districtSeatCount += tmpSeats;
            }
            writef("| %3s/%3s ", districtSeatCount, district.seats);
            writeln();
            totalSeatCount += districtSeatCount;
        }
        write("------------------");
        foreach (party; parties)
            write("+---------------");
        write("+---------");
        writeln();
        writef(" %16.16s ", "Total");
        foreach (party; parties) {
            ulong partySeatCount;
            foreach (district; districts)
                partySeatCount += cast(long) (districtPartySeats[district][party] + Rational(1, 2));
            writef("|       %3s/%3s ", partySeatCount, party.seats);
        }
        writef("| %3s/%3s ", totalSeatCount, maxSeats);
        writeln();
    }
    writefln("It took %s iterations before a result was found", --iterationCounter);
    writefln("Party multipliers:");
    foreach (party; parties)
        writef("%5s: %s, ", party.name, partyMultipliers[party]);
    writeln();
    writefln("District multipliers:");
    foreach (district; districts)
        writef("%5s: %s, ", district.name, districtMultipliers[district]);
    writeln();
}
