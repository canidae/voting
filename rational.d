module rational;

import std.bigint;
import std.conv: to;
import std.traits;

T gcd(T)(/*in*/ T a, /*in*/ T b) /*pure nothrow*/ {
    // std.numeric.gcd doesn't work with BigInt
    return (b != 0) ? gcd(b, a % b) : (a < 0) ? -a : a;
}

T lcm(T)(/*in*/ T a, /*in*/ T b) {
    return a / gcd(a, b) * b;
}

BigInt toBig(T : BigInt)(/*const*/ ref T n) pure nothrow {
    return n;
}

BigInt toBig(T)(const ref T n) pure nothrow if (isIntegral!T) {
    return BigInt(n);
}

struct Rational {
    /*const*/ private BigInt num, den; // numerator & denominator

    private enum Type {
        NegINF = -2,
        NegDEN = -1,
        NaRAT  =  0,
        NORMAL =  1,
        PosINF =  2
    };

    this(U : Rational)(U n) pure nothrow {
        num = n.num;
        den = n.den;
    }

    this(U)(in U n) pure nothrow if (isIntegral!U) {
        num = toBig(n);
        den = 1UL;
    }

    this(U, V)(/*in*/ U n, /*in*/ V d) /*pure nothrow*/ {
        num = toBig(n);
        den = toBig(d);
        /*const*/ BigInt common = gcd(num, den);
        if (common != 0) {
            num /= common;
            den /= common;
        } else { // infinite or NOT a Number
            num = (num == 0) ? 0 : (num < 0) ? -1 : 1;
            den = 0;
        }
        if (den < 0) { // assure den is non-negative
            num = -num;
            den = -den;
        }
    }

    @property BigInt numerator() /*const*/ pure nothrow {
        return num;
    }

    @property BigInt denominator() /*const*/ pure nothrow {
        return den;
    }

    long floor() /* const */ {
        if(den == 1)
            return num.toLong();

        auto t = num > 0 ? this : this - 1;
        return (t.num / t.den).toLong();
    }

    long ceil() /* const */ {
        if (den == 1)
            return num.toLong();

        auto t = num > 0 ? this + 1 : this;
        return (t.num / t.den).toLong();
    }

    string toString() /*const*/ {
        if (den == 0) {
            if (num == 0)
                return "NaRat";
            else
                return ((num < 0) ? "-" : "+") ~ "infRat";
        }
        //return to!(string)(cast(real) num.toLong() / cast(real) den.toLong());
        return "[" ~ toDecimalString(num) ~ (den == 1 ? "" : ("/" ~ toDecimalString(den))) ~ "]";
    }

    Rational opBinary(string op)(/*in*/ Rational r) /*const pure nothrow*/ if (op == "+" || op == "-") {
        BigInt common = lcm(den, r.den);
        BigInt n = mixin("common / den * num" ~ op ~ "common / r.den * r.num" );
        return Rational(n, common);
    }

    Rational opBinary(string op)(/*in*/ Rational r) /*const pure nothrow*/ if (op == "*") {
        return Rational(num * r.num, den * r.den);
    }

    Rational opBinary(string op)(/*in*/ Rational r) /*const pure nothrow*/ if (op == "/") {
        return Rational(num * r.den, den * r.num);
    }

    Rational opBinary(string op, T)(in T r) /*const pure nothrow*/ if (isIntegral!T && (op == "+" || op == "-" || op == "*" || op == "/")) {
        return opBinary!op(Rational(r));
    }

    Rational opBinary(string op)(in size_t p) /*const pure nothrow*/ if (op == "^^") {
        return Rational(num ^^ p, den ^^ p);
    }

    Rational opBinaryRight(string op, T)(in T l) /*const pure nothrow*/ if (isIntegral!T) {
        return Rational(l).opBinary!op(Rational(num, den));
    }

    Rational opUnary(string op)() /*const pure nothrow*/ if (op == "+" || op == "-") {
        return Rational(mixin(op ~ "num"), den);
    }

    Rational opUnary(string op)() /*const pure nothrow*/ if (op == "++") {
        this = this + 1;
        return this;
    }

    Rational opUnary(string op)() /*const pure nothrow*/ if (op == "--") {
        this = this - 1;
        return this;
    }

    Rational opOpAssign(string op, T)(T r) /*const pure nothrow*/ {
        this = mixin("this" ~ op ~ "r");
        return this;
    }

    int opCast(T : int)() /*const pure nothrow*/ {
        return (num / den).toInt();
    }

    long opCast(T : long)() /*const pure nothrow*/ {
        return (num / den).toLong();
    }

    int opCmp(T)(/*in*/ T r) /*const pure nothrow*/ {
        Rational rhs = Rational(r);
        if (type() == Type.NaRAT || rhs.type() == Type.NaRAT)
            throw new Exception("Compare invlove an NaRAT.");
        if (type() != Type.NORMAL || rhs.type() != Type.NORMAL) // for infinite
            return (type() == rhs.type()) ? 0 : ((type() < rhs.type()) ? -1 : 1);
        BigInt diff = num * rhs.den - den * rhs.num;
        return (diff == 0) ? 0 : ((diff < 0) ? -1 : 1);
    }

    int opEquals(T)(/*in*/ T r) /*const pure nothrow*/ {
        Rational rhs = Rational(r);
        if (type() == Type.NaRAT || rhs.type() == Type.NaRAT)
            return false;
        return num == rhs.num && den == rhs.den;
    }

    Type type() /*const pure nothrow*/ {
        if (den > 0)
            return Type.NORMAL;
        if (den < 0)
            return Type.NegDEN;
        if (num > 0)
            return Type.PosINF;
        if (num < 0)
            return Type.NegINF;
        return Type.NaRAT;
    }
}

unittest {
    import std.stdio, std.math;

    foreach (p; 2 .. 2 ^^ 19) {
        auto sum = Rational(1, p);
        immutable limit = 1 + cast(uint)sqrt(cast(real)p);
        foreach (factor; 2 .. limit) {
            if (p % factor == 0)
                sum = sum + Rational(1, factor) + Rational(factor, p);
        }
        if (sum.denominator == 1)
            writefln("Sum of recipr. factors of %6s = %s exactly%s", p, sum, (sum == 1) ? ", perfect." : ".");
    }
}
