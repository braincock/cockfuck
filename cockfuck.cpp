/*
 *   DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
 *            Version 2, December 2004 
 *
 * Copyright (C) 2004 Sam Hocevar <sam@hocevar.net> 
 *
 * Everyone is permitted to copy and distribute verbatim or modified 
 * copies of this license document, and changing it is allowed as long 
 * as the name is changed. 
 *
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
 *   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 
 *
 *  0. You just DO WHAT THE FUCK YOU WANT TO.
 *
 *
 * cockfuck.rs - cockfuck interpreter in rust
 */

#include "cockfuck.hpp"

void add_cmd(ParseState &p, ProgStep &&t, bool force) {
    if (! force && (t.n == 0)) {
        parse_err(p);
    } else {
        p.cmds.push_back(t);
        parse_set_at(p);
    }
}

void parse_err(ParseState &p) {
    if (fseek(p.infile, p.at + 1, SEEK_SET) < 0) {
        perror("Seek error");
        exit(-1);
    }
    parse_set_at(p);
}

void parse_set_at(ParseState &p) {
    p.at = ftell(p.infile);
}

void parse_back_up(ParseState &p) {
    if (fseek(p.infile, -1, SEEK_CUR) < 0) {
        perror("Seek error");
        exit(-1);
    }
    parse_set_at(p);
}

void parse_infile(ParseState &p) {
    int c;
    while ( (c = fgetc(p.infile)) != EOF ) {
        switch ((char) c) {
            case '8': parse_hanging(p, 0); break;
            case 'B': parse_cupped(p, 0); break;
            case '-': parse_sound(p, 1); break;
            case '~': parse_jizz(p, 1); break;
            case '`': parse_cglans(p); break;
            default : parse_err(p);
        }
    }
    if (ferror(p.infile)) {
        perror("Error reading program file");
        exit(-1);
    }
}

void parse_hanging(ParseState &p, unsigned n) {
    int c = fgetc(p.infile);
    if (c == EOF) {
        return;
    }
    switch ((char) c) {
        case '=': parse_hanging(p, n+1); break;
        case '>': add_cmd(p, { ptr_inc, n }); break;
        case 'D': add_cmd(p, { ptr_dec, n }); break;
        case ',': p.lcStack.push_back(p.cmds.size()); add_cmd(p, { jump_fwd, n }, true); break;
        case '`':
        case '~':
        case '-':
        case '8':
        case 'B': parse_err(p); break;
        default : parse_hanging(p, n);
    }
}

void parse_cupped(ParseState &p, unsigned n) {
    int c = fgetc(p.infile);
    if (c == EOF) {
        return;
    }
    switch ((char) c) {
        case '=': parse_cupped(p, n+1); break;
        case '>': add_cmd(p, { data_inc, n }); break;
        case 'D': add_cmd(p, { data_dec, n }); break;
        case ',':
        case '`':
        case '~':
        case '-':
        case '8':
        case 'B': parse_err(p); break;
        default : parse_cupped(p, n);
    }
}

void parse_sound(ParseState &p, unsigned n) {
    int c = fgetc(p.infile);
    if (c == EOF) {
        add_cmd(p, { take_in, n });
        return;
    }
    switch ((char) c) {
        case '-': parse_sound(p, n+1); break;
        case '8':
        case 'B':
        case 'D':
        case '>':
        case '=':
        case ',':
        case '`':
        case '~': add_cmd(p, { take_in, n }); parse_back_up(p); break;
        default : parse_sound(p, n);
    }
}

void parse_jizz(ParseState &p, unsigned n) {
    int c = fgetc(p.infile);
    if (c == EOF) {
        add_cmd(p, { put_out, n });
        return;
    }
    switch ((char) c) {
        case '~': parse_jizz(p, n+1); break;
        case '8':
        case 'B':
        case 'D':
        case '>':
        case '=':
        case ',':
        case '`':
        case '-': add_cmd(p, { put_out, n }); parse_back_up(p); break;
        default : parse_jizz(p, n);
    }
}

void parse_cglans(ParseState &p) {
    int c = fgetc(p.infile);
    if (c == EOF) {
        return;
    }
    switch ((char) c) {
        case '=': parse_cglans(p); break;
        case 'D':
        case ',':
        case '`':
        case '~':
        case '-':
        case '8':
        case 'B': parse_err(p); break;
        case '>': if (p.lcStack.size() < 1) {
                      printf("unbalanced chopticock! program is invalid.\n");
                      exit(-1);
                  } else {
                      unsigned last = p.lcStack.back();
                      p.lcStack.pop_back();
                      unsigned ppos = p.cmds.size();
                      p.cmds[last].n = ppos;
                      add_cmd(p, { jump_back, last }, true);
                  }
                  break;
        default : parse_cglans(p);
    }
}

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Usage: %s <infile>\n",argv[0]);
        exit(-1);
    }

    ParseState pState;
    pState.at = 0;
    if ( (pState.infile = fopen(argv[1],"r")) == NULL ) {
        perror("Could not open input file");
        exit(-1);
    }

    parse_infile(pState);

    if (pState.lcStack.size() > 0) {
        printf("unbalanced chopticock! program is invalid.\n");
        exit(-1);
    }

    pState.cmds.push_back({ halt, 0 });
    std::vector<ProgStep> cmds = pState.cmds;

    bool cont = true;
    int c = 0;
    ProgStep s;

    while (cont) {
        s = cmds[cPtr];
        switch(s.op) {
            case data_inc : array[dPtr] += s.n;
                            break;
            case data_dec : array[dPtr] -= s.n;
                            break;
            case ptr_inc  : dPtr += s.n;
                            break;
            case ptr_dec  : dPtr -= s.n;
                            break;
            case take_in  : for (unsigned i=0; i<s.n; i++) {
                                c = getchar();
                            }
                            array[dPtr] = (c == EOF) ? 0 : c;
                            break;
            case put_out  : for (unsigned i=0; i<s.n; i++) {
                                putc(array[dPtr], stdout);
                            }
                            break;
            case jump_fwd : if (array[dPtr] == 0) {
                                cPtr = s.n;
                            }
                            break;
            case jump_back: if (array[dPtr] != 0) {
                                cPtr = s.n;
                            }
                            break;
            case halt     : cont = false;
        }
        cPtr++;
    }

    return 0;
}
