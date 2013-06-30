module exent.rp;

import std.algorithm: sort;
import std.stdio;

class Candidate {
    string name;
    int id;
    ulong seats;
    real votes = 0.0;
    real totalVotes = 0.0; // used for excluding candidates that are least representet on a ballot
    bool excluded = false;

    this(string name) {
        this.name = name;
    }
}

struct Vote {
    Candidate[] candidates;
    real weight = 1.0;
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
        votes ~= Vote([sp, ap, krf]);
    foreach (i; 0 .. 8786)
        votes ~= Vote([krf, v, sp]);
    foreach (i; 0 .. 20784)
        votes ~= Vote([v, krf, h]);
    foreach (i; 0 .. 69999)
        votes ~= Vote([h, v, frp]);
    foreach (i; 0 .. 56953)
        votes ~= Vote([frp, h, v]);

    immutable maxSeats = 17;
    auto quota = votes.length / (maxSeats + 1) + 1;

    writefln("Votes: %s, Seats: %s, Quota: %s", votes.length, maxSeats, quota);

    int round = 1;
    int seats = maxSeats;
    while (seats > 0) {
        seats = maxSeats;

        /* tally votes */
        foreach (candidate; candidates) {
            candidate.votes = 0.0;
            candidate.totalVotes = 0.0;
        }
        foreach (vote; votes) {
            bool first = true;
            foreach (candidate; vote.candidates) {
                if (candidate.excluded)
                    continue;
                if (first) {
                    candidate.votes += vote.weight;
                    first = false;
                }
                candidate.totalVotes += vote.weight;
            }
        }

        /* assign seats */
        foreach (candidate; candidates) {
            if (candidate.excluded)
                continue;
            candidate.seats = cast(ulong) (candidate.votes / quota);
        }

        /* print result */
        writeln();
        foreach (candidate; candidates) {
            writefln("%s (vote weight: %s) got %s seats", candidate.name, candidate.votes, candidate.seats);
            seats -= candidate.seats;
        }
        writefln("Seats left: %s", seats);
        if (seats == 0)
            break;

        /* exclude candidate with fewest votes */
        int min = 0;
        Candidate[] remaining;
        foreach (int id, candidate; candidates) {
            if (candidate.excluded)
                continue;
            remaining ~= candidate;
            // strategy 1: exclude candidate with least rank 1 votes
            /*
            if (candidates[min].excluded || candidate.votes < candidates[min].votes)
                min = id;
             */
            // strategy 2: exclude candidate with least rank 1 votes - seats * quota
            /*
            if (candidates[min].excluded || (candidate.votes - candidate.seats * quota) < (candidates[min].votes - candidates[min].seats * quota))
                min = id;
             */
            // strategy 3: exclude candidate with least votes regardless of ranking (with fallback to candidate with least first preference when there's a tie)
            if (candidates[min].excluded || (candidate.totalVotes < candidates[min].totalVotes) || (candidate.totalVotes == candidates[min].totalVotes && (candidate.votes - candidate.seats * quota) < (candidates[min].votes - candidates[min].seats * quota)))
                min = id;
        }
        if (remaining.length == 1) {
            /* only one candidate remaining, this candidate gets the last seat */
            writefln("Assigning last seat to %s", remaining[0].name);
            ++remaining[0].seats;
            break;
        } else {
            writefln("Excluding %s with vote weight %s (%s) from future seat allocations", candidates[min].name, candidates[min].votes, candidates[min].votes - candidates[min].seats * quota);
            candidates[min].excluded = true;
            foreach (ref vote; votes) {
                foreach (candidate; vote.candidates) {
                    if (!candidate.excluded)
                        break;
                    if (candidate.votes == 0)
                        continue;
                    vote.weight -= candidate.seats * quota / candidate.votes;
                    if (vote.weight < 0.0)
                        vote.weight = 0.0;
                }
            }
        }
        ++round;
    }
}
