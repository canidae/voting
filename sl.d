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
    /* akershus */
    Vote[] votes;
    foreach (i; 0 .. 101241)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 17040)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 2566)
        votes ~= Vote([r]);
    foreach (i; 0 .. 9435)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 9308)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 14688)
        votes ~= Vote([v]);
    foreach (i; 0 .. 69505)
        votes ~= Vote([h]);
    foreach (i; 0 .. 73300)
        votes ~= Vote([frp]);
    //immutable maxSeats = 16;

    /* aust-agder */
    //Vote[] votes;
    foreach (i; 0 .. 19377)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 2588)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 377)
        votes ~= Vote([r]);
    foreach (i; 0 .. 2609)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 6663)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 2054)
        votes ~= Vote([v]);
    foreach (i; 0 .. 9721)
        votes ~= Vote([h]);
    foreach (i; 0 .. 15538)
        votes ~= Vote([frp]);
    //immutable maxSeats = 4;

    /* buskerud */
    //Vote[] votes;
    foreach (i; 0 .. 52751)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 6514)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 884)
        votes ~= Vote([r]);
    foreach (i; 0 .. 8842)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 4500)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 4324)
        votes ~= Vote([v]);
    foreach (i; 0 .. 27588)
        votes ~= Vote([h]);
    foreach (i; 0 .. 35764)
        votes ~= Vote([frp]);
    //immutable maxSeats = 9;

    /* finnmark */
    //Vote[] votes;
    foreach (i; 0 .. 16834)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 2989)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 299)
        votes ~= Vote([r]);
    foreach (i; 0 .. 1613)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 1026)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 847)
        votes ~= Vote([v]);
    foreach (i; 0 .. 3970)
        votes ~= Vote([h]);
    foreach (i; 0 .. 8277)
        votes ~= Vote([frp]);
    //immutable maxSeats = 5;

    /* hedmark */
    //Vote[] votes;
    foreach (i; 0 .. 50855)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 7078)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 630)
        votes ~= Vote([r]);
    foreach (i; 0 .. 11096)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 2652)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 2650)
        votes ~= Vote([v]);
    foreach (i; 0 .. 10994)
        votes ~= Vote([h]);
    foreach (i; 0 .. 19326)
        votes ~= Vote([frp]);
    //immutable maxSeats = 8;

    /* hordaland */
    //Vote[] votes;
    foreach (i; 0 .. 81636)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 14698)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 6794)
        votes ~= Vote([r]);
    foreach (i; 0 .. 14768)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 19138)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 12361)
        votes ~= Vote([v]);
    foreach (i; 0 .. 54066)
        votes ~= Vote([h]);
    foreach (i; 0 .. 61147)
        votes ~= Vote([frp]);
    //immutable maxSeats = 15;

    /* møre og romsdal */
    //Vote[] votes;
    foreach (i; 0 .. 42542)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 5279)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 653)
        votes ~= Vote([r]);
    foreach (i; 0 .. 11879)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 11713)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 5298)
        votes ~= Vote([v]);
    foreach (i; 0 .. 22356)
        votes ~= Vote([h]);
    foreach (i; 0 .. 37967)
        votes ~= Vote([frp]);
    //immutable maxSeats = 9;

    /* nordland */
    //Vote[] votes;
    foreach (i; 0 .. 50912)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 10045)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 1829)
        votes ~= Vote([r]);
    foreach (i; 0 .. 10736)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 4778)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 2957)
        votes ~= Vote([v]);
    foreach (i; 0 .. 14905)
        votes ~= Vote([h]);
    foreach (i; 0 .. 31562)
        votes ~= Vote([frp]);
    //immutable maxSeats = 10;

    /* nord-trøndelag */
    //Vote[] votes;
    foreach (i; 0 .. 31466)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 4685)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 447)
        votes ~= Vote([r]);
    foreach (i; 0 .. 11259)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 2917)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 2119)
        votes ~= Vote([v]);
    foreach (i; 0 .. 6465)
        votes ~= Vote([h]);
    foreach (i; 0 .. 12641)
        votes ~= Vote([frp]);
    //immutable maxSeats = 6;

    /* oppland */
    //Vote[] votes;
    foreach (i; 0 .. 47728)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 5367)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 612)
        votes ~= Vote([r]);
    foreach (i; 0 .. 12912)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 3182)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 3103)
        votes ~= Vote([v]);
    foreach (i; 0 .. 11643)
        votes ~= Vote([h]);
    foreach (i; 0 .. 18272)
        votes ~= Vote([frp]);
    //immutable maxSeats = 7;

    /* oslo */
    //Vote[] votes;
    foreach (i; 0 .. 113103)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 33205)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 12917)
        votes ~= Vote([r]);
    foreach (i; 0 .. 3126)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 8786)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 20784)
        votes ~= Vote([v]);
    foreach (i; 0 .. 69999)
        votes ~= Vote([h]);
    foreach (i; 0 .. 56953)
        votes ~= Vote([frp]);
    //immutable maxSeats = 17;

    /* rogaland */
    //Vote[] votes;
    foreach (i; 0 .. 59145)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 10609)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 908)
        votes ~= Vote([r]);
    foreach (i; 0 .. 13144)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 25541)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 10053)
        votes ~= Vote([v]);
    foreach (i; 0 .. 44289)
        votes ~= Vote([h]);
    foreach (i; 0 .. 60030)
        votes ~= Vote([frp]);
    //immutable maxSeats = 13;

    /* sogn og fjordane */
    //Vote[] votes;
    foreach (i; 0 .. 17375)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 3418)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 541)
        votes ~= Vote([r]);
    foreach (i; 0 .. 14782)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 3984)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 1952)
        votes ~= Vote([v]);
    foreach (i; 0 .. 7112)
        votes ~= Vote([h]);
    foreach (i; 0 .. 9287)
        votes ~= Vote([frp]);
    //immutable maxSeats = 5;

    /* sør-trøndelag */
    //Vote[] votes;
    foreach (i; 0 .. 66614)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 12852)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 2057)
        votes ~= Vote([r]);
    foreach (i; 0 .. 11803)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 6189)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 5871)
        votes ~= Vote([v]);
    foreach (i; 0 .. 22587)
        votes ~= Vote([h]);
    foreach (i; 0 .. 31885)
        votes ~= Vote([frp]);
    //immutable maxSeats = 10;

    /* telemark */
    //Vote[] votes;
    foreach (i; 0 .. 39296)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 5020)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 1147)
        votes ~= Vote([r]);
    foreach (i; 0 .. 5184)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 6239)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 2374)
        votes ~= Vote([v]);
    foreach (i; 0 .. 12405)
        votes ~= Vote([h]);
    foreach (i; 0 .. 21708)
        votes ~= Vote([frp]);
    //immutable maxSeats = 6;

    /* troms */
    //Vote[] votes;
    foreach (i; 0 .. 30942)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 6275)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 1242)
        votes ~= Vote([r]);
    foreach (i; 0 .. 7015)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 3042)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 2150)
        votes ~= Vote([v]);
    foreach (i; 0 .. 10846)
        votes ~= Vote([h]);
    foreach (i; 0 .. 21224)
        votes ~= Vote([frp]);
    //immutable maxSeats = 7;

    /* vest-agder */
    //Vote[] votes;
    foreach (i; 0 .. 24450)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 3647)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 427)
        votes ~= Vote([r]);
    foreach (i; 0 .. 3296)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 14337)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 2876)
        votes ~= Vote([v]);
    foreach (i; 0 .. 16214)
        votes ~= Vote([h]);
    foreach (i; 0 .. 25296)
        votes ~= Vote([frp]);
    //immutable maxSeats = 6;

    /* vestfold */
    //Vote[] votes;
    foreach (i; 0 .. 44169)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 8551)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 848)
        votes ~= Vote([r]);
    foreach (i; 0 .. 4257)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 6164)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 3944)
        votes ~= Vote([v]);
    foreach (i; 0 .. 25752)
        votes ~= Vote([h]);
    foreach (i; 0 .. 35687)
        votes ~= Vote([frp]);
    //immutable maxSeats = 7;

    /* østfold */
    //Vote[] votes;
    foreach (i; 0 .. 58613)
        votes ~= Vote([ap]);
    foreach (i; 0 .. 6501)
        votes ~= Vote([sv]);
    foreach (i; 0 .. 1041)
        votes ~= Vote([r]);
    foreach (i; 0 .. 7250)
        votes ~= Vote([sp]);
    foreach (i; 0 .. 8589)
        votes ~= Vote([krf]);
    foreach (i; 0 .. 3739)
        votes ~= Vote([v]);
    foreach (i; 0 .. 22041)
        votes ~= Vote([h]);
    foreach (i; 0 .. 38853)
        votes ~= Vote([frp]);
    //immutable maxSeats = 9;


    immutable maxSeats = 169;

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
