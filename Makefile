WAT_ARGS ?= --fold-exprs --inline-exports --generate-names

all:
	#rustc --target wasm32-unknown-unknown -O --crate-type=cdylib src/ewasm_token.rs
	#mv ewasm_token.wasm ewasm_token-bloated.wasm
	cargo build --target=wasm32-unknown-unknown --release
	cp target/wasm32-unknown-unknown/release/ewasm_token.wasm ewasm_token.wasm
	chisel run

	wasm-opt -Oz -o ewasm_token.wasm ewasm_token.wasm #156
	wasm-snip --snip-rust-panicking-code ewasm_token.wasm -o ewasm_token.wasm #3.5/2.0
	wasm-minify ewasm_token.wasm ewasm_token.wasm #6.3
	#wasm-gc ewasm_token-bloated.wasm ewasm_token.wasm
