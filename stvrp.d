module exent.rp;

import std.algorithm: sort;
import std.stdio;

class Candidate {
    string name;
    int id;
    ulong totalSeats;
    ulong newSeats;
    real votes = 0.0;
    bool excluded = false;

    this(string name) {
        this.name = name;
    }
}

struct Vote {
    Candidate[] candidates;
    real weight = 1.0;
}

struct Pair {
    Candidate winner;
    Candidate loser;
    real diff;
}

void main() {
    Candidate r = new Candidate("Rodt");
    Candidate sv = new Candidate("Sosialistisk Venstreparti");
    Candidate ap = new Candidate("Arbeiderpartiet");
    Candidate sp = new Candidate("Senterpartiet");
    Candidate krf = new Candidate("Kristelig Folkeparti");
    Candidate v = new Candidate("Venstre");
    Candidate h = new Candidate("Hoyre");
    Candidate frp = new Candidate("Fremskrittspartiet");

    Candidate[] candidates;
    candidates ~= r;
    candidates ~= sv;
    candidates ~= ap;
    candidates ~= sp;
    candidates ~= krf;
    candidates ~= v;
    candidates ~= h;
    candidates ~= frp;

    /* set id */
    foreach (int index, candidate; candidates)
        candidate.id = index;

    /* assign votes */
    Vote[] votes;
    foreach (i; 0 .. 12917)
        votes ~= Vote([r, sv, ap]);
    foreach (i; 0 .. 33205)
        votes ~= Vote([sv, ap, r]);
    foreach (i; 0 .. 113103)
        votes ~= Vote([ap, sp, sv]);
    foreach (i; 0 .. 3126)
        votes ~= Vote([sp, ap, krf]);
    foreach (i; 0 .. 8786)
        votes ~= Vote([krf, v, sp]);
    foreach (i; 0 .. 20784)
        votes ~= Vote([v, krf, h]);
    foreach (i; 0 .. 69999)
        votes ~= Vote([h]);
    foreach (i; 0 .. 56953)
        votes ~= Vote([frp, v, h]);

    immutable maxSeats = 17;
    auto quota = votes.length / (maxSeats + 1) + 1;

    writefln("Votes: %s, Seats: %s, Quota: %s", votes.length, maxSeats, quota);

    int round = 1;
    int seats = maxSeats;
    while (seats > 0) {
        seats = maxSeats;

        /* tally votes */
        ulong newQuotaSeats = maxSeats;
        real newQuotaVotes = 0.0;
        foreach (candidate; candidates) {
            candidate.votes = 0.0;
            newQuotaSeats -= candidate.totalSeats;
        }
        foreach (vote; votes) {
            foreach (candidate; vote.candidates) {
                if (candidate.excluded)
                    continue;
                newQuotaVotes += vote.weight;
                candidate.votes += vote.weight;
                break;
            }
        }
        quota = cast(ulong) newQuotaVotes / (newQuotaSeats + 1) + 1;
        writefln("New quota: %s", quota);

        /* assign seats */
        foreach (candidate; candidates) {
            candidate.newSeats = cast(ulong) (candidate.votes / quota);
            candidate.totalSeats += candidate.newSeats;
        }

        /* reweight votes */
        foreach (ref vote; votes) {
            foreach (candidate; vote.candidates) {
                if (candidate.excluded)
                    continue;
                if (candidate.newSeats <= 0)
                    break;
                vote.weight -= candidate.newSeats * quota / candidate.votes;
                if (vote.weight < 0.0)
                    vote.weight = 0.0;
                break;
            }
        }

        /* print result */
        writeln();
        writeln("Candidate | New seats | Total seats | Vote weight | Vote weight - New seats * Quota");
        foreach (candidate; candidates) {
            writefln("%9.9s | %9s | %11s | %11.6s | %s", candidate.name, candidate.newSeats, candidate.totalSeats, candidate.votes, candidate.votes - candidate.newSeats * quota);
            seats -= candidate.totalSeats;
        }
        writefln("Seats left: %s", seats);
        if (seats == 0)
            break;

        /* exclude least preferred candidate, determined using inverted Ranked Pairs (least preferred candidate on top) */
        real[] resultTable = new real[candidates.length * candidates.length];
        resultTable[] = 0.0;
        foreach (vote; votes) {
            bool[Candidate] betterCandidates;
            foreach (vcandidate; vote.candidates) {
                if (vcandidate.excluded)
                    continue;
                foreach (candidate; candidates) {
                    if (candidate.excluded || candidate == vcandidate || candidate in betterCandidates)
                        continue;
                    resultTable[vcandidate.id + candidate.id * candidates.length] += vote.weight;
                }
                betterCandidates[vcandidate] = true;
            }
        }
        /* print matrix */
        writef("             ");
        foreach (candidate; candidates)
            writef("| %12.12s ", candidate.name);
        writeln("|");
        for (int a = 0; a < candidates.length; ++a) {
            writef("%12.12s ", candidates[a].name);
            for (int b = 0; b < candidates.length; ++b) {
                writef("| %12s ", resultTable[a + b * candidates.length]);
            }
            writeln("|");
        }
        writeln();
        /* sort after biggest difference */
        Pair[] pairs;
        for (int a = 0; a < candidates.length; ++a) {
            for (int b = 0; b < candidates.length; ++b) {
                if (a == b || candidates[a].excluded || candidates[b].excluded)
                    continue;
                real cA = resultTable[a + b * candidates.length];
                real cB = resultTable[b + a * candidates.length];
                if (cA == cB) {
                    /* tie, what now? */
                    writefln("Tie between %s and %s", candidates[a].name, candidates[b].name);
                } else if (cA > cB) {
                    pairs ~= Pair(candidates[a], candidates[b], cA - cB);
                }
            }
        }
        sort!("a.diff > b.diff")(pairs);
        /* lock pairs, creating an acyclic graph */
        Candidate[][Candidate] graph;
        foreach (pair; pairs) {
            if (pair.winner in graph) {
                Candidate[] children = graph[pair.winner];
                bool createsCycle = false;
                while (children.length > 0) {
                    Candidate child = children[0];
                    if (child == pair.loser) {
                        createsCycle = true;
                        break;
                    }
                    if (child in graph)
                        children ~= graph[child];
                    children = children[1 .. $];
                }
                if (createsCycle) {
                    writefln("Not locking %s > %s (%s), would create a cyclic graph", pair.winner.name, pair.loser.name, pair.diff);
                    continue;
                }
            } else {
                graph[pair.winner] = [];
            }
            writefln("Locking %s > %s (%s)", pair.winner.name, pair.loser.name, pair.diff);
            graph[pair.loser] ~= pair.winner;
        }
        writeln();
        /* find least preferred candidate, the one with no parents in acyclic graph */
        bool[Candidate] losers;
        foreach (candidate; candidates)
            losers[candidate] = true;
        foreach (candidate; candidates) {
            if (candidate !in graph)
                continue;
            Candidate[] children = graph[candidate];
            while (children.length > 0) {
                Candidate child = children[0];
                losers[child] = false;
                children ~= graph[child];
                children = children[1 .. $];
            }
        }
        foreach (loser, lost; losers) {
            if (loser.excluded || !lost)
                continue;
            writefln("The majority prefer other candidates over %s, excluding candidate from future seat allocations", loser.name);
            loser.excluded = true;
        }
        Candidate[] remaining;
        foreach (int id, candidate; candidates) {
            if (candidate.excluded)
                continue;
            remaining ~= candidate;
        }
        if (remaining.length == 1) {
            /* only one candidate remaining, this candidate gets the last seat */
            writefln("Assigning last seat to %s", remaining[0].name);
            ++remaining[0].totalSeats;
            break;
        }
        ++round;
    }

    /* print result */
    writeln();
    writeln("Final result:");
    writeln("Candidate | Seats");
    foreach (candidate; candidates)
        writefln("%9.9s | %6s", candidate.name, candidate.totalSeats);
}
