import std.algorithm: sort;
import std.conv: to;
import std.stdio;
import std.string: stripLeft, stripRight, indexOf;

import rational;

class Party {
    string name;
    int id;
    ulong seats;
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
    real weight;
}

struct Pair {
    Party winner;
    Party loser;
    //real diff;
    Rational diff;
}

void main() {
    /* read file with election results */
    auto file = File("election_slrp_1.txt");
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
            /* otherwise it's a party preference list */
            while (true) {
                delimPos = text.indexOf(">");
                string partyName = text[0 .. (delimPos == -1 ? $ : delimPos)];
                if (delimPos > 0)
                    text = text[delimPos + 1 .. $];
                Party readParty;
                if (partyName in readParties) {
                    readParty = readParties[partyName];
                } else {
                    readParty = new Party(partyName);
                    readParties[partyName] = readParty;
                    parties ~= readParty;
                }
                foreach (i; 0 .. value)
                    readDistrict.votes ~= Vote([readParty]);

                if (delimPos == -1)
                    break;
                ++delimPos;
            }
            maxVotes += value;
        }
    }

    /* set id */
    foreach (int index, party; parties)
        party.id = index;

    writefln("Votes: %s", maxVotes);
    writeln();

    int round = 1;
    long seats = maxSeats;
    while (seats > 0) {
        /* tally (reweighted) votes */
        //real[] resultTable = new real[parties.length * parties.length];
        auto resultTable = new Rational[parties.length * parties.length];
        resultTable[] = Rational(0);
        foreach (district; districts) {
            foreach (vote; district.votes) {
                bool[Party] betterParties;
                int seatSum = 0;
                foreach (vparty; vote.parties) {
                    seatSum += vparty.seats;
                    foreach (party; parties) {
                        if (party == vparty || party in betterParties)
                            continue;
                        //resultTable[vparty.id + party.id * parties.length] += 1.0 / (2 * seatSum + 1);
                        resultTable[vparty.id + party.id * parties.length] += Rational(1, (2 * seatSum + 1));
                    }
                    betterParties[vparty] = true;
                }
            }
        }

        /* print matrix */
        writef("        ");
        foreach (party; parties)
            writef("| %7.7s ", party.name);
        writeln("|");
        foreach (a, partyA; parties) {
            writef("%7.7s ", partyA.name);
            foreach (b, partyB; parties)
                writef("| %7s ", cast(real) resultTable[a + b * parties.length]);
            writeln("|");
        }
        writeln();

        /* sort after biggest win */
        Pair[] pairs;
        foreach (a, partyA; parties) {
            foreach (b, partyB; parties) {
                if (a == b)
                    continue;
                auto cA = resultTable[a + b * parties.length];
                auto cB = resultTable[b + a * parties.length];
                if (cA == cB) {
                    /* tie, what now? */
                    writefln("Tie between %s and %s", parties[a].name, parties[b].name);
                } else if (cA > cB) {
                    pairs ~= Pair(partyA, partyB, cA - cB);
                }
            }
        }
        sort!("a.diff > b.diff")(pairs);

        /* lock pairs, creating an acyclic graph */
        Party[][Party] graph;
        foreach (pair; pairs) {
            if (pair.loser in graph) {
                Party[] children = graph[pair.loser];
                bool createsCycle = false;
                while (children.length > 0) {
                    Party child = children[0];
                    if (child == pair.winner) {
                        createsCycle = true;
                        break;
                    }
                    if (child in graph)
                        children ~= graph[child];
                    children = children[1 .. $];
                }
                if (createsCycle) {
                    writefln("Not locking %s > %s (%s), would create a cyclic graph", pair.winner.name, pair.loser.name, cast(real) pair.diff);
                    continue;
                }
            } else {
                graph[pair.loser] = [];
            }
            writefln("Locking %s > %s (%s)", pair.winner.name, pair.loser.name, cast(real) pair.diff);
            graph[pair.winner] ~= pair.loser;
        }
        writeln();

        /* find winner, the one with no parents in acyclic graph */
        bool[Party] winners;
        foreach (party; parties)
            winners[party] = true;
        foreach (party; parties) {
            Party[] children = graph[party];
            while (children.length > 0) {
                Party child = children[0];
                winners[child] = false;
                children ~= graph[child];
                children = children[1 .. $];
            }
        }
        /*
        foreach (party, parents; graph) {
            if (parents.length == 0)
                winners ~= party;
        }
        */
        foreach (winner, won; winners) {
            if (won) {
                ++winner.seats;
                --seats;
                writefln("Winner round %s: %s", round, winner.name);
            }
        }
        ++round;
        writefln("Seats left: %s", seats);
    }

    /* print end result */
    writeln();
    foreach (party; parties)
        writefln("%s got %s seat(s)", party.name, party.seats);
}
