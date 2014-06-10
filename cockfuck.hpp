#ifndef INC_COCKFUCK_HPP
#define INC_COCKFUCK_HPP

#include <cinttypes>
#include <cstdio>
#include <cstdlib>
#include <vector>
#include <array>

enum OpType { data_inc, data_dec, ptr_inc, ptr_dec, take_in, put_out, jump_fwd, jump_back, halt };

typedef struct {
    OpType op;
    unsigned n;
} ProgStep;

typedef struct {
    FILE *infile;
    long at;
    std::vector<unsigned> lcStack;
    std::vector<ProgStep> cmds;
} ParseState;

void add_cmd(ParseState &p, ProgStep &&t, bool force = false);
void parse_err(ParseState &p);
void parse_set_at(ParseState &p);
void parse_back_up(ParseState &p);
void parse_infile(ParseState &p);
void parse_hanging(ParseState &p, unsigned n);
void parse_cupped(ParseState &p, unsigned n);
void parse_sound(ParseState &p, unsigned n);
void parse_jizz(ParseState &p, unsigned n);
void parse_cglans(ParseState &p);

// program state
uint16_t dPtr = 0;
unsigned cPtr = 0;
uint8_t array[65536] = {0,};

#endif
