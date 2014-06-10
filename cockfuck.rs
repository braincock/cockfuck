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

use std::os;
use std::io::{stdio, File, SeekSet, SeekCur};

#[deriving(Clone, Show)]
enum StepType {
    DataInc(u8),
    DataDec(u8),
    PtrInc(u16),
    PtrDec(u16),
    TakeIn(uint),
    PutOut(uint),
    JumpFwd(uint),
    JumpBack(uint),
    Halt
}

// state for use while parsing
struct ParseInfo {
    f : File,
    at : i64,
    lcStack : Vec<uint>,
    cmds : Vec<StepType>
}

fn parse_err(p : &mut ParseInfo) {
    match p.f.seek(p.at + 1, SeekSet) {
        Err(e) => fail!("Seek failed: {}",e),
        _ => ()
    };
    parse_set_at(p);
}

fn parse_set_at(p : &mut ParseInfo) {
    p.at = match p.f.tell() {
        Err(e) => fail!("Tell failed: {}",e),
        Ok(t) => t as i64
    }
}

fn parse_back_up(p : &mut ParseInfo) {
    match p.f.seek(-1, SeekCur) {
        Err(e) => fail!("Seek failed: {}",e),
        _ => ()
    };
    parse_set_at(p);
}


fn parse_infile(p : &mut ParseInfo) {
    loop {
        match p.f.read_byte() {
            Err(_) => break,
            Ok(b) => match b as char {
                '8' => parse_hanging(p,0),
                'B' => parse_cupped(p,0),
                '-' => parse_sound(p,1),
                '~' => parse_jizz(p,1),
                '`' => parse_cglans(p),
                _   => parse_err(p)
            }
        }
    }
}

// 8
// =
// >
// D
// B
// -
// ~
// `
// ,

fn add_cmd(p : &mut ParseInfo, t : StepType, n : uint) {
    if n == 0 {
        parse_err(p);
    } else {
        p.cmds.push(t);
        parse_set_at(p);
    }
}

fn parse_hanging(p : &mut ParseInfo, n : uint) {
    match p.f.read_byte() {
        Err(_) => return,
        Ok(b) => match b as char {
            '=' => parse_hanging(p, n+1),
            '>' => add_cmd(p, PtrInc(n as u16), n),
            'D' => add_cmd(p, PtrDec(n as u16), n),
            ',' => { p.lcStack.push(p.cmds.len()); add_cmd(p, JumpFwd(n), 1); },
            '`' | '~' | '-' | '8' | 'B' => parse_err(p),
            _   => parse_hanging(p,n)
        }
    }
}

fn parse_cupped(p : &mut ParseInfo, n : uint) {
    match p.f.read_byte() {
        Err(_) => return,
        Ok(b) => match b as char {
            '=' => parse_cupped(p, n+1),
            '>' => add_cmd(p, DataInc(n as u8), n),
            'D' => add_cmd(p, DataDec(n as u8), n),
            ',' | '`' | '~' | '-' | '8' | 'B' => parse_err(p),
            _   => parse_cupped(p,n)
        }
    }
}

fn parse_sound(p : &mut ParseInfo, n : uint) {
    match p.f.read_byte() {
        Err(_) => return,
        Ok(b) => match b as char {
            '-' => parse_sound(p, n+1),
            _   => { p.cmds.push(TakeIn(n)); parse_back_up(p); }
        }
    }
}

fn parse_jizz(p : &mut ParseInfo, n : uint) {
    match p.f.read_byte() {
        Err(_) => return,
        Ok(b) => match b as char {
            '~' => parse_jizz(p, n+1),
            _   => { p.cmds.push(PutOut(n)); parse_back_up(p); }
        }
    }
}

fn parse_cglans(p : &mut ParseInfo) {
    match p.f.read_byte() {
        Err(_) => return,
        Ok(b) => match b as char {
            '=' => parse_cglans(p),
            'D' | ',' | '`' | '~' | '-' | '8' | 'B' => parse_err(p),
            '>' => {
                let lstck = match p.lcStack.pop() {
                    None => fail!("unbalanced chopticock! program is invalid"),
                    Some(t) => t
                };
                let ppos = p.cmds.len();
                *(p.cmds.get_mut(lstck)) = JumpFwd(ppos);
                add_cmd(p, JumpBack(lstck), 1);
            }
            _   => parse_cglans(p)
        }
    }
}

fn main() {
    let args : Vec<String> = os::args();
    let program : &String = args.get(0);
    if args.len() != 2 {
        println!("Usage: {} <infile>",program);
        os::set_exit_status(-1);
        return;
    }

    let inf = &Path::new(args.get(1).clone());
    let infile = match File::open(inf) {
        Ok(f) => f,
        Err(e) => fail!("Could not open input file {}: {}",args.get(1),e)
    };

    let mut pInfo = ParseInfo { f : infile, at : 0, lcStack : vec!(), cmds : vec!() };

    parse_infile(&mut pInfo);

    if pInfo.lcStack.len() > 0 {
        fail!("unbalanced chopticock! program is invalid");
    }

    pInfo.cmds.push(Halt);
    let cmds = pInfo.cmds.as_slice();

    let mut dPtr : u16 = 0;
    let mut cPtr : uint = 0;
    let mut array : [u8, ..65536] = [0, ..65536];
    let mut sIn = stdio::stdin_raw();
    let mut sOut = stdio::stdout();

    loop {
        match &cmds[cPtr] {
            &Halt => break,
            &DataInc(d) => array[dPtr as uint] += d,
            &DataDec(d) => array[dPtr as uint] -= d,
            &PtrInc(p)  => dPtr += p,
            &PtrDec(p)  => dPtr -= p,
            &TakeIn(n)  => array[dPtr as uint] =
                            match sIn.read_exact(n) {
                                Ok(v) => *v.get(n-1) as u8,
                                Err(_)=> 0
                            },
            &PutOut(n)  => sOut.write_str( String::from_char(n, array[dPtr as uint] as char).as_slice() ).unwrap_or(()),
            &JumpFwd(n) => if array[dPtr as uint] == 0 { cPtr = n },
            &JumpBack(n)=> if array[dPtr as uint] != 0 { cPtr = n }
        };

        cPtr += 1;
    }
}
