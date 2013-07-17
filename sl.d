import std.algorithm: sort;
import std.stdio;

class Party {
    string name;
    bool excluded = false;

    this(string name) {
        this.name = name;
    }
}

class District {
    string name;
    ulong seats;
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
    /* create parties */
    Party r = new Party("Rodt");
    Party sv = new Party("Sosialistisk Venstreparti");
    Party ap = new Party("Arbeiderpartiet");
    Party sp = new Party("Senterpartiet");
    Party krf = new Party("Kristelig Folkeparti");
    Party v = new Party("Venstre");
    Party h = new Party("Hoyre");
    Party frp = new Party("Fremskrittspartiet");

    Party[] parties;
    parties ~= r;
    parties ~= sv;
    parties ~= ap;
    parties ~= sp;
    parties ~= krf;
    parties ~= v;
    parties ~= h;
    parties ~= frp;

    /* create districts */
    District ak = new District("Akershus", 16);
    District au = new District("Aust-Agder", 4);
    District bu = new District("Buskerud", 9);
    District fi = new District("Finnmark", 5);
    District he = new District("Hedmark", 8);
    District ho = new District("Hordaland", 15);
    District mo = new District("More og Romsdal", 9);
    District no = new District("Nordland", 10);
    District nt = new District("Nord-Trondelag", 6);
    District op = new District("Oppland", 7);
    District os = new District("Oslo", 17);
    District ro = new District("Rogaland", 13);
    District so = new District("Sogn og Fjordane", 5);
    District st = new District("Sor-Trondelag", 10);
    District te = new District("Telemark", 6);
    District tr = new District("Troms", 7);
    District va = new District("Vest-Agder", 6);
    District ve = new District("Vestfold", 7);
    District of = new District("Ostfold", 9);

    District[] districts;
    districts ~= ak;
    districts ~= au;
    districts ~= bu;
    districts ~= fi;
    districts ~= he;
    districts ~= ho;
    districts ~= mo;
    districts ~= no;
    districts ~= nt;
    districts ~= op;
    districts ~= os;
    districts ~= ro;
    districts ~= so;
    districts ~= st;
    districts ~= te;
    districts ~= tr;
    districts ~= va;
    districts ~= ve;
    districts ~= of;

    /* assign votes */
    /* akershus */
    foreach (i; 0 .. 101241)
        ak.votes ~= Vote([ap]);
    foreach (i; 0 .. 17040)
        ak.votes ~= Vote([sv]);
    foreach (i; 0 .. 2566)
        ak.votes ~= Vote([r]);
    foreach (i; 0 .. 9435)
        ak.votes ~= Vote([sp]);
    foreach (i; 0 .. 9308)
        ak.votes ~= Vote([krf]);
    foreach (i; 0 .. 14688)
        ak.votes ~= Vote([v]);
    foreach (i; 0 .. 69505)
        ak.votes ~= Vote([h]);
    foreach (i; 0 .. 73300)
        ak.votes ~= Vote([frp]);

    /* aust-agder */
    foreach (i; 0 .. 19377)
        au.votes ~= Vote([ap]);
    foreach (i; 0 .. 2588)
        au.votes ~= Vote([sv]);
    foreach (i; 0 .. 377)
        au.votes ~= Vote([r]);
    foreach (i; 0 .. 2609)
        au.votes ~= Vote([sp]);
    foreach (i; 0 .. 6663)
        au.votes ~= Vote([krf]);
    foreach (i; 0 .. 2054)
        au.votes ~= Vote([v]);
    foreach (i; 0 .. 9721)
        au.votes ~= Vote([h]);
    foreach (i; 0 .. 15538)
        au.votes ~= Vote([frp]);

    /* buskerud */
    foreach (i; 0 .. 52751)
        bu.votes ~= Vote([ap]);
    foreach (i; 0 .. 6514)
        bu.votes ~= Vote([sv]);
    foreach (i; 0 .. 884)
        bu.votes ~= Vote([r]);
    foreach (i; 0 .. 8842)
        bu.votes ~= Vote([sp]);
    foreach (i; 0 .. 4500)
        bu.votes ~= Vote([krf]);
    foreach (i; 0 .. 4324)
        bu.votes ~= Vote([v]);
    foreach (i; 0 .. 27588)
        bu.votes ~= Vote([h]);
    foreach (i; 0 .. 35764)
        bu.votes ~= Vote([frp]);

    /* finnmark */
    foreach (i; 0 .. 16834)
        fi.votes ~= Vote([ap]);
    foreach (i; 0 .. 2989)
        fi.votes ~= Vote([sv]);
    foreach (i; 0 .. 299)
        fi.votes ~= Vote([r]);
    foreach (i; 0 .. 1613)
        fi.votes ~= Vote([sp]);
    foreach (i; 0 .. 1026)
        fi.votes ~= Vote([krf]);
    foreach (i; 0 .. 847)
        fi.votes ~= Vote([v]);
    foreach (i; 0 .. 3970)
        fi.votes ~= Vote([h]);
    foreach (i; 0 .. 8277)
        fi.votes ~= Vote([frp]);

    /* hedmark */
    foreach (i; 0 .. 50855)
        he.votes ~= Vote([ap]);
    foreach (i; 0 .. 7078)
        he.votes ~= Vote([sv]);
    foreach (i; 0 .. 630)
        he.votes ~= Vote([r]);
    foreach (i; 0 .. 11096)
        he.votes ~= Vote([sp]);
    foreach (i; 0 .. 2652)
        he.votes ~= Vote([krf]);
    foreach (i; 0 .. 2650)
        he.votes ~= Vote([v]);
    foreach (i; 0 .. 10994)
        he.votes ~= Vote([h]);
    foreach (i; 0 .. 19326)
        he.votes ~= Vote([frp]);

    /* hordaland */
    foreach (i; 0 .. 81636)
        ho.votes ~= Vote([ap]);
    foreach (i; 0 .. 14698)
        ho.votes ~= Vote([sv]);
    foreach (i; 0 .. 6794)
        ho.votes ~= Vote([r]);
    foreach (i; 0 .. 14768)
        ho.votes ~= Vote([sp]);
    foreach (i; 0 .. 19138)
        ho.votes ~= Vote([krf]);
    foreach (i; 0 .. 12361)
        ho.votes ~= Vote([v]);
    foreach (i; 0 .. 54066)
        ho.votes ~= Vote([h]);
    foreach (i; 0 .. 61147)
        ho.votes ~= Vote([frp]);

    /* møre og romsdal */
    foreach (i; 0 .. 42542)
        mo.votes ~= Vote([ap]);
    foreach (i; 0 .. 5279)
        mo.votes ~= Vote([sv]);
    foreach (i; 0 .. 653)
        mo.votes ~= Vote([r]);
    foreach (i; 0 .. 11879)
        mo.votes ~= Vote([sp]);
    foreach (i; 0 .. 11713)
        mo.votes ~= Vote([krf]);
    foreach (i; 0 .. 5298)
        mo.votes ~= Vote([v]);
    foreach (i; 0 .. 22356)
        mo.votes ~= Vote([h]);
    foreach (i; 0 .. 37967)
        mo.votes ~= Vote([frp]);

    /* nordland */
    foreach (i; 0 .. 50912)
        no.votes ~= Vote([ap]);
    foreach (i; 0 .. 10045)
        no.votes ~= Vote([sv]);
    foreach (i; 0 .. 1829)
        no.votes ~= Vote([r]);
    foreach (i; 0 .. 10736)
        no.votes ~= Vote([sp]);
    foreach (i; 0 .. 4778)
        no.votes ~= Vote([krf]);
    foreach (i; 0 .. 2957)
        no.votes ~= Vote([v]);
    foreach (i; 0 .. 14905)
        no.votes ~= Vote([h]);
    foreach (i; 0 .. 31562)
        no.votes ~= Vote([frp]);

    /* nord-trøndelag */
    foreach (i; 0 .. 31466)
        nt.votes ~= Vote([ap]);
    foreach (i; 0 .. 4685)
        nt.votes ~= Vote([sv]);
    foreach (i; 0 .. 447)
        nt.votes ~= Vote([r]);
    foreach (i; 0 .. 11259)
        nt.votes ~= Vote([sp]);
    foreach (i; 0 .. 2917)
        nt.votes ~= Vote([krf]);
    foreach (i; 0 .. 2119)
        nt.votes ~= Vote([v]);
    foreach (i; 0 .. 6465)
        nt.votes ~= Vote([h]);
    foreach (i; 0 .. 12641)
        nt.votes ~= Vote([frp]);

    /* oppland */
    foreach (i; 0 .. 47728)
        op.votes ~= Vote([ap]);
    foreach (i; 0 .. 5367)
        op.votes ~= Vote([sv]);
    foreach (i; 0 .. 612)
        op.votes ~= Vote([r]);
    foreach (i; 0 .. 12912)
        op.votes ~= Vote([sp]);
    foreach (i; 0 .. 3182)
        op.votes ~= Vote([krf]);
    foreach (i; 0 .. 3103)
        op.votes ~= Vote([v]);
    foreach (i; 0 .. 11643)
        op.votes ~= Vote([h]);
    foreach (i; 0 .. 18272)
        op.votes ~= Vote([frp]);

    /* oslo */
    foreach (i; 0 .. 113103)
        os.votes ~= Vote([ap]);
    foreach (i; 0 .. 33205)
        os.votes ~= Vote([sv]);
    foreach (i; 0 .. 12917)
        os.votes ~= Vote([r]);
    foreach (i; 0 .. 3126)
        os.votes ~= Vote([sp]);
    foreach (i; 0 .. 8786)
        os.votes ~= Vote([krf]);
    foreach (i; 0 .. 20784)
        os.votes ~= Vote([v]);
    foreach (i; 0 .. 69999)
        os.votes ~= Vote([h]);
    foreach (i; 0 .. 56953)
        os.votes ~= Vote([frp]);

    /* rogaland */
    foreach (i; 0 .. 59145)
        ro.votes ~= Vote([ap]);
    foreach (i; 0 .. 10609)
        ro.votes ~= Vote([sv]);
    foreach (i; 0 .. 908)
        ro.votes ~= Vote([r]);
    foreach (i; 0 .. 13144)
        ro.votes ~= Vote([sp]);
    foreach (i; 0 .. 25541)
        ro.votes ~= Vote([krf]);
    foreach (i; 0 .. 10053)
        ro.votes ~= Vote([v]);
    foreach (i; 0 .. 44289)
        ro.votes ~= Vote([h]);
    foreach (i; 0 .. 60030)
        ro.votes ~= Vote([frp]);

    /* sogn og fjordane */
    foreach (i; 0 .. 17375)
        so.votes ~= Vote([ap]);
    foreach (i; 0 .. 3418)
        so.votes ~= Vote([sv]);
    foreach (i; 0 .. 541)
        so.votes ~= Vote([r]);
    foreach (i; 0 .. 14782)
        so.votes ~= Vote([sp]);
    foreach (i; 0 .. 3984)
        so.votes ~= Vote([krf]);
    foreach (i; 0 .. 1952)
        so.votes ~= Vote([v]);
    foreach (i; 0 .. 7112)
        so.votes ~= Vote([h]);
    foreach (i; 0 .. 9287)
        so.votes ~= Vote([frp]);

    /* sør-trøndelag */
    foreach (i; 0 .. 66614)
        st.votes ~= Vote([ap]);
    foreach (i; 0 .. 12852)
        st.votes ~= Vote([sv]);
    foreach (i; 0 .. 2057)
        st.votes ~= Vote([r]);
    foreach (i; 0 .. 11803)
        st.votes ~= Vote([sp]);
    foreach (i; 0 .. 6189)
        st.votes ~= Vote([krf]);
    foreach (i; 0 .. 5871)
        st.votes ~= Vote([v]);
    foreach (i; 0 .. 22587)
        st.votes ~= Vote([h]);
    foreach (i; 0 .. 31885)
        st.votes ~= Vote([frp]);

    /* telemark */
    foreach (i; 0 .. 39296)
        te.votes ~= Vote([ap]);
    foreach (i; 0 .. 5020)
        te.votes ~= Vote([sv]);
    foreach (i; 0 .. 1147)
        te.votes ~= Vote([r]);
    foreach (i; 0 .. 5184)
        te.votes ~= Vote([sp]);
    foreach (i; 0 .. 6239)
        te.votes ~= Vote([krf]);
    foreach (i; 0 .. 2374)
        te.votes ~= Vote([v]);
    foreach (i; 0 .. 12405)
        te.votes ~= Vote([h]);
    foreach (i; 0 .. 21708)
        te.votes ~= Vote([frp]);

    /* troms */
    foreach (i; 0 .. 30942)
        tr.votes ~= Vote([ap]);
    foreach (i; 0 .. 6275)
        tr.votes ~= Vote([sv]);
    foreach (i; 0 .. 1242)
        tr.votes ~= Vote([r]);
    foreach (i; 0 .. 7015)
        tr.votes ~= Vote([sp]);
    foreach (i; 0 .. 3042)
        tr.votes ~= Vote([krf]);
    foreach (i; 0 .. 2150)
        tr.votes ~= Vote([v]);
    foreach (i; 0 .. 10846)
        tr.votes ~= Vote([h]);
    foreach (i; 0 .. 21224)
        tr.votes ~= Vote([frp]);

    /* vest-agder */
    foreach (i; 0 .. 24450)
        va.votes ~= Vote([ap]);
    foreach (i; 0 .. 3647)
        va.votes ~= Vote([sv]);
    foreach (i; 0 .. 427)
        va.votes ~= Vote([r]);
    foreach (i; 0 .. 3296)
        va.votes ~= Vote([sp]);
    foreach (i; 0 .. 14337)
        va.votes ~= Vote([krf]);
    foreach (i; 0 .. 2876)
        va.votes ~= Vote([v]);
    foreach (i; 0 .. 16214)
        va.votes ~= Vote([h]);
    foreach (i; 0 .. 25296)
        va.votes ~= Vote([frp]);

    /* vestfold */
    foreach (i; 0 .. 44169)
        ve.votes ~= Vote([ap]);
    foreach (i; 0 .. 8551)
        ve.votes ~= Vote([sv]);
    foreach (i; 0 .. 848)
        ve.votes ~= Vote([r]);
    foreach (i; 0 .. 4257)
        ve.votes ~= Vote([sp]);
    foreach (i; 0 .. 6164)
        ve.votes ~= Vote([krf]);
    foreach (i; 0 .. 3944)
        ve.votes ~= Vote([v]);
    foreach (i; 0 .. 25752)
        ve.votes ~= Vote([h]);
    foreach (i; 0 .. 35687)
        ve.votes ~= Vote([frp]);

    /* østfold */
    foreach (i; 0 .. 58613)
        of.votes ~= Vote([ap]);
    foreach (i; 0 .. 6501)
        of.votes ~= Vote([sv]);
    foreach (i; 0 .. 1041)
        of.votes ~= Vote([r]);
    foreach (i; 0 .. 7250)
        of.votes ~= Vote([sp]);
    foreach (i; 0 .. 8589)
        of.votes ~= Vote([krf]);
    foreach (i; 0 .. 3739)
        of.votes ~= Vote([v]);
    foreach (i; 0 .. 22041)
        of.votes ~= Vote([h]);
    foreach (i; 0 .. 38853)
        of.votes ~= Vote([frp]);

    Vote[] votes;
    foreach (district; districts)
        votes ~= district.votes;

    /* distribute seats to parties */
    immutable maxSeats = 169;
    immutable election_threshold = 0.0; // 0.014; // not to be confused with first divisor in modified sainte-lague
    ulong[Party] partyVotes;
    ulong[Party] partySeats;
    while (true) {
        /* tally votes */
        foreach (party; parties) {
            partyVotes[party] = 0;
            partySeats[party] = 0;
        }
        foreach (vote; votes) {
            foreach (party; vote.parties) {
                if (party.excluded)
                    continue;
                ++partyVotes[party];
            }
        }

        /* assign seats */
        foreach (seats; 0 .. maxSeats) {
            Party winner = parties[0];
            foreach (party; parties[1 .. $]) {
                if (partyVotes[winner] < election_threshold * votes.length || partyVotes[winner] / (2 * partySeats[winner] + 1) < partyVotes[party] / (2 * partySeats[party] + 1))
                    winner = party;
            }
            ++partySeats[winner];
            //writefln("Assigning seat to %s", winner.name);
        }

        /* print result so far */
        writeln();
        writeln("Result:");
        foreach (party; parties)
            writefln("%15.15s: %2s seats, %7s votes, excluded: %s", party.name, partySeats[party], partyVotes[party], party.excluded);

        /* check if all parties got a seat, if not, exclude party with fewest votes */
        Party exclude = parties[0];
        foreach (party; parties[1 .. $]) {
            if (partySeats[party] > 0)
                continue;
            if (exclude.excluded || partyVotes[exclude] > partyVotes[party])
                exclude = party;
        }
        if (!exclude.excluded && partySeats[exclude] == 0) {
            exclude.excluded = true;
            writefln("Excluding %s as they received no seats and got fewest votes", exclude.name);
        } else {
            /* we're done here */
            break;
        }
    }

    /* now distribute seats to districts */
    /* first tally votes for districts */
    ulong[Party][District] districtPartyVotes;
    ulong[Party][District] districtPartySeats;
    ulong seatsLeft = maxSeats;
    ulong districtSeatsLeft[District];
    foreach (district; districts) {
        districtSeatsLeft[district] = district.seats;
        foreach (party; parties) {
            districtPartyVotes[district][party] = 0;
            districtPartySeats[district][party] = 0;
        }
        foreach (vote; district.votes) {
            foreach (party; vote.parties) {
                if (party.excluded)
                    continue;
                ++districtPartyVotes[district][party];
                break;
            }
        }
    }
    /* then assign seats, ordered by reversed sainte-lague giving smaller parties first seats, skipping parties who already have received all their seats.
       using sainte-lague here as well, parties get a seat in the district where the party got the highest (districtPartyVotes / districtVotes / (2 * districtPartySeats + 1))
       districts who've filled all their seats are of course skipped. */
    while (seatsLeft > 0) {
        Party pWinner = parties[0];
        foreach (party; parties[1 .. $]) {
            if (partySeats[party] == 0)
                continue;
            if (partySeats[pWinner] == 0 || partyVotes[pWinner] / (2 * partySeats[pWinner] + 1) > partyVotes[party] / (2 * partySeats[party] + 1))
                pWinner = party;
        }
        District dWinner = districts[0];
        foreach (district; districts[1 .. $]) {
            if (districtSeatsLeft[district] == 0)
                continue;
            if (districtSeatsLeft[dWinner] == 0 || cast(real) districtPartyVotes[dWinner][pWinner] / cast(real) dWinner.votes.length / cast(real) (2 * districtPartySeats[dWinner][pWinner] + 1) < cast(real) districtPartyVotes[district][pWinner] / cast(real) district.votes.length / cast(real) (2 * districtPartySeats[district][pWinner] + 1))
                dWinner = district;
        }
        writefln("Assigning seat to %s in %s", pWinner.name, dWinner.name);
        ++districtPartySeats[dWinner][pWinner];
        --districtSeatsLeft[dWinner];
        --partySeats[pWinner];
        --seatsLeft;
    }

    /* print result */
    writeln();
    write("                 ");
    foreach (party; parties)
        writef("| %3.3s ", party.name);
    writeln();
    write("-----------------");
    foreach (party; parties)
        write("+-----");
    writeln();
    foreach (district; districts) {
        writef(" %15.15s ", district.name);
        foreach (party; parties) {
            writef("| %3s ", districtPartySeats[district][party]);
        }
        writeln();
    }
    write("-----------------");
    foreach (party; parties)
        write("+-----");
    writeln();
    writef(" %15.15s ", "Total");
    foreach (party; parties) {
        foreach (district; districts)
            partySeats[party] += districtPartySeats[district][party];
        writef("| %3s ", partySeats[party]);
    }
    writeln();
}
