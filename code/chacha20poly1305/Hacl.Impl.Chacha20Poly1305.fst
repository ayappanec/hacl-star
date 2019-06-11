module Hacl.Impl.Chacha20Poly1305

module ST = FStar.HyperStack.ST
open FStar.HyperStack.All
open FStar.HyperStack
open FStar.Mul

open Lib.IntTypes
open Lib.Buffer
open Lib.ByteBuffer

open Hacl.Impl.Chacha20Poly1305.PolyCore
open Hacl.Impl.Poly1305.Fields

module LSeq = Lib.Sequence
module BSeq = Lib.ByteSequence

module Spec = Spec.Chacha20Poly1305
module Chacha = Hacl.Impl.Chacha20
module ChachaCore = Hacl.Impl.Chacha20.Core32

module SpecPoly = Spec.Poly1305
module Poly = Hacl.Impl.Poly1305

#set-options "--z3rlimit 50 --max_fuel 0 --max_ifuel 1"

val derive_key:
    k:lbuffer uint8 32ul
  -> n:lbuffer uint8 12ul
  -> out:lbuffer uint8 64ul ->
  Stack unit
    (requires fun h -> live h k /\ live h out /\ live h n /\
      disjoint k out /\ disjoint n out)
    (ensures fun h0 _ h1 -> modifies (loc out) h0 h1 /\
      as_seq h1 out == Spec.Chacha20.chacha20_key_block0 (as_seq h0 k) (as_seq h0 n))
let derive_key k n out =
  push_frame();
  let ctx = ChachaCore.create_state () in
  let ctx_core = ChachaCore.create_state () in
  Chacha.chacha20_init ctx k n 0ul;
  Chacha.chacha20_core ctx_core ctx 0ul;
  ChachaCore.store_state out ctx_core;
  pop_frame()

#reset-options "--z3rlimit 100 --max_fuel 1 --max_ifuel 1 --using_facts_from '* -FStar.Seq'"

inline_for_extraction noextract
val poly1305_do_:
    #w:field_spec
  -> k:lbuffer uint8 32ul // key
  -> aadlen:size_t
  -> aad:lbuffer uint8 aadlen // authenticated additional data
  -> mlen:size_t
  -> m:lbuffer uint8 mlen // plaintext
  -> out:lbuffer uint8 16ul // output: tag
  -> ctx:Poly.poly1305_ctx w
  -> block:lbuffer uint8 16ul ->
  Stack unit
    (requires fun h ->
      live h k /\ live h aad /\ live h m /\ live h out /\ live h ctx /\ live h block /\
      disjoint k out /\
      disjoint ctx k /\ disjoint ctx aad /\ disjoint ctx m /\ disjoint ctx out /\ disjoint ctx block /\
      disjoint block k /\ disjoint block aad /\ disjoint block m /\ disjoint block out)
    (ensures fun h0 _ h1 ->
      modifies (loc out |+| loc ctx |+| loc block) h0 h1 /\
      as_seq h1 out == Spec.poly1305_do (as_seq h0 k) (as_seq h0 m) (as_seq h0 aad))
let poly1305_do_ #w k aadlen aad mlen m out ctx block =
  Poly.poly1305_init ctx k;
  poly1305_padded ctx aadlen aad;
  poly1305_padded ctx mlen m;
  let h0 = ST.get () in
  update_sub_f h0 block 0ul 8ul
    (fun h -> BSeq.uint_to_bytes_le #U64 (to_u64 aadlen))
    (fun _ -> uint_to_bytes_le (sub block 0ul 8ul) (to_u64 aadlen));
  let h1 = ST.get () in
  assert (LSeq.sub (as_seq h1 block) 0 8 == BSeq.uint_to_bytes_le #U64 (to_u64 aadlen));
  Poly.reveal_ctx_inv ctx h0 h1;
  update_sub_f h1 block 8ul 8ul
    (fun h -> BSeq.uint_to_bytes_le #U64 (to_u64 mlen))
    (fun _ -> uint_to_bytes_le (sub block 8ul 8ul) (to_u64 mlen));
  let h2 = ST.get () in
  assert (LSeq.sub (as_seq h2 block) 8 8 == BSeq.uint_to_bytes_le #U64 (to_u64 mlen));
  LSeq.eq_intro (LSeq.sub (as_seq h2 block) 0 8) (BSeq.uint_to_bytes_le #U64 (to_u64 aadlen));
  LSeq.lemma_concat2 8 (BSeq.uint_to_bytes_le #U64 (to_u64 aadlen)) 8 (BSeq.uint_to_bytes_le #U64 (to_u64 mlen)) (as_seq h2 block);
  assert (as_seq h2 block == LSeq.concat (BSeq.uint_to_bytes_le #U64 (to_u64 aadlen)) (BSeq.uint_to_bytes_le #U64 (to_u64 mlen)));
  Poly.reveal_ctx_inv ctx h1 h2;
  Poly.poly1305_update1 ctx block;
  Poly.poly1305_finish out k ctx

// Implements the actual poly1305_do operation
inline_for_extraction noextract
let poly1305_do_core_st (w:field_spec) =
    k:lbuffer uint8 32ul // key
  -> aadlen:size_t
  -> aad:lbuffer uint8 aadlen // authenticated additional data
  -> mlen:size_t
  -> m:lbuffer uint8 mlen // plaintext
  -> out:lbuffer uint8 16ul -> // output: tag
  Stack unit
    (requires fun h ->
      live h k /\ live h aad /\ live h m /\ live h out /\
      disjoint k out)
    (ensures fun h0 _ h1 ->
      modifies (loc out) h0 h1 /\
      as_seq h1 out ==
      Spec.poly1305_do (as_seq h0 k) (as_seq h0 m) (as_seq h0 aad))

inline_for_extraction noextract
val poly1305_do_core: #w:field_spec -> poly1305_do_core_st w
let poly1305_do_core #w k aadlen aad mlen m out =
  push_frame();
  let ctx = create (nlimb w +! precomplen w) (limb_zero w) in
  let block = create 16ul (u8 0) in
  poly1305_do_ k aadlen aad mlen m out ctx block;
  pop_frame()

[@CInline]
let poly1305_do_32 : poly1305_do_core_st M32 = poly1305_do_core
[@CInline]
let poly1305_do_128 : poly1305_do_core_st M128 = poly1305_do_core
[@CInline]
let poly1305_do_256 : poly1305_do_core_st M256 = poly1305_do_core

inline_for_extraction noextract
val poly1305_do: #w:field_spec -> poly1305_do_core_st w
let poly1305_do #w =
  match w with
  | M32 -> poly1305_do_32
  | M128 -> poly1305_do_128
  | M256 -> poly1305_do_256

// Derives the key, and then perform poly1305
inline_for_extraction noextract
val derive_key_poly1305_do:
    #w:field_spec
  -> k:lbuffer uint8 32ul
  -> n:lbuffer uint8 12ul
  -> aadlen:size_t
  -> aad:lbuffer uint8 aadlen
  -> mlen:size_t
  -> m:lbuffer uint8 mlen
  -> out:lbuffer uint8 16ul ->
  Stack unit
    (requires fun h ->
      live h k /\ live h n /\ live h aad /\ live h m /\ live h out)
    (ensures  fun h0 _ h1 -> modifies (loc out) h0 h1 /\
     (let key = Spec.Chacha20.chacha20_key_block0 (as_seq h0 k) (as_seq h0 n) in
      let poly_k = LSeq.sub key 0 32 in
      as_seq h1 out == Spec.poly1305_do poly_k (as_seq h0 m) (as_seq h0 aad)))
let derive_key_poly1305_do #w k n aadlen aad mlen m out =
  push_frame ();
  // Create a new buffer to derive the key
  let tmp = create 64ul (u8 0) in
  derive_key k n tmp;
  // The derived key should only be the first 32 bytes
  let key = sub tmp 0ul 32ul in
  poly1305_do #w key aadlen aad mlen m out;
  pop_frame()

let aead_encrypt #w k n aadlen aad mlen m cipher mac =
  Chacha.chacha20_encrypt mlen cipher m k n 1ul;
  derive_key_poly1305_do #w k n aadlen aad mlen cipher mac

let aead_decrypt #w k n aadlen aad mlen m cipher mac =
  push_frame();
  let h0 = get() in
  // Create a buffer to store the temporary mac
  let computed_mac = create 16ul (u8 0) in
  // Compute the expected mac using Poly1305
  derive_key_poly1305_do #w k n aadlen aad mlen cipher computed_mac;
  let h1 = get() in
  let res =
    if lbytes_eq computed_mac mac then (
      assert (Lib.ByteSequence.lbytes_eq (as_seq h1 computed_mac) (as_seq h1 mac));
      // If the computed mac matches the mac given, decrypt the ciphertext and return 0
      Chacha.chacha20_encrypt mlen m cipher k n 1ul;
      0ul
    ) else 1ul // Macs do not agree, do not decrypt
  in
  pop_frame();
  res
