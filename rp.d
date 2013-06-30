module exent.rp;

import std.algorithm: sort;
import std.stdio;

class Candidate {
    string name;
    int id;
    ulong seats;

    this(string name) {
        this.name = name;
    }
}

struct Vote {
    Candidate[] candidates;
    real weight;
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
    foreach (i; 0 .. 113103)
        votes ~= Vote([ap, sv, sp]);
    foreach (i; 0 .. 33205)
        votes ~= Vote([sv, ap, r]);
    foreach (i; 0 .. 12917)
        votes ~= Vote([r, sv, ap]);
    foreach (i; 0 .. 3126)
        votes ~= Vote([sp, ap, sv]);
    foreach (i; 0 .. 8786)
        votes ~= Vote([krf, v, h]);
    foreach (i; 0 .. 20784)
        votes ~= Vote([v, krf, h]);
    foreach (i; 0 .. 69999)
        votes ~= Vote([h, v, frp]);
    foreach (i; 0 .. 56953)
        votes ~= Vote([frp, h, v]);

    auto seats = 17;
    auto quota = votes.length / (seats + 1) + 1;

    writefln("Votes: %s", votes.length);
    writeln();

    int round = 1;
    while (seats > 0) {
        /* ranked pairs tainted with sainte-laguës method to fill seats */
        long[] resultTable = new long[candidates.length * candidates.length];
        resultTable[] = 0;
        foreach (a, candidate; candidates) {
            if (candidate.seats <= 0)
                continue;
            foreach (b; 0 .. candidates.length) {
                if (a == b)
                    continue;
                resultTable[a + b * candidates.length] -= candidate.seats * quota;
            }
        }
        foreach (vote; votes) {
            bool[Candidate] betterCandidates;
            foreach (vcandidate; vote.candidates) {
                foreach (candidate; candidates) {
                    if (candidate == vcandidate || candidate in betterCandidates)
                        continue;
                    ++resultTable[vcandidate.id + candidate.id * candidates.length];
                }
                betterCandidates[vcandidate] = true;
            }
        }

        /* print matrix */
        writef("            ");
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

        /* sort after biggest win */
        Pair[] pairs;
        for (int a = 0; a < candidates.length; ++a) {
            for (int b = 0; b < candidates.length; ++b) {
                if (a == b)
                    continue;
                long cA = resultTable[a + b * candidates.length];
                long cB = resultTable[b + a * candidates.length];
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
            if (pair.loser in graph) {
                Candidate[] children = graph[pair.loser];
                bool createsCycle = false;
                while (children.length > 0) {
                    Candidate child = children[0];
                    if (child == pair.winner) {
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
                graph[pair.loser] = [];
            }
            writefln("Locking %s > %s (%s)", pair.winner.name, pair.loser.name, pair.diff);
            graph[pair.winner] ~= pair.loser;
        }
        writeln();

        /* find winner, the one with no parents in acyclic graph */
        bool[Candidate] winners;
        foreach (candidate; candidates)
            winners[candidate] = true;
        foreach (candidate; candidates) {
            Candidate[] children = graph[candidate];
            while (children.length > 0) {
                Candidate child = children[0];
                winners[child] = false;
                children ~= graph[child];
                children = children[1 .. $];
            }
        }
        /*
        foreach (candidate, parents; graph) {
            if (parents.length == 0)
                winners ~= candidate;
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
    foreach (candidate; candidates)
        writefln("%s got %s seat(s)", candidate.name, candidate.seats);
}
