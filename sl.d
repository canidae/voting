import std.algorithm: sort;
import std.stdio;

class Candidate {
    string name;
    ulong seats;
    ulong votes = 0;
    bool excluded = false;

    this(string name) {
        this.name = name;
    }
}

struct Vote {
    Candidate[] candidates;
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
    while (true) {
        /* tally votes */
        foreach (candidate; candidates) {
            candidate.votes = 0;
            candidate.seats = 0;
        }
        foreach (vote; votes) {
            foreach (candidate; vote.candidates) {
                if (candidate.excluded)
                    continue;
                ++candidate.votes;
                break;
            }
        }

        /* assign seats */
        foreach (seats; 0 .. maxSeats) {
            Candidate winner = candidates[0];
            foreach (candidate; candidates[1 .. $]) {
                if (winner.excluded || winner.votes / (winner.seats == 0 ? 1.4 : 2 * winner.seats + 1) < candidate.votes / (candidate.seats == 0 ? 1.4 : 2 * candidate.seats + 1))
                    winner = candidate;
            }
            ++winner.seats;
            writefln("Assigning seat to %s", winner.name);
        }

        /* print result so far */
        writeln();
        writeln("Result:");
        foreach (candidate; candidates)
            writefln("%15.15s: %2s, excluded: %s", candidate.name, candidate.seats, candidate.excluded);

        /* check if all candidates got a seat, if not, exclude candidate with fewest votes */
        Candidate exclude = candidates[0];
        foreach (candidate; candidates) {
            if (candidate.excluded || candidate.seats > 0)
                continue;
            if (exclude.excluded || exclude.seats > 0 || exclude.votes > candidate.votes)
                exclude = candidate;
        }
        if (!exclude.excluded && exclude.seats == 0) {
            exclude.excluded = true;
            writefln("Excluding %s as they received no seats and got fewest votes", exclude.name);
        } else {
            /* we're done here */
            break;
        }
    }
}
