#
#   DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
#            Version 2, December 2004 
#
# Copyright (C) 2004 Sam Hocevar <sam@hocevar.net> 
#
# Everyone is permitted to copy and distribute verbatim or modified 
# copies of this license document, and changing it is allowed as long 
# as the name is changed. 
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#
#

CXXFLAGS := -m64 -pedantic -pedantic-errors -std=c++1y -Werror -Wall -Wextra -Wshadow -Wpointer-arith -Wcast-qual -Wformat=2 -Ofast
CXX := clang++

RUSTFLAGS := -O
RUSTC := rustc

PERF := $(shell { ( command -v perf && echo stat ) || echo time ; })

all: cfuck crust

.PHONY: test
test: cfuck crust cInput
	@echo Running Collatz test.
	@echo
	@echo \*\*\* C++ INTERPRETER \*\*\*
	@$(PERF) ./cfuck collatz.cf < cInput
	@echo \*\*\* RUST INTERPRETER \*\*\*
	@$(PERF) ./crust collatz.cf < cInput

cfuck: cockfuck.cpp cockfuck.hpp
	@echo "[$<] compiling."
	@$(CXX) $(CXXFLAGS) $< -o $@

crust: cockfuck.rs
	@echo "[$<] compiling."
	@$(RUSTC) $(RUSTFLAGS) $< -o $@

cInput:
	@echo "Generating random 512-digit inputs for Collatz test."
	@perl -e 'for ($$i=0;$$i<10;$$i++) { for ($$j=0;$$j<512;$$j++) { print int(rand(10)); } print "\n"; }' > $@

.PHONY: clean
clean:
	@rm -f cfuck crust cInput
